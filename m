Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYC2MU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYC2MU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 08:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYC2MUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 08:20:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:59833 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751048AbYC2MUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 08:20:15 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+nNrVSC/mn0hAiPsOTuOvb8N65yki0QCQoVnM6Gy
	L2clD6Pry0mqi5
Date: Sat, 29 Mar 2008 13:20:10 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Oops/Warning report for the week of March 28th 2008
Message-ID: <20080329122010.GA10058@atjola.homenet>
References: <47ED3F1A.1090101@linux.intel.com> <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org> <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org> <20080328171407.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080328171407.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.03.28 17:16:42 -0400, Dmitry Torokhov wrote:
> On Fri, Mar 28, 2008 at 01:51:38PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 28 Mar 2008, Linus Torvalds wrote:
> > > 
> > > Is there something obvious that I'm missing? I'd really like to see the 
> > > whole posting that the oops came from. Do you save the originals or even 
> > > just message ID's from the ones you pick from emails?
> > 
> > Hmm. Definitely not from the kernel mailing list. I'm intrigued, where did 
> > that oops #5814 come from (picked a recent one at random)?
> > 
> > The thing is recent, and oopses on "mutex_lock(dev->mutex)" in 
> > input_release_device. In particular, the path *seems* to be this one:
> > 
> >   evdev_release ->
> >     evdev_ungrab ->
> >       input_release_device ->
> >         mutex_lock ->
> >           mutex_lock_nested ->
> >             __mutex_lock_common ->
> >               list_add_tail(&waiter.list, &lock->wait_list)
> > 
> > where "lock->wait_list.prev" seems to be 0x6b6b6b6b6b6b6b6b, which is the 
> > use-after-free poison pattern.
> > 
> > (In fact, I think the access that actually oopses is when the 
> > debug version of __list_add() does
> > 
> > 	if (unlikely(prev->next != next)) {
> > 
> > because that "prev" pointer is crap).
> > 
> > So it seems that when input_release_device() does:
> > 
> > 	struct input_dev *dev = handle->dev;
> > 
> > 	mutex_lock(&dev->mutex);
> > 
> > the "dev" it uses has already been released. And this only shows up as a 
> > problem when you have slab debugging turned on (like the Fedora kernels 
> > do, thank you all Fedora guys).
> > 
> > The odd thing is that I don't think any of this code has really changed 
> > recently. 
> > 
> 
> There is a patch from Pete that works around the problem by not
> calling input_release_device() on devices that are gone. But what
> I don't understand is why the parent input device is gone since
> sysfs/driver core should be keeping a reference to it since it is
> a parent of evdev. input_dev shoudl only be released after
> evdev_free() is called.

Hm? evdev_free only does the final kfree call. The calls to device_del
and put_device are already happening in device_disconnect, so the parent
can go away any time after that. Do you say that that should be moved
into evdev_free instead? I'm not familiar with the code, but at first
sight, I'd say that we should have a "if (evdev->grab)
evdev_ungrab(evdev, evdev->grab)" in evdev_cleanup, looks like the
logical place to do that. Anything I'm missing?

Björn
