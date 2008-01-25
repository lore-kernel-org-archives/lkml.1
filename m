Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbYAYI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbYAYI3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbYAYIBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:53727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764095AbYAYIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <axboe@kernel.dk>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 120/196] Kobject: change drivers/block/pktcdvd.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:29 -0800
Message-Id: <1201246425-5058-41-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/pktcdvd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 17da699..d1ee383 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -110,17 +110,18 @@ static struct pktcdvd_kobj* pkt_kobj_create(struct pktcdvd_device *pd,
 					struct kobj_type* ktype)
 {
 	struct pktcdvd_kobj *p;
+	int error;
+
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return NULL;
-	kobject_set_name(&p->kobj, "%s", name);
-	p->kobj.parent = parent;
-	p->kobj.ktype = ktype;
 	p->pd = pd;
-	if (kobject_register(&p->kobj) != 0) {
+	error = kobject_init_and_add(&p->kobj, ktype, parent, "%s", name);
+	if (error) {
 		kobject_put(&p->kobj);
 		return NULL;
 	}
+	kobject_uevent(&p->kobj, KOBJ_ADD);
 	return p;
 }
 /*
-- 
1.5.3.8

