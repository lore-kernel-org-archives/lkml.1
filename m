Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZEER1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZEER1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZEER0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:26:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbZEER0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:26:49 -0400
Date: Tue, 5 May 2009 10:22:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: David Brownell <david-b@pacbell.net>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: use memdup_user()
Message-Id: <20090505102253.6993f381.akpm@linux-foundation.org>
In-Reply-To: <200905051244.01698.oliver@neukum.org>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
	<200905041601.51789.oliver@neukum.org>
	<20090504231157.1ff2cf15.akpm@linux-foundation.org>
	<200905051244.01698.oliver@neukum.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 12:44:01 +0200 Oliver Neukum <oliver@neukum.org> wrote:

> Am Dienstag, 5. Mai 2009 08:11:57 schrieb Andrew Morton:
> > On Mon, 4 May 2009 16:01:51 +0200 Oliver Neukum <oliver@neukum.org> wrote:
> 
> > > I want people to be forced to think about memory allocations.
> > > We had endless trouble during 2.4 with storage deadlocking.
> > > We simply need full control of this.
> >
> > thou-shalt-use-GFP_NOFS is a very common pattern in many filesystems.
> > And thou-shalt-use-GFP_NOIO is a very common pattern in block drivers.
> 
> USB drivers are interface level yet some functions, reset and power
> management, are on a device level. As it is unpredictable whether
> a driver will share a device with a storage driver, all USB drivers as far as
> these functions are concerned must be considered block device drivers.
> That's the reason GFP_NOIO is so prevalent in USB.

There must be some particular action which flips the thread of control
from one state to the other.  eg, taking of a lock.

> > I wonder how hard it would be to add runtime debugging checks?  If
> 
> I'd prefer compile time checks. Ideally we'd annotate a function with an
> attribute making the compiler barf if copy_to/from_user or an inappropriate
> kmalloc is used. It can't be perfect due to function pointers, but it would
> be a good start.

I don't think that would have enough coverage - bugs in this area tend
to come from calling some function which looks innocent, but which
calls some function which calls some function which calls some function
which uses GFP_KERNEL.

And then there's stuff like "usb takes a mutex which is also taken by
some other thread which does a GFP_KERNEL allocation while holding that
mutex".

