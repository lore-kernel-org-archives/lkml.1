Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AJT4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AJT4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 14:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0AJT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 14:56:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51248 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0AJT4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 14:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nh9XcS/wW68c3hr6BnTfaXgRphsPnkeNkfguXEL5lmJD0h36Fb1N88hcsBKl24xt+D
         8PK7tjjsaQTXlUIN0SZ+yw0QHVpApC3QhHMDUpJPp/AgjNiYTsl99YzxYf6B3kG5/bOq
         lnVhbQ7M9I9aVLKSWWu0bMusn1MkHlPH9CYKE=
Date: Sun, 10 Jan 2010 11:56:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/input/joystick/xpad.c: Add rumble support for
 original xbox controller
Message-ID: <20100110195641.GA27553@core.coreip.homeip.net>
References: <20100108033215.447c814e@rechenknecht2k7>
 <20100108075054.GA3696@core.coreip.homeip.net>
 <20100108112610.0b78785b@piBook>
 <20100110075615.GC16057@core.coreip.homeip.net>
 <20100110191112.5c66dc94@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110191112.5c66dc94@rechenknecht2k7>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 07:11:12PM +0100, Benjamin Valentin wrote:
> On Sat, 9 Jan 2010 23:56:16 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > --- /usr/src/linux-source-2.6.33/drivers/input/joystick/xpad.c
> > > 2010-01-08 02:56:59.365851076 +0100 +++ xpad.c	2010-01-08
> > > 03:13:38.477835651 +0100 @@ -505,7 +505,7 @@
> > >  	struct usb_endpoint_descriptor *ep_irq_out;
> > >  	int error = -ENOMEM;
> > >  
> > > -	if (xpad->xtype != XTYPE_XBOX360)
> > > +	if (xpad->xtype != XTYPE_XBOX360 && xpad->xtype !=
> > > XTYPE_XBOX) return 0;
> > >  
> > >  	xpad->odata = usb_buffer_alloc(xpad->udev, XPAD_PKT_LEN,
> > > @@ -535,13 +535,13 @@
> > >  
> > >  static void xpad_stop_output(struct usb_xpad *xpad)
> > >  {
> > > -	if (xpad->xtype == XTYPE_XBOX360)
> > > +	if (xpad->xtype == XTYPE_XBOX360 || xpad->xtype !=
> > > XTYPE_XBOX)
> > 
> > This should cretainly be "... || xpad->xtype == XTYPE_XBOX)", I'll fix
> > it up locally.
> 
> Thank you, this made me discover another bug that eventually leads to a
> kernel oops when the device is unplugged while an effect is playing
> (or the effect is somehow else interrupted).
> This should be fixed by taking the mutex when modifying xpad->odata as
> well as checking whether it has been freed before writing to it.
> 

No, you may not take mutex in xpad_play_effect because it is called with
interrupts off and dev->event_lock spinlock held. We probably need a
workqueue-based solution to queue play requests and ensure that 2
different requests do not "step" on each other.

-- 
Dmitry
