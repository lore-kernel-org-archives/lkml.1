Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZEVEz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZEVEz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZEVEzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45240 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEVEzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dDZGylFi15wZ3rdv7pKjqkSAc5b7WgbSKrdTGOsFihzY/paQt/hOZs77b0shIwAGOd
         2XLFYcfCMSRnDGOs9RgGalHp+xwfgYaGzgTI+QG19lV+/e749ae5GyXDt8P/3xYYmqK3
         wpQ/ZHZIDdSFiysrnW2YBc2PrBsDLSgBCmuQM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/38] utsns: extract create_uts_ns()
Date: Fri, 22 May 2009 08:54:56 +0400
Message-Id: <1242968132-1044-2-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_uts_ns() will be used by C/R to create fresh uts_ns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/utsname.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/utsname.c b/kernel/utsname.c
index 815237a..8a82b4b 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -15,6 +15,16 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 
+static struct uts_namespace *create_uts_ns(void)
+{
+	struct uts_namespace *uts_ns;
+
+	uts_ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	if (uts_ns)
+		kref_init(&uts_ns->kref);
+	return uts_ns;
+}
+
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
  * @old_ns: namespace to clone
@@ -24,14 +34,13 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
 {
 	struct uts_namespace *ns;
 
-	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
+	ns = create_uts_ns();
 	if (!ns)
 		return ERR_PTR(-ENOMEM);
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
 	up_read(&uts_sem);
-	kref_init(&ns->kref);
 	return ns;
 }
 
-- 
1.5.6.5

