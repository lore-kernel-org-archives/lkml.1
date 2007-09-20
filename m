Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbXITHoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbXITHoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXITHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:43:53 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63676 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbXITHnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:43:52 -0400
Date: Thu, 20 Sep 2007 09:43:50 +0200
From: Cornelia Huck <huckc@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: kobject: Temporarily save k_name on cleanup for debug message.
Message-ID: <20070920094350.6417a547@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<200709182345.13435.m.kozlowski@tuxland.pl>
	<20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
	<200709191843.54902.m.kozlowski@tuxland.pl>
	<20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 20:02:05 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> > kobject drivers: cleaning up
> > kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
> 
> <Unrelated side note: We should probably save the kobject's name for
> printing this debug message, it looks a bit odd :)>

kobject: Temporarily save k_name on cleanup for debug message.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 lib/kobject.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -498,9 +498,9 @@ void kobject_cleanup(struct kobject * ko
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
+	const char *k_name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kfree(kobj->k_name);
 	kobj->k_name = NULL;
 	if (t && t->release)
 		t->release(kobj);
@@ -508,8 +508,8 @@ void kobject_cleanup(struct kobject * ko
 		pr_debug("kobject '%s' does not have a release() function, "
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
-			kobject_name(kobj));
-
+			k_name);
+	kfree(k_name);
 	if (s)
 		kset_put(s);
 	kobject_put(parent);
