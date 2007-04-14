Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXDNIqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXDNIqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXDNIqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:46:08 -0400
Received: from tim.rpsys.net ([194.106.48.114]:59736 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXDNIqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:46:05 -0400
Subject: Re: [PATCH] applesmc - fix crash when activating a led trigger on
	the keyboard backlight
From: Richard Purdie <rpurdie@rpsys.net>
To: Nicolas Boichat <nicolas@boichat.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bradley Hook <bdhook@gmail.com>,
       mactel-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <46208B40.1060809@boichat.ch>
References: <45F7C083.7090504@boichat.ch>
	 <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>
	 <45FF86F6.7050200@boichat.ch>
	 <eb4a44160703200016i74786682n41f87f3d88f90409@mail.gmail.com>
	 <46208B40.1060809@boichat.ch>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 09:45:11 +0100
Message-Id: <1176540311.6818.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2007-04-14 at 16:05 +0800, Nicolas Boichat wrote:
> Bradley Hook wrote:
> > Slightly off-topic, but I've been experiencing a minor bug in the
> > keyboard backlight feature.
> >
> > I say it is "minor" only because the feature serves no real functional
> > purpose. You can activate a trigger called "heartbeat" that will cause
> > the keyboard light to pulse at a speed based on the CPU usage. On my
> > MBP17, after activating this trigger the machine will either lock-up
> > or core dump within about a minute (timing is not consistent).
> >   
> 
> This is caused by the fact applesmc_backlight_set locks a mutex (or more
> precisely sleeps while trying to lock a mutex) while being in a softirq
> context.
> 
> This might be obvious for others, but it was not for me, and there is
> absolutely no mention in the documentation of the fact it is not always
> safe to sleep in the brightness_set handler of a led_class device (it is
> safe when it is called because someone wrote to the brightness sysfs file).

Its never safe for a brightness_set handler to sleep. They're designed
to be called from interrupt context and as you've noted, several
triggers do that.

The solution if you have locks like your case is to offload the work to
a workqueue, there is simply no other way to do it.

I'll have a look to see if I can improve the documentation (patches
welcome).

> Also, the led-trigger code seems buggy when it comes to locking. Setting
> CONFIG_DEBUG_SPINLOCK_SLEEP causes a lot a warnings. The problem is that
> the list of triggers is locked using a rw spinlock, but the rest of the
> code seems to ignore that, and calls a lot of functions which can sleep
> (kzalloc with GFP_KERNEL, sysfs_add_file, mutex_lock, etc...). I think
> the list lock should be converted to a mutex (or maybe modified to use
> RCU). I'm not very experienced in that domain, but if you want I can
> provide a patch for this.

Someone else has mentioned this within the past few days and there is a
problem with the trigger->activate and ->deactivate calls occurring
within a spinlock. Its not a simple problem to solve unfortunately and
you can't just convert to a mutex but I'm looking at it. Again, patches
welcome but its going to need careful thought.

Cheers,

Richard


