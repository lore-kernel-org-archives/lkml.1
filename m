Return-Path: <linux-kernel-owner+w=401wt.eu-S1030528AbXDPMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528AbXDPMvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030565AbXDPMvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 08:51:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:28303 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030528AbXDPMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 08:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rKNrcYICLP0PikvDvZrNdRGWbIwqRlLlub+0+bje9foFSubRNSVZbFC3npo+CP4jYDcVOIrQnwyYFgnu3AhCMR1BTP78xtnUFqvC8jFkFuLB9pWKaGar+k951FnR69Bqj/NgNJjqw29dpr/IktNjhDCxNw6yM48LltzdFp/1F74=
Message-ID: <6bffcb0e0704160551i1685a1edt5ee480b8b7b8c05e@mail.gmail.com>
Date: Mon, 16 Apr 2007 14:51:45 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [xfs-masters] Re: mm snapshot broken-out-2007-04-11-02-24.tar.gz uploaded
Cc: xfs-masters@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070416015911.GW32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704110926.l3B9Qe3D000895@shell0.pdx.osdl.net>
	 <461D22E5.9030705@googlemail.com>
	 <20070411121515.56425c23.akpm@linux-foundation.org>
	 <461D5DE3.1050300@googlemail.com>
	 <20070411154204.84c97c10.akpm@linux-foundation.org>
	 <20070416015911.GW32602149@melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 16/04/07, David Chinner <dgc@sgi.com> wrote:
> On Wed, Apr 11, 2007 at 03:42:04PM -0700, Andrew Morton wrote:
> > On Thu, 12 Apr 2007 00:14:59 +0200
> > Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >
> > > Andrew Morton napisa__(a):
> > > [ 1053.757285] EIP is at xlog_iodone+0x99/0xbb [xfs]
> > > [ 1053.762069] eax: 00000000   ebx: d6871ae8   ecx: c04a396c   edx: 00000000
> > > [ 1053.769002] esi: d6871ae8   edi: d0f7def8   ebp: d0fa5f30   esp: d0fa5f18
> > > [ 1053.775912] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> > > [ 1053.781842] Process xfslogd/1 (pid: 3642, ti=d0fa4000 task=cac7f5a0 task.ti=d0fa4000)
> > > [ 1053.789660] Stack: c01339fc d0f36130 db641df8 d6871ae8 d0f3611c d6871b84 d0fa5f40 fddab492
> > > [ 1053.798450]        dd2439ad d6871b88 d0fa5f70 c0133a26 c9c39db0 d0f36144 d0fa5f70 c01372d8
> > > [ 1053.807213]        00000000 00000000 fddab477 d0f3611c d0f85d70 00000000 d0fa5fb0 c0134469
> > > [ 1053.815902] Call Trace:
> > > [ 1053.818721]  [<fddab492>] xfs_buf_iodone_work+0x1b/0x3e [xfs]
> > > [ 1053.824830]  [<c0133a26>] run_workqueue+0x8e/0x15a
> > > [ 1053.829766]  [<c0134469>] worker_thread+0x108/0x116
> > > [ 1053.834793]  [<c013707c>] kthread+0xb5/0xe1
> > > [ 1053.839129]  [<c0104eb3>] kernel_thread_helper+0x7/0x10
> > > [ 1053.844539]  =======================
> > > [ 1053.848172] INFO: lockdep is turned off.
> > > [ 1053.852201] Code: 46 4c db fd ba 02 00 00 00 e8 61 fc 01 00 ba 02 00 00 00 eb 0f 8a 47 78 83 e0 80 3c 01 19 d2 f7 d2 83 e2 02 89 f8 e8 99 f7 ff ff <f6> 46 68 10 75 14 f0 ff 86 bc 00 00 00 7f 0b 8d 86 bc 00 00 00
> > > [ 1053.872927] EIP: [<fdd91dfe>] xlog_iodone+0x99/0xbb [xfs] SS:ESP 0068:d0fa5f18
> > >
> >
> > Bingo.  So it seems the xfslogd_workqueue is being run after unmount has
> > freed the memory which it uses.  Or something along those lines.
>
> It looks like the workqueue is being run while the log is
> being torn down.
>
> On unmount, we write a log record to indicate a clean unmount just
> before we tear the log down. We sleep on the iclog force semaphore
> waiting for the log I/O to complete, which is processed by xfslogd
> and xlog_iodone().
>
> xlog_iodone() calls xlog_state_done_syncing() which processes the I/O
> completion and wakes the unmount process sleeping on the semaphore.
> xlog_state_done_syncing() then does a bit more work before returning
> to xlog_iodone() where we check the buffer to determine if it was an
> async I/o or not.
>
> However, before we get to this, the unmount process has woken and
> continued onwards which then frees the iclogs and the buffer. Hence
> we have a race between xlog_iodone() looking at the buffer and the
> unmount process tearing the buffer down.
>
> There's a couple of different ways I can see to fix the problem -
> the first is to not reference the buffer in xlog_iodone() after
> running the callbacks that may trigger it being freed. I'd prfer to
> see if this fixes the problem before having to do more invasive
> surgery.  Can you try the patch below to see if it fixes the
> problem?

Problem seems to be fixed. Thanks!

Reagrds,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
