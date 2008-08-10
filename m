Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYHJHs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYHJHs7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYHJHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:39:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:3859 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYHJHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lP3bBxS1m9radWVSamVzqQWdcwBAgZcYAtnz46xoKNsBG/fSzxOXGFOt6mkDfYkeIh
         /6GSjag09Xr64yQWI/UFOfoT7Wtwezhb05aU+vsiBwvO4tiv0fUXZTE/uohi5S51cGgN
         kaoodv6R7Ze/hHhlzqR86EiA9cUgxoIMh1zp4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 32/43] add irq_desc_without_new
Date: Sun, 10 Aug 2008 00:36:21 -0700
Message-Id: <1218353792-3355-33-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-23-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-24-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-25-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-26-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-27-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-28-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-29-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-30-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-31-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-32-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/linux/irq.h |   13 +++++++++++++
 kernel/irq/handle.c |   27 ++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e98bc00..c13e645 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -191,10 +191,23 @@ struct irq_desc {
 } ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc *irq_desc(unsigned int irq);
+extern struct irq_desc *irq_desc_without_new(unsigned int irq);
+
+#ifndef CONFIG_HAVE_SPARSE_IRQ
+
 #ifndef CONFIG_HAVE_DYN_ARRAY
 /* could be removed if we get rid of all irq_desc reference */
 extern struct irq_desc irq_descX[NR_IRQS];
+#else
+extern struct irq_desc *irq_descX;
 #endif
+
+#else
+
+extern struct irq_desc *irq_descX;
+
+#endif
+
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6e7f759..91924b8 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -111,7 +111,6 @@ static void init_kstat_irqs(struct irq_desc *desc, int nr_desc, int nr)
 	}
 }
 
-
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;
@@ -148,9 +147,27 @@ static int __init parse_nr_irq_desc(char *arg)
 
 early_param("nr_irq_desc", parse_nr_irq_desc);
 
-static struct irq_desc *irq_descX;
+struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irq_desc, PAGE_SIZE, init_work);
 
+struct irq_desc *irq_desc_without_new(unsigned int irq)
+{
+	struct irq_desc *desc;
+
+	BUG_ON(irq == -1U);
+
+	desc = &irq_descX[0];
+	while (desc) {
+		if (desc->irq == irq)
+			return desc;
+
+		if (desc->irq == -1U)
+			return NULL;
+
+		desc = desc->next;
+	}
+	return NULL;
+}
 struct irq_desc *irq_desc(unsigned int irq)
 {
 	struct irq_desc *desc, *desc_pri;
@@ -208,7 +225,7 @@ struct irq_desc *irq_desc(unsigned int irq)
 }
 #else
 
-static struct irq_desc *irq_descX;
+struct irq_desc *irq_descX;
 DEFINE_DYN_ARRAY(irq_descX, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);
 
 #endif
@@ -238,6 +255,10 @@ struct irq_desc *irq_desc(unsigned int irq)
 
 	return NULL;
 }
+struct irq_desc *irq_desc_without_new(unsigned int irq)
+{
+	return irq_desc(irq);
+}
 #endif
 
 /*
-- 
1.5.4.5

