Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYGVIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYGVIme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYGVIm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:42:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:52240 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYGVImY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=qFYLNUhqqSpZ38/W6r1sHNUqj5w4yINTYqE2q+gllxw9XVTUbm8uKdDJt7j9RVEurm
         jvq6ubw3s/IVyfzbcy23UBsy3ol5GDHKNPDET0/+v0y10FjpLaxHLlp5zuLlxpWUNfMa
         ULCejmfA7fnmUG6AqPIUc5HzdWPvuC8lUMY+A=
Message-ID: <aecf5e530807220142k4d53aa7aq568385cfc6cd44a0@mail.gmail.com>
Date: Tue, 22 Jul 2008 14:12:23 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] IRQ : bug fix in setup_irq
Cc: "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_83119_21041192.1216716144076"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_83119_21041192.1216716144076
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From cf76c764e891a90ab0aaf322327e47e3a3302492 Mon Sep 17 00:00:00 2001
From: Sandeep Kaushik <sandeep-mmc.kaushik@st.com>
Date: Tue, 22 Jul 2008 13:20:51 +0530
Subject: [PATCH] IRQ : bug fix in setup_irq

This patch is for bug fix in setup_irq function.
Error handling is added in setup_irq function. This is required in case if some
architecture dependent pin's set_type function returned error.

