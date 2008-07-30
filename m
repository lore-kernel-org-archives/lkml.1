Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbYG3Vh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbYG3Vh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYG3Vht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:37:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:18364 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYG3Vhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xVHg448a5zXJ/LbTAwgi9dLVAYUeREobORF4zgQ3Zq40HqH9hdQNoF1sy+Cdoz5PjR
         I6dHIG+aCssVSrn9ZoZnSaXMJvQnagVf+/cHyyGyCydv7cg2W06/FeosvlB+kv96pF5T
         cSR5kcTqq1Euxy7pE4EG4OzclTAiNyzSILS7E=
Date: Thu, 31 Jul 2008 01:37:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc1: IP: iov_iter_advance+0x2e/0x90
Message-ID: <20080730213745.GA20546@martell.zuzino.mipt.ru>
References: <20080730195457.GA3517@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807301255560.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807301255560.3334@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 01:09:21PM -0700, Linus Torvalds wrote:
> On Wed, 30 Jul 2008, Alexey Dobriyan wrote:
> >
> > Steps to reproduce:
> > 
> > 	# while true; do ./ftest03; done
> > 
> > ftest03 from LTP 20080603
> 
> Hmm. The oops disassembles to
> 
>  -12:	4c 8b 07             	mov    (%rdi),%r8
>   -9:	48 8b 4f 10          	mov    0x10(%rdi),%rcx
>   -5:	48 85 f6             	test   %rsi,%rsi
>   -2:	75 17                	jne    0x42
>    0:	49 83 78 08 00       	cmpq   $0x0,0x8(%r8)	<---
>    5:	75 07                	jne    0xe
>    7:	48 83 7f 18 00       	cmpq   $0x0,0x18(%rdi)
>    c:	75 09                	jne    0x17
> 
> So it looks like we just overflowed %r8 to a new page and you presumably 
> have DEBUG_PAGEALLOC on.
> 
> (And yes, I see in the oops that you do)
> 
> > RIP  [<ffffffff8026190e>] iov_iter_advance+0x2e/0x90
> > Call Trace:
> >  [<ffffffff80263452>] generic_file_buffered_write+0x1e2/0x710
> >  [<ffffffff8040cfd0>] ? _spin_unlock+0x30/0x60
> >  [<ffffffff80263e0f>] __generic_file_aio_write_nolock+0x29f/0x450
> >  [<ffffffff80264026>] generic_file_aio_write+0x66/0xd0
> >  [<ffffffff802c9506>] ext3_file_write+0x26/0xc0
> >  [<ffffffff80264250>] ? generic_file_aio_read+0x0/0x670
> >  [<ffffffff802c94e0>] ? ext3_file_write+0x0/0xc0
> >  [<ffffffff8028921b>] do_sync_readv_writev+0xeb/0x130
> >  [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
> >  [<ffffffff802449c0>] ? autoremove_wake_function+0x0/0x40
> >  [<ffffffff80289055>] ? rw_copy_check_uvector+0x95/0x130
> >  [<ffffffff80289953>] do_readv_writev+0xc3/0x120
> >  [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
> >  [<ffffffff802527b5>] ? trace_hardirqs_on_caller+0xd5/0x160
> >  [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
> >  [<ffffffff802899e9>] vfs_writev+0x39/0x60
> >  [<ffffffff80289d60>] sys_writev+0x50/0x90
> >  [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
> > 
> > 0xffffffff8026190e is in iov_iter_advance (mm/filemap.c:1882).
> > 1877
> > 1878                    /*
> > 1879                     * The !iov->iov_len check ensures we skip over unlikely
> > 1880                     * zero-length segments (without overruning the iovec).
> > 1881                     */
> > 1882     ===>           while (bytes || unlikely(!iov->iov_len && i->count)) {
> 
> And yes, that oopsing op would be the one that loads 'iov->iov_len'.
> 
> So it very much looks like iov_iter_advance() advances past the end of the 
> iov array. We've had issues like that before. And I bet it's due to a 
> combination of Nick's commit f7009264c519603b8ec67c881bd368a56703cfc9 
> ("iov_iter_advance() fix") and 124d3b7041f9a0ca7c43a6293e1cae4576c32fd5 
> ("fix writev regression: pan hanging unkillable and un-straceable").
> 
> It's simply _not_ acceptable to look at iov->iov_len when 'bytes' has gone 
> down to zero, because there may be no 'iov' left!
> 
> Nick?
> 
> That said, I do think that we have another issue with iovec's - I think we 
> should strive to always pass in the number of iovec's when we pass a 
> pointer to an iovec, in addition to the bytes. The sad part is that 
> 'iov_iter_advance' actually -has- the count, but it's the byte count 
> remaining, not the iovec's remaining. 
> 
> In this particular case, the trivial fix _may_ be to just change the order 
> of testing iov->iov_len && i->count, but I really think we should also 
> count actual iov entries and pass them around (and keep them updated).
> 
> So does this (hacky, ugly) patch fix it for you?

You forgot "untested". And, yes, it helps.

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1879,7 +1879,7 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
>  		 * The !iov->iov_len check ensures we skip over unlikely
>  		 * zero-length segments (without overruning the iovec).
>  		 */
> -		while (bytes || unlikely(!iov->iov_len && i->count)) {
> +		while (bytes || unlikely(i->count && !iov->iov_len)) {
>  			int copy;
>  
>  			copy = min(bytes, iov->iov_len - base);

