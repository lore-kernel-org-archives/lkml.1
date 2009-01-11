Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbZAKMor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbZAKMor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZAKMoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:44:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZAKMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:44:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata hibernation fixes
Date: Sun, 11 Jan 2009 13:43:49 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081104062734.GA4420@havoc.gtf.org> <495D7DC9.8070101@kernel.org> <49698739.6010003@garzik.org>
In-Reply-To: <49698739.6010003@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111343.49901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Jeff Garzik wrote:
> Tejun Heo wrote:
> > Jeff Garzik wrote:
> >> This adds code at a late stage (heading towards -rc4), but does
> >> eliminate a particular spin-up overcycling behavior associated with
> >> hibernation.
> >>
> >> Rafael's extended description below...  Separated to make it easier to
> >> pull-or-not, separate from the other libata fixes.  There shouldn't be
> >> any merge trouble between the two.
> >>
> >> SATA: Blacklist systems that spin off disks during ACPI power off
> > 
> > Jeff, I think this should be merged into 2.6.29 unless Linus still
> > objects.  Linus, as discussed in this thread, this is workaround for a
> > hardware / firmware problem and vanilla windows also suffers the
> > problem, so as ugly as it is, we need this to prevent double spin down
> > on the machine.
> 
> Oh, I forgot to reply to this...  libata-2.6.git#hibern_regress no 
> longer applies cleanly.

There is a name conflict with a change applied after this patchset had been
created.  The appended patch fixes it for me.

> I'll try poking at it on Monday and get it cleaned up, as it is IMO a 
> bug fix and still should go in.

Thanks!

Best,
Rafael

---
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 9a81508..8f0f7c4 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -415,10 +415,10 @@ void __init dmi_scan_machine(void)
 }
 
 /**
- *	dmi_match - check if dmi_system_id structure matches system DMI data
+ *	dmi_matches - check if dmi_system_id structure matches system DMI data
  *	@dmi: pointer to the dmi_system_id structure to check
  */
-static bool dmi_match(const struct dmi_system_id *dmi)
+static bool dmi_matches(const struct dmi_system_id *dmi)
 {
 	int i;
 
@@ -456,7 +456,7 @@ int dmi_check_system(const struct dmi_system_id *list)
 	const struct dmi_system_id *d;
 
 	for (d = list; d->ident; d++)
-		if (dmi_match(d)) {
+		if (dmi_matches(d)) {
 			count++;
 			if (d->callback && d->callback(d))
 				break;
@@ -483,7 +483,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
 	const struct dmi_system_id *d;
 
 	for (d = list; d->ident; d++)
-		if (dmi_match(d))
+		if (dmi_matches(d))
 			return d;
 
 	return NULL;

