Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbYIXUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbYIXUV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIXUVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:21:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbYIXUVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:21:48 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 08/18] lirc driver for the Soundgraph IMON IR Receivers
Date: Wed, 24 Sep 2008 16:21:38 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <20080910150229.2b4f990d@bike.lwn.net> <200809221747.57170.jwilson@redhat.com>
In-Reply-To: <200809221747.57170.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809241621.38715.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2008 17:47:56 Jarod Wilson wrote:
> > > +/**
> > > + * Called by lirc_dev when the application opens /dev/lirc
> > > + */
> > > +static int ir_open(void *data)
> > > +{
> > > +   int retval = SUCCESS;
> > > +   struct imon_context *context;
> > > +
> > > +   /* prevent races with disconnect */
> > > +   down(&disconnect_sem);
> > > +
> > > +   context = (struct imon_context *) data;
> > > +
> > > +   LOCK_CONTEXT;
> > > +
> > > +   if (context->ir_isopen) {
> > > +           err("%s: IR port is already open", __func__);
> > > +           retval = -EBUSY;
> > > +           goto exit;
> > > +   }
> >
> > I wonder if the single-open semantics are really doing what the author
> > intended?  It is unsufficient to prevent concurrent calls elsewhere.
>
> I think we're good to go with disconnect_sem being converted to an actual
> mutex, no?

No. The lock here is worthless, as is the check for context->ir_isopen, as 
this function *only* gets called with the driver_lock held in lirc_dev, and 
lirc_dev won't call this if the device is already open. I've simply dropped 
the context lock, as its not needed at all (and in fact, triggered lockdep 
spew).

-- 
Jarod Wilson
jarod@redhat.com

