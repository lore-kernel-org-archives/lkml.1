Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668Ab0AZXwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0AZXwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084Ab0AZXn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:56 -0500
Received: from kroah.org ([198.145.64.141]:35386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0AZXnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.762889668@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [60/98] DMI: allow omitting ident strings in DMI tables
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 75757507e014fa074d25d2883c4ab604999584bd upstream.

The purpose of dmi->ident is twofold - it may be used by DMI callback
functions when composing log messages; it is also used to determine
end of DMI table in dmi_check_system() and dmi_first_match(). However,
in case when callbacks are not interested in using ident at all it just
wastes memory. Let's make entries with empty first match slot serve as
end-of-table markers instead.

[needed for DMI table changes that need to be done by later patches - gkh]

Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/dmi_scan.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -429,7 +429,7 @@ static bool dmi_matches(const struct dmi
 	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
 		int s = dmi->matches[i].slot;
 		if (s == DMI_NONE)
-			continue;
+			break;
 		if (dmi_ident[s]
 		    && strstr(dmi_ident[s], dmi->matches[i].substr))
 			continue;
@@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi
 }
 
 /**
+ *	dmi_is_end_of_table - check for end-of-table marker
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
+{
+	return dmi->matches[0].slot == DMI_NONE;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -457,7 +466,7 @@ int dmi_check_system(const struct dmi_sy
 	int count = 0;
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d)) {
 			count++;
 			if (d->callback && d->callback(d))
@@ -484,7 +493,7 @@ const struct dmi_system_id *dmi_first_ma
 {
 	const struct dmi_system_id *d;
 
-	for (d = list; d->ident; d++)
+	for (d = list; !dmi_is_end_of_table(d); d++)
 		if (dmi_matches(d))
 			return d;
 


