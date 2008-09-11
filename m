Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYIKQI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYIKQI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756140AbYIKQIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:08:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:32208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbYIKQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SCDaJgo0CneyHk76lpdpZRwLTxYsVSDa8S4D6eBqc7QgAgNFbKdqUIxHe4u1RJw2AV
         +WwYQWhabNDzHlR4WHksTStjLvls+8UXSJF3iLpT6HaLYt92r77SABZgXe1ZG4wyH6QV
         2aA0Y7unvEGJmiUosbozygbfB7xXIiEUhaF4A=
Message-ID: <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com>
Date: Thu, 11 Sep 2008 12:08:41 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Cc: "Elias Oltmanns" <eo@nebensachen.de>, "Thomas Renninger" <trenn@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>
In-Reply-To: <48C7FCEE.8060404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C7FCEE.8060404@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Sep 10, 2008 at 12:59 PM, Tejun Heo <tj@kernel.org> wrote:

>The original hdaps uses polling on sysfs
> nodes, the HP thing Thomas is working on is likely to use sysfs +
> sysfs_notify_event() and probably another node to control LED.  The
> tp_smapi seems to use joystick input device to transfer the data along
> all the axises.

> 1. How should the shock interface look like?  As we're gonna need
>   userland daemon one way or the other, we can use the userland
>   daemon to glue all the interfaces but it would be much better to
>   have a unified interface.  Although there seem to be several
>   different variants, they don't differ all that much and creating a
>   new interface every time is painful.  I think we can get by with a
>   sysfs interface with notification.

Using the input device interface for the accelerometer (as done by
tp_smapi's hdaps + latest hdapsd) greatly reduces the number of
accelerometer-related timer interrupts on tickless kernels, as
measured by powertop. With syscall polling you have the kernal polling
the hardware at ~50Hz and then the userspace hdapsd polling the kernel
at ~50Hz. When they're out of phase so you can get up to 100
interrupts/sec. With an input device you're always at 50Hz. The phase
difference also induces a small extra delay in the shock handling
response.


> 2. If we're gonna unify interface, how much can we unify the backend?
>   Some devices are based on polling, others interrupt.  For polling,
>   is it better to delegate the whole polling to userland or is it
>   better to do some of it in kernel (tp_smapi seems to be doing
>   this)?

The ThinkPad accelerometer needs to be polled at very regular
intervals (max jitter on the order of 10ms), which sounds like a job
for the kernel.
This is because in ThinkPads we actually have a 4-level pile:
[hdapsd userspace] -> [hdaps kernel] -> [embedded controller] ->
[accelerometer A2D]
What the kernel polls is actually is the H8S embedded controller (EC)
chip, which in turn does its own polling of the accelerometer A2D.
Now, the EC has a tiny buffer and strange buffering semantics, and it
has its own internal clock, so the software->EC polling should be very
regular to minmize EC buffer overflows/underruns.


> 3. What about the userland daemon?  It would be best to have a unified
>   daemon which can handle all instead of one for hdaps and another
>   for hp (and so on).  If we can unify the interface, this will be
>   much easier.

Assuming the funky shock detection algorithms are done in userspace,
we need two interfaces: one for the acceleration data (an input device
works nicely) and one for "unload now" events.
On HP, the kernel can trigger the "unload now" event directly. On
ThinkPads, there's still the question of what the userspace shock
detection daemon should do when it detects a shock: should it unloads
the heads by itself, or trigger the generic "unload now" event and let
someone else do the actual unloading.

  Shem
