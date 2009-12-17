Return-Path: <linux-kernel-owner+w=401wt.eu-S936500AbZLQE12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936500AbZLQE12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936477AbZLQE0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:26:17 -0500
Received: from kroah.org ([198.145.64.141]:55770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935642AbZLQEE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:55 2009
Message-Id: <20091217035655.322127547@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: [095/151] xen: use iret for return from 64b kernel to 32b usermode
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 6aaf5d633bb6cead81b396d861d7bae4b9a0ba7e upstream.

If Xen wants to return to a 32b usermode with sysret it must use the
right form.  When using VCGF_in_syscall to trigger this, it looks at
the code segment and does a 32b sysret if it is FLAT_USER_CS32.
However, this is different from __USER32_CS, so it fails to return
properly if we use the normal Linux segment.

So avoid the whole mess by dropping VCGF_in_syscall and simply use
plain iret to return to usermode.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/xen-asm_64.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -96,7 +96,7 @@ ENTRY(xen_sysret32)
 	pushq $__USER32_CS
 	pushq %rcx
 
-	pushq $VGCF_in_syscall
+	pushq $0
 1:	jmp hypercall_iret
 ENDPATCH(xen_sysret32)
 RELOC(xen_sysret32, 1b+1)
@@ -151,7 +151,7 @@ ENTRY(xen_syscall32_target)
 ENTRY(xen_sysenter_target)
 	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
-	pushq $VGCF_in_syscall
+	pushq $0
 	jmp hypercall_iret
 ENDPROC(xen_syscall32_target)
 ENDPROC(xen_sysenter_target)


