Return-Path: <linux-kernel-owner+w=401wt.eu-S1761851AbYAKMHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851AbYAKMHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYAKMD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:59 -0500
Received: from smtp107.plus.mail.re1.yahoo.com ([69.147.102.70]:20682 "HELO
	smtp107.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759421AbYAKMDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=vggyrCq1jixtch1niBCRxYR5uj2CtaHRo8cR8m+MCRLRpzGlmG1r8P8rNByLAj9ZPMGA5osyj3p6PcT07DU6Q3hRv4pfejjaV/pal++YnN1xnwzZEYJZLtik4dZJTO/QLxRh1bWU319mxAUJo+M0YfH1HIfESMbC7jtkJYGrPLM=  ;
X-YMail-OSG: 6lWVH.oVM1lk62yBVt2.FSNFenHR.FGHt.IbKUIKSdohciaqROP64MPaDFcoEyHz5H5h.cMczg--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 15/21] ide-floppy: disambiguate function names
Date: Fri, 11 Jan 2008 12:58:13 +0100
Message-Id: <1200052699-28420-16-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-13-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were two almost identical function names in ide-floppy.c, which makes their
distinction almost impossible. While ide_floppy_release() cleans up the object
after the last reference to it has been dropped, idefloppy_release() is the blkdev
.release method from struct block_device_operations which releases that last reference.

Rename ide_floppy_release() to idefloppy_cleanup_obj() in order to make its purpose
more clear. There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index b718615..6e8926a 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -234,12 +234,12 @@ static struct ide_floppy_obj *ide_floppy_get(struct gendisk *disk)
 	return floppy;
 }
 
-static void ide_floppy_release(struct kref *);
+static void idefloppy_cleanup_obj(struct kref *);
 
 static void ide_floppy_put(struct ide_floppy_obj *floppy)
 {
 	mutex_lock(&idefloppy_ref_mutex);
-	kref_put(&floppy->kref, ide_floppy_release);
+	kref_put(&floppy->kref, idefloppy_cleanup_obj);
 	mutex_unlock(&idefloppy_ref_mutex);
 }
 
@@ -1431,7 +1431,7 @@ static void ide_floppy_remove(ide_drive_t *drive)
 	ide_floppy_put(floppy);
 }
 
-static void ide_floppy_release(struct kref *kref)
+static void idefloppy_cleanup_obj(struct kref *kref)
 {
 	struct ide_floppy_obj *floppy = to_ide_floppy(kref);
 	ide_drive_t *drive = floppy->drive;
-- 
1.5.3.7

