Return-Path: <linux-kernel-owner+w=401wt.eu-S1765372AbZEAPAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765372AbZEAPAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765279AbZEAO4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:56:00 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44153 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbZEAOz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:55:59 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com> 
	<ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com> 
	<9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 16:55:38 +0200
Message-ID: <ac3eb2510905010755j1c9375dx64157e77185e59ea@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 14:38, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 5/1/09, Kay Sievers <kay.sievers@vrfy.org> wrote:

> I thought it was a useful comparison.  Start udev early enough, and
> you could avoid re-doing absolutely anything.  Thinking about, the
> reasons it doesn't work are
>
> a) running before /dev/null and /dev/console requires hacks
> b) it requires an initramfs
> c) it pulls everything that hooks into or otherwise affects udev into
> the initramfs; that's much more than we have at present, and a bigger
> initramfs' can only make bootup _slower_.

Exactly. That can not work, we always need to do the coldplug in the
rootfs, because only there are all the tools we require.

With the automatic devtmpfs mount in the rootfs, we can do most of the
coldplug in the background, because other stuff can be sure that
mandatory device nodes already exist, and they do not need to wait for
udev to finish.

Inside the initramfs, the need for coldplug is very much limited to
module loading and block device handling, and has also no hard
checkpoint anymore, when devtmpfsl pre-populates /dev.

Static /dev entries are no option anymore, with all the dynamic number
assignments today. It might be fine for custom systems, but distros
can not use it at all. And even for the custom setups, which could do
it, devtmpfs should be the most flexible and reliable option.

I think the init=/bin/sh case alone would be worth to do it, without
any of the other optimizations it makes possible. It's a pretty
difficult to manage situation today, if your userspace breaks, and you
need to get to your devices, and /dev is empty, contains entries with
the wrong numbers, or does not contain what you are looking for.

Thanks,
Kay
