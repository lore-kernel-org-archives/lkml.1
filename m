Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYCXRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYCXRyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYCXRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:54:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45905 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbYCXRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:54:06 -0400
Date: Mon, 24 Mar 2008 10:58:44 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fixing the main programmer thinko with the device model
Message-ID: <20080324175844.GA13816@kroah.com>
References: <1206373188.3494.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206373188.3494.36.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 10:39:48AM -0500, James Bottomley wrote:
> Having just spent the weekend tracking two separate driver model
> problems through SCSI, I believe the biggest trap everyone falls into
> with the driver model (well, OK, at least with SCSI) is to try to defer
> a callback to the device ->release routine without realising that
> somewhere along the callback path we're going to drop a reference to the
> device.
> 
> You can do this very inadvertently:  One developer didn't realise
> bsg_unregister_queue() released a ref, and another didn't realise that
> transport_destroy_device() held one.
> 
> The real problem is that it's fantastically easy to do this ... it's not
> at all clear which of the cleanup routines actually release references
> unless you dig down into them and it's very difficult to detect because
> all that happens is that devices don't get released when they should,
> which isn't something we ever warn about.

Sounds like a documentation issue for how the scsi layer is using the
driver model more than anything else.  None of the other busses seem to
have these kinds of issues that I can see, is it just because of your
complex usage model?

> So, what I was wondering is:  is there any way we can reliably detect
> and warn when someone does this.

Warn that a device did not get released when the programmer thought it
should yet they forgot to call the correct function to have that happen?
That seems a bit difficult :)

Also note that the scsi layer usage of multiple refcounted objects
within the same structure might be causing some of these issues, that's
a bug in how the scsi layer has implmented things much more so than how
the driver core is implemented, right?

thanks,

greg k-h
