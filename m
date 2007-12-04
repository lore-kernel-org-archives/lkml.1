Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXLDTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXLDTVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXLDTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:21:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:38000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXLDTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:21:31 -0500
Subject: Re: [PATCH] USB testing driver: convert dev->sem to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <20071204165540.GH6729@traven>
References: <20071204165540.GH6729@traven>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 11:09:02 -0800
Message-Id: <1196795342.1568.41.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 17:55 +0100, Matthias Kaehlcke wrote:
> @@ -1990,7 +1991,7 @@ static void usbtest_disconnect (struct
> usb_interface *intf)
>  {
>         struct usbtest_dev      *dev = usb_get_intfdata (intf);
>  
> -       down (&dev->sem);
> +       mutex_lock(&dev->lock);
>  
>         usb_set_intfdata (intf, NULL);
>         dev_dbg (&intf->dev, "disconnect\n"); 

This looks like a bit of an anomaly.. The code that isn't shown above is
the "kfree(dev)" .. So this isn't legal since it's freeing a locked
mutex. Here's a excerpt from the comment above mutex_lock(),

 * The mutex must later on be released by the same task that
 * acquired it. Recursive locking is not allowed. The task
 * may not exit without first unlocking the mutex. Also, kernel
 * memory where the mutex resides mutex must not be freed with
 * the mutex still locked. The mutex must first be initialized
 * (or statically defined) before it can be locked. memset()-ing
 * the mutex to 0 is not allowed.

Daniel

