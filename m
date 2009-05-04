Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZEDQyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZEDQyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbZEDQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:53:57 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:51245 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbZEDQx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <20090504162011.GO17956@suse.de>
References: <20090501061701.GB19234@kroah.com> <20090501065527.GA19773@kroah.com> 
	<20090501120359.05bacb48@lxorguk.ukuu.org.uk> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 
	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 
	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com> 
	<ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com> 
	<20090504162011.GO17956@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 4 May 2009 18:53:40 +0200
Message-ID: <ac3eb2510905040953t29e104eel1f820516195c623a@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 18:20, Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2009-05-02T23:47:03, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> It is not about missing events, it is about the bootstrap step we
>> would like to avoid. Buffering events, or reading all device
>> information from sysfs at this stage introduces a hard checkpoint,
>> where we need to bring a process up process these events and create
>> nodes for them. Only after that we can start other things in userspace
>> which depend on a working /dev, and with the kernel populated one, we
>> can just go ahead.
>
> So if udevd was present before the kernel started scanning devices this
> would not be as much of a problem, would it?

It is too early, you would need a working userspace environment to
start a process like udev, which we don't have at this point. You
really want to catch the creation of /dev/null and /dev/console and
such, and there is no real chance to run anything like udev reliably
at this stage.

> (Couldn't udevd trigger the device scan? Could it be started so early as
> for this not to matter?)

The driver-core is basically "80% of basic udev" in the kernel - the
/dev part is just the last missing piece. :)

The problem is not the missing events, they could be pretty easily
recovered from sysfs with just another special hack to run at bootup -
it's the time it takes to bring up the engine to bootstrap /dev, to
allow us to start any other process which looks for devices. Today,
udev mounts /dev as a tmpfs, and at that point it is obviously empty,
and needs to be filled, and nothing else can reliably run at that
time.

> And isn't part of the problem that you have a choke point in the
> dependency graph - namely "/dev working" as a predicate for running
> certain services/scripts - instead of more fine-grained dependencies for
> just the devices they need?

Without the basic devices, you can not start anything "normal", and
currently it's udev which provides /dev/null /dev/console,
/dev/random, the ttys, or whatever which might be needed you can not
know in advance.
  The plan is to start udevd, but run the coldplug in the background
and start other stuff in parallel, because you can be sure that all
currently known devices are already there, and the missing meaningful
symlinks created by udev will show up soon, along with a new event to
hook into. There will be no hard checkpoint anymore to wait for the
basic environment..

The other important reason besides that it saves us from coming up
with just another custom hack to fill the initial /dev, is that it is
damn simple and very reliable. It allows init=/bin/sh to just work,
and /dev has the same logic when an initramfs is used, or the kernel
mounts the rootfs. And simpler is almost always better - and I think
it's also the fastest we can do.

Thanks,
Kay
