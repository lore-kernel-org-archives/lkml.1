Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXENMX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXENMX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXENMXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:23:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:35421 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXENMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:23:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TIbvVlSNvGBPphB1GFbUUKLit+1FiMJS3IjuzcDmOygPiglpWWFvTVRXgmrf6qT1Ga54pxLfX2Un/xr8aqIVz8lg9b0ymuumYk0h6/ceW1VED+9blcjmb/cNYP+JAoHYv0n06z7kVJKmJCy9DZSoiP7aI4HoUeXl7EEkpJj2EZA=
Message-ID: <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
Date: Mon, 14 May 2007 17:53:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "James Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Cc: "Dave Jones" <davej@redhat.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
>
> > > [...]
> > >  config SCSI_WAIT_SCAN
> > >         tristate
> > > -       default m
> > > -       depends on SCSI
> > > -       depends on MODULES
> > > +       default m if SCSI=m
> > > +       default n
> >
> > Note that this also means SCSI_WAIT_SCAN=n (will not get compiled
> > and built even as a module) if SCSI=y. But this is perfectly fine, because
> > I see:
> >
> > #ifndef MODULE
> > late_initcall(scsi_complete_async_scans);
> > #endif
> >
> > in drivers/scsi/scsi_scan.c anyway, so the async scans will be waited
> > upon and get complete even when SCSI=y and scsi_scan_type=async,
> > i.e. you don't really need the scsi_wait_scan module in that case anyway.
>
> It seems there is a:
>
> late_initcall(wait_scan_init);
>
> in drivers/scsi/scsi_wait_scan.c too. So we can get rid of the redundant:
>
> #ifndef MODULE
> late_initcal(scsi_complete_async_scans);
> #endif
>
> in drivers/scsi/scsi_scan.c by enforcing SCSI_WAIT_SCAN=y when
> SCSI=y (and =m when SCSI=m).
>
> I guess this is probably the behaviour that James wanted originally?
>
> Anyway, attached patch (subsumes previous one) cleans up all this.
> Now, scsi_wait_scan is the only guy who controls waiting upon async
> scans to complete:
>
> If SCSI=n, SCSI_WAIT_SCAN=n, obviously.
>
> If SCSI=y, SCSI_WAIT_SCAN=y, so it gets built-in and is run at
> late_initcall.
>
> If SCSI=m, SCSI_WAIT_SCAN=m too and would hopefully be run
> by the initrd/initramfs scripts to wait for async SCSI bus scans to
> finish before allowing the boot to proceed.
>
> [ Attached patch does _not_ expose SCSI_WAIT_SCAN to the
> user at kernel configuration time, so if somebody wants it to be
> built as a module even when SCSI=y (why would anybody
> want that, doesn't make much sense to me to modprobe
> scsi_wait_scan _after_ boot-up), it would not be possible to
> do so. But if someone really wants that, let me know, we can
> add a depends, tristate "..." and help in this Kconfig option to
> accomplish that too. ]

This has sadly become a one-person thread, but Robert informs
me in private mail that we can further clean/simplify the patch:

[subsumes both previous patches]

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

 drivers/scsi/Kconfig     |    3 +--
 drivers/scsi/scsi_scan.c |    5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

---

diff -ruNp a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2007-05-10 23:19:32.000000000 +0530
+++ b/drivers/scsi/Kconfig	2007-05-14 17:59:51.000000000 +0530
@@ -243,9 +243,8 @@ config SCSI_SCAN_ASYNC

 config SCSI_WAIT_SCAN
 	tristate
-	default m
 	depends on SCSI
-	depends on MODULES
+	default SCSI

 menu "SCSI Transports"
 	depends on SCSI
diff -ruNp a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2007-05-14 16:06:43.000000000 +0530
+++ b/drivers/scsi/scsi_scan.c	2007-05-14 16:10:34.000000000 +0530
@@ -184,14 +184,11 @@ int scsi_complete_async_scans(void)
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);

-#ifndef MODULE
 /*
  * For async scanning we need to wait for all the scans to complete before
  * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
- * yet.
+ * yet.  This is done by scsi_wait_scan.
  */
-late_initcall(scsi_complete_async_scans);
-#endif

 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
