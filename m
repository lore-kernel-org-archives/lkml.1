Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZKQP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZKQP4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZKQPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:55:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:58686 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZKQPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:55:58 -0500
MIME-Version: 1.0
In-Reply-To: <1258468659-5446-1-git-send-email-mjg@redhat.com>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 17 Nov 2009 16:55:46 +0100
Message-ID: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 15:37, Matthew Garrett <mjg@redhat.com> wrote:
> Userspace may wish to know whether a given disk is active or idle, for
> example to modify power management policy based on access patterns. This
> patch adds a deferrable timer to the block layer which will fire if the
> disk is idle for a user-definable period of time, generating a uevent. A
> uevent will also be generated if an access is received while the disk is
> classified as idle.
>
> This patch seems to work as designed, but introduces a noticable amount of
> userspace overhead in udevd. I'm guessing that this is because change events
> on block devices are normally associated with disk removal/insertion, so
> a large quantity of complex rules end up getting run in order to deal with
> RAID setup or whatever. Is there a better way to deliver these events?

I guess, at the moment the disk tells it's idle, udev will open() the
disk and look for changed signatures, and end its idle state. :)

Uevents might not be the right interface, they are usually used if the
device needs to be (re-)examined, which will the idle thing into a
loop with the current setups, I guess.

Maybe we can use a sysfs file which can be open()'d and something can
watch with poll(), and gets woken up by the kernel, after the drive
changes its state? MD raid, as an example, has files like this in
sysfs to allow monitoring. That way, there is also no overhead, if the
requesting process goes away, which is usually the nicer interface,
than a global switch, which does not care about if the requesting
process still exists.

Thanks,
Kay
