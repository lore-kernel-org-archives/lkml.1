Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbXHXOAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbXHXOAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760680AbXHXN7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:59:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48105 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756837AbXHXN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:59:50 -0400
Date: Fri, 24 Aug 2007 09:59:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <stable@kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       Oliver Neukum <oneukum@suse.de>
Subject: Re: [patch 25/28] USB: cdc-acm: fix sysfs attribute registration
 bug
In-Reply-To: <20070823222750.GY18559@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0708240956570.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Greg KH wrote:

> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> This patch (as950) fixes a bug in the cdc-acm driver.  It doesn't keep
> track of which interface (control or data) the sysfs attributes get
> registered for, and as a result, during disconnect it will sometimes
> attempt to remove the attributes from the wrong interface.  The
> left-over attributes can cause a crash later on, particularly if the driver
> module has been unloaded.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Oliver Neukum <oneukum@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/usb/class/cdc-acm.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/drivers/usb/class/cdc-acm.c
> +++ b/drivers/usb/class/cdc-acm.c
> @@ -900,6 +900,10 @@ next_desc:
>  			return -ENODEV;
>  		}
>  	}
> +
> +	/* Accept probe requests only for the control interface */
> +	if (intf != control_interface)
> +		return -ENODEV;
>  	
>  	if (data_interface_num != call_interface_num)
>  		dev_dbg(&intf->dev,"Seperate call control interface. That is not fully supported.");
> 

Odd.  This doesn't include the entire patch; the second hunk is
missing.  It should go on to say:

@@ -1109,10 +1113,12 @@ static void acm_disconnect(struct usb_interface *intf)
 		return;
 	}
 	if (acm->country_codes){
-		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
-		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_wCountryCodes);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_iCountryCodeRelDate);
 	}
-	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
+	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 	acm->dev = NULL;
 	usb_set_intfdata(acm->control, NULL);
 	usb_set_intfdata(acm->data, NULL);

Alan Stern

