Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYBLWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYBLWUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYBLWUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:20:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38183 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbYBLWUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:20:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mirco Tischler <mt-ml@gmx.de>
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
Date: Tue, 12 Feb 2008 23:18:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
References: <1202664109.8394.19.camel@mtlp> <200802120113.07063.rjw@sisk.pl> <1202853943.6790.3.camel@mtlp>
In-Reply-To: <1202853943.6790.3.camel@mtlp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122318.46271.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of February 2008, Mirco Tischler wrote:
> 
> Am Dienstag, den 12.02.2008, 01:13 +0100 schrieb Rafael J. Wysocki:
> > Since _GTS and _BFS don't seem to be defined in your box's BIOS, please
> > try to apply the appended patch on top of the revert and see if that breaks
> > things again.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  drivers/acpi/hardware/hwsleep.c |   11 -----------
> >  1 file changed, 11 deletions(-)
> > 
> > Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
> > +++ linux-2.6/drivers/acpi/hardware/hwsleep.c
> > @@ -199,11 +199,6 @@ acpi_status acpi_enter_sleep_state_prep(
> >  		return_ACPI_STATUS(status);
> >  	}
> >  
> > -	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
> > -	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> > -		return_ACPI_STATUS(status);
> > -	}
> > -
> >  	/* Setup the argument to _SST */
> >  
> >  	switch (sleep_state) {
> > @@ -554,12 +549,6 @@ acpi_status acpi_leave_sleep_state(u8 sl
> >  		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
> >  	}
> >  
> > -	arg.integer.value = sleep_state;
> > -	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
> > -	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
> > -		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
> > -	}
> > -
> >  	/*
> >  	 * GPEs must be enabled before _WAK is called as GPEs
> >  	 * might get fired there
> Yes, that's it. This patch breaks things again.

Ouch.  I think I know what the problem is.

On top of this patch, please apply the appended one and retest.

Thanks,
Rafael

---
 drivers/acpi/hardware/hwsleep.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
@@ -566,6 +566,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		return_ACPI_STATUS(status);
 	}
 
+	arg.integer.value = sleep_state;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
