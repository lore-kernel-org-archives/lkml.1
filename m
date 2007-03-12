Return-Path: <linux-kernel-owner+w=401wt.eu-S1030404AbXCLPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030404AbXCLPm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030417AbXCLPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:42:59 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:40378 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030404AbXCLPm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n7uNmsz5ROaHTdvbbD6jg140LdEOd91SvrPcJoWiA0yiS+6SIlrNal0qUF/E9YGNINCxGvOdhpzlkhB+99gHN5TQzp29KNbYA83VOSBizuwOt82BOEic/qVZ722/K5WNRM4aUI1Rb8G3OCZhwn8t9ONLW2SfRCBqOS3vV752eKA=
Message-ID: <d120d5000703120842k4e134136v2fe56dcfc2264841@mail.gmail.com>
Date: Mon, 12 Mar 2007 10:42:56 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Oliver Neukum" <oneukum@suse.de>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Maneesh Soni" <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703121623.58607.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0703121041400.2489-100000@iolanthe.rowland.org>
	 <200703121623.58607.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Oliver Neukum <oneukum@suse.de> wrote:
> Am Montag, 12. März 2007 15:57 schrieb Alan Stern:probably nece
> > On Mon, 12 Mar 2007, Oliver Neukum wrote:
> >
> > > > > Why? What's wrong with simply calling kref_get/put?
> > > >
> > > > It's the same old problem: the race between unbind and sysfs I/O.  What
> > > > good does holding a reference to the private data structure do if the
> > > > show/store method gets called after the driver has been unbound from the
> > > > device?  dev_get_drvdata() will no longer provide a valid pointer to the
> > > > private data, so the method will have no way to access it.  Hence the
> > > > method needs another argument.
> > >
> > > It does half the job. You can make sure the driver is not asked to access
> > > freed memory.
> > > It is true that a driver will have to mark that device "disconnected"
> > > and return errors if that device's attributes are referenced, but this can
> > > be done internally.
> >
> > No, you're missing the point.  Let's say driver A's disconnect() is
> > called, so the driver marks its private data structure as "disconnected"
> > and does dev_set_drvdata(NULL).  Then driver B is probed and bound to the
> > device, and it does its own dev_set_drvdata().  Then a user still holding
> > an open sysfs file reference for driver A calls a show() or store()
> > method.  The method will do dev_get_drvdata(), receiving the pointer to
> > driver B's private data.  Now you're in trouble, because A's method will
> > think it owns B's private data!
>
> Yes, I was missing the point. In consequence, drivers must not use
> dev_get_drvdata() to get their references to their private data. It's
> probably necessary to store it in struct sysfs_buffer and include that
> in the store/show callbacks.
> (The same does apply to interfaces of course)
>

Or drivers coudl verify that they still bound to the device they are
about to operate on (psmouse does this by taking a lock on device and
then checking if driver bound is the same address as psmouse). But I'd
rather get rid of all this clutter if we could sever sysfs access
after removing corresponding attributes.

-- 
Dmitry
