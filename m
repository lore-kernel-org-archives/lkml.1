Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYBXLNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYBXLNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYBXLNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:13:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYBXLNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:13:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [PATCH] PM: Introduce PM_EVENT_HIBERNATE (was: Re: i915 hibernation patch (was: Re: 2.6.25-rc2 System no longer ...))
Date: Sun, 24 Feb 2008 12:11:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802231913.27592.rjw@sisk.pl> <1203826599.30621.25.camel@mtlp>
In-Reply-To: <1203826599.30621.25.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802241211.48000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Mirco Tischler wrote:
> 
> On Sa, 2008-02-23 at 19:13 +0100, Rafael J. Wysocki wrote:
> > Index: linux-2.6/drivers/usb/host/u132-hcd.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/usb/host/u132-hcd.c
> > +++ linux-2.6/drivers/usb/host/u132-hcd.c
> > @@ -3214,14 +3214,19 @@ static int u132_suspend(struct platform_
> >                  return -ESHUTDOWN;
> >          } else {
> >                  int retval = 0;
> > -                if (state.event == PM_EVENT_FREEZE) {
> > +
> > +		switch (state.event) {
> > +		case PM_EVENT_FREEZE:
> >                          retval = u132_bus_suspend(hcd);
> > -                } else if (state.event == PM_EVENT_SUSPEND) {
> > +			break;
> > +		case PM_EVENT_SUSPEND:
> > +		case PM_EVENT_HIBERNATE:
> >                          int ports = MAX_U132_PORTS;
> >                          while (ports-- > 0) {
> >                                  port_power(u132, ports, 0);
> >                          }
> > -                }
> > +			break;
> > +		}
> >                  if (retval == 0)
> >                          pdev->dev.power.power_state = state;
> >                  return retval;
> ﻿Hmm. Doesn't compile for me in 2.6.25-rc2-git7:
> 
>   CC [M]  drivers/usb/host/u132-hcd.o
> drivers/usb/host/u132-hcd.c: In function ‘u132_suspend’:
> drivers/usb/host/u132-hcd.c:3224: error: expected expression before
> ‘int’
> drivers/usb/host/u132-hcd.c:3225: error: ‘ports’ undeclared (first use
> in this function)
> drivers/usb/host/u132-hcd.c:3225: error: (Each undeclared identifier is
> reported only once
> drivers/usb/host/u132-hcd.c:3225: error: for each function it appears
> in.)
> make[3]: *** [drivers/usb/host/u132-hcd.o] Error 1
> make[2]: *** [drivers/usb/host] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2
> 
> This fixes it:
> 
> Thanks
> Mirco
> 
> ---
> From: Mirco Tischler <mt-ml@gmx.de>
> 
> Fixes the following compile error caused by commit
> 3a2d5b700132f35401f1d9e22fe3c2cab02c2549
> 
> ...
>   CC [M]  drivers/usb/host/u132-hcd.o
> drivers/usb/host/u132-hcd.c: In function ‘u132_suspend’:
> drivers/usb/host/u132-hcd.c:3224: error: expected expression before
> ‘int’
> drivers/usb/host/u132-hcd.c:3225: error: ‘ports’ undeclared (first use
> in this function)
> ...
> 
> Signed-off-by: Mirco Tischler <mt-ml@gmx.de>
> ---
>  drivers/usb/host/u132-hcd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
> index 6fca069..58830b2 100644
> --- a/drivers/usb/host/u132-hcd.c
> +++ b/drivers/usb/host/u132-hcd.c
> @@ -3214,6 +3214,7 @@ static int u132_suspend(struct platform_device
> *pdev, pm_message_t state)
>                  return -ESHUTDOWN;
>          } else {
>                  int retval = 0;
> +		int ports = 0;

Hm, why not to do:

---
 drivers/usb/host/u132-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/usb/host/u132-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/u132-hcd.c
+++ linux-2.6/drivers/usb/host/u132-hcd.c
@@ -3214,6 +3214,7 @@ static int u132_suspend(struct platform_
                 return -ESHUTDOWN;
         } else {
                 int retval = 0;
+		int ports = MAX_U132_PORTS;
 
 		switch (state.event) {
 		case PM_EVENT_FREEZE:
@@ -3221,7 +3222,6 @@ static int u132_suspend(struct platform_
 			break;
 		case PM_EVENT_SUSPEND:
 		case PM_EVENT_HIBERNATE:
-                        int ports = MAX_U132_PORTS;
                         while (ports-- > 0) {
                                 port_power(u132, ports, 0);
                         }
