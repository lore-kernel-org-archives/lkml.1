Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYLCUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYLCUFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYLCTwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:43 -0500
Received: from kroah.org ([198.145.64.141]:59985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755265AbYLCTwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:41 -0500
Date: Wed, 3 Dec 2008 11:51:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 039/104] PCI: rpaphp: kmalloc/kfree slot->name directly
Message-ID: <20081203195108.GN8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-rpaphp-kmalloc-kfree-slot-name-directly.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit b2132fecca02fa05d509ba4c8c1e51dee6ccd003 upstream.

rpaphp tends to use slot->name directly everywhere, and doesn't
ever need slot->hotplug_slot->name.

struct hotplug_slot->name is going away, so convert rpaphp directly
manipulate its own slot->name everywhere, and don't bother touching
slot->hotplug_slot->name.

Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/rpaphp_slot.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -43,7 +43,7 @@ static void rpaphp_release_slot(struct h
 void dealloc_slot_struct(struct slot *slot)
 {
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
+	kfree(slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
@@ -63,11 +63,9 @@ struct slot *alloc_slot_struct(struct de
 					   GFP_KERNEL);
 	if (!slot->hotplug_slot->info)
 		goto error_hpslot;
-	slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
-	if (!slot->hotplug_slot->name)
+	slot->name = kstrdup(drc_name, GFP_KERNEL);
+	if (!slot->name)
 		goto error_info;	
-	slot->name = slot->hotplug_slot->name;
-	strcpy(slot->name, drc_name);
 	slot->dn = dn;
 	slot->index = drc_index;
 	slot->power_domain = power_domain;

