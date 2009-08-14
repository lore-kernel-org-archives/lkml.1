Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbZHNPBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbZHNPBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbZHNPBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:01:04 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47451 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZHNPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YulH5CCmEt9+jm78bqxaSy49cdQLTZQkNyH6nYLH8s9Qo6b9xy2NAJDN/dnj6A/9+z
         +cV0qTiLp3Qy+DF0wb9vvd0dJTIAzr8IM4tkIgmZfU+P4j+wlxiBc8c69T4wrjqmJIHT
         vF4Rh6oh/GQ58/egu3urkIzU8NSsJDs+KrVYc=
MIME-Version: 1.0
In-Reply-To: <4A856C45.40706@users.sourceforge.net>
References: <4A855F5D.1010502@users.sourceforge.net>
	 <4A856C45.40706@users.sourceforge.net>
Date: Fri, 14 Aug 2009 15:54:10 +0100
Message-ID: <9b2b86520908140754i278c7160vab3b8e0edab2eb15@mail.gmail.com>
Subject: Re: [RFC] charger: Offer kernel build that disables disks, screen, 
	etc. and lets laptop serve as charger for USB/FireWire devices
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Pander <pander@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/09, Pander <pander@users.sourceforge.net> wrote:
> Pander wrote:
>> Hi all,
>>
> ...
>>
>> This can be achieved by building a special kernel that will shut down
>> all hardware that is not needed for offering power on the before
>> mentioned ports. Perhaps this can be achieved by kernel configuration
>> alone or it might require a minimal of functionality to put a laptop
>> into such a charging state.
>
> Alternative implementation could be that this functionality is present
> in a normal kernel and is only activated by boot time command argument
> 'charger'.
>
> While being on the subject anyway, optionally, extra functionality could
> be implemented for turning the laptop into an emergency light. The boot
> time command argument 'light' could offer this.
>
> The same functionality as with charger will be enabled and the screen
> and keyboard will powered up. Initially, the screen will be white. By
> means of the following keys: arrow op, arrow down, arrow left, arrow
> right, page up, page down, home, end, return, tab one is able to change
> the color of the screen in on of 16 basic colors: white, yellow,
> fuchsia, red, silver, gray, olive, purple, maroon, aqua, lime, teal,
> green, blue, navy and black (perhaps omit the latter). The space bar key
> would enable and disable the screen but still allow for the other keys
> to change the color. Also the brightness keys should be supported.
>
> Of course this is easily done by software on a fully booted system.
> However, due to the emergency situation, again power can be scarce and
> must be used as efficient as possible. Considering and discussing
> implementation of this greatly overlaps the aforementioned proposal.
>
> Kind regards,
>
> Pander

You can do all this in userspace, without using any more power.  E.g.
instead of a "charger" boot option, just use init=/sbin/charger.

If there are any opportunities to save more power by disabling certain
devices, then these capability should be exercised automatically when
devices are unused.

Where this is not possible, userspace can explicitly disable the
device.  E.g. USB mice which usually have broken autosuspend support,
and will not "wake up" when used.  In this example, userspace can
already write "suspend" or "auto" to
/sys/bus/usb/devices/.../power/level.  See
Documentation/ABI/testing/sysfs-bus-usb.

Then you can benefit from writing "charger" or "torch" in userspace,
which is generally a much nicer environment.  And any extra power
saving capabilities you add can be reused by other userspace software,
possibly including the modern desktop environments.

W.r.t to suspend: I do not believe it is guaranteed that USB ports
will supply full power when the system is suspended.  You might have
to make that an option.

Here are some of the biggest potential power savings:  Disable all
radios e.g. WiFi, using the rkill subsystem.  Put the screen into
power saving mode.  Don't access the disk - use a ramdisk, or a good
prefetching system, and spin the disk down once you've loaded
everything into ram.  Don't run any userspace programs which wake up
periodically (i.e. audit your system with powertop).

All the above can be implemented in userspace without doing anything
really novel.  If anything, they will be harder to implement in-kernel
because it's not really designed to allow that sort of policy
enforcement.  And you might even have to run X in order to reliably &
portably blank the screen :-).

Have fun
Alan
