Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0CHVub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:50:31 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:60711 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0CHVu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:50:28 -0500
Message-ID: <4B957122.4060007@msgid.tls.msk.ru>
Date: Tue, 09 Mar 2010 00:50:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru> <x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497hpm8p69.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
> 
>> Hello.
>>
>> I just come across a situation (next in a long row :)
>> when on x86, 32bit userspace does not work with 64bit
>> kernel.  This time this is about aio requests.
>>
>> An application submits some aio job, and it is returned
>> immediately (from io_getevents()) with EINVAL error.
[]
> Can you post the program, please?

The program which I'm trying is quite big - it's qemu-kvm
v. 0.12.3 compiled with --enable-linux-aio.  I bugged
kvm folks about non-working aio support but immediately
realized it's 32/64bit issue in the kernel, since 64bit
kvm works just fine on the same kernel (which is 64bits).
So I added 2 printfs into its linux-aio.c and re-run it.

The diff against upstream qemu-kvm is this one:

---- cut -----
diff --git a/linux-aio.c b/linux-aio.c
index 5e892b0..e856873 100644
--- a/linux-aio.c
+++ b/linux-aio.c
@@ -60,6 +60,9 @@ static void qemu_laio_process_completion(struct qemu_laio_state *s,

     ret = laiocb->ret;
     if (ret != -ECANCELED) {
+if (ret != laiocb->nbytes)
+fprintf(stderr, "io_getevents: exp %d got %d %s\n", laiocb->nbytes, ret,
+strerror(ret));
         if (ret == laiocb->nbytes)
             ret = 0;
         else if (ret >= 0)
@@ -223,6 +226,12 @@ BlockDriverAIOCB *laio_submit(BlockDriverState *bs, void *aio_ctx, int fd,
     io_set_eventfd(&laiocb->iocb, s->efd);
     s->count++;

+{ struct iovec *v = (struct iovec*)iocbs->u.c.buf;
+printf("io_submit: lio_opcode=%d reqprio=%d iov=%p{%p,%d}, niov=%lu, offset=%Ld\n",
+iocbs->aio_lio_opcode, iocbs->aio_reqprio, iocbs->u.c.buf,
+v->iov_base, v->iov_len,
+iocbs->u.c.nbytes, iocbs->u.c.offset);
+}
     if (io_submit(s->ctx, 1, &iocbs) < 0)
         goto out_dec_count;
     return &laiocb->common;
---- cut -----

I'm not sure if it's useful or not.

Qemu-kvm git tree is at
git://git.kernel.org/pub/scm/virt/kvm/qemu-kvm.git

I never dealt with aio before, so I'll need to familiarize
myself with it before trying to create a smaller testcase.

Thanks!

/mjt
