Return-Path: <linux-kernel-owner+w=401wt.eu-S1762316AbYGCNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762316AbYGCNJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762047AbYGCNIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:08:20 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49383 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762042AbYGCNIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:08:18 -0400
Date: Thu, 3 Jul 2008 11:57:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Adam Williamson <awilliamson@mandriva.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Matthias Geissert <matthias.geissert@web.de>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents
	use of device
Message-ID: <20080703085733.GB11254@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807022333.25275.oliver@neukum.org> <1215034900.6054.204.camel@lenovo.local.net> <200807031005.59691.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807031005.59691.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 10:05:57AM +0200, Oliver Neukum wrote:
> Am Mittwoch 02 Juli 2008 23:41:40 schrieb Adam Williamson:
> > On Wed, 2008-07-02 at 23:33 +0200, Oliver Neukum wrote:
> > 
> > > This is odd. Your device shows one interface with one endpoint bulk and
> > > bulk out respectively. Yet two ports are created. Odd.
> > 
> > OK. If you mean /dev/ttyUSB0 and /dev/ttyUSB1 are always both created
> > when the device is plugged in - yep. This is the case in the working
> 
> Now this is very hard to explain. From the code in 2.6.25 it is clear that
> only ttyUSB0 will be created. Please verify that indeed you get ttyUSB0
> and ttyUSB1 with the kernel working for you.
> 
> > kernel too. From what I've seen in howtos and the like, this seems to be
> > the case for most such devices. Well, let me know what else you need
> > from me. :)
> 
> As far as I can tell somebody changed the ipaq driver in 2.6.26-rc6. I cannot
> find the exact patch that did it in Greg's directory. As it causes a regression
> here's a reversal.


It was changed by:


commit e1879b19b0abdb387e4aeb0b935a486cc75042fb
Author: Matthias Geissert <matthias.geissert@web.de>
Date:   Thu Mar 6 22:00:33 2008 +0100

    USB: ipaq: fix devices having more than one endpoint
    
    The ipaq module  supports devices with one endpoint only. Some devices,
    e.g. Yakumo Delta 300, have more than one endpoint.
    
    This patch fixes support for devices having up to 2 endpoints which used
    to work on older kernel versions.
    
    Signed-off-by: Matthias Geissert <matthias.geissert@web.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 9b38a08..17f2a53 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -571,9 +571,9 @@ static struct usb_serial_driver ipaq_device = {
 	.usb_driver = 		&ipaq_driver,
 	.id_table =		ipaq_id_table,
 	.num_interrupt_in =	NUM_DONT_CARE,
-	.num_bulk_in =		1,
-	.num_bulk_out =		1,
-	.num_ports =		1,
+	.num_bulk_in =		NUM_DONT_CARE,
+	.num_bulk_out =		NUM_DONT_CARE,
+	.num_ports =		2,
 	.open =			ipaq_open,
 	.close =		ipaq_close,
 	.attach =		ipaq_startup,


> 	Regards
> 		Oliver
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> 
> ---
> 
> --- linux-2.6.26-greg/drivers/usb/serial/ipaq.alt.c	2008-07-03 09:01:37.000000000 +0200
> +++ linux-2.6.26-greg/drivers/usb/serial/ipaq.c	2008-07-03 09:01:47.000000000 +0200
> @@ -570,7 +570,7 @@ static struct usb_serial_driver ipaq_dev
>  	.description =		"PocketPC PDA",
>  	.usb_driver = 		&ipaq_driver,
>  	.id_table =		ipaq_id_table,
> -	.num_ports =		2,
> +	.num_ports =		1,
>  	.open =			ipaq_open,
>  	.close =		ipaq_close,
>  	.attach =		ipaq_startup,
> 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

