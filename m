Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbXHXPw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbXHXPw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbXHXPwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:52:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:59759 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbXHXPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:52:21 -0400
Date: Fri, 24 Aug 2007 08:49:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [stable] [patch 25/28] USB: cdc-acm: fix sysfs attribute
	registration bug
Message-ID: <20070824154906.GA19239@kroah.com>
References: <20070823222750.GY18559@kroah.com> <Pine.LNX.4.44L0.0708240956570.3862-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708240956570.3862-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 09:59:49AM -0400, Alan Stern wrote:
> On Thu, 23 Aug 2007, Greg KH wrote:
> 
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > This patch (as950) fixes a bug in the cdc-acm driver.  It doesn't keep
> > track of which interface (control or data) the sysfs attributes get
> > registered for, and as a result, during disconnect it will sometimes
> > attempt to remove the attributes from the wrong interface.  The
> > left-over attributes can cause a crash later on, particularly if the driver
> > module has been unloaded.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Acked-by: Oliver Neukum <oneukum@suse.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/usb/class/cdc-acm.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > --- a/drivers/usb/class/cdc-acm.c
> > +++ b/drivers/usb/class/cdc-acm.c
> > @@ -900,6 +900,10 @@ next_desc:
> >  			return -ENODEV;
> >  		}
> >  	}
> > +
> > +	/* Accept probe requests only for the control interface */
> > +	if (intf != control_interface)
> > +		return -ENODEV;
> >  	
> >  	if (data_interface_num != call_interface_num)
> >  		dev_dbg(&intf->dev,"Seperate call control interface. That is not fully supported.");
> > 
> 
> Odd.  This doesn't include the entire patch; the second hunk is
> missing.  It should go on to say:
> 
> @@ -1109,10 +1113,12 @@ static void acm_disconnect(struct usb_interface *intf)
>  		return;
>  	}
>  	if (acm->country_codes){
> -		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
> -		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
> +		device_remove_file(&acm->control->dev,
> +				&dev_attr_wCountryCodes);
> +		device_remove_file(&acm->control->dev,
> +				&dev_attr_iCountryCodeRelDate);
>  	}
> -	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
> +	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);


I thought so too, untill you look at the 2.6.22.5 release, which already
has that change in it for some reason.

So that part of the patch drops out, it turns out you just reverted
things back to the way things used to be here :)

thanks,

greg k-h
