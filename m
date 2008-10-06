Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJFJze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJFJze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 05:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYJFJzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 05:55:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYJFJzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 05:55:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Date: Mon, 6 Oct 2008 11:59:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv>
In-Reply-To: <20081006062235.GA2808@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061159.30103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 of October 2008, Dmitry Torokhov wrote:
> On Mon, Oct 06, 2008 at 12:29:42AM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > On Sun, Oct 05, 2008 at 09:19:13PM +0200, Rafael J. Wysocki wrote:
> > > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > > On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > > > > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > > > > Hi,
> > > > > > > 
> > > > > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > > > > speed, fans are constantly on, everything seems sluggish.
> > > > > > > 
> > > > > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > > > > somewhere in tty_init.
> > > > > > 
> > > > > > Is that an HP box, by chance?
> > > > > > 
> > > > > 
> > > > > Yeah, HP nx6115.
> > > > 
> > > > Oh well.
> > > > 
> > > > Please send me the output of dmidecode from it.
> > > > 
> > > 
> > > Here you go:
> > 
> > Thanks.
> > 
> > Please see if the appended patch helps.
> > 
> 
> Yep, works great, everything is zappy, hdparm reports 30Mb/s and fan is
> off. Thanks a lot!

OK, thanks for the confirmation.  Below is a changelogged version for
inclusion.

> Although I wonder why this blacklist is needed now, earlier kernels were
> able to cope with this condition.

Please see the changelog. :-)

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

x86 ACPI: Blacklist two HP machines with buggy BIOSes

There is a bug in the BIOSes of some HP boxes with AMD Turions which
connects IO-APIC pins with ACPI thermal trip points in such a way
that if the state of the IO-APIC is not as expected by the (buggy)
BIOS, the thermal trip points are set to insanely low values
(usually all of them become 16 degrees Celsius).  As a result,
thermal throttling kicks in and knock the system down to its shoes.

Unfortunately some of the recent IO-APIC changes made the bug show
up.  To prevent this from happening, blacklist machines that are
known to be affected (nx6115 and 6715b in this particular case).

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=11516 listed as
a regression from 2.6.26.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Jason Vas Dias <jason.vas.dias@gmail.com>
---
 arch/x86/kernel/acpi/boot.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1605,6 +1605,14 @@ static struct dmi_system_id __initdata a
 	 */
 	{
 	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "HP nx6115 laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6115"),
+		     },
+	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
 	 .ident = "HP NX6125 laptop",
 	 .matches = {
 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
@@ -1619,6 +1627,14 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
 		     },
 	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "HP 6715b laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
+		     },
+	 },
 	{}
 };
 
