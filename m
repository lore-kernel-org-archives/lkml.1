Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0BVUon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:44:43 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46812 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0BVUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:44:42 -0500
Date: Mon, 22 Feb 2010 15:44:29 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       nhorman@tuxdriver.com
Subject: [PATCH] supress uid comparison test if core output files are pipes
Message-ID: <20100222200851.GD3344@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify uid check in do_coredump so as to not apply it in the case of pipes

So this just got noticed in testing.  The end of do_coredump validates the uid
of the inode for the created file against the uid of the crashing process to
ensure that no one can pre-create a core file with different ownership and grab
the information contained in the core when they shouldn' tbe able to.  This
causes failures when using pipes for a core dumps if the crashing process is not
root, which is the uid of the pipe when it is created.

The fix is simple.  Since the check for matching uid's isn't relevant for pipes
(a process can't create a pipe that the uermodehelper code will open anyway), we
can just just skip it in the event ispipe is non-zero

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6303d18..6af2214 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1987,8 +1987,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
+	 * Note, this is not relevant for pipes
 	 */
-	if (inode->i_uid != current_fsuid())
+	if (!ispipe && (inode->i_uid != current_fsuid()))
 		goto close_fail;
 	if (!cprm.file->f_op)
 		goto close_fail;
