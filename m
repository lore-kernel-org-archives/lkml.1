Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYC1VRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYC1VRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbYC1VQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:16:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57556 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYC1VQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=T1S6+q+U+gIU0zITsvwTy8Cju1Qv+O0F36w6zHjNxWUAb45KFJc3gPfI6cCHHr+9pNfLZ1fedHB3AsFPb10unvejDgsIMXAC7qpMnYiEQBz+nmBud/eztj8YKHLky2WorQ3dknOfhYd6l4XKndyRQN+tc+yrjCKMi4+XEOh5XDs=
Date: Fri, 28 Mar 2008 17:16:42 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Oops/Warning report for the week of March 28th 2008
Message-ID: <20080328171407.ZZRA012@mailhub.coreip.homeip.net>
References: <47ED3F1A.1090101@linux.intel.com> <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org> <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:51:38PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 28 Mar 2008, Linus Torvalds wrote:
> > 
> > Is there something obvious that I'm missing? I'd really like to see the 
> > whole posting that the oops came from. Do you save the originals or even 
> > just message ID's from the ones you pick from emails?
> 
> Hmm. Definitely not from the kernel mailing list. I'm intrigued, where did 
> that oops #5814 come from (picked a recent one at random)?
> 
> The thing is recent, and oopses on "mutex_lock(dev->mutex)" in 
> input_release_device. In particular, the path *seems* to be this one:
> 
>   evdev_release ->
>     evdev_ungrab ->
>       input_release_device ->
>         mutex_lock ->
>           mutex_lock_nested ->
>             __mutex_lock_common ->
>               list_add_tail(&waiter.list, &lock->wait_list)
> 
> where "lock->wait_list.prev" seems to be 0x6b6b6b6b6b6b6b6b, which is the 
> use-after-free poison pattern.
> 
> (In fact, I think the access that actually oopses is when the 
> debug version of __list_add() does
> 
> 	if (unlikely(prev->next != next)) {
> 
> because that "prev" pointer is crap).
> 
> So it seems that when input_release_device() does:
> 
> 	struct input_dev *dev = handle->dev;
> 
> 	mutex_lock(&dev->mutex);
> 
> the "dev" it uses has already been released. And this only shows up as a 
> problem when you have slab debugging turned on (like the Fedora kernels 
> do, thank you all Fedora guys).
> 
> The odd thing is that I don't think any of this code has really changed 
> recently. 
> 

There is a patch from Pete that works around the problem by not
calling input_release_device() on devices that are gone. But what
I don't understand is why the parent input device is gone since
sysfs/driver core should be keeping a reference to it since it is
a parent of evdev. input_dev shoudl only be released after
evdev_free() is called.

-- 
Dmitry
