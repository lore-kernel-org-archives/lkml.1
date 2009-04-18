Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZDRUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZDRUCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZDRUCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:02:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:35062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZDRUCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:02:14 -0400
Message-ID: <49EA3176.4010901@kernel.org>
Date: Sat, 18 Apr 2009 13:00:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] driver: dont update dev_name if it is not changed
References: <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de>
In-Reply-To: <20090418192314.GA22107@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


notice one system /proc/iomem some entries missed the name for pci_devices

it turns that dev->dev.kobj name is changed after device_add.

[Impact: fix corrupted names in /proc/iomem ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 lib/kobject.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/lib/kobject.c
===================================================================
--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -216,12 +216,21 @@ int kobject_set_name_vargs(struct kobjec
 				  va_list vargs)
 {
 	const char *old_name = kobj->name;
+	char *new_name;
 	char *s;
 
-	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	new_name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!new_name)
 		return -ENOMEM;
 
+	/* different ? */
+	if (!strcmp(new_name, old_name)) {
+		kfree(new_name);
+		return 0;
+	}
+
+	kobj->name = new_name;
+
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';
