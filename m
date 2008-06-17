Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYFQQEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYFQQEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYFQQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:04:23 -0400
Received: from rimp2.nist.gov ([129.6.16.227]:49824 "EHLO smtp.nist.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752326AbYFQQEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:04:22 -0400
X-Greylist: delayed 2874 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jun 2008 12:04:21 EDT
From: Ian Soboroff <isoboroff@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Oops in NFS (RHEL4, but also in kernel bugzilla)
Date: Tue, 17 Jun 2008 11:15:59 -0400
Message-ID: <9cf3ancks7k.fsf@rogue.ncsl.nist.gov>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.1.91 (darwin)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NIST-MailScanner: Found to be clean
X-NIST-MailScanner-From: ian.soboroff@nist.gov
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a server that hosts some large XFS filesystems and serves them
out over NFS.  Every so often I get the following Oops, and then the
machine locks hard with blinky keyboard lights.  ("Every so often" == I
can't reproduce this reliably.  It comes up about once a week, we've
seen it three times.)

Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 355bf001
Oops: 0000 [#1]
SMP 
Modules linked in: nfs nfsd exportfs lockd nfs_acl md5 ipv6 parport_pc lp parport autofs4 i2c_dev i2c_core sunrpc button battery ac ohci_hcd tg3 floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod aacraid aic7xxx sd_mod scsi_m
od
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010282   (2.6.9-67.0.15.ELirsmp) 
EIP is at 0x0
eax: e1c86c30   ebx: c04ba260   ecx: 00000000   edx: d820304c
esi: d820304c   edi: f6ecbf00   ebp: 00000000   esp: f6ecbee4
ds: 007b   es: 007b   ss: 0068
Process nfsd (pid: 4339, threadinfo=f6ecb000 task=f6c470b0)
Stack: c0168c5f e1c86c30 ffffffff f5f96090 60229cac cc751afc c0168cd3 60229cac 
       00000008 f5f96088 e1c86ca0 e1c86ca0 e1c86c30 cc751afc f5f95004 f8bcee28 
       f5f96088 f7e6ba00 f7d351c0 f7e6ba00 f8b2b46a f5f95800 f5f95000 f5f951d4 
Call Trace:
 [<c0168c5f>] __lookup_hash+0x70/0x89
 [<c0168cd3>] lookup_one_len+0x54/0x63
 [<f8bcee28>] nfsd_lookup+0x321/0x3ad [nfsd]
 [<f8b2b46a>] svcauth_unix_set_client+0xa7/0xb5 [sunrpc]
 [<f8bd6b49>] nfsd3_proc_lookup+0xa9/0xb3 [nfsd]
 [<f8bd8b37>] nfs3svc_decode_diropargs+0x0/0xfa [nfsd]
 [<f8bcc681>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<f8b2862d>] svc_process+0x444/0x6f3 [sunrpc]
 [<f8bcc45a>] nfsd+0x1cc/0x339 [nfsd]
 [<f8bcc28e>] nfsd+0x0/0x339 [nfsd]
 [<c01041f5>] kernel_thread_helper+0x5/0xb
Code:  Bad EIP value.
 <0>Fatal exception: panic in 5 seconds

This machine is running RHEL4, using the stock kernel but with XFS
enabled.  I would have reported it to Redhat instead, but in googling
around found a nearly identical kernel bugzilla report:

http://bugzilla.kernel.org/show_bug.cgi?id=7809

In there, the bug reporter has tracked the Oops to __lookup_hash() in
fs/namei.c, and includes a patch which basically just takes care to not
dereference inode->i_op->lookup without checking it first.

I looked at the latest fs/namei.c via gitweb and it's the same code.  So
here I am reporting it here, where more knowledgable and responsive
people lurk anyway.

Is this a NFS problem, or an XFS one?  (Since XFS is common in both my
report and in the bugzilla one... I'm not sure whether the 'inode' in
question is NFS or from the underlying filesystem).

Is the bugzilla report's patch papering over a real problem, or does it
fix a real possible null-pointer case in __lookup_hash?

Thanks,
Ian

