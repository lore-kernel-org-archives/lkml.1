Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYICGyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYICGyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYICGxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:53:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52651 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbYICGxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cWWZK8z7ibB75bLkpU5rqg4SNsDShpNBaa6wM4kU7UtH5wRXBBGNKwYHkM2dGVAAn6
         ydNvl/BEutV0bMZyl7duswiLr3zpb7lVcLzp8wGi8iE+38bSkcS9dfmb7wzwCnkLIgoB
         5UVUN+dyRC3noEbsYJ7+4olh6Ebj26RUbV008=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/5] x86: make get_mode_name of 64bit the same of 32bit
Date: Tue,  2 Sep 2008 23:53:00 -0700
Message-Id: <1220424781-17752-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common_64.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -83,6 +83,7 @@ static struct cpu_dev *this_cpu __cpuini
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
+	char *p, *q;
 
 	if (c->extended_cpuid_level < 0x80000004)
 		return 0;
@@ -92,6 +93,19 @@ int __cpuinit get_model_name(struct cpui
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
+
+	/* Intel chips right-justify this string for some dumb reason;
+	   undo that brain damage */
+	p = q = &c->x86_model_id[0];
+	while (*p == ' ')
+	     p++;
+	if (p != q) {
+	     while (*p)
+		  *q++ = *p++;
+	     while (q <= &c->x86_model_id[48])
+		  *q++ = '\0';	/* Zero-pad the rest */
+	}
+
 	return 1;
 }
 
