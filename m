Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbXGYUWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbXGYUWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXGYUWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:22:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbXGYUWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:22:43 -0400
Date: Wed, 25 Jul 2007 13:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Cedric Le Goater <clg@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Antonino A. Daplas" <adaplas@pol.net>
Subject: Re: 2.6.23-rc1-mm1: chipsfb_pci_suspend problem
Message-Id: <20070725132206.df77650f.akpm@linux-foundation.org>
In-Reply-To: <200707251548.10962.rjw@sisk.pl>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<46A7483C.60005@fr.ibm.com>
	<200707251548.10962.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 15:48:10 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 25 July 2007 14:55, Cedric Le Goater wrote:
> > Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> > 
> > from pm-move-definition-of-struct-pm_ops-to-suspendh.patch :
> > 
> > drivers/video/chipsfb.c: In function 'chipsfb_pci_suspend':
> > drivers/video/chipsfb.c:461: error: 'PM_SUSPEND_MEM' undeclared (first use in this function)
> > drivers/video/chipsfb.c:461: error: (Each undeclared identifier is reported only once
> > drivers/video/chipsfb.c:461: error: for each function it appears in.)
> 
> Well, actually, this is a bug in chipsfb.c, as it shouldn't use PM_SUSPEND_MEM
> in there, but PMSG_SUSPEND (patch untested).
> 
> Greetings,
> Rafael
> 
> 
> ---
>  drivers/video/chipsfb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.23-rc1/drivers/video/chipsfb.c
> ===================================================================
> --- linux-2.6.23-rc1.orig/drivers/video/chipsfb.c
> +++ linux-2.6.23-rc1/drivers/video/chipsfb.c
> @@ -458,7 +458,7 @@ static int chipsfb_pci_suspend(struct pc
>  
>  	if (state.event == pdev->dev.power.power_state.event)
>  		return 0;
> -	if (state.event != PM_SUSPEND_MEM)
> +	if (state != PMSG_SUSPEND)
>  		goto done;
>  
>  	acquire_console_sem();

For reasons which aren't immediately obvious, the compiler didn't like
that: comparing with an immediate struct liek that is a bit tricky.

This is equivalent, and works:


--- a/drivers/video/chipsfb.c~chipsfb-use-correct-pm-state
+++ a/drivers/video/chipsfb.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
+#include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/console.h>
@@ -458,7 +459,7 @@ static int chipsfb_pci_suspend(struct pc
 
 	if (state.event == pdev->dev.power.power_state.event)
 		return 0;
-	if (state.event != PM_SUSPEND_MEM)
+	if (state.event != PM_EVENT_SUSPEND)
 		goto done;
 
 	acquire_console_sem();
_

Is this a 2.6.23 thing?
