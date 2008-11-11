Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYKKOL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYKKOL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYKKOLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:11:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53491 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbYKKOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:11:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Tue, 11 Nov 2008 15:16:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
References: <20081109202830.GA7206@x61> <200811092151.57620.rjw@sisk.pl> <20081111065643.GA11757@x61>
In-Reply-To: <20081111065643.GA11757@x61>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111516.09163.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Tino Keitel wrote:
> On Sun, Nov 09, 2008 at 21:51:57 +0100, Rafael J. Wysocki wrote:
> > On Sunday, 9 of November 2008, Greg KH wrote:
> > > On Sun, Nov 09, 2008 at 09:28:30PM +0100, Tino Keitel wrote:
> > > > Hi,
> > > > 
> > > > my Mac mini Core Duo doesn't wake up from suspend to RAM anymore with
> > > > 2.6.27.4. It works with 2.6.27.3. I enabled pm_trace, but dmesg | grep
> > > > "hash matches" didn't show anything after resume. I tried 2.6.27.5,
> > > > which also failed to resume.
> > > > 
> > > > The system is i386, the hardware is basically Intel based: Core Duo
> > > > T2300 CPU, Intel graphics i945, ICH7, Marvell GbE (sky2), a SATA hard
> > > > disk, PATA DVD drive, a Firewire hard disk, and a lot of USB devices.
> > > > 
> > > > Does that ring any bells? Any hints what commit I should try to revert?
> > > 
> > > Can you run 'git bisect' on the patches in 2.6.27.4 to see which one
> > > broke your box?
> > 
> > I would start from these commits:
> > 
> > 3b987ac961486373f91191b14291b331fa546072
> > "ACPI suspend: Always use the 32-bit waking vector"
> > 
> > 66036f5862883fcc9f7ff8550685a5a3de1a57e4
> > "ACPI Suspend: Enable ACPI during resume if SCI_EN is not set"
> 
> Thanks Rafael, 2.6.27.5 with 66036f5862883fcc9f7ff8550685a5a3de1a57e4
> reverted resumes fine.

This really is not a good news, because this commit evidently fixes at least
several systems.

First, let's try to remove things that we shouldn't be doing.

Please apply the patch below to 2.6.27.5 without reverting that commit and see
if that works.

Thanks,
Rafael

---
 drivers/acpi/pci_link.c |    4 ----
 1 file changed, 4 deletions(-)

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
