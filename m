Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbXD0TPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbXD0TPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXD0TPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:15:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:35224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbXD0S5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/46] kref: fix CPU ordering with respect to krefs
Date: Fri, 27 Apr 2007 11:53:26 -0700
Message-Id: <11777000814075-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000773819-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

some atomic operations are only atomic, not ordered. Thus a CPU is allowed
to reorder memory references to an object to before the reference is
obtained. This fixes it.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kref.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/kref.c b/lib/kref.c
index 0d07cc3..a6dc3ec 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -21,6 +21,7 @@
 void kref_init(struct kref *kref)
 {
 	atomic_set(&kref->refcount,1);
+	smp_mb();
 }
 
 /**
@@ -31,6 +32,7 @@ void kref_get(struct kref *kref)
 {
 	WARN_ON(!atomic_read(&kref->refcount));
 	atomic_inc(&kref->refcount);
+	smp_mb__after_atomic_inc();
 }
 
 /**
-- 
1.5.1.2