Signed-off-by: Sandeep Kaushik <sandeep-mmc.kaushik@st.com>
---
 kernel/irq/manage.c |   24 ++++++++++++++++++++----
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1f31422..a90ed1c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -339,6 +339,8 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		desc->status |= IRQ_NO_BALANCING;

 	if (!shared) {
+		int trigger_type;
+
 		irq_chip_set_defaults(desc->chip);

 #if defined(CONFIG_IRQ_PER_CPU)
@@ -346,11 +348,25 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 			desc->status |= IRQ_PER_CPU;
 #endif

+		trigger_type = new->flags & IRQF_TRIGGER_MASK;
+
 		/* Setup the type (level, edge polarity) if configured: */
-		if (new->flags & IRQF_TRIGGER_MASK) {
-			if (desc->chip && desc->chip->set_type)
-				desc->chip->set_type(irq,
-						new->flags & IRQF_TRIGGER_MASK);
+		if (trigger_type) {
+			if (desc->chip && desc->chip->set_type)	{
+				if ((desc->chip->set_type(irq, trigger_type))) {
+					printk(KERN_ERR "IRQF_TRIGGER set_type"
+							"function for IRQ"
+							"%d (%s) failed\n",
+							irq, desc->chip->name);
+					/*
+					 * Action handler gets freed but
+					 * last action handler on desc->action
+					 * list also needs to bet to NULL.
+					 */
+					*p = NULL;
+					goto mismatch;
+				}
+			}
 			else
 				/*
 				 * IRQF_TRIGGER_* but the PIC does not support
-- 
1.5.6.GIT

------=_Part_83119_21041192.1216716144076
Content-Type: application/octet-stream;
 name=0001-IRQ-bug-fix-in-setup_irq_new1.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiy9awmf0
Content-Disposition: attachment;
 filename=0001-IRQ-bug-fix-in-setup_irq_new1.patch

RnJvbSBjZjc2Yzc2NGU4OTFhOTBhYjBhYWYzMjIzMjdlNDdlM2EzMzAyNDkyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW5kZWVwIEthdXNoaWsgPHNhbmRlZXAtbW1jLmthdXNoaWtA
c3QuY29tPgpEYXRlOiBUdWUsIDIyIEp1bCAyMDA4IDEzOjIwOjUxICswNTMwClN1YmplY3Q6IFtQ
QVRDSF0gSVJRIDogYnVnIGZpeCBpbiBzZXR1cF9pcnEKClRoaXMgcGF0Y2ggaXMgZm9yIGJ1ZyBm
aXggaW4gc2V0dXBfaXJxIGZ1bmN0aW9uLgpFcnJvciBoYW5kbGluZyBpcyBhZGRlZCBpbiBzZXR1
cF9pcnEgZnVuY3Rpb24uIFRoaXMgaXMgcmVxdWlyZWQgaW4gY2FzZSBpZiBzb21lCmFyY2hpdGVj
dHVyZSBkZXBlbmRlbnQgcGluJ3Mgc2V0X3R5cGUgZnVuY3Rpb24gcmV0dXJuZWQgZXJyb3IuCgpT
aWduZWQtb2ZmLWJ5OiBTYW5kZWVwIEthdXNoaWsgPHNhbmRlZXAtbW1jLmthdXNoaWtAc3QuY29t
PgotLS0KIGtlcm5lbC9pcnEvbWFuYWdlLmMgfCAgIDI0ICsrKysrKysrKysrKysrKysrKysrLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2tlcm5lbC9pcnEvbWFuYWdlLmMgYi9rZXJuZWwvaXJxL21hbmFnZS5jCmluZGV4
IDFmMzE0MjIuLmE5MGVkMWMgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9pcnEvbWFuYWdlLmMKKysrIGIv
a2VybmVsL2lycS9tYW5hZ2UuYwpAQCAtMzM5LDYgKzMzOSw4IEBAIGludCBzZXR1cF9pcnEodW5z
aWduZWQgaW50IGlycSwgc3RydWN0IGlycWFjdGlvbiAqbmV3KQogCQlkZXNjLT5zdGF0dXMgfD0g
SVJRX05PX0JBTEFOQ0lORzsKIAogCWlmICghc2hhcmVkKSB7CisJCWludCB0cmlnZ2VyX3R5cGU7
CisKIAkJaXJxX2NoaXBfc2V0X2RlZmF1bHRzKGRlc2MtPmNoaXApOwogCiAjaWYgZGVmaW5lZChD
T05GSUdfSVJRX1BFUl9DUFUpCkBAIC0zNDYsMTEgKzM0OCwyNSBAQCBpbnQgc2V0dXBfaXJxKHVu
c2lnbmVkIGludCBpcnEsIHN0cnVjdCBpcnFhY3Rpb24gKm5ldykKIAkJCWRlc2MtPnN0YXR1cyB8
PSBJUlFfUEVSX0NQVTsKICNlbmRpZgogCisJCXRyaWdnZXJfdHlwZSA9IG5ldy0+ZmxhZ3MgJiBJ
UlFGX1RSSUdHRVJfTUFTSzsKKwogCQkvKiBTZXR1cCB0aGUgdHlwZSAobGV2ZWwsIGVkZ2UgcG9s
YXJpdHkpIGlmIGNvbmZpZ3VyZWQ6ICovCi0JCWlmIChuZXctPmZsYWdzICYgSVJRRl9UUklHR0VS
X01BU0spIHsKLQkJCWlmIChkZXNjLT5jaGlwICYmIGRlc2MtPmNoaXAtPnNldF90eXBlKQotCQkJ
CWRlc2MtPmNoaXAtPnNldF90eXBlKGlycSwKLQkJCQkJCW5ldy0+ZmxhZ3MgJiBJUlFGX1RSSUdH
RVJfTUFTSyk7CisJCWlmICh0cmlnZ2VyX3R5cGUpIHsKKwkJCWlmIChkZXNjLT5jaGlwICYmIGRl
c2MtPmNoaXAtPnNldF90eXBlKQl7CisJCQkJaWYgKChkZXNjLT5jaGlwLT5zZXRfdHlwZShpcnEs
IHRyaWdnZXJfdHlwZSkpKSB7CisJCQkJCXByaW50ayhLRVJOX0VSUiAiSVJRRl9UUklHR0VSIHNl
dF90eXBlIgorCQkJCQkJCSJmdW5jdGlvbiBmb3IgSVJRIgorCQkJCQkJCSIlZCAoJXMpIGZhaWxl
ZFxuIiwKKwkJCQkJCQlpcnEsIGRlc2MtPmNoaXAtPm5hbWUpOworCQkJCQkvKgorCQkJCQkgKiBB
Y3Rpb24gaGFuZGxlciBnZXRzIGZyZWVkIGJ1dAorCQkJCQkgKiBsYXN0IGFjdGlvbiBoYW5kbGVy
IG9uIGRlc2MtPmFjdGlvbgorCQkJCQkgKiBsaXN0IGFsc28gbmVlZHMgdG8gYmV0IHRvIE5VTEwu
CisJCQkJCSAqLworCQkJCQkqcCA9IE5VTEw7CisJCQkJCWdvdG8gbWlzbWF0Y2g7CisJCQkJfQor
CQkJfQogCQkJZWxzZQogCQkJCS8qCiAJCQkJICogSVJRRl9UUklHR0VSXyogYnV0IHRoZSBQSUMg
ZG9lcyBub3Qgc3VwcG9ydAotLSAKMS41LjYuR0lUCgo=
------=_Part_83119_21041192.1216716144076--
