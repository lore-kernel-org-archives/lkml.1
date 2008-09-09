Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYIILTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYIILTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYIILTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:19:41 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:39428 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYIILTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:19:40 -0400
Message-ID: <48C65C6A.6030701@keyaccess.nl>
Date: Tue, 09 Sep 2008 13:22:18 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap"
 messages
References: <200809091250.08620.elendil@planet.nl>
In-Reply-To: <200809091250.08620.elendil@planet.nl>
Content-Type: multipart/mixed;
 boundary="------------090200060703010806080801"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090200060703010806080801
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 09-09-08 12:50, Frans Pop wrote:
> The only thing I used to get for pnp 00:08 on my Toshiba Satellite A40
> up to 2.6.26 was this single line:
> pnp 00:08: can't add resource for IO 0xa8-0xa9
> 
> During bisecting I have found that fairly early in the 2.6.27 cycle this
> was "fixed" and that message disappeared. The commit that changed this was:
> commit aee3ad815dd291a7193ab01da0f1a30c84d00061
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Fri Jun 27 16:56:57 2008 -0600
>     PNP: replace pnp_resource_table with dynamically allocated resources
> 
> Was it expected that that change could lead to a message disappearing?
> I don't really read that from the commit description.
> 
> 
> So far for the intro, now the issue (regression?) that prompted this mail.
> 
> Now with 2.6.27-rc4/5 I'm suddenly getting a total of 78 (!) warnings
> about "io resource overlaps" for pnp 00:08 in my dmesg, even though
> AFAIK those have never caused any trouble.
> 
> Bisection identified this commit as the cause:
> commit 999ed65ad12e374d7445fbc13f5a1d146ae4b0da
> Author: Rene Herman <rene.herman@gmail.com>
> Date:   Fri Jul 25 19:44:47 2008 -0700
>     pnp: have quirk_system_pci_resources() include io resources
> 
> The PCI devices mentioned in the messages (1f.5 and 1f.6) are the ICH4
> AC'97 audio controller and AC'97 (software) modem. At least sound works
> fine _without_ this change; I don't really use the softmodem.
> I'm not completely sure what pnp 00:08 is. Seems to have the "system"
> driver.
> 
> Anyway, I wonder if this patch is really desirable as a general check.

It's not just a check, and not just general...

Generally, you need it -- if PnP grabs an I/O resource, PCI can no 
longer do so (making the driver fail) which is the same problem that 
quirk_system_pci_resources() upto that point solved for mem resources only.

And specifically, I definitely need it to not have my soundcard driver 
crap out due to PnPACPI grabbing a range that overlaps with its BAR.

I don't know why your 1f.5 and 1f.6 are grabbing the "motherboard I/O 
ports" 0x00-0xff (with your BIOS also advertising those ports through 
ACPI) but obviously, 78 messages are not something to put up with.

Bjorn might have something more to say about the general setup of things 
here but at this point and for now it might make most sense to just go 
ahead and do our doings without noting that we do. Ie, just delete the 
message...

Rene.

--------------090200060703010806080801
Content-Type: text/plain;
 name="0001-PNP-delete-quirk_system_pci_resources-warning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-PNP-delete-quirk_system_pci_resources-warning.patch"

>From 68f22c94ebaac4ae16efb1f0caf8f7e78bb3cf5f Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Tue, 9 Sep 2008 13:17:14 +0200
Subject: [PATCH] PNP: delete quirk_system_pci_resources() warning.

Some boxes trigger too many of them.

Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/pnp/quirks.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..9123434 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -285,15 +285,6 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				 * the PCI region, and that might prevent a PCI
 				 * driver from requesting its resources.
 				 */
-				dev_warn(&dev->dev, "%s resource "
-					"(0x%llx-0x%llx) overlaps %s BAR %d "
-					"(0x%llx-0x%llx), disabling\n",
-					pnp_resource_type_name(res),
-					(unsigned long long) pnp_start,
-					(unsigned long long) pnp_end,
-					pci_name(pdev), i,
-					(unsigned long long) pci_start,
-					(unsigned long long) pci_end);
 				res->flags |= IORESOURCE_DISABLED;
 			}
 		}
-- 
1.5.5


--------------090200060703010806080801--
