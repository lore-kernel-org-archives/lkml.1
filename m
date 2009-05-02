Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZEBPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZEBPSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZEBPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 11:18:35 -0400
Received: from main.gmane.org ([80.91.229.2]:45342 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbZEBPSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 11:18:35 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andy Lutomirski <luto@myrealbox.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
Date: Sat, 02 May 2009 11:18:17 -0400
Message-ID: <49FC6439.80704@myrealbox.com>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 	<20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> 	<ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 	<20090502071939.GA14094@infradead.org> <ac3eb2510905020646k28ebaf07j2216c6f3f614748c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
X-Gmane-NNTP-Posting-Host: 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
In-Reply-To: <ac3eb2510905020646k28ebaf07j2216c6f3f614748c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Sat, May 2, 2009 at 09:19, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, May 01, 2009 at 03:24:01PM +0200, Kay Sievers wrote:
>>> I'm very sure, you can not fix it outside the kernel. Or do you have
>>> an idea how to create the missing device nodes for device without
>>> crawling sysfs, when the first userspace process is started?
>> Just make sure to queue up your uevents in a ring buffer that udev
>> can read once it has started?
> 
> Which does not really target any of the problems we try to solve, and
> is probably even larger than the 300 lines to create the proper /dev
> stuff right away. It's about fractions of a second, we are optimizing
> for, and we need to start as many things in parallel, as early as
> possible. And a working and populated /dev is mandatory for most of
> the stuff we need to bring up.
> 
> I think the init=/bin/sh case alone would be justification enough to
> do that, it can save you a lot of trouble if things go wrong, which
> things do, and which is pretty hard to cope with today, with no access
> to your devices.

What's wrong with:

mount -n -t sysfs none /sys
mount -n -t tmpfs none /tmp
udevd --daemon
udevadm trigger

once the shell comes up?  There could even be a standard script that all 
distributions ship that does that, plus mounts /proc and does whatever 
magic is needed to make Ctrl-C work.

(OK, so you depend on udev and mount working, but you already depend
on sh working, and you'll have a heck of time rescuing anything if even 
mount doesn't work.)

If you want a really reliable rescue mode, then either put a whole 
working busybox system in a spare initramfs with a spare boot menu entry 
or just use a real rescue disk, neither of which require devtmpfs.


As a separate question, what happens with devtmpfs if I plug in some 
device that uses dynamic minors, then unplug it, then plug in another 
device that gets a new minor but the same name, all before (or even 
after) udev starts?  Are there any subsystems that could do that?

--Andy

> 
> We are not implementing anything crazy here like devfs did, including
> the later versions - there is no modprobe behind your back, no lookup
> hooks, no stupid new naming scheme, no new filesystem type to
> register.
> Udev uses the kernel provided names anyway today, there are no naming
> rules at all in current userspace for 98 of 100 devices. It's todays
> kernel which provides the naming already, and we will not change
> anything here, just add the few exceptions, which are only in udev
> rules today, and let the kernel create the node that udev will create
> anyway.
> 
> Thanks,
> Kay

