Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZLCDMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZLCDMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZLCDMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:12:38 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63148 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZLCDMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cQvU4IzYWdzaR0aHH9xmGgZzC/8aFl25311u1u47o0fwsyyyWB/8hBmV/0a0NOro5z
         ERoB5XXx/t81G5OqiPT78dihM1d5lxsO/j30CBogaB7uaFgqOX1VutrOdfVpO35AyMSc
         2gSwdYL6fxJYgalDeZkhyYJYh/4pf6OAPp+FU=
Date: Wed, 2 Dec 2009 19:12:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091203031240.GB9121@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of dmi->ident is twofold - it may be used by DMI callback
functions when composing log messages; it is also used to determine
end of DMI table in dmi_check_system() and dmi_first_match(). However,
in case when callbacks are not interested in using ident at all it just
wastes memory. Let's consider entries with empty ident but initialized
first match slot as a valid entry and not as end-of-table marker.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

CCed a few random people since they touched dmi code in the last few
months...

 drivers/firmware/dmi_scan.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 938100f..9116aa7 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
 }
 
 /**
+ *	dmi_is_end_of_table - check for end-of-table marker
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
+{
+	return dmi->ident == NULL && dmi->matches[0].slot == DMI_NONE;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -457,7 +466,7 @@ int dmi_check_system(const struct dmi_system_id *list)
 	int count = 0;
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d)) {
 			count++;
 			if (d->callback && d->callback(d))
@@ -484,7 +493,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
 {
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d))
 			return d;
 
-- 
Dmitry
