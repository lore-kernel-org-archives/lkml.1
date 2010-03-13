Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935265Ab0CMBN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:13:59 -0500
Received: from kroah.org ([198.145.64.141]:46615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935255Ab0CMAag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:36 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.013614301@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Neuling <mikey@neuling.org>,
       WANG Cong <xiyou.wangcong@gmail.com>, Anton Blanchard <anton@samba.org>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Serge Hallyn <serue@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jouni Malinen <j@w1.fi>
Subject: [009/145] fs/exec.c: fix initial stack reservation
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Michael Neuling <mikey@neuling.org>

commit a17e18790a8c47113a73139d54a375dc9ccd8f08 upstream.

803bf5ec259941936262d10ecc84511b76a20921 ("fs/exec.c: restrict initial
stack space expansion to rlimit") attempts to limit the initial stack to
20*PAGE_SIZE.  Unfortunately, in attempting ensure the stack is not
reduced in size, we ended up not changing the stack at all.

This size reduction check is not necessary as the expand_stack call does
this already.

This caused a regression in UML resulting in most guest processes being
killed.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jouni Malinen <j@w1.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -638,7 +638,6 @@ int setup_arg_pages(struct linux_binprm
 	 * will align it up.
 	 */
 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
-	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
 	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_start + rlim_stack;


