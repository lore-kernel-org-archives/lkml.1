Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXKWKWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXKWKWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXKWKWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:22:03 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:4222 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXKWKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OE+tYT5714uoNtopNpCa6iZ1PA8tmcuKSh/ZDjSaM+gU2mT0bAov479B6f+ROqemEacOk31iyRC5+NBKspU51O7/hc290ZZzlwBzx2zLE9twAzN28DDcKRPi1DzbhyHEcq7sbCpONhRctbTXXXcHWlToY6Ko8axuREVuFIWFjR8=
Message-ID: <64bb37e0711230221k49d4ddefoaab1ff1515c65a54@mail.gmail.com>
Date: Fri, 23 Nov 2007 11:21:58 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Milan Broz" <mbroz@redhat.com>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Alasdair G Kergon" <agk@redhat.com>
In-Reply-To: <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
	 <20071119075627.GB28432@elte.hu>
	 <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
	 <4741F97D.6090808@redhat.com>
	 <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2007 7:55 AM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On Nov 19, 2007 10:00 PM, Milan Broz <mbroz@redhat.com> wrote:
> > Please could you try which patch from the dm-crypt series cause this ?
> > (agk-dm-dm-crypt* names.)
> >
> > I suspect agk-dm-dm-crypt-move-bio-submission-to-thread.patch because
> > there is one work struct used subsequently in two threads...
> > (io thread already started while crypt thread is processing lockdep_map
> > after calling f(work)...)
>
> After reverting only
> agk-dm-dm-crypt-move-bio-submission-to-thread.patch I also have not
> seen the 'held lock freed' message again.
>
> If it happens again with this revert, I will post that output.

It happened again, here I post the output:
Nov 23 10:56:17 treogen [   58.364441] XFS mounting filesystem dm-0
Nov 23 10:56:17 treogen [   58.519648] Ending clean XFS mount for
filesystem: dm-0
Nov 23 10:56:17 treogen [   58.858098]
Nov 23 10:56:17 treogen [   58.858104] =========================
Nov 23 10:56:17 treogen [   58.863316] [ BUG: held lock freed! ]
Nov 23 10:56:17 treogen [   58.866998] -------------------------
Nov 23 10:56:17 treogen [   58.870685] kcryptd/1022 is freeing memory
FFFF81011EAD4B00-FFFF81011EAD4B3F
, with a lock still held there!
Nov 23 10:56:17 treogen [   58.880430]  (kcryptd){--..}, at:
[<ffffffff80247dd9>] run_workqueue+0x129/0
x210
Nov 23 10:56:17 treogen [   58.888014] 2 locks held by kcryptd/1022:
Nov 23 10:56:17 treogen [   58.892045]  #0:  (kcryptd){--..}, at:
[<ffffffff80247dd9>] run_workqueue+0x
129/0x210
Nov 23 10:56:17 treogen [   58.900095]  #1:  (&io->work#2){--..}, at:
[<ffffffff80247dd9>] run_workqueu
e+0x129/0x210
Nov 23 10:56:17 treogen [   58.908535]
Nov 23 10:56:17 treogen [   58.908535] stack backtrace:
Nov 23 10:56:17 treogen [   58.912954]
Nov 23 10:56:17 treogen [   58.912955] Call Trace:
Nov 23 10:56:17 treogen [   58.916944]  [<ffffffff8025a5f0>]
debug_check_no_locks_freed+0x190/0x1b0
Nov 23 10:56:17 treogen [   58.924313]  [<ffffffff8026f192>]
mempool_free_slab+0x12/0x20
Nov 23 10:56:17 treogen [   58.930073]  [<ffffffff80296bb9>]
kmem_cache_free+0x79/0xe0
Nov 23 10:56:17 treogen [   58.935665]  [<ffffffff8026f192>]
mempool_free_slab+0x12/0x20
Nov 23 10:56:17 treogen [   58.941424]  [<ffffffff8026f22a>]
mempool_free+0x8a/0xa0
Nov 23 10:56:17 treogen [   58.946755]  [<ffffffff802c76af>] bio_free+0x2f/0x50
Nov 23 10:56:17 treogen [   58.951736]  [<ffffffff804e36fd>]
dm_bio_destructor+0xd/0x10
Nov 23 10:56:17 treogen [   58.957414]  [<ffffffff802c7436>] bio_put+0x26/0x30
Nov 23 10:56:17 treogen [   58.962311]  [<ffffffff804e3af3>]
clone_endio+0x83/0xb0
Nov 23 10:56:17 treogen [   58.967553]  [<ffffffff804eb860>]
kcryptd_do_crypt+0x0/0x290
Nov 23 10:56:17 treogen [   58.973224]  [<ffffffff802c72a9>] bio_endio+0x19/0x40
Nov 23 10:56:17 treogen [   58.978291]  [<ffffffff804eb372>]
crypt_dec_pending+0x32/0x50
Nov 23 10:56:17 treogen [   58.984050]  [<ffffffff804eb8c4>]
kcryptd_do_crypt+0x64/0x290
Nov 23 10:56:17 treogen [   58.989810]  [<ffffffff804eb860>]
kcryptd_do_crypt+0x0/0x290
Nov 23 10:56:17 treogen [   58.995483]  [<ffffffff804eb860>]
kcryptd_do_crypt+0x0/0x290
Nov 23 10:56:17 treogen [   59.001158]  [<ffffffff80247e25>]
run_workqueue+0x175/0x210
Nov 23 10:56:17 treogen [   59.006746]  [<ffffffff80248af1>]
worker_thread+0x71/0xb0
Nov 23 10:56:17 treogen [   59.012158]  [<ffffffff8024c830>]
autoremove_wake_function+0x0/0x40
Nov 23 10:56:17 treogen [   59.018435]  [<ffffffff80248a80>]
worker_thread+0x0/0xb0
Nov 23 10:56:17 treogen [   59.023764]  [<ffffffff8024c43d>] kthread+0x4d/0x80
Nov 23 10:56:17 treogen [   59.028660]  [<ffffffff8020cbc8>] child_rip+0xa/0x12
Nov 23 10:56:17 treogen [   59.033640]  [<ffffffff8020c2df>]
restore_args+0x0/0x30
Nov 23 10:56:17 treogen [   59.038880]  [<ffffffff8024c3f0>] kthread+0x0/0x80
Nov 23 10:56:17 treogen [   59.043689]  [<ffffffff8020cbbe>] child_rip+0x0/0x12
Nov 23 10:56:17 treogen [   59.048670]
Nov 23 10:56:17 treogen [   59.050190] INFO: lockdep is turned off.
Nov 23 10:56:17 treogen [   59.919020] pata_amd 0000:00:04.0: version 0.3.10

