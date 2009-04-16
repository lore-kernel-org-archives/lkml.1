Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZDPVAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZDPVAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZDPU76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:59:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44493 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZDPU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:59:58 -0400
Date: Thu, 16 Apr 2009 21:58:12 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, arjan@linux.intel.com,
       gregkh@suse.de, alan@lxorguk.ukuu.org.uk, viro@ZenIV.linux.org.uk,
       jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: pass correct mm when growing stack
In-Reply-To: <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0904162156310.645@blonde.anvils>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp>
 <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk>
 <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp>
 <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk>
 <200904130048.n3D0mw1f077050@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904141801300.24679@blonde.anvils>
 <200904150328.n3F3S0F9083222@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
 <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
 <Pine.LNX.4.64.0904160551080.28048@blonde.anvils>
 <200904160535.n3G5ZBIE006724@www262.sakura.ne.jp> <Pine.LNX.4.64.0904162145130.645@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa reports seeing the WARN_ON(current->mm == NULL) in
security_vm_enough_memory(), when do_execve() is touching the
target mm's stack, to set up its args and environment.

Yes, a UMH_NO_WAIT or UMH_WAIT_PROC call_usermodehelper() spawns
an mm-less kernel thread to do the exec.  And in any case, that
vm_enough_memory check when growing stack ought to be done on the
target mm, not on the execer's mm (though apart from the warning,
it only makes a slight tweak to OVERCOMMIT_NEVER behaviour).

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---
Commoner in 2.6.30-rc, but needs fixing in 2.6.28.N and 2.6.29.N too.

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.30-rc2/mm/mmap.c	2009-04-08 18:20:25.000000000 +0100
+++ linux/mm/mmap.c	2009-04-16 20:31:17.000000000 +0100
@@ -1575,7 +1575,7 @@ static int acct_stack_growth(struct vm_a
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
