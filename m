Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYARHsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYARHsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYARHsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:48:10 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:19726 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753406AbYARHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Crb+HJTm0Nxmj4vsEFG0+WmoiysQYf/NNqdZvOdFvizxVcrGurBOo24hEL1duwHRKygzeRBYNjAXM+U/z/1WEyVjG/FsBDbIWDtBS560Dqivfp2JScGEbD1Ysu1dU1O3osxi4M0wRodJSRL2ZCz8vjUSbvKmbS6lcAag6u0yxGc=
Message-ID: <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>
Date: Fri, 18 Jan 2008 15:48:02 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct class
Cc: "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <gregkh@suse.de>,
       stefanr@s5r6.in-berlin.de, "David Brownell" <david-b@pacbell.net>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080118073836.GA1703@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080117194728.GA2598@ami.dom.local>
	 <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>
	 <20080117203155.GA2791@ami.dom.local>
	 <20080117232626.GC2905@ami.dom.local>
	 <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>
	 <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com>
	 <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com>
	 <1200626323.5640.21.camel@lov.site>
	 <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com>
	 <20080118073836.GA1703@ff.dom.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 3:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Fri, Jan 18, 2008 at 01:31:17PM +0800, Dave Young wrote:
> > On Jan 18, 2008 11:18 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> ...
> > > Yeah, might be better to wait until class_device is gone, otherwise you
> > > may need to fix stuff that is just going to be removed. Your change to
> > > have iterators for the class devices look like a nice preparation for
> > > future changes though.
> > >
> > > Our rough plan is:
> > >  2.6.25:
> > >   - get the ~100 patches in Greg's tree (in -mm) merged :)
> > >  2.6.26:
> > > ???  - remove the 20 char limit in "struct device"
> > >   - get rid of "struct class_device"
> >
> > Fine, thanks.
> >
> > Let's wait for other people's comment.
>
> Dave, I doubt you'll ever manage to do this if you're going to wait:
> probably there will be always some new changes like this around...

Maybe you are right.

>
> IMHO, it would be nice to get the real state of current lockdep
> problems here to figure out if there is any chance to do this right &
> without any warnings with current lockdep. If I got it right from
> earlier threads it might be impossible with USB, at least.

I don't think so, usb doesn't be affected by struct class mutex, they
only use the lock of struct device. As I replied before, the lockdep
issue exist only between class_interface and class_device.

>
> So, since I think these nesting levels seem to be wrong in 7/7 patch,
> maybe it's better to exclude it from this patchset, and to try this as
> testing for some time.

I may file the updated patch with more nesting changes and test it of
course. Actually I should have done it, thanks.

>
> My proposal is to do the annotations with mutex_lock_nested(),
> everywhere in this patch, according to 'real' relations between these
> classes from thread POV, so e.g.:
>
> mutex_lock_nested(&some_class->mutex, CLASS_PARENT);
> mutex_lock_nested(&some_class->mutex, CLASS_CLASS);
> ...or more if needed:
> mutex_lock_nested(&some_class->mutex, CLASS_CHILD);
> mutex_lock_nested(&some_class->mutex, CLASS_ROOT);
> ...etc.
>
> using adequate names for these enums, and only after this check what
> lockdep thinks about it. Then, if there are no obvious mistakes, but
> lockdep doesn't like it, send the patch and report without trying to
> 'silence' lockdep, so we could see what's going on, and if there are
> any chances to make it right.

1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
or
2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
class_device functions because it is the only possible nest-lock place
as I know.

Do you agree?

>
> Thanks,
> Jarek P.
>
