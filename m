Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZECXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZECXYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbZECXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:24:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:14913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZECXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KpFKZDASVugA3p0xO/Op77IyYxIPmRotwXfEAoY2WwMSY2Zalod13j0Ivi08tXM4b0
         rXJmZWuigjjfWD55I5nWF/JCbDuuCf/GADds79YkkGrdLoTg4J3GQvqooZynX/c7ndiE
         3mzjBb/jfJnfTnKIKYeH06T3C3kwvo6ocbtUI=
Date: Mon, 4 May 2009 03:25:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH] utsns: extract creeate_uts_ns()
Message-ID: <20090503232510.GA16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
 
