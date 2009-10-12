Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZJLO7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZJLO7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZJLO7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:59:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41374 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757011AbZJLO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:59:18 -0400
Date: Mon, 12 Oct 2009 10:58:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ben Efros <ben@pc-doctor.com>, Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
In-Reply-To: <1255326252.2192.110.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Benjamin Herrenschmidt wrote:

> On Sun, 2009-10-11 at 09:16 -0700, Ben Efros wrote:
> 
> > No I don't think its a good idea to turn off SANE_SENSE in this situation.
> > Here is a patch similar to Ben Herrenschmidt's but will not turn off SANE_SENSE
> > just because a transport failure.
> >
> > Retry with short sense when SANE_SENSE fails.
> 
> Works for me too.
> 
> Alan, what do you think ? I definitely don't like Ben E's most recent
> patch with a quirk for all devices, it's simply a lot more code for
> something that will come back and bite again when somebody does the
> same mistake again. I'd rather have the request sense code be more
> robust. But this patch is fine, as was my previous one.

I agree that it seems silly to have a flag _for_ SANE_SENSE and another 
flag _against_ SANE_SENSE.  Retrying seems easier and more robust.

> So it boils down on clearing SANE_SENSE vs. not clearing it. If we
> clear it, we probably want to keep it cleared (via an INSANE_SENSE
> flag ?). But on the other hand, I don't think that always going
> for a retry when a SANE_SENSE fails is going to hurt and sounds
> like the robust thing to do, so I don't mind that simple patch
> from Ben. So up to you :-)

I agree; it won't hurt much and only if the device is buggy to begin 
with.

> Cheers,
> Ben.
> 
> >  Signed-off-by: Ben Efros <ben@pc-doctor.com>
> 
> Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> > --- linux-2.6.31.1/drivers/usb/storage/transport.c        2009-09-24 08:45:25.000000000 -0700
> > +++ linux-2.6.31.1.new/drivers/usb/storage/transport.c        2009-10-11 08:06:26.000000000 -0700
> > @@ -696,7 +696,7 @@ void usb_stor_invoke_transport(struct sc
> >                  /* device supports and needs bigger sense buffer */
> >                  if (us->fflags & US_FL_SANE_SENSE)
> >                          sense_size = ~0;
> > -
> > +Retry_Sense:
> >                  US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
> >  
> >                  scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
> > @@ -723,6 +723,12 @@ void usb_stor_invoke_transport(struct sc
> >                  if (temp_result != USB_STOR_TRANSPORT_GOOD) {
> >                          US_DEBUGP("-- auto-sense failure\n");
> >  
> > +                        if ((us->fflags & US_FL_SANE_SENSE) &&
> > +                            sense_size != US_SENSE_SIZE) {
> > +                                sense_size = US_SENSE_SIZE;
> > +                                US_DEBUGP("-- retry without SANE_SENSE\n");
> > +                                goto Retry_Sense;
> > +                        }

Except that this is wrong.  We can retry if temp_result == 
USB_STOR_TRANSPORT_FAILURE, but we should not retry if temp_result ==
USB_STOR_TRANSPORT_ERROR.

Alan Stern

P.S.: In case you don't already know...  TRANSPORT_FAILURE means we
were able to communicate with the device, and it told us that it
couldn't carry out the command.  TRANSPORT_ERROR means we weren't able
to communicate with the device.

