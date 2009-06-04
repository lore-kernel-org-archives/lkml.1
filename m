Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZFDIqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZFDIqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFDIqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:46:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbZFDIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:46:36 -0400
Date: Thu, 4 Jun 2009 01:46:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: make blank timeout value a boot option
Message-Id: <20090604014601.7dcf0d52.akpm@linux-foundation.org>
In-Reply-To: <20090604083726.GZ26148@buzzloop.caiaq.de>
References: <1243953993-18608-1-git-send-email-daniel@caiaq.de>
	<20090604002325.5b1284de.akpm@linux-foundation.org>
	<20090604074407.GX26148@buzzloop.caiaq.de>
	<20090604011740.5879732c.akpm@linux-foundation.org>
	<20090604083726.GZ26148@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 10:37:27 +0200 Daniel Mack <daniel@caiaq.de> wrote:

> On Thu, Jun 04, 2009 at 01:17:40AM -0700, Andrew Morton wrote:
> > > That's already possible - there is an ioctl for that. It's just not
> > > configurable at boot time, and that occured to be very annoying when
> > > developing systems that won't fully boot up for >10mins. You have no way
> > > to wake up the console then.
> > 
> > Oh.  Your changelog sucked :)
> > 
> > > Is there any concern why that shouldn't be a kernel option?
> > 
> > I suppose it makes sense.  You really have systems which take more than
> > ten minutes to start running initscripts?  Poor you.
> 
> This happens during development only. Assume the system tries to mount
> an NFS volume for its rootfs and fails due to a broken NIC driver; you
> might be interessted in some debug output. Assume the kernel crashes
> at boot time and you happen to miss that and come back to the machine
> 10 minutes later; you would still like to see the Oops. Or think about
> situations where you forgot to add a userspace application to disable
> the screen saver and you still want to see kernel messages and no input
> device is attached to wake up the console. All possible scenarios where
> this option would make sense.
> 

OK, that would be irritating.

> 
> > Please resend with a more complete description?
> 
> Attached. Better now?
> 

yep ;)

> 
> >From 9a77004367e49d41b58b81fb6a4882d0906a4743 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Tue, 2 Jun 2009 16:38:44 +0200
> Subject: [PATCH] console: make blank timeout value a boot option
> 
> The console blank timer is currently hardcoded to 10*60 seconds which
> might be annoying on systems with no input devices attached to wake up
> the console again. Especially during development, disabling the screen
> saver can be handy - for example when debugging the root fs mount
> mechanism or other scenarios where no userspace program could be started
> to do that at runtime from userspace.
> 
> This patch defines a core_param for the variable in charge which allows
> users to entirely disable the blank feature at boot time by setting it
> 0. The value can still be overwritten at runtime using the standard
> ioctl call - this just allows to conditionally change the default.
> 
> ...
>
> +static int blankinterval = 10*60;
> +core_param(consoleblank, blankinterval, int, 0444);
>  
> ...
>
> -		mod_timer(&console_timer, jiffies + blankinterval);
> +		mod_timer(&console_timer, jiffies + (blankinterval * HZ));

although one would prefer that the *HZ be done a single time at a
single callsite.  But that's hard when core_param() is used.


