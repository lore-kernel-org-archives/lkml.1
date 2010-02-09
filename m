Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0BIWwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:52:53 -0500
Received: from mga10.intel.com ([192.55.52.92]:20515 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566Ab0BIWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:52:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,439,1262592000"; 
   d="scan'208";a="539317407"
Date: Tue, 9 Feb 2010 14:52:50 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: don't read past config->interface[] if
 usb_control_msg() fails in usb_reset_configuration()
Message-ID: <20100209225250.GA5182@xanatos>
References: <Pine.LNX.4.44L0.1002091010100.1665-100000@iolanthe.rowland.org>
 <4B7186F1.808@gmail.com>
 <4B71DB34.5090708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B71DB34.5090708@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 11:01:24PM +0100, Roel Kluin wrote:
> After the loop `for (i = 0; i < config->desc.bNumInterfaces; i++)' if no
> break occurred, i equals config->desc.bNumInterfaces. so if
> usb_control_msg() failed then after goto reset_old_alts we read from
> config->interface[config->desc.bNumInterfaces].
> 
> Reported-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> 
> >> You correctly identified a problem, but your fix is wrong -- or at 
> >> least, it is much too complicated. The proper fix goes like this:
> > 
> >  	/* If not, reinstate the old alternate settings */
> >  	if (retval < 0) {
> >  reset_old_alts:
> > -		for (; i >= 0; i--) {
> > +		for (i--; i >= 0; i--) {
> >  			struct usb_interface *intf = config->interface[i];
> >  			struct usb_host_interface *alt;
> 
> 
> Are you really sure this is better?

Yes.

> If usb_hcd_alloc_bandwidth() fails, in the loop _before_ the
> reset_old_alts label, don't we still have to reinstate the old
> alternate settings for that usb_interface config->interface[i]? This
> was what my initial patch tried to do.

No, you do not.  Take a look at usb_hcd_alloc_bandwidth() in
drivers/usb/core/hcd.c.  If an allocation fails for interface i when
the HCD's check_bandwidth() function is called, then
hcd->driver->reset_bandwidth is called.  We only need to clean up the
interfaces that have successfully been allocated bandwidth (0 to i - 1).

> Alternatively usb_hcd_alloc_bandwidth() could undo what it does if an
> error occurs there, then I think i could be decremented.

Yes, that's what usb_hcd_alloc_bandwidth() does at the reset label.

Sarah
