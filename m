Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbZD3RZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbZD3RZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764635AbZD3RH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:57 -0400
Received: from kroah.org ([198.145.64.141]:56384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764560AbZD3RHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:44 2009
Message-Id: <20090430165744.429966231@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 41/88] mm: pass correct mm when growing stack
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0071-mm-pass-correct-mm-when-growing-stack.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

upstream commit: 05fa199d45c54a9bda7aa3ae6537253d6f097aa9

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1580,7 +1580,7 @@ static int acct_stack_growth(struct vm_a
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */


