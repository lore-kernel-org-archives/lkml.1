Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZEAMi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZEAMi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZEAMiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:38:15 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:53461 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZEAMiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wg0H2NkArzihAPPL+frmmTUKzzhgIo8PhbdZ7k9CLSbDWKfaxnTZtDARDLNAvDjMLN
         UuOySaQLtAqEHkzsmizcNVFNiDKcJTTwQ2HcHfIpAdcNzfGHBEc+rqgHtHlkkcDo+XUJ
         bbGTcnZkbQtMkJiweAvYxkEO/DL28zdqOYAvo=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	 <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
	 <ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com>
Date: Fri, 1 May 2009 13:38:13 +0100
Message-ID: <9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Fri, May 1, 2009 at 12:19, Alan Jenkins
> <sourcejedi.lkml@googlemail.com> wrote:
>> On 4/30/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>>> With the kernel populated /dev, existing initramfs or kernel-mount
>>> bootup logic can be optimized to be more efficient, and not to require a
>>> full coldplug run, which is currently needed to bootstrap the inital
>>> /dev directory content, before continuing bringing up the rest of
>>> the system. There will be no missed events to replay, because /dev is
>>> available before the first kernel device is registered with the core.
>>> A coldplug run can take, depending on the speed of the system and the
>>> amount of devices which need to be handled, from one to several seconds.
>>
>> Aren't you overeaching in your claims here?  I'm sure you can't avoid
>> at least one coldplug run on a contemporary general purpose system,
>
> You still need coldplug, sure. But distros have 2 full coldplugs
> today, one in initramfs, one in the rootfs.
>
>> because you lose so much of the functionality provided by udev.
>
> No, udev will do the same thing as it does today, it will not be
> different, it's just that the colplug can run in parallel with other
> stuff, and the initramfs coldplug can be much simplified, or even
> avoided.

Ok, I can see there's no problem there, given that coldplug still
happens eventually.

>> I'm
>> sure of that, but it would be nice if you could address it in the
>> changelog.  And modern initramfs' require udev RUN rules to read UUIDs
>> and set up LVM.
>
> A simple uuid/label lookup will not need a full coldplug run in
> initramfs. You just need to start udev, and wait for the links to show
> up.Possibly running triggering block events, but not the hundreds of
> other devices.

Assuming you have all the necessary modules loaded!  I guess that's
easy enough though

find /sys -name modalias -exec cat \{\} \; | xargs -n 1 modprobe -Qa

bonus: increase "-n" for reduced modprobe fork overhead.

>> I'm loving this for embedded, init=/bin/sh, and rescue floppies :-).
>> But I can't understand how you plan to use this as an optimisation.
>>
>> And - I'm sure you must have considered this in a moment of madness -
>> do you know why we couldn't just start _udev_ "before the first kernel
>> device is registered with the core"?
>
> I think it's pretty obvious, that this is the fastest you can get for
> /dev. And it's not about the time when udev is started, its about
> doing the stuff when the devices are created, and not to need to redo
> it at bootup, or do it even twice.

Ok, yes.  I can see that cutting initramfs coldplug down to size is a win.

I thought it was a useful comparison.  Start udev early enough, and
you could avoid re-doing absolutely anything.  Thinking about, the
reasons it doesn't work are

a) running before /dev/null and /dev/console requires hacks
b) it requires an initramfs
c) it pulls everything that hooks into or otherwise affects udev into
the initramfs; that's much more than we have at present, and a bigger
initramfs' can only make bootup _slower_.

Regards
Alan
