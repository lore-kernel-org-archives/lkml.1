Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYHNWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYHNWmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYHNWmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:42:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56653 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYHNWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:42:34 -0400
Date: Thu, 14 Aug 2008 15:43:33 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] msr: Fix NULL pointer deref due to msr_open on nonexistent
	CPUs
Message-ID: <20080814224333.GG28450@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msr_open tests for someone trying to open a device for a nonexistent CPU.
However, the function always returns 0, not ret like it should, hence userspace
can BUG the kernel trivially.  This bug was introduced by the cdev lock_kernel
pushdown patch last May.

The BUG can be reproduced with these commands:

# mknod fubar c 202 8 <-- pick a number less than NR_CPUS that is not
                          the number of an online CPU
# cat fubar

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 arch/x86/kernel/msr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 9fd8095..e439380 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -131,7 +131,7 @@ static int msr_open(struct inode *inode, struct file *file)
 		ret = -EIO;	/* MSR not supported */
 out:
 	unlock_kernel();
-	return 0;
+	return ret;
 }
 
 /*
