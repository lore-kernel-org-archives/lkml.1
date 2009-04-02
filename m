Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZDBU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZDBU4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZDBU4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:56:40 -0400
Received: from mail.crca.org.au ([67.207.131.56]:54532 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbZDBU4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:56:39 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Andreas Robinson <andr345@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238675410.13249.42.camel@andreas-desktop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
	 <1238629202.9027.111.camel@nigel-laptop>
	 <1238675410.13249.42.camel@andreas-desktop>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 03 Apr 2009 07:59:29 +1100
Message-Id: <1238705969.10479.8.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-04-02 at 14:30 +0200, Andreas Robinson wrote:
> On Thu, 2009-04-02 at 10:40 +1100, Nigel Cunningham wrote:
> > Sorry to jump in with a tangential issue, but I just noticed the
> > thread
> > and it reminded me of an issue :)
> > 
> > Should the lzo code used via cryptoapi (I believe it's the same stuff)
> > be SMP safe? I've tried to use it work TuxOnIce and get image corruption
> > (test kernel is 64 bit). The same code works fine if I tell it to use
> > LZF (which comes with TuxOnIce), no compression or, IIRC, work single
> > threaded.
> 
> Do you compress or decompress data through the crypto API?
> 
> Neither function modifies the input data and there are no static or
> global variables in use, so there shouldn't be a problem there.
> 
> They do however modify the destination length argument.
> 
> But most importantly, each compressor thread needs a private work buffer
> allocated through lzo_init() in crypto/lzo.c. So, if you use the crypto
> API to compress and share the crypto_tfm struct among threads, that
> would explain your breakage.

I use cryptoapi, and have per-cpu struct crypto_comps and per-cpu
buffers for output. As I said, it works fine if I use LZF (all I'm doing
is changing the name of the algorithm passed to crypto_alloc_comp. Here
are the relevant data structures, the initialisation routine and the
routines for reading and writing one page.

Regards,

Nigel

struct cpu_context {
        u8 *page_buffer;
        struct crypto_comp *transform;
        unsigned int len;
        char *buffer_start;
};

static DEFINE_PER_CPU(struct cpu_context, contexts);

static int toi_compress_crypto_prepare(void)
{
        int cpu;

        if (!*toi_compressor_name) {
                printk(KERN_INFO "TuxOnIce: Compression enabled but no "
                                "compressor name set.\n");
                return 1;
        }

        for_each_online_cpu(cpu) {
                struct cpu_context *this = &per_cpu(contexts, cpu);
                this->transform = crypto_alloc_comp(toi_compressor_name, 0, 0);
                if (IS_ERR(this->transform)) {
                        printk(KERN_INFO "TuxOnIce: Failed to initialise the "
                                        "%s compression transform.\n",
                                        toi_compressor_name);
                        this->transform = NULL;
                        return 1;
                }

                this->page_buffer =
                        (char *) toi_get_zeroed_page(16, TOI_ATOMIC_GFP);

                if (!this->page_buffer) {
                        printk(KERN_ERR
                          "Failed to allocate a page buffer for TuxOnIce "
                          "encryption driver.\n");
                        return -ENOMEM;
                }
        }

        return 0;
}

static int toi_compress_write_page(unsigned long index,
                struct page *buffer_page, unsigned int buf_size)
{
        int ret, cpu = smp_processor_id();
        struct cpu_context *ctx = &per_cpu(contexts, cpu);

        if (!ctx->transform)
                return next_driver->write_page(index, buffer_page, buf_size);

        ctx->buffer_start = kmap(buffer_page);

        ctx->len = buf_size;

        ret = crypto_comp_compress(ctx->transform,
                        ctx->buffer_start, buf_size,
                        ctx->page_buffer, &ctx->len);

        kunmap(buffer_page);

        if (ret) {
                printk(KERN_INFO "Compression failed.\n");
                return ret;
        }

        mutex_lock(&stats_lock);
        toi_compress_bytes_in += buf_size;
        toi_compress_bytes_out += ctx->len;
        mutex_unlock(&stats_lock);

        if (ctx->len < buf_size) /* some compression */
                return next_driver->write_page(index,
                                virt_to_page(ctx->page_buffer),
                                ctx->len);
        else
                return next_driver->write_page(index, buffer_page, buf_size);
}

static int toi_compress_read_page(unsigned long *index,
                struct page *buffer_page, unsigned int *buf_size)
{
        int ret, cpu = smp_processor_id();
        unsigned int len;
        unsigned int outlen = PAGE_SIZE;
        char *buffer_start;
        struct cpu_context *ctx = &per_cpu(contexts, cpu);

        if (!ctx->transform)
                return next_driver->read_page(index, buffer_page, buf_size);

        /*
         * All our reads must be synchronous - we can't decompress
         * data that hasn't been read yet.
         */

        *buf_size = PAGE_SIZE;

        ret = next_driver->read_page(index, buffer_page, &len);

        /* Error or uncompressed data */
        if (ret || len == PAGE_SIZE)
                return ret;

        buffer_start = kmap(buffer_page);
        memcpy(ctx->page_buffer, buffer_start, len);
        ret = crypto_comp_decompress(
                        ctx->transform,
                        ctx->page_buffer,
                        len, buffer_start, &outlen);
        if (ret)
                abort_hibernate(TOI_FAILED_IO,
                        "Compress_read returned %d.\n", ret);
        else if (outlen != PAGE_SIZE) {
                abort_hibernate(TOI_FAILED_IO,
                        "Decompression yielded %d bytes instead of %ld.\n",
                        outlen, PAGE_SIZE);
                printk(KERN_ERR "Decompression yielded %d bytes instead of "
                                "%ld.\n", outlen, PAGE_SIZE);
                ret = -EIO;
                *buf_size = outlen;
        }
        kunmap(buffer_page);
        return ret;
}


