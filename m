Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYKKX7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYKKX7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYKKX7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:59:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYKKX7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:59:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Wed, 12 Nov 2008 01:03:54 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <20081111181925.GA5036@dose.home.local> <200811120048.06647.rjw@sisk.pl>
In-Reply-To: <200811120048.06647.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811120103.55253.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of November 2008, Rafael J. Wysocki wrote:
> On Tuesday, 11 of November 2008, Tino Keitel wrote:
> > On Tue, Nov 11, 2008 at 15:16:08 +0100, Rafael J. Wysocki wrote:
> > 
> > [...]
> > 
> > > This really is not a good news, because this commit evidently fixes at least
> > > several systems.
> > > 
> > > First, let's try to remove things that we shouldn't be doing.
> > > 
> > > Please apply the patch below to 2.6.27.5 without reverting that commit and see
> > > if that works.
> > 
> > It doesn't work. 2.6.27.5 with the patch applied hangs at resume.
> 
> Well, this appears to be a broken BIOS thing.  Perhaps we'll have to blacklist
> the box or something.
> 
> Is there any possibility to get some information about where exactly it hangs?

Also, can you check this patch on top of 2.6.27.4 and see what happens?

Rafael

---
 drivers/acpi/pci_link.c   |    4 ----
 drivers/acpi/sleep/main.c |    3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/pci_link.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_link.c
+++ linux-2.6/drivers/acpi/pci_link.c
@@ -796,10 +796,6 @@ static int irqrouter_resume(struct sys_d
 	struct list_head *node = NULL;
 	struct acpi_pci_link *link = NULL;
 
-
-	/* Make sure SCI is enabled again (Apple firmware bug?) */
-	acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
-
 	list_for_each(node, &acpi_link.entries) {
 		link = list_entry(node, struct acpi_pci_link, node);
 		if (!link) {
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -249,7 +249,8 @@ static int acpi_suspend_enter(suspend_st
 	}
 
 	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
-	acpi_enable();
+	acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
+	/*acpi_enable();*/
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
