Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZEDSN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZEDSN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZEDSNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:13:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56265 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZEDSNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <49FF2BD4.3070409@googlemail.com>
References: <20090501061701.GB19234@kroah.com> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 
	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 
	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> 
	<ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> 
	<20090504162011.GO17956@suse.de> <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com> 
	<49FF2BD4.3070409@googlemail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 4 May 2009 20:13:00 +0200
Message-ID: <ac3eb2510905041113x58bdb807od7dd4a6ce258e317@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Michael Riepe <michael.riepe@googlemail.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 19:54, Michael Riepe
<michael.riepe@googlemail.com> wrote:
>> The problem is not the missing events, they could be pretty easily
>> recovered from sysfs with just another special hack to run at bootup -
>> it's the time it takes to bring up the engine to bootstrap /dev, to
>> allow us to start any other process which looks for devices. Today,
>> udev mounts /dev as a tmpfs, and at that point it is obviously empty,
>> and needs to be filled, and nothing else can reliably run at that
>> time.
>
> And what about mounting /dev from an already populated image? Or, even
> faster, using the /dev directory of the root fs? That way, the device
> nodes would be present as soon as / is mounted, without any additional
> overhead, except the very first time the system boots (in case you
> choose not to populate /dev with a default set of device nodes in advance).

Dynamic device numbers! A static /dev does not work at all for many
subsystems, not to mention the risk you take by talking to the wrong
device pointed to, by your incorrect static device nodes. It's not an
option at all today, and it will get much worse in the future.

> I know, not using tmpfs is a security risk and whatever. But does that
> really matter in an embedded system where you have no user accounts?

If you have a very limited environment, and no hotplug setups, sure
you can do that. But some of us have not even sd* as stable numbers
anymore.

>>   The plan is to start udevd, but run the coldplug in the background
>> and start other stuff in parallel, because you can be sure that all
>> currently known devices are already there, and the missing meaningful
>> symlinks created by udev will show up soon, along with a new event to
>> hook into. There will be no hard checkpoint anymore to wait for the
>> basic environment..
>
> You can do that with a persistent /dev as well. It will even keep the
> symlinks udev created before the system rebooted. The only drawback is
> that you have to wait for device nodes that belong to new devices which
> were connected to the system while it was down. But that rarely happens,
> and will eventually be fixed by udev.

What? Keeping the links is insane, many things can go wrong with that.
Udev does not work reliable on non-tmpfs - you can do that, but don't
be surprised if stuff goes wrong and talks to the wrong devices.

Thanks,
Kay
