Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYHCMJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYHCMJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHCMJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:09:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:53747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYHCMJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:09:45 -0400
From: Neil Brown <neilb@suse.de>
To: Paul Collins <paul@burly.ondioline.org>
Date: Sun, 3 Aug 2008 22:09:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18581.40960.737792.454035@notabene.brown>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linuxppc-dev@ozlabs.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
In-Reply-To: message from Paul Collins on Sunday August 3
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday August 3, paul@burly.ondioline.org wrote:
> 
> I can trigger it reliably with a 2.6.26 client.  I've also triggered it
> with 496d6c32d4d057cb44272d9bd587ff97d023ee92 reverted on the server.
> 
> It's harder to trigger with 2.6.27-rc1+ but I managed to get an Oops
> on the fourth build after three successful builds on the NFS4 mount.
> 
> One of the Oopses I got with 2.6.26 had a slightly different call trace:
> 
> Unable to handle kernel paging request for instruction fetch
> Faulting instruction address: 0x00000000

So we have called a function pointer which was NULL.

There a lots of function pointers in use in this code.
There is the 'acceptable' function.  There is ->fh_to_dentry
and ->fh_to_parent.  And various inode operations line ->lookup, but
that is a bit further away.

> NIP [00000000] 0x0
> LR [c0159bb0] exportfs_decode_fh+0xa8/0x200

I guess this is where the call came from.
exportfs_decode_fh is never passed NULL for 'acceptable'.  Only
ever 'nfsd_acceptable'.
->fh_to_parent is tested for NULL before being called, and
->fh_to_dentry is called very early in exportfs_decode_fh, where as
the bad call is 0xa8 in to the function.

Is it possible that ->fh_to_parent is being changed immediately after
being tested for NULL and before being dereferenced.  That seems
unlikely.

What filesystem is being exported here?

Can you get an assembly version of exportfs_decode_fh, so we can check
what is happening at 0xa8 (and 0x4c).
Either "disassemble exportfs_decode_fh" in gdb, or 
make fs/exportfs/expfs.i
(I think).

NeilBrown


> Call Trace:
> [c1f79d50] [c0159b54] exportfs_decode_fh+0x4c/0x200 (unreliable)
> [c1f79e80] [c015d568] fh_verify+0x2e8/0x578
> [c1f79ed0] [c016b1ec] nfsd4_putfh+0x60/0x78
> [c1f79ef0] [c016afd0] nfsd4_proc_compound+0x1e4/0x34c
> [c1f79f30] [c015a060] nfsd_dispatch+0xfc/0x220
> [c1f79f50] [c0400c70] svc_process+0x3e4/0x6e8
> [c1f79f90] [c015a8bc] nfsd+0x1c4/0x294
> [c1f79fd0] [c0049e48] kthread+0x5c/0x9c
> [c1f79ff0] [c00125c0] kernel_thread+0x44/0x60
