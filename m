Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbYAYIN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbYAYIN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763990AbYAYIA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763982AbYAYH7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kyle McMartin <kyle@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 123/196] Kobject: change drivers/parisc/pdc_stable.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:32 -0800
Message-Id: <1201246425-5058-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parisc/pdc_stable.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index 880b10b..87bc6b7 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -991,13 +991,12 @@ pdcs_register_pathentries(void)
 		if (err < 0)
 			continue;
 
-		if ((err = kobject_set_name(&entry->kobj, "%s", entry->name)))
-			return err;
 		entry->kobj.kset = paths_kset;
-		entry->kobj.ktype = &ktype_pdcspath;
-		if ((err = kobject_register(&entry->kobj)))
+		err = kobject_init_and_add(&entry->kobj, &ktype_pdcspath, NULL,
+					   "%s", entry->name);
+		if (err)
 			return err;
-		
+
 		/* kobject is now registered */
 		write_lock(&entry->rw_lock);
 		entry->ready = 2;
@@ -1009,6 +1008,7 @@ pdcs_register_pathentries(void)
 		}
 
 		write_unlock(&entry->rw_lock);
+		kobject_uevent(&entry->kobj, KOBJ_ADD);
 	}
 	
 	return 0;
-- 
1.5.3.8

