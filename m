Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbZFMUFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbZFMUFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZFMUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:04:54 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63441 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbZFMUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UVa1PHxPxlPuOWzZXneP6jyQzb7Lw7gTF97gFQOPUUwc86zgphRA6fu9fgBhR3d8rG
         ilpurJ3Qy2D4hTcbya3m9AfYfRPpsUBMR6mQ9IY9MlbEyiwog6f/ZJ2lJtsSjdq6g8N1
         xKxBE9GYtUE2DKTaQ3+/yZZvSpXe6DcX7f/6g=
MIME-Version: 1.0
In-Reply-To: <20090613072611.GO11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
	 <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com>
	 <20090608070503.GB11363@kernel.dk>
	 <c384c5ea0906121505g7ab137dp3bbc202da0d43bcd@mail.gmail.com>
	 <20090613072611.GO11363@kernel.dk>
Date: Sat, 13 Jun 2009 22:04:55 +0200
Message-ID: <c384c5ea0906131304r5ef33826w81e6aa5bf9028340@mail.gmail.com>
Subject: Re: splice methods in character device driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens, Steve,

On Sat, Jun 13, 2009 at 9:26 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Sat, Jun 13 2009, Leon Woestenberg wrote:
>> On Mon, Jun 8, 2009 at 9:05 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
>> > On Sat, Jun 06 2009, Leon Woestenberg wrote:
>> >> How can I pass information from the splice_read(), which spawns a hardware
>> >> DMA to the pages in my case, to the confirm() hook which is called at some
>> >> (random) time in the future?
>> >
>> > There's a ->private for each pipe_buffer, so you can pass along info on
>> > a per-page granularity.
>> >
>> So, this means in my driver's splice_read(), I must set
>> pipe->bufs[i]->private for each 0 <= i < PIPE_BUFFERS?
>
> Yes. There's no way to make it bigger granularity, since you could have
> a mix of source pages in the pipe.
>

My current splice support code is copied at the end of this email.

I would like to batch up some pages before I start the DMA transfer,
as starting a device-driven DMA on page granularity (with a
corresponding interrupt)
looks like too much overhead to me.

I allocate a device transfer in splice_write(), which I would like to
fill-in in my write actor pipe_to_device(). At some point, I have to
start a transfer.

(sd-> len == sd->total_len) is not a strong enough condition, and I
find that SPLICE_F_MORE is never set:

root@mpc8315e-rdb:~# /splice-in /7000-bytes.bin  | /splice-out -s8192 /dev/alt
altpciesgdma_open(0xc74fc368, 0xc7be7000)

splice_write(len=8192)

transfer = 0xc7114140

pipe_to_device(buf->offset=0, sd->len/total_len=4096/8192, sd->data =
0xc7114140)

pipe_to_device() expect no more

pipe_to_device(buf->offset=0, sd->len/total_len=2904/4096, sd->data =
0xc7114140)

pipe_to_device() expect no more

splice_write(len=8192)

transfer = 0xc7114ac0

altpciesgdma_close(0xc74fc368, 0xc7be7000)

Is total_len <= PAGE_SIZE a sensible and robust (always occuring)
condition that indicates the last buffer?


Regards, Leon.



/* the write actor which takes a page from the pipe to the device
 *
 * it must move a single struct pipe_buffer to the desired destination
 * Existing implementations are pipe_to_file, pipe_to_sendpage, pipe_to_user.
 */
static int pipe_to_device(


#if SPLICE

static void *alt_pipe_buf_map(struct pipe_inode_info *pipe,
struct pipe_buffer *buf, int atomic)
{
	printk(KERN_DEBUG "alt_pipe_buf_map(buf->page=0x%p)\n", buf->page);
	if (atomic) {
		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
		return kmap_atomic(buf->page, KM_USER0);
	}
	return kmap(buf->page);
}

static void alt_pipe_buf_unmap(struct pipe_inode_info *pipe,
struct pipe_buffer *buf, void *map_data)
{
	printk(KERN_DEBUG "alt_pipe_buf_unmap()\n");
	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
		kunmap_atomic(map_data, KM_USER0);
	} else
	kunmap(buf->page);
}

/*
 * Check whether the contents of the pipe buffer may be accessed.
 * XXX to be implemented, see page_cache_pipe_buf_confirm
 */
static int alt_pipe_buf_confirm(struct pipe_inode_info *pipe,
struct pipe_buffer *buf)
{
	printk(KERN_DEBUG "alt_pipe_buf_confirm()\n");
	/* 0 seems ok */
	return 0;
}

/* XXX to be implemented, see page_cache_pipe_buf_release */
static void alt_pipe_buf_release(struct pipe_inode_info *pipe,
struct pipe_buffer *buf)
{
	printk(KERN_DEBUG "alt_pipe_buf_release()\n");
	put_page(buf->page);
	buf->flags &= ~PIPE_BUF_FLAG_LRU;
}

/* XXX to be implemented, see page_cache_pipe_buf_steal */
static int alt_pipe_buf_steal(struct pipe_inode_info *pipe,
struct pipe_buffer *buf)
{
	printk(KERN_DEBUG "alt_pipe_buf_steal()\n");
	return 1;
}

