Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZEAKwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZEAKwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEAKwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:52:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56406 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZEAKwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <20090501000353.b89caa8c.akpm@linux-foundation.org>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <20090501000353.b89caa8c.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 12:52:18 +0200
Message-ID: <ac3eb2510905010352l661b6671je4cef88096c87878@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 09:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 30 Apr 2009 23:55:27 -0700 Greg KH <greg@kroah.com> wrote:
>> On Thu, Apr 30, 2009 at 11:43:12PM -0700, Andrew Morton wrote:
>> > I don't understand why we need devfs2, really.  What problems are
>> > people having with teh existing design?

Bootup complexity. that you need a rather complex userspace, to get a
system booted. Pretty annoying in the rescue case, where you might not
have any working device node for a current disk. The static ones you
may have on the rootfs image, now that we can have dynamic block
device minors, may not work at all.

>> Boot speed, boot speed, boot speed.

>> Oh, and reduction in complexity in init scripts, and saving embedded
>> systems a lot of effort to implement a dynamic

It makes it possible to run udev in the background at bootup, parallel
to other things, instead of having a hard checkpoint to wait for,
before you can continue to bring up the rest.

> > /dev properly (have you
>> _seen_ what Android does to keep from having to ship udev?  It's
>> horrible...)
>
> Why can't they ship udev?

Not sure, seems they avoid GPL code, if they can. Besides that it's
pretty slow to bootstrap /dev with stock udev. Most embedded systems
use busybox's mdev here.

>> > Where is it determined that these subsystems create /dev subdirectories?
>> > udev rules?

It should be defined in Documentation/devices.txt, and for some
subsystems not mentioned there, it is only in the default udev rules
set.

>> If so, do we need to henceforth keep devfs2 (sorry, I
>> > can't resist) in sync with udev?

>> No, with this, udev rules can get simpler and remove these directory
>> names, keeping them only in one place, preventing anything from getting
>> out of sync.

During the last years, we synchronized all distros, and all ship
exactly the same naming rules today besides a few distro-specific
custom additions. So we have a common well defined setup today. With
devtmpfs, the final decision is still in udev rules, like it is today,
but with this, the kernel can pre-create a node, where udev will apply
permissions/ownership to.

Future versions of udev will be able to follow the kernel provided
device name hint, so drivers can provide a hint to userspace, without
the need to drop udev rules. Existing udev rules would still overwrite
the kernel-provided device node name hints. But this is all optional,
devtmpfs enabled today works just fine with any old udev version, and
udev should do the right thing on top.

> This assumes that devtmpfs is enabled in config, yes?

It's optional, yes.

> Does that means that we need two versions of udev out there, or can one
> version be feasibly extended to handle both flavours of kernel?

No, udev works just fine with or without it. When udev receives the
event, it looks if there is an already existing node, and if yes, it
just applies the defined permissions/ownership  to it. The final
decisionss are still made in udev. All ownerships must be handled in
uerspace anyway, there is no way for the kernel to assing group
numbers.

It does not really change anything visible for the normal distros,
besides that bootup can be made more efficient by running things in
parallel, and that there will be a working and correct /dev in the
rescue case.

For tiny, custom, embedded like setups, it might just work without any
userspace help, or with something very simple compared what we need
today.

Thanks,
Kay