>From what I see the only difference between the other stack traces and
this one is the following part:

old traces with agk-dm-dm-crypt-move-bio-submission-to-thread.patch applied:
[   64.584415]  [<ffffffff802c76af>] bio_free+0x2f/0x50
[   64.586337]  [<ffffffff802c76e0>] bio_fs_destructor+0x10/0x20
[   64.588558]  [<ffffffff802c7436>] bio_put+0x26/0x30
[   64.590446]  [<ffffffff803834d9>] xfs_buf_bio_end_io+0x99/0x120
[   64.592734]  [<ffffffff802c72a9>] bio_endio+0x19/0x40
[   64.594687]  [<ffffffff804e3827>] dec_pending+0x107/0x210
[   64.596775]  [<ffffffff804e3ae0>] clone_endio+0x70/0xb0

new trace with agk-dm-dm-crypt-move-bio-submission-to-thread.patch reverted:
[   58.946755]  [<ffffffff802c76af>] bio_free+0x2f/0x50
[   58.951736]  [<ffffffff804e36fd>] dm_bio_destructor+0xd/0x10
[   58.957414]  [<ffffffff802c7436>] bio_put+0x26/0x30
[   58.962311]  [<ffffffff804e3af3>] clone_endio+0x83/0xb0

(gdb) list *0xffffffff804e3ae0
0xffffffff804e3ae0 is in clone_endio (drivers/md/dm.c:539).
534             dec_pending(tio->io, error);
535
536             /*
537              * Store md for cleanup instead of tio which is about
to get freed.
538              */
539             bio->bi_private = md->bs;
540
541             bio_put(bio);
542             free_tio(md, tio);
543     }

(gdb) list *0xffffffff804e3af3
0xffffffff804e3af3 is in clone_endio (drivers/md/dm.c:542).
537              * Store md for cleanup instead of tio which is about
to get freed.
538              */
539             bio->bi_private = md->bs;
540
541             bio_put(bio);
542             free_tio(md, tio);
543     }
544
545     static sector_t max_io_len(struct mapped_device *md,
546                                sector_t sector, struct dm_target *ti)

Torsten