static void alt_pipe_buf_get(struct pipe_inode_info *pipe, struct
pipe_buffer *buf)
{
	printk(KERN_DEBUG "alt_pipe_buf_get()\n");
	page_cache_get(buf->page);
}

static void alt_spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
{
	printk(KERN_DEBUG "alt_spd_release_page()\n");
	put_page(spd->pages[i]);
}

static const struct pipe_buf_operations alt_pipe_buf_ops = {
	.can_merge = 0,
	.map = alt_pipe_buf_map,
	.unmap = alt_pipe_buf_unmap,
	.confirm = alt_pipe_buf_confirm,
	.release = alt_pipe_buf_release,
	.steal = alt_pipe_buf_steal,
	.get = alt_pipe_buf_get,
};

/* kernel wants to read from our file in at ppos to the pipe */
static int splice_read(struct file *in, loff_t *ppos,
struct pipe_inode_info *pipe, size_t len, unsigned int flags)
{
	int i;
	struct page *pages[PIPE_BUFFERS];
	struct partial_page partial[PIPE_BUFFERS];
	struct splice_pipe_desc spd = {
		/* pointer to an array of page pointers */
		.pages = pages,
		.partial = partial,
		.flags = flags,
		.ops = &alt_pipe_buf_ops,
		.spd_release = alt_spd_release_page,
	};

	printk(KERN_DEBUG "splice_read(len=%d)\n", len);
	printk(KERN_DEBUG "pipe_info() = 0x%p\n", pipe);

	while (i < PIPE_BUFFERS) {
		pages[i] = alloc_page(GFP_KERNEL);
		printk(KERN_DEBUG "spd.pages[%d] = 0x%p\n", i, spd.pages[i]);
		if (!pages[i]) break;
		i++;
	}
	BUG_ON(i < PIPE_BUFFERS);
	/* allocate pages */
	spd.nr_pages = PIPE_BUFFERS;
	if (spd.nr_pages <= 0)
		return spd.nr_pages;

	/* @todo somehow, fill a private field that we can use during confirm() */

	/* @todo now, start a transfer on the hardware */
	
	return splice_to_pipe(pipe, &spd);
}

/* the write actor which takes a page from the pipe to the device
 *
 * it must move a single struct pipe_buffer to the desired destination
 * Existing implementations are pipe_to_file, pipe_to_sendpage, pipe_to_user.
 */
static int pipe_to_device(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
		 struct splice_desc *sd)
{
	int rc;
	dma_addr_t dma_addr;
	struct ape_sgdma_transfer *transfer = sd->u.data;
	printk(KERN_DEBUG "pipe_to_device(buf->offset=%d, sd->len=%d/%d,
sd->data = 0x%x)\n",
		buf->offset, sd->len, sd->total_len, sd->u.data);
	/* have pipe source confirm that the data in this buffer is up-to-date */
	rc = buf->ops->confirm(pipe, buf);
	/* not up-to-date? */
	if (unlikely(rc))
		return rc;
	
	/* map page into PCI address space so device can DMA into it */
	dma_addr = pci_map_page(transfer->ape->pci_dev, buf->page, buf->offset,
		sd->len, DMA_TO_DEVICE);
	/* XXX rewind/bailout if that failed */
	/* XXX pci_unmap_page must be called later */

	/* create a transfer descriptor for this buffer */
	transfer_add(transfer, dma_addr, sd->len, buf->offset, 1/*dir_to_dev*/);
	
	printk(KERN_DEBUG "pipe_to_device(): expect %s more data\n",
		sd->flags & SPLICE_F_MORE ? "" : "no");

	/* splice complete, now start the transfer */
	if (sd-> len == sd->total_len) {
		/* terminate transfer list */
		transfer_end(transfer);
		/* dump the descriptor list for debugging purposes */
		dump_transfer(transfer);
		/* start the transfer on the device */
		queue_transfer(transfer->ape->read_engine, transfer);
	}
	return sd->len;
}

/* kernel wants to write from the pipe into our file at ppos */
ssize_t splice_write(struct pipe_inode_info *pipe, struct file *out,
loff_t *ppos, size_t len, unsigned int flags)
{
	struct ape_dev *ape = (struct ape_dev *)out->private_data;
	struct ape_sgdma_transfer *transfer;
	int ret;
	struct splice_desc sd = {
		.total_len = len,
		.flags = flags,
		.pos = *ppos,
	};
	printk(KERN_DEBUG "splice_write(len=%d)\n", len);
	/* allocate a new transfer request */
	transfer = alloc_transfer(ape, PIPE_BUFFERS, 1/*dir_to_dev*/);
	/* remember transfer in the splice descriptor */
	sd.u.data = transfer;
	printk(KERN_DEBUG "transfer = 0x%p\n", sd.u.data);
#if 1
	ret = __splice_from_pipe(pipe, &sd, pipe_to_device);
#else
	ret = splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_device);
#endif
	return ret;
}

#endif /* SPLICE */

/*
 * character device file operations
 */
static struct file_operations sg_fops = {
	.owner = THIS_MODULE,
	.open = sg_open,
	.release = sg_close,
	.read = sg_read,
	.write = sg_write,
	/* asynchronous */
	.aio_read = sg_aio_read,
	.aio_write = sg_aio_write,
#if SPLICE
	/* splice */
	.splice_read = splice_read,
	.splice_write = splice_write,
#endif /* SPLICE */
};
