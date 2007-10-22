Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbXJVFZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbXJVFZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXJVFZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:25:15 -0400
Received: from smtp125.plus.mail.mud.yahoo.com ([209.191.106.156]:44056 "HELO
	smtp125.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751139AbXJVFZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:25:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=XDbtr0fm3lBLVjQk6vbVjzMePTDr9W1M2eH2cONOA3lf1014JsRKz5fGfBwMwuHZEprNLYI1F6HOcvl2nZeQCVgI0j/7crxU4hPD3mLC5W0jZKUR3fUI06fePHxJAHizIYOheLX2ARm6i4GxUiqBgWt52vqBnzsEGFfwEWKFqSU=  ;
X-YMail-OSG: IBFGgp0VM1madP.z1xR99G_ivvLmGb9llhGl0qtZR0tz2E7sYVu9AoxpvQDFk3t8CK0SpD50LA--
Date: Mon, 22 Oct 2007 07:22:55 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/partitions/check.c: add error handling for kobject_add
Message-ID: <20071022052255.GA9095@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Add error handling to the kobject_add()-call and signal (the even highly
unlikely) error condition.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

--
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..5490e33 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -371,11 +371,12 @@ void delete_partition(struct gendisk *disk, int part)
 void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
 {
 	struct hd_struct *p;
+	int err = -EINVAL;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return;
-	
+
 	p->start_sect = start;
 	p->nr_sects = len;
 	p->partno = part;
@@ -390,7 +391,13 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 	p->kobj.parent = &disk->kobj;
 	p->kobj.ktype = &ktype_part;
 	kobject_init(&p->kobj);
-	kobject_add(&p->kobj);
+
+	err = kobject_add(&p->kobj);
+	if (err) {
+		pr_err("%s: Error adding %s to sysfs\n", __FUNCTION__,
+				kobject_name(&p->kobj));
+	}
+
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
 	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
-- 
Regards/Gruﬂ,
    Boris.
