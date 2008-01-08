Return-Path: <linux-kernel-owner+w=401wt.eu-S1761941AbYAHQiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761941AbYAHQiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYAHQhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:37:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57119 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbYAHQhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:37:51 -0500
Date: Tue, 8 Jan 2008 17:40:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com
Subject: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108164015.GC31504@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a proposal for some useful code transformations the kernel janitors
could do as opposed to running checkpatch.pl.

Most ioctl handlers still running implicitely under the big kernel 
lock (BKL). But long term Linux is trying to get away from that. There is a new
->unlocked_ioctl entry point that allows ioctls without BKL, but the code
needs to be explicitely converted to use this.

The first step of getting rid of the BKL is typically to make it visible
in the source. Once it is visible people will have incentive to eliminate it.
That is how the BKL conversion project for Linux long ago started too.
On 2.0 all system calls were still implicitely BKL and in 2.1 the
lock/unlock_kernel()s were moved into the various syscall functions and then
step by step eliminated.

And now it's time to do the same for all the ioctls too.

So my proposal is to convert the ->ioctl handlers all over the tree 
to ->unlocked_ioctl with explicit lock_kernel()/unlock_kernel.

It is not a completely trivial conversion. You will have to 
at least read the source, although not completely understand it.
But it is not very difficult.

Rough recipe:

Grep the source tree for "struct file_operations". You should
fine something like

static int xyz_ioctl(struct inode *i, struct file *f, unsigned cmd, unsigned long arg) 
{
	switch (cmd) { 
	case IOCTL1:
		err = ...;
		...	
		break;
	case IOCTL2:
		...
		err = ...;
		break;
	default:
		err = -ENOTTY;
	} 
	return err;
}
...

struct file_operations xyz_ops = {
	...
	.ioctl = xyz_ioctl
};

The conversion is now to change the prototype of xyz_ioctl to 

static long xyz_ioctl(struct file *f, unsigned cmd, unsigned long arg)
{
}

This means return type from int to long and drop the struct inode * argument

Then add lock_kernel() to the entry point and unlock_kernel() to all exit points.
So you should get

static long xyz_ioctl(struct file *f, unsigned cmd, unsigned long arg)
{
	lock_kernel();
	...
	unlock_kernel();
	return err;
}

The only thing you need to watch out for is that all returns get an unlock_kernel.
so e.g. if the ioctl handler has early error exits they all need an own unlock_kernel()
(if you prefer it you can also use a goto to handle this, but just adding own
unlock_kernels is easier) 

so e.g. if you have

case IOCTL1:

	...
	if (something failed)
		return -EIO;

you would convert it to

	if (something failed) { 
		unlock_kernel();
		return -EIO;
	}

It is very important that all returns have an unlock_kernel(), please always
double and triple check that!

Then change

	.ioctl = xyz_ioctl

to 

	.unlocked_ioctl = xyz_ioctl

Then compile ideally test the result and submit it.

-Andi


