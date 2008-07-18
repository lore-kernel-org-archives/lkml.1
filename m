Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbYGRRQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbYGRRQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYGRRQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:16:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42911 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761098AbYGRRQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:16:14 -0400
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jfs-discussion@lists.sourceforge.net,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 12:15:56 -0500
Message-Id: <1216401356.11215.15.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 10:10 +0200, Vegard Nossum wrote:

> But whether it truly helped or not, I don't know. I got something different now:
> 
> jfs_unlink: dtDelete returned -116
> jfs_unlink: dtDelete returned -116
> ------------[ cut here ]------------
> kernel BUG at fs/inode.c:262!

        BUG_ON(inode->i_data.nrpages);

> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
> EIP: 0060:[<c01b96f9>] EFLAGS: 00010206 CPU: 0
> EIP is at clear_inode+0x149/0x160
> EAX: 00000005 EBX: f56e283c ECX: f7242fd0 EDX: 00000000
> ESI: f56e2568 EDI: 00000000 EBP: f79f9f0c ESP: f79f9f04
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process jfsCommit (pid: 387, ti=f79f8000 task=f7242fd0 task.ti=f79f8000)
> Stack: 00000001 f56e283c f79f9f24 c02de258 c08f7ba0 f79f9f24 c02de220 f56e283c
>        f79f9f34 c01b9ba1 f56e283c 00000000 f79f9f44 c01b9d67 f56e283c 00000000
>        f79f9f50 c01b8be7 f56e283c f79f9f9c c02fd5b5 f88261bc f79f9f70 c0159173

> 
> ...but it might just be a different error altogether.

I think it is.  Your test corrupt more than just di_nlink, right?  There
is a test in jfs_delete_inode() for JFS_IP(inode)->fileset ==
FILESYSTEM_I.  If the test fails, we don't call truncate_inode_pages().
Nowhere do we validate that fileset = FILESYSTEM_I when we read the
inode from disk.

I'm pondering whether it would be okay to remove the silly test in
jfs_delete_inode(), or whether I need to validate the field when we read
in the inode.

Hmm.  The fileset is written to the journal, so it really should be
validated.

Here's another patch

JFS: validate di_fileset when reading inode from disk.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index d6363d8..19df0dd 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -391,7 +391,10 @@ int diRead(struct inode *ip)
 	dp += rel_inode;
 
 	if (ip->i_ino != le32_to_cpu(dp->di_number)) {
-		jfs_error(ip->i_sb, "diRead: i_ino != di_number");
+		jfs_error(ip->i_sb, "JFS diRead: i_ino != di_number");
+		rc = -EIO;
+	} else if (dp->di_fileset != cpu_to_le32(FILESYSTEM_I)) {
+		jfs_error(ip->i_sb, "JFS diRead: inode is corrupt");
 		rc = -EIO;
 	} else if (le32_to_cpu(dp->di_nlink) == 0)
 		rc = -ESTALE;

-- 
David Kleikamp
IBM Linux Technology Center

