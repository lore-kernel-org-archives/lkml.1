Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYEWJJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYEWJJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbYEWJJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:09:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbYEWJJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:09:32 -0400
Date: Fri, 23 May 2008 05:09:19 -0400
From: Alan Cox <alan@redhat.com>
To: Andy Walls <awalls@radix.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080523090919.GA31575@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core> <1211508484.3273.86.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211508484.3273.86.camel@palomino.walls.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:08:04PM -0400, Andy Walls wrote:
> Could someone give me a brief education as to what elements of
> cx18/ivtv_v4l2_do_ioctl() would be forcing the use of the BKL for these
> drivers' ioctls?   I'm assuming it's not the
> mutex_un/lock(&....->serialize_lock) and that the answer's not in the
> diff.

As it stood previous for historical reasons the kernel called the driver
ioctl method already holding the big kernel lock. That lock effectively
serialized a lot of ioctl processing and also serializes against module
loading and registration/open for the most part. If all the resources you
are working on within the ioctl handler are driver owned as is likely with
a video capture driver, and you have sufficient locking of your own you can
drop the lock.

video_usercopy currently also uses the BKL so you might want to copy a
version to video_usercopy_unlocked() without that.

A small number of other things still depend on the BKL but probably don't
affect a capture driver: Setting file flags and using the deprecated
sleep_on and interruptible_sleep_on. Other things like memory allocators
wait_event, wake_up and the like all do their own locking internally and
that is a model we want to end up at - whether everything has "proper" locking.

You may also find a driver depends on other things (eg video on i2c and you
can't yet prove the i2c (or don't know) is locked entirely privately in
which cases I've ended up leaving the drivers I worked on with

	lock_kernel();
	ret = subsys_some_foo(bar);
	unlock_kernel();

which makes it clear what the remaining problem points are so they can be
revisited.

For a lot of ioctl conversions the big issue is "two ioctls at once in parallel"
which can happen even on a single opener device. The other tends be stuff like
"ioctl versus unplug" although for PCI and many other subsystems the resources
are ref-counted so a pci_dev won't vanish on you without warning.

Alan

