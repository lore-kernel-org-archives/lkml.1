Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbXE1NH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbXE1NH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXE1NHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:07:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51698 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754794AbXE1NHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:07:12 -0400
Date: Mon, 28 May 2007 15:07:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528130709.GO18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272231.54535.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Use a hibernation and suspend notifier to disable the firmware requesting
> mechanism before a hibernation/suspend and enable it after the operation.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
>  drivers/base/firmware_class.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> Index: linux-2.6.22-rc3/drivers/base/firmware_class.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/drivers/base/firmware_class.c	2007-05-27 19:43:03.000000000 +0200
> +++ linux-2.6.22-rc3/drivers/base/firmware_class.c	2007-05-27 19:44:06.000000000 +0200
> @@ -17,6 +17,8 @@
>  #include <linux/bitops.h>
>  #include <linux/mutex.h>
>  #include <linux/kthread.h>
> +#include <linux/notifier.h>
> +#include <linux/suspend.h>
>  
>  #include <linux/firmware.h>
>  #include "base.h"
> @@ -35,6 +37,9 @@ enum {
>  
>  static int loading_timeout = 60;	/* In seconds */
>  
> +/* If set, _request_firmware() will exit immediately returning -EBUSY */
> +static int requesting_firmware_disabled;
> +
>  /* fw_lock could be moved to 'struct firmware_priv' but since it is just
>   * guarding for corner cases a global lock should be OK */
>  static DEFINE_MUTEX(fw_lock);
> @@ -397,6 +402,9 @@ _request_firmware(const struct firmware 
>  	struct firmware *firmware;
>  	int retval;
>  
> +	if (requesting_firmware_disabled)
> +		return -EBUSY;

WARN_ON()? This should not happen, and if it does, we'll end up with
non-working device.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
