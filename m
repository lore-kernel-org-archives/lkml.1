Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbYCXSIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbYCXSIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYCXSIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:08:35 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44382 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbYCXSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:08:34 -0400
Subject: Re: Fixing the main programmer thinko with the device model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "Van De Ven, Arjan" <arjan@linux.intel.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080324175844.GA13816@kroah.com>
References: <1206373188.3494.36.camel@localhost.localdomain>
	 <20080324175844.GA13816@kroah.com>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 13:08:29 -0500
Message-Id: <1206382109.3494.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 10:58 -0700, Greg KH wrote:
> On Mon, Mar 24, 2008 at 10:39:48AM -0500, James Bottomley wrote:
> > Having just spent the weekend tracking two separate driver model
> > problems through SCSI, I believe the biggest trap everyone falls into
> > with the driver model (well, OK, at least with SCSI) is to try to defer
> > a callback to the device ->release routine without realising that
> > somewhere along the callback path we're going to drop a reference to the
> > device.
> > 
> > You can do this very inadvertently:  One developer didn't realise
> > bsg_unregister_queue() released a ref, and another didn't realise that
> > transport_destroy_device() held one.
> > 
> > The real problem is that it's fantastically easy to do this ... it's not
> > at all clear which of the cleanup routines actually release references
> > unless you dig down into them and it's very difficult to detect because
> > all that happens is that devices don't get released when they should,
> > which isn't something we ever warn about.
> 
> Sounds like a documentation issue for how the scsi layer is using the
> driver model more than anything else.  None of the other busses seem to
> have these kinds of issues that I can see, is it just because of your
> complex usage model?

Possibly ... although the bsg routines aren't actually SCSI ones,
they're block.  The transport class destroy function also actually
picked up an implicit reference because of the class device rework you
just did.

> > So, what I was wondering is:  is there any way we can reliably detect
> > and warn when someone does this.
> 
> Warn that a device did not get released when the programmer thought it
> should yet they forgot to call the correct function to have that happen?
> That seems a bit difficult :)

Yes, that's why I think it has to be discovered via static analysis.

> Also note that the scsi layer usage of multiple refcounted objects
> within the same structure might be causing some of these issues, that's
> a bug in how the scsi layer has implmented things much more so than how
> the driver core is implemented, right?

That's true, but irrelevant (and also soon to be untrue if we get rid of
the scsi_device class as you and Kay keep requesting).  The two calls
release references on the actual embedded generic device, it's nothing
to do with entangled lifetime rules.

James


