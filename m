Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbXJXJdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbXJXJdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXJXJdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:33:24 -0400
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:47893 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752808AbXJXJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:33:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=4KKYlj6f04mjXalLqJQGVN29BCmiyYv4wxPgbLXjJFP7GR7hSfEPbpqjqdWB+nGVodSNuAacra93NKsJu6U3tC3IK8CrPdaimutjTKsqXInVEHCPJTOEYULIj01zvuvI6aReDMIaCHAhVxqS3ytfIQizeqFgqtCsjyVaXPRbD5g=  ;
X-YMail-OSG: fmy_OJ8VM1mUPSNMR_Tcfu.d7B58lkKuf53LuTsz1fNJkxGfYMIwwQ1AtThckSlIqQRMw6wS.Q--
Date: Wed, 24 Oct 2007 11:32:53 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add error handling for
	kobject_add
Message-ID: <20071024093253.GA6191@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20071022052255.GA9095@gollum.tnic> <20071023233900.7e683516.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071023233900.7e683516.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 11:39:00PM -0700, Andrew Morton wrote:
> I get 100% rejects from this.  Please redo against latest mainline.
Here you go, this one is against today's 24-rc1.

---
From: Borislav Petkov <bbpetkov@yahoo.de>

Add error handling to the kobject_add()-call and signal (the even highly
		unlikely) error condition.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
--
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 722e12e..6ba66b4 100644
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
+		pr_err("%s: error adding %s to sysfs.\n", __FUNCTION__,
+				kobject_name(&p->kobj));
+	}
+
 	if (!disk->part_uevent_suppress)
 		kobject_uevent(&p->kobj, KOBJ_ADD);
 	sysfs_create_link(&p->kobj, &block_subsys.kobj, "subsystem");
-- 
Regards/Gruﬂ,
    Boris.
