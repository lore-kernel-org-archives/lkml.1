Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXGFJld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXGFJld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbXGFJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:41:26 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51819 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbXGFJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:41:25 -0400
Message-ID: <468E0E4A.1010106@bull.net>
Date: Fri, 06 Jul 2007 11:41:30 +0200
From: xb <xavier.bru@bull.net>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.12 quotaoff loop on a read-only ext3 filesystem
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/07/2007 11:45:41,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/07/2007 11:45:42,
	Serialize complete at 06/07/2007 11:45:42
Content-Type: multipart/mixed;
 boundary="------------030207070002060207030709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030207070002060207030709
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hi all,

Running on a 2.6.12.6 kernel, we found a problem with running quotaoff 
on an ext3 read-only filesystem:

quotaoff loops in dqput() because DQ_ACTIVE_B is set and 
ext3_release_dquot() returns because of ext3_journal_start() returning 
EROFS  without  calling dquot_release() that should have removed 
DQ_ACTIVE_B.
Then if we try to run the mount command to remount rw the file system, 
it deadlocks on the down_write(&s->s_umount) owned by quotaoff.
Has this problem been already identified and fixed in recent versions ?
Thanks in advance.

traces -------------------------------------------------------
/static int ext3_release_dquot(struct dquot *dquot)
{
...
    handle = ext3_journal_start(dquot_to_inode(dquot),
                    EXT3_QUOTA_INIT_BLOCKS);
    if (IS_ERR(handle))
        return PTR_ERR(handle); <------ returns here
    ret = dquot_release(dquot); <------- not executed
...
}/

/    <4>Backtrace of current task (pid 20974, quotaoff)
    <4>
    <4>Call Trace:
    <4> [<a00000010019ca10>] dqput+0x210/0x4e0
    <4>                                sp=e00000062a21fbe0 
bsp=e00000062a211198
    <4> [<a0000001001a15f0>] vfs_quota_off+0x590/0xca0
    <4>                                sp=e00000062a21fbe0 
bsp=e00000062a2110f8
    <4> [<a0000001001a5660>] sys_quotactl+0x1540/0x15e0
    <4> [<a00000010000b040>] ia64_ret_from_syscall+0x0/0x20
/
/    <4>mount         D a000000100547520     0 24222  
21243                     (NOTLB)
    <4>
    <4>Call Trace:
    <4> [<a000000100543ab0>] schedule+0xc10/0x23a0
    <4>                                sp=e00000055a5efaf0 
bsp=e00000055a5e1248
    <4> [<a000000100547520>] rwsem_down_write_failed+0x1c0/0x4e0
    <4>                                sp=e00000055a5efb30 
bsp=e00000055a5e1200
    <4> [<a000000100139930>] sget+0x6d0/0xb60
    <4>                                sp=e00000055a5efb50 
bsp=e00000055a5e1198
    <4> [<a00000010013b6d0>] get_sb_bdev+0xd0/0x400
    <4>                                sp=e00000055a5efb70 
bsp=e00000055a5e1148
    <4> [<a000000205508980>] ext3_get_sb+0x40/0x60 [ext3]
    <4>                                sp=e00000055a5efb90 
bsp=e00000055a5e1110
 <4> [<a00000010013bfe0>] do_kern_mount+0x140/0x480
   <4> [<a0000001001759f0>] do_mount+0x370/0x1060
    <4>                                sp=e00000055a5efb90 
bsp=e00000055a5e1060
   <4> [<a000000100177000>] sys_mount+0x100/0x1c0
  /


--------------030207070002060207030709
Content-Transfer-Encoding: 7bit
Content-Type: text/x-vcard; charset=utf-8;
 name="xavier.bru.vcf"
Content-Disposition: attachment;
 filename="xavier.bru.vcf"

begin:vcard
fn:Xavier Bru
n:Bru;Xavier
adr:;;1 rue de Provence, BP 208;38432 Echirolles Cedex;;;France
email;internet:Xavier.Bru@bull.net
title:BULL/HPC/linux/kernel
tel;work:+33 (0)4 76 29 77 45
tel;fax:+33 (0)4 76 29 77 70 
x-mozilla-html:TRUE
url:http://www.bull.com
version:2.1
end:vcard


--------------030207070002060207030709--
