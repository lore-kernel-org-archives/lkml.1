Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbXITUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbXITUkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXITUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:40:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40140 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbXITUkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:40:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>, Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba Satellite A40
Date: Thu, 20 Sep 2007 22:53:06 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Maciek Rutecki <maciej.rutecki@gmail.com>
References: <200709192014.08443.elendil@planet.nl> <200709202207.13101.rjw@sisk.pl> <200709202232.33309.elendil@planet.nl>
In-Reply-To: <200709202232.33309.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709202253.07571.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 September 2007 22:32, Frans Pop wrote:
> On Thursday 20 September 2007, Rafael J. Wysocki wrote:
> > On Thursday, 20 September 2007 20:33, Alexey Starikovskiy wrote:
> > > Frans Pop wrote:
> > > > On Thursday 20 September 2007, you wrote:
> > > >> Please try this patch.
> > > >
> > > > Works. All states are now listed again.
> > > > I've not tested suspend to disk, but suspend to ram and power off
> > > > work fine.
> > > >
> > > >> +printk(KERN_INFO PREFIX "(supports");
> 
> Note that this printk should be indented.
> 
> > > >>  #ifdef CONFIG_SUSPEND
> > > >> -       printk(KERN_INFO PREFIX "(supports");
> > > >>         for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
> > > >
> > > > Isn't there a risk now that we now end up printing
> > > >    ACPI: (supports)
> > > > if CONFIG_SUSPEND is not enabled and >S4 is not supported?
> > > >
> > > > Or, more probably, it would print
> > > >    ACPI: (supports S5)
> > >
> > > Don't know what does it mean to support S0 exactly... :)
> 
> Agreed, though arguably the same goes for S5. I guess you could say they are 
> all states that can be switched to.
> 
> > > > as it is unlikely that "off" is not supported :-)
> > > >
> > > > Maybe S0 should be taken outside the #ifdef and the loop as that
> > > > state is also basically always there?
> > >
> > > Don't think it is worth the trouble. We already have this loop almost
> > > completely unrolled, let's not make it complete mess...
> >
> > Well, you could use "(supports S0" instead of just "(supports". ;-)
> 
> After thinking about this a bit more, I think this does make sense for three 
> (admittedly minor) reasons:
> - consistency between messages with and without CONFIG_SUSPEND
> - consistency with /proc/acpi/sleep
> - avoiding unnecessary change from previous versions.
> 
> Please consider the attached patch which applies on top of Alexey's. Feel 
> free to integrate it in his patch.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

Alexey, do you agree?

(patch reproduced below for convenience).

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 638172f..85633c5 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -401,9 +401,11 @@ int __init acpi_sleep_init(void)
        if (acpi_disabled)
                return 0;
 
-printk(KERN_INFO PREFIX "(supports");
+       sleep_states[ACPI_STATE_S0] = 1;
+       printk(KERN_INFO PREFIX "(supports S0");
+
 #ifdef CONFIG_SUSPEND
-       for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
+       for (i = ACPI_STATE_S1; i < ACPI_STATE_S4; i++) {
                status = acpi_get_sleep_type_data(i, &type_a, &type_b);
                if (ACPI_SUCCESS(status)) {
                        sleep_states[i] = 1;
