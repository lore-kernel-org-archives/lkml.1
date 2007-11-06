Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbXKFQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbXKFQmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXKFQmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:42:24 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39764 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXKFQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:42:21 -0500
Date: Tue, 6 Nov 2007 17:42:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: akpm@linux-foundation.org
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Greg K-H <greg@kroah.com>, Michael Ernst <mernst@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded - S390x
 build fails
Message-ID: <20071106174208.3b01e68f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071106162939.41c4bd36@gondolin.boeblingen.de.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	<473083CA.9060607@linux.vnet.ibm.com>
	<20071106162939.41c4bd36@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 16:29:39 +0100,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> That's a clash between git-s390 and the recent kset cleanup.
> 
> sclp_cpi_sys.c needs to be converted from firmware_register() to the
> new dynamic kset allocation (kset_create_and_register()) and the
> subsys_attributes to kobj_attributes (I may look at it later if I find
> some time).

Adapt sclp_cpi_sys.c to the dynamic kset changes.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/char/sclp_cpi_sys.c |   58 ++++++++++++++++++++++-----------------
 1 files changed, 33 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/s390/char/sclp_cpi_sys.c
===================================================================
--- linux-2.6.orig/drivers/s390/char/sclp_cpi_sys.c	2007-11-06 17:08:59.000000000 +0100
+++ linux-2.6/drivers/s390/char/sclp_cpi_sys.c	2007-11-06 17:30:09.000000000 +0100
@@ -220,13 +220,15 @@ static void set_string(char *attr, const
 	}
 }
 
-static ssize_t system_name_show(struct kset *kset, char *page)
+static ssize_t system_name_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", system_name);
 }
 
-static ssize_t system_name_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_name_store(struct kobject *kobj,
+				 struct kobj_attribute *attr, const char *buf,
+				 size_t len)
 {
 	int rc;
 
@@ -239,16 +241,18 @@ static ssize_t system_name_store(struct 
 	return len;
 }
 
-static struct subsys_attribute system_name_attr =
+static struct kobj_attribute system_name_attr =
 	__ATTR(system_name, 0644, system_name_show, system_name_store);
 
-static ssize_t sysplex_name_show(struct kset *kset, char *page)
+static ssize_t sysplex_name_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", sysplex_name);
 }
 
-static ssize_t sysplex_name_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t sysplex_name_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t len)
 {
 	int rc;
 
@@ -261,17 +265,19 @@ static ssize_t sysplex_name_store(struct
 	return len;
 }
 
-static struct subsys_attribute sysplex_name_attr =
+static struct kobj_attribute sysplex_name_attr =
 	__ATTR(sysplex_name, 0644, sysplex_name_show,
 	sysplex_name_store);
 
-static ssize_t system_type_show(struct kset *kset, char *page)
+static ssize_t system_type_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *page)
 {
 	return snprintf(page, PAGE_SIZE, "%s\n", system_type);
 }
 
-static ssize_t system_type_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_type_store(struct kobject *kobj,
+				 struct kobj_attribute *attr, const char *buf,
+				 size_t len)
 {
 	int rc;
 
@@ -284,18 +290,20 @@ static ssize_t system_type_store(struct 
 	return len;
 }
 
-static struct subsys_attribute system_type_attr =
+static struct kobj_attribute system_type_attr =
 	__ATTR(system_type, 0644, system_type_show, system_type_store);
 
-static ssize_t system_level_show(struct kset *kset, char *page)
+static ssize_t system_level_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *page)
 {
 	unsigned long long level = system_level;
 
 	return snprintf(page, PAGE_SIZE, "%#018llx\n", level);
 }
 
-static ssize_t system_level_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t system_level_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t len)
 {
 	unsigned long long level;
 	char *endp;
@@ -314,12 +322,12 @@ static ssize_t system_level_store(struct
 	return len;
 }
 
-static struct subsys_attribute system_level_attr =
+static struct kobj_attribute system_level_attr =
 	__ATTR(system_level, 0644, system_level_show,
 	system_level_store);
 
-static ssize_t set_store(struct kset *kset, const char *buf,
-	size_t len)
+static ssize_t set_store(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t len)
 {
 	int rc;
 
@@ -330,7 +338,7 @@ static ssize_t set_store(struct kset *ks
 	return len;
 }
 
-static struct subsys_attribute set_attr =
+static struct kobj_attribute set_attr =
 	__ATTR(set, 0200, NULL, set_store);
 
 static struct attribute *cpi_attrs[] = {
@@ -346,7 +354,7 @@ static struct attribute_group cpi_attr_g
 	.attrs = cpi_attrs,
 };
 
-static decl_subsys(cpi, NULL, NULL);
+static struct kset *cpi_kset;
 
 int sclp_cpi_set_data(const char *system, const char *sysplex, const char *type,
 		      const u64 level)
@@ -376,13 +384,13 @@ static int __init cpi_init(void)
 {
 	int rc;
 
-	rc = firmware_register(&cpi_subsys);
-	if (rc)
-		return rc;
+	cpi_kset = kset_create_and_register("cpi", NULL, NULL, firmware_kset);
+	if (IS_ERR(cpi_kset))
+		return PTR_ERR(cpi_kset);
 
-	rc = sysfs_create_group(&cpi_subsys.kobj, &cpi_attr_group);
+	rc = sysfs_create_group(&cpi_kset->kobj, &cpi_attr_group);
 	if (rc)
-		firmware_unregister(&cpi_subsys);
+		kset_unregister(cpi_kset);
 
 	return rc;
 }
