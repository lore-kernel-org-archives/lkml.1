Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbYGRKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbYGRKVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYGRKVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 06:21:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:18249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbYGRKVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 06:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=AP9WhCn182P8MNIubDb4FYKV//yANWkblPBeb26q45ah8uQDbR61y8HHaXvMk4fX1r
         ILt0QFsIew/L3AA/clOBTT1VRc3pOwPFb3e3bRBY7FqiWKgObV6rUeR9KLXHNBHM5RMl
         6XJL4GMybTz4X6gFHaeJy7RS44euFAhYeezag=
Message-ID: <aecf5e530807180321v529c95e1k91fbcffe246a0a75@mail.gmail.com>
Date: Fri, 18 Jul 2008 15:51:02 +0530
From: "sasa sasa" <sasak.1983@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] IRQ : bug fix in setup_irq
Cc: "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_47759_14874118.1216376462261"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_47759_14874118.1216376462261
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From ebb5cb875363822e7c2dc17dae36f14dd4a0e71e Mon Sep 17 00:00:00 2001
From: Sandeep Kaushik <sandeep-mmc.kaushik@st.com>
Date: Fri, 18 Jul 2008 14:58:19 +0530
Subject: [PATCH] IRQ : bug fix in setup_irq

This patch is for bug fix in setup_irq function.
Error handling is added in setup_irq function. This is required in case if some
rchitecture dependent pins like gpio pins are requested as interrupt pin and
they are already occupied by other devices in some other modes, then setup_irq
must return error.

