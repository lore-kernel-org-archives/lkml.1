Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbYJ2W6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbYJ2W6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYJ2Wq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:27 -0400
Received: from kroah.org ([198.145.64.141]:56282 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754835AbYJ2WqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:14 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/49] Staging: poch: Correct pages from bytes.
Date: Wed, 29 Oct 2008 15:40:06 -0700
Message-Id: <1225320016-21803-39-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Accurately calculate the no. of pages from the bytes.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index de3f8c6..52fc3d4 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -299,6 +299,14 @@ static ssize_t show_direction(struct device *dev,
 }
 static DEVICE_ATTR(dir, S_IRUSR|S_IRGRP, show_direction, NULL);
 
+static unsigned long npages(unsigned long bytes)
+{
+	if (bytes % PAGE_SIZE == 0)
+		return bytes / PAGE_SIZE;
+	else
+		return (bytes / PAGE_SIZE) + 1;
+}
+
 static ssize_t show_mmap_size(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
@@ -309,10 +317,8 @@ static ssize_t show_mmap_size(struct device *dev,
 	unsigned long header_pages;
 	unsigned long total_group_pages;
 
-	/* FIXME: We do not have to add 1, if group_size a multiple of
-	   PAGE_SIZE. */
-	group_pages = (channel->group_size / PAGE_SIZE) + 1;
-	header_pages = (channel->header_size / PAGE_SIZE) + 1;
+	group_pages = npages(channel->group_size);
+	header_pages = npages(channel->header_size);
 	total_group_pages = group_pages * channel->group_count;
 
 	mmap_size = (header_pages + total_group_pages) * PAGE_SIZE;
@@ -350,8 +356,8 @@ static int poch_channel_alloc_groups(struct channel_info *channel)
 	unsigned long group_pages;
 	unsigned long header_pages;
 
-	group_pages = (channel->group_size / PAGE_SIZE) + 1;
-	header_pages = (channel->header_size / PAGE_SIZE) + 1;
+	group_pages = npages(channel->group_size);
+	header_pages = npages(channel->header_size);
 
 	for (i = 0; i < channel->group_count; i++) {
 		struct poch_group_info *group;
@@ -850,8 +856,8 @@ static int poch_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
-	group_pages = (channel->group_size / PAGE_SIZE) + 1;
-	header_pages = (channel->header_size / PAGE_SIZE) + 1;
+	group_pages = npages(channel->group_size);
+	header_pages = npages(channel->header_size);
 	total_group_pages = group_pages * channel->group_count;
 
 	size = vma->vm_end - vma->vm_start;
-- 
1.6.0.2

