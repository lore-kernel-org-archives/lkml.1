Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbYHURiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYHURiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYHURhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:37:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:34324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759585AbYHURhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:37:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/15] driver model: anti-oopsing medicine
Date: Thu, 21 Aug 2008 10:32:54 -0700
Message-Id: <1219339983-9634-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Anti-oops medicine for the class iterators ... the oops was
observed when a class was implicitly referenced before it
was initialized.

[Modified by Greg to spit a warning back so someone knows to fix their code]

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 5667c2f..cc5e28c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -295,6 +295,12 @@ int class_for_each_device(struct class *class, struct device *start,
 
 	if (!class)
 		return -EINVAL;
+	if (!class->p) {
+		WARN(1, "%s called for class '%s' before it was initialized",
+		     __func__, class->name);
+		return -EINVAL;
+	}
+
 	mutex_lock(&class->p->class_mutex);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
 		if (start) {
@@ -344,6 +350,11 @@ struct device *class_find_device(struct class *class, struct device *start,
 
 	if (!class)
 		return NULL;
+	if (!class->p) {
+		WARN(1, "%s called for class '%s' before it was initialized",
+		     __func__, class->name);
+		return NULL;
+	}
 
 	mutex_lock(&class->p->class_mutex);
 	list_for_each_entry(dev, &class->p->class_devices, node) {
-- 
1.5.6.5

