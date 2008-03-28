Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYC1UwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYC1UwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbYC1Uvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:51:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757670AbYC1Uvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:51:47 -0400
Date: Fri, 28 Mar 2008 13:51:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Oops/Warning report for the week of March 28th 2008
In-Reply-To: <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org>
References: <47ED3F1A.1090101@linux.intel.com> <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Linus Torvalds wrote:
> 
> Is there something obvious that I'm missing? I'd really like to see the 
> whole posting that the oops came from. Do you save the originals or even 
> just message ID's from the ones you pick from emails?

Hmm. Definitely not from the kernel mailing list. I'm intrigued, where did 
that oops #5814 come from (picked a recent one at random)?

The thing is recent, and oopses on "mutex_lock(dev->mutex)" in 
input_release_device. In particular, the path *seems* to be this one:

  evdev_release ->
    evdev_ungrab ->
      input_release_device ->
        mutex_lock ->
          mutex_lock_nested ->
            __mutex_lock_common ->
              list_add_tail(&waiter.list, &lock->wait_list)

where "lock->wait_list.prev" seems to be 0x6b6b6b6b6b6b6b6b, which is the 
use-after-free poison pattern.

(In fact, I think the access that actually oopses is when the 
debug version of __list_add() does

	if (unlikely(prev->next != next)) {

because that "prev" pointer is crap).

So it seems that when input_release_device() does:

	struct input_dev *dev = handle->dev;

	mutex_lock(&dev->mutex);

the "dev" it uses has already been released. And this only shows up as a 
problem when you have slab debugging turned on (like the Fedora kernels 
do, thank you all Fedora guys).

The odd thing is that I don't think any of this code has really changed 
recently. 

			Linus
