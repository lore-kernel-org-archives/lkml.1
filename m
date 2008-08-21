Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYHUN3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYHUN3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYHUN3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:29:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYHUN3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:29:30 -0400
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200808211440.27577.rjw@sisk.pl>
References: <200808181540.25286.elendil@planet.nl>
	 <200808200956.52883.bjorn.helgaas@hp.com>  <200808211440.27577.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 15:28:56 +0200
Message-Id: <1219325336.20723.32.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18XJtRcEaFdDQrEBVrN+2w7NMvO6DAb9tW6wdM
 nsWo6oPqU3DfciNLVj5dwRSLPPWtH9MCNmt4EwFOj2rvePkZcM
 bXAmID20rWMXY1/ngSTjM/ntIZ8pqtB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-21 at 14:40 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 20 of August 2008, Bjorn Helgaas wrote:
> > On Monday 18 August 2008 07:40:24 am Frans Pop wrote:
> > > While comparing the loaded modules for 2.6.26 and 2.6.27-rc3 for my HP 
> > > 2510p, I noticed that the tpm_infineon module and related modules no 
> > > longer get loaded automatically.
> > > 
> > > The difference seems to be that 2.6.26 listed:
> > > /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0102* tpm_infineon
> > > /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0101* tpm_infineon
> > > 
> > > while 2.6.27 has:
> > > /lib/modules/2.6.27-rc3/modules.alias:alias acpi*:IFX0101:* tpm_infineon
> > > /lib/modules/2.6.27-rc3/modules.alias:alias pnp:dIFX0101* tpm_infineon
> > > 
> > > My system has:
> > > $ grep IFX /sys/bus/pnp/devices/*/id
> > > /sys/bus/pnp/devices/00:02/id:IFX0102
> > 
> > drivers/char/tpm/tpm_infineon.c hasn't changed since v2.6.26.  I think
> > the problem is more likely related to commit 22454cb99fc39f2629a:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22454cb99fc39f2629ad06a7eccb3df312f8830e
> 
> Frans, could you verify if reverting commit 22454cb99fc39f2629a fixes the
> problem for you?

Yeah, we miss to loop over the list. This should fix it. Thanks!


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: pnp: fix "add acpi:* modalias entries"

With 22454cb99fc39f2629ad06a7eccb3df312f8830e we added only the
first entry of the device table. We need to loop over the whole
device list.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 file2alias.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -344,14 +344,20 @@ static void do_pnp_device_entry(void *symval, unsigned long size,
 				struct module *mod)
 {
 	const unsigned long id_size = sizeof(struct pnp_device_id);
-	const struct pnp_device_id *id = symval;
+	const unsigned int count = (size / id_size)-1;
+	const struct pnp_device_id *devs = symval;
+	unsigned int i;
 
 	device_id_check(mod->name, "pnp", size, id_size, symval);
 
-	buf_printf(&mod->dev_table_buf,
-		   "MODULE_ALIAS(\"pnp:d%s*\");\n", id->id);
-	buf_printf(&mod->dev_table_buf,
-		   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id->id);
+	for (i = 0; i < count; i++) {
+		const char *id = (char *)devs[i].id;
+
+		buf_printf(&mod->dev_table_buf,
+			   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+		buf_printf(&mod->dev_table_buf,
+			   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id);
+	}
 }
 
 /* looks like: "pnp:dD" for every device of the card */


