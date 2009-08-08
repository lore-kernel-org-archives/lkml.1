Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbZHHPTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbZHHPTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZHHPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:19:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59051 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751772AbZHHPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:19:04 -0400
Date: Sat, 8 Aug 2009 11:19:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
In-Reply-To: <d82e647a0908080206j78a49674i99ba80801398055d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0908081117040.19562-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009, Ming Lei wrote:

> > The ordering requirement is: Don't try to acquire a device's lock if
> > you already hold the lock for a non-ancestor device.  More generally
> > (if more obscurely): If you already hold device A's lock, then don't
> > try to acquire the lock for device B unless you already hold the lock
> > for A & B's most recent common ancestor.
> >
> 
> It seems that the following case is very common, and A and B have no
> common ancestor, but we can hold device A and B's lock at the same
> time, can't we?
> 
> Thanks.
> 
> device A  comes in one bus:
> 	device_add()
>          ->bus_attach_device()
>             ->device_attach():drivers/base/dd.c /*holding device A's lock*/
>                ->...drv->probe()		/*sleep here some time*/

So right now thread 1 is sleeping.

> then device B comes in another bus:

So all this must happen in a different thread, thread 2:

> 	device_add()
>          ->bus_attach_device()
>             ->device_attach():drivers/base/dd.c /*holding device B's lock*/
>                ->...drv->probe()		/*sleep here some time*/

At this point, thread 1 holds A's lock and thread 2 holds B's lock.  
Neither thread holds both locks.

Alan Stern

