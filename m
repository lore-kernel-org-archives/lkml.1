Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYK3NVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYK3NVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 08:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYK3NVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 08:21:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYK3NVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 08:21:22 -0500
Date: Sun, 30 Nov 2008 13:21:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix pktcdvd breakage from commit
	e105b8bfc769b0545b6f0f395179d1e43cbee822
Message-ID: <20081130132118.GY28946@ZenIV.linux.org.uk>
References: <20081130121909.GV28946@ZenIV.linux.org.uk> <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 01:41:29PM +0100, Kay Sievers wrote:

> I posted a fix for that weeks ago. But the pktcdvd maintainer stated,
> that the char device nodes are not used for anything. So the whole use
> of dev_t should be removed entirely. They just blindly claim the same
> char dev_t the block devices use, and conflict with char devices from
> other subsystems. Patching out the /sys/dev/class links fixes the
> oops, but the underlying fundamental breakage will still exist.
> 
> Original mail here states:
> "Maybe, but that character device would not be used for anything,
> besides creating sub-directories in /sys/class/pktcdvd. The driver
> implements a block device, not a character device."

_What_ character device nodes?  The only thing that dev_t value used to
be used for was giving contents for a text file - ..../dev in sysfs directory.  
With introduction of /sys/dev/char the damn thing got confused for
character device number *by* *device_create()*.  That's all.

There are no character device nodes at all.  Driver doesn't claim them.
Not in that call of device_create(), not anywhere else.  sysfs doesn't
create them (or any other device nodes).  If you mknod such thing as
char device and try to open it, the kernel won't go anywhere near this driver,
whether there'd been other drivers or not. 

So what kind of fundamental breakage are you talking about?  All I can see
here is a bogus entry added to bogu^Wmisguided^W /sys/dev/char, which leads
to WARN_ON() in case if somebody had char device with device number numerically
equal to that of our block device and to silent crapping into /sys/dev/char
if no such char device had been there already.
