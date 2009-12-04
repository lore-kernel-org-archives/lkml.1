Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbZLDW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbZLDW3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbZLDW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:29:20 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:61978 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbZLDW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:29:17 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2009 17:29:17 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hUBZiS3kp6xNX0NlwOCMngPCsL5Xcq1rPJSvROXRzA8DsDbcChnTShKgCLfIH1AQIQ
         VoD7vD2HDj2H26BDsM3oy86scgIgiEKq5IisHrLP8eSaKAU4+NN2MxapabFlQ6+rnoRU
         9GsJID4dDgIt2GuAlvQaBiLxW5Hq5GdAKh2Ms=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
Date: Fri, 4 Dec 2009 14:23:10 -0800
User-Agent: KMail/1.12.3 (Linux/2.6.32; KDE/4.3.3; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       stable@kernel.org, Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0912041702510.2616-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041702510.2616-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912041423.10632.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009 02:07:11 pm Alan Stern wrote:
> On Fri, 4 Dec 2009, Oliver Neukum wrote:
> > OK, yes. It's a bad example. However this is tricky.
> >
> > This is a bug then:
> >
> > mutex_lock(...);
> >
> > if (instance->error) {
> > 	rv = instance->error;
> > 	instance->error  = 0;
> > 	dev_dbg(instance->dev,...);
> 
> Unless you can guarantee at this point that instance->dev isn't stale,
> it is indeed a bug.
> 
> > 	goto err_out;
> > }
> >
> > rv = -ENODEV;
> > if (instance->disconnected)
> > 	goto err_out;
> >
> > > One approach is to set instance->dev to NULL in disconnect().  That
> > > wouldn't do much good for your dev_dbg(), though.  A better solution is
> > > to refcount the instance->dev pointer: Take a reference to the device
> > > when setting instance->dev and drop it when clearing instance->dev (or
> > > when instance is freed).
> >
> > That would mean that I am forced to adopt refcounting just to print
> > something. This seems very inelegant.
> 
> What can I say?  When the something you want to print can be
> deallocated at any time, there isn't much choice.
> 
> Maybe reference counting is inelegant; it depends on your point of
> view.  Can you think of a more elegant way to make sure that a pointer
> isn't stale?

Yes, just say "no" to device_create() and friends. Embed device structure in
yours, be mindful of lifetime rules and only use "your" device (i.e device
bound to your driver). This way, as long as your refcount your instance you
can rest assured the device structure is there as well.

-- 
Dmitry
