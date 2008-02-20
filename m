Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYBTAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYBTAOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYBTAOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:14:19 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47548 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbYBTAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:14:17 -0500
Date: Wed, 20 Feb 2008 00:13:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: unionfs_copy_attr_times oopses 
In-Reply-To: <200802170306.m1H36xeT031583@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0802192331370.9533@blonde.site>
References: <200802170306.m1H36xeT031583@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Erez Zadok wrote:
> 
> Check out my latest set of patches (which correspond to release 2.2.4 of
> Unionfs).  Thanks to your info and the patch, I was able to trigger several
> races more frequently, and fix them.  I've tested my code with make -j N
> (for N=4 and N=20), on a 4 cpu machine a well as a 2 cpu machine (w/
> different amounts of memory and CPU speeds, also 32-bit vs 64-bit); I ran a
> kernel compile for ~10-12 hours.  With the patches I just posted, I wasn't
> able to trigger any of the WARN_ON's in unionfs_copy_attr_times.  I also
> tried it while flushing caches via /proc, and/or performing branch-mgmt
> commands in unionfs.
> 
> Give it a good shake and let me know what you find.

I've now shaken it for 26 hours each on three machines, while running
a few other tests (including LTP, with CONFIG_LOCKDEP=y) on another;
used 2.6.25-rc2-mm1 plus your patches plus undo dependence on BROKEN.

I took the precaution of running with my WARN_ONs
reinstated in unionfs_copy_attr_times, i.e.

	int bindex, bend;
	struct inode *lower;
	struct inode **lower_inodes;

	if (!upper)
		return;
	bindex = ibstart(upper);
	if (bindex < 0)
		return;
	while (1) {
		bend = ibend(upper);
		if (WARN_ON(bend < 0))
			break;
		if (bindex > bend)
			break;
		lower_inodes = UNIONFS_I(upper)->lower_inodes;
		if (WARN_ON(!lower_inodes))
			break;
		lower = lower_inodes[bindex++];
		if (!lower)
			continue; /* not all lower dir objects may exist */
		...

Things look much better with this version than they did, but in that
26 hours one of the machines did issue one of those warnings, the
WARN_ON(bend < 0): that does indicate still some raciness,
doesn't it, since bindex >= 0 before entering the loop?
Here's the accompanying stacktrace:

------------[ cut here ]------------
WARNING: at fs/unionfs/subr.c:258 unionfs_copy_attr_times+0x70/0x11c()
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device acpi_cpufreq processor button
Pid: 10438, comm: pdflush Not tainted 2.6.25-rc2-mm1 #3

Call Trace:
 [<ffffffff8023812f>] warn_on_slowpath+0x62/0x8d
 [<ffffffff80509dd9>] ? preempt_schedule_irq+0x63/0x7c
 [<ffffffff8032a7a4>] ? unionfs_copy_attr_times+0x85/0x11c
 [<ffffffff8032a78f>] unionfs_copy_attr_times+0x70/0x11c
 [<ffffffff80273369>] ? __writepage+0x0/0x45
 [<ffffffff803379c4>] unionfs_writepages+0x5c/0x69
 [<ffffffff80273422>] do_writepages+0x36/0x51
 [<ffffffff802c13a8>] __sync_single_inode+0x71/0x1a1
 [<ffffffff802c1609>] __writeback_single_inode+0x131/0x13e
 [<ffffffff80509d5c>] ? preempt_schedule+0x5d/0x77
 [<ffffffff802b67bf>] ? iput+0x55/0x8f
 [<ffffffff802c176d>] generic_sync_sb_inodes+0x157/0x257
 [<ffffffff802c18a8>] sync_sb_inodes+0x3b/0x3d
 [<ffffffff802c1917>] writeback_inodes+0x6d/0xc7
 [<ffffffff80272c63>] ? background_writeout+0x35/0xe9
 [<ffffffff80272cd4>] background_writeout+0xa6/0xe9
 [<ffffffff80273cf0>] __pdflush+0x148/0x1f5
 [<ffffffff80273d9d>] ? pdflush+0x0/0x50
 [<ffffffff80273deb>] pdflush+0x4e/0x50
 [<ffffffff80272c2e>] ? background_writeout+0x0/0xe9
 [<ffffffff8024d2ae>] kthread+0x56/0x86
 [<ffffffff8022eb51>] ? schedule_tail+0x36/0x72
 [<ffffffff8020c449>] child_rip+0xb/0x12
 [<ffffffff8024d258>] ? kthread+0x0/0x86
 [<ffffffff8020c43e>] ? child_rip+0x0/0x12

---[ end trace 1b6402a1105c37cb ]---

Another of the machines, with CONFIG_UNION_FS_DEBUG=y,
occasionally issued one of your debug warnings, six in all:

PC:fs/unionfs/rename.c:unionfs_rename:536
 Ci7: inode/linode=f08e9bec:00000000 bindex=0 istart/end=0:0
...
PC:fs/unionfs/dentry.c:unionfs_d_revalidate:481
 CI8: bindex=0 mtime/lmtime=1203370546.467901272/1203370546.467901272 ctime/lctime=1203370546.467901272/1203370546.467901272
...
PC:fs/unionfs/rename.c:unionfs_rename:536
 Ci7: inode/linode=efabb31c:00000000 bindex=0 istart/end=0:0
...
PC:fs/unionfs/rename.c:unionfs_rename:536
 Ci7: inode/linode=ee06dbec:00000000 bindex=0 istart/end=0:0
...
PC:fs/unionfs/rename.c:unionfs_rename:536
 Ci4: no lower_inodes e1442494
...
PC:fs/unionfs/rename.c:unionfs_rename:536
 Ci7: inode/linode=d71731a4:00000000 bindex=0 istart/end=0:0

The third (like the first, without UNION_FS_DEBUG) had a clean run.

The LTP run generally went fine, but one anomaly I happened to
notice this time, probably been there for months: when it's testing
swapon on unionfs over tmpfs, the kernel's "Adding 32k swap" message
said "across:4k" each time, which is odd since it's hard to fit 32k
into 4k - unless you're compressing, which is someone else's project!

I think that's because bmap() is not very well defined, and actually,
you need to be sure to return sector 0 whenever there's an error
(including the lower level not supporting bmap, as in the tmpfs case),
not -EINVAL.  I think that's how generic_block_bmap tries to play it.

Previously I'd felt indulgent about you "supporting" swapon of a
unionfs file even when the lower level didn't support it; but now
I think it's probably dangerously wrong (though limited to root).
I didn't dare try what happens when you actually get to swapping to
such a beast; and in fact, I didn't even try to wrap my head around
even your "good" bmap support in unionfs - it's not obvious to me
that it makes any sense at all, but I've hardly tried to think.

The last thing I noticed, there seems to be a regression (since when?
long time since I last tried it) with fsx on unionfs while swapping:
very soon collapses with fsx reporting inconsistency.  I've not had
time to investigate (nor shall this week), but after finding it with
tmpfs, did verify that it's not a tmpfs issue, same happens with ext2
as the lower filesystem; but doesn't happen without memory pressure.
Probably a truncation issue like last time.

Hugh