Signed-off-by: Sandeep Kaushik <sandeep-mmc.kaushik@st.com>
---
 kernel/irq/manage.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 1f31422..ca92f97 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -339,6 +339,7 @@ int setup_irq(unsigned int irq, struct irqaction *new)
 		desc->status |= IRQ_NO_BALANCING;

 	if (!shared) {
+		int trigger_type = 0;
 		irq_chip_set_defaults(desc->chip);

 #if defined(CONFIG_IRQ_PER_CPU)
@@ -346,11 +347,22 @@ int setup_irq(unsigned int irq, struct irqaction *new)
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
+					/* Action handler gets freed but
+					 * desc->action also needs to be
+					 * set to NULL
+					 */
+					*p = NULL;
+					spin_unlock_irqrestore(&desc->lock,
+								flags);
+					return -EBUSY;
+				}
+			}
 			else
 				/*
 				 * IRQF_TRIGGER_* but the PIC does not support
@@ -571,8 +583,10 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 #endif

 	retval = setup_irq(irq, action);
-	if (retval)
+	if (retval) {
+		printk(KERN_WARNING"Failed to allocate interrupt %d\n", retval);
 		kfree(action);
+	}

 	return retval;
 }
-- 
1.5.6.GIT

------=_Part_47759_14874118.1216376462261
Content-Type: application/octet-stream;
 name=0001-IRQ-bug-fix-in-setup_irq.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fisn22io0
Content-Disposition: attachment;
 filename=0001-IRQ-bug-fix-in-setup_irq.patch

RnJvbSBlYmI1Y2I4NzUzNjM4MjJlN2MyZGMxN2RhZTM2ZjE0ZGQ0YTBlNzFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW5kZWVwIEthdXNoaWsgPHNhbmRlZXAtbW1jLmthdXNoaWtA
c3QuY29tPgpEYXRlOiBGcmksIDE4IEp1bCAyMDA4IDE0OjU4OjE5ICswNTMwClN1YmplY3Q6IFtQ
QVRDSF0gSVJRIDogYnVnIGZpeCBpbiBzZXR1cF9pcnEKClRoaXMgcGF0Y2ggaXMgZm9yIGJ1ZyBm
aXggaW4gc2V0dXBfaXJxIGZ1bmN0aW9uLgpFcnJvciBoYW5kbGluZyBpcyBhZGRlZCBpbiBzZXR1
cF9pcnEgZnVuY3Rpb24uIFRoaXMgaXMgcmVxdWlyZWQgaW4gY2FzZSBpZiBzb21lCnJjaGl0ZWN0
dXJlIGRlcGVuZGVudCBwaW5zIGxpa2UgZ3BpbyBwaW5zIGFyZSByZXF1ZXN0ZWQgYXMgaW50ZXJy
dXB0IHBpbiBhbmQgCnRoZXkgYXJlIGFscmVhZHkgb2NjdXBpZWQgYnkgb3RoZXIgZGV2aWNlcyBp
biBzb21lIG90aGVyIG1vZGVzLCB0aGVuIHNldHVwX2lycQptdXN0IHJldHVybiBlcnJvci4KClNp
Z25lZC1vZmYtYnk6IFNhbmRlZXAgS2F1c2hpayA8c2FuZGVlcC1tbWMua2F1c2hpa0BzdC5jb20+
Ci0tLQoga2VybmVsL2lycS9tYW5hZ2UuYyB8ICAgMjQgKysrKysrKysrKysrKysrKysrKy0tLS0t
CiAxIGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEva2VybmVsL2lycS9tYW5hZ2UuYyBiL2tlcm5lbC9pcnEvbWFuYWdlLmMKaW5kZXgg
MWYzMTQyMi4uY2E5MmY5NyAxMDA2NDQKLS0tIGEva2VybmVsL2lycS9tYW5hZ2UuYworKysgYi9r
ZXJuZWwvaXJxL21hbmFnZS5jCkBAIC0zMzksNiArMzM5LDcgQEAgaW50IHNldHVwX2lycSh1bnNp
Z25lZCBpbnQgaXJxLCBzdHJ1Y3QgaXJxYWN0aW9uICpuZXcpCiAJCWRlc2MtPnN0YXR1cyB8PSBJ
UlFfTk9fQkFMQU5DSU5HOwogCiAJaWYgKCFzaGFyZWQpIHsKKwkJaW50IHRyaWdnZXJfdHlwZSA9
IDA7CiAJCWlycV9jaGlwX3NldF9kZWZhdWx0cyhkZXNjLT5jaGlwKTsKIAogI2lmIGRlZmluZWQo
Q09ORklHX0lSUV9QRVJfQ1BVKQpAQCAtMzQ2LDExICszNDcsMjIgQEAgaW50IHNldHVwX2lycSh1
bnNpZ25lZCBpbnQgaXJxLCBzdHJ1Y3QgaXJxYWN0aW9uICpuZXcpCiAJCQlkZXNjLT5zdGF0dXMg
fD0gSVJRX1BFUl9DUFU7CiAjZW5kaWYKIAorCQl0cmlnZ2VyX3R5cGUgPSBuZXctPmZsYWdzICYg
SVJRRl9UUklHR0VSX01BU0s7CisKIAkJLyogU2V0dXAgdGhlIHR5cGUgKGxldmVsLCBlZGdlIHBv
bGFyaXR5KSBpZiBjb25maWd1cmVkOiAqLwotCQlpZiAobmV3LT5mbGFncyAmIElSUUZfVFJJR0dF
Ul9NQVNLKSB7Ci0JCQlpZiAoZGVzYy0+Y2hpcCAmJiBkZXNjLT5jaGlwLT5zZXRfdHlwZSkKLQkJ
CQlkZXNjLT5jaGlwLT5zZXRfdHlwZShpcnEsCi0JCQkJCQluZXctPmZsYWdzICYgSVJRRl9UUklH
R0VSX01BU0spOworCQlpZiAodHJpZ2dlcl90eXBlKSB7CisJCQlpZiAoZGVzYy0+Y2hpcCAmJiBk
ZXNjLT5jaGlwLT5zZXRfdHlwZSkJeworCQkJCWlmICgoZGVzYy0+Y2hpcC0+c2V0X3R5cGUoaXJx
LCB0cmlnZ2VyX3R5cGUpKSkgeworCQkJCQkvKiBBY3Rpb24gaGFuZGxlciBnZXRzIGZyZWVkIGJ1
dAorCQkJCQkgKiBkZXNjLT5hY3Rpb24gYWxzbyBuZWVkcyB0byBiZQorCQkJCQkgKiBzZXQgdG8g
TlVMTAorCQkJCQkgKi8KKwkJCQkJKnAgPSBOVUxMOworCQkJCQlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZkZXNjLT5sb2NrLAorCQkJCQkJCQlmbGFncyk7CisJCQkJCXJldHVybiAtRUJVU1k7CisJ
CQkJfQorCQkJfQogCQkJZWxzZQogCQkJCS8qCiAJCQkJICogSVJRRl9UUklHR0VSXyogYnV0IHRo
ZSBQSUMgZG9lcyBub3Qgc3VwcG9ydApAQCAtNTcxLDggKzU4MywxMCBAQCBpbnQgcmVxdWVzdF9p
cnEodW5zaWduZWQgaW50IGlycSwgaXJxX2hhbmRsZXJfdCBoYW5kbGVyLAogI2VuZGlmCiAKIAly
ZXR2YWwgPSBzZXR1cF9pcnEoaXJxLCBhY3Rpb24pOwotCWlmIChyZXR2YWwpCisJaWYgKHJldHZh
bCkgeworCQlwcmludGsoS0VSTl9XQVJOSU5HIkZhaWxlZCB0byBhbGxvY2F0ZSBpbnRlcnJ1cHQg
JWRcbiIsIHJldHZhbCk7CiAJCWtmcmVlKGFjdGlvbik7CisJfQogCiAJcmV0dXJuIHJldHZhbDsK
IH0KLS0gCjEuNS42LkdJVAoK
------=_Part_47759_14874118.1216376462261--
