Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106Ab0AZT31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab0AZT31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116Ab0AZT3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:29:18 -0500
Received: from kroah.org ([198.145.64.141]:33620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab0AZT3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:29:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 11:16:25 2010
Message-Id: <20100126191625.184885976@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 11:14:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [11/11] KVM: S390: fix potential array overrun in intercept handling
In-Reply-To: <20100126191730.GA20872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 062d5e9b0d714f449b261bb522eadaaf6f00f438 upstream.

kvm_handle_sie_intercept uses a jump table to get the intercept handler
for a SIE intercept. Static code analysis revealed a potential problem:
the intercept_funcs jump table was defined to contain (0x48 >> 2) entries,
but we only checked for code > 0x48 which would cause an off-by-one
array overflow if code == 0x48.

Use the compiler and ARRAY_SIZE to automatically set the limits.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kvm/intercept.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -199,7 +199,7 @@ static int handle_instruction_and_prog(s
 	return rc2;
 }
 
-static const intercept_handler_t intercept_funcs[0x48 >> 2] = {
+static const intercept_handler_t intercept_funcs[] = {
 	[0x00 >> 2] = handle_noop,
 	[0x04 >> 2] = handle_instruction,
 	[0x08 >> 2] = handle_prog,
@@ -216,7 +216,7 @@ int kvm_handle_sie_intercept(struct kvm_
 	intercept_handler_t func;
 	u8 code = vcpu->arch.sie_block->icptcode;
 
-	if (code & 3 || code > 0x48)
+	if (code & 3 || (code >> 2) >= ARRAY_SIZE(intercept_funcs))
 		return -ENOTSUPP;
 	func = intercept_funcs[code >> 2];
 	if (func)


