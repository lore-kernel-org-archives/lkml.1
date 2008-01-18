Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYARB4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYARB4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbYARBzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:55:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:35016 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYARBzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YjK0+M+ejBXMrXWh7Bp/jTelAwHlOZftfRgdh4jmL9fXL3NW0AhTZRBjrolXNWPM3CSWhO2Y4GJyiLopU7e99p4i6PeHhmAz6a3YRyJyWhf8q0FHCp24OZG3XDlenrwhUxbewdxP1wUey9c+doaKbCeqIP/AqNo/8RFuMgwytwY=
Message-ID: <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com>
Date: Fri, 18 Jan 2008 02:55:38 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Jarek Poplawski" <jarkao2@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080117194728.GA2598@ami.dom.local>
	 <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
	 <20080117203155.GA2791@ami.dom.local>
	 <20080117232626.GC2905@ami.dom.local>
	 <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
X-Google-Sender-Auth: 2c8e8abd037dd2b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 2:42 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Jan 18, 2008 7:26 AM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> >
> > On Thu, Jan 17, 2008 at 09:31:55PM +0100, Jarek Poplawski wrote:
> > > On Thu, Jan 17, 2008 at 02:57:36PM -0500, Alan Stern wrote:
> > > > On Thu, 17 Jan 2008, Jarek Poplawski wrote:
> > > >
> > > > > On Thu, Jan 17, 2008 at 10:16:30AM -0500, Alan Stern wrote:
> > > > > > On Thu, 17 Jan 2008, Dave Young wrote:
> > > > > >
> > > > > > > > Your meaning isn't clear.  Do you mean that your patch doesn't generate
> > > > > > > > any lockdep warnings at all?  Or do you mean that it generates a single
> > > > > > > > lockdep warning at boot time and then no more warnings afterward?
> > > > > > >
> > > > > > > I means the latter one.
> > > > > >
> > > > > > That's very bad.
> > > > > >
> > > > > > For each type of violation, lockdep only gives one error message.  So
> > > > > > the fact that you get one message at boot time and then no more doesn't
> > > > > > mean the code is almost right -- it probably means the code has lots of
> > > > > > errors and you're seeing only the first one.
> > > > >
> > > > > I hope it's better than this: lockdep really stops checking after first
> > > > > warning, but I've understood from David's description that after fixing
> > > > > this one place lockdep seems to be pleased.
> > > >
> > > > That isn't what Dave said above; he said that lockdep produces a single
> > > > warning at bootup.  If he did mention anything about one place being
> > > > fixed up or lockdep being pleased, it was a while back and I've lost
> > > > track of it.
> > > >
> > > > If I recall correctly the nature of the warning was that a method
> > > > routine for one class (called with the class's mutex held) was creating
> > > > a second class and locking that class's mutex.  In principle this is
> > > > perfectly legal and should be allowed for arbitrary depths of nesting,
> > > > even though it is the sort of thing lockdep is currently unable to
> > > > handle.
> > >
> > > You are definitely right! After first reading Dave's description I got
> > > it the same way, but after re-reading I probably was misled with this
> > > "thus"! Only now I've had a look at this warning and there is really
> > > mutex_lock_nested(). Sorry Alan!
> >
> > But, on the other hand, mutex_lock() is really mutex_lock_nested(), and
> > after second checking this lockdep warning from Jan. 3, it seems
> > impossible it was get after this patch...
> >
> > Dave, could you please answer with full sentence if there is any lockdep
> > warning possible after applying these 1-7/7 patches, and if so, attach
> > current warning? Otherwise, I'll have apologized for this everybody from
> > the list soon!
>
> After digging the class usage code again, I found that the only
> possible double lock place is the class_interface_register/unregister
> in which the class_device api could be called.
>
> The scsi and pcmcia use the class_interface api, I just found the
> warning above caused by scsi part then.
>
> So I think I will need to use mutex_lock_nesting for the
> class_device_* functions.

All "struct class_device" stuff will go away very soon, and only
"struct device" will stay.
The conversion for remaining users is already in -mm. Only SCSI and IB
are missing,
but experimental patches for these exist already.

Kay
