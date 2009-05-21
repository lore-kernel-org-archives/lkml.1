Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZEUVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZEUVH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZEUVHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 17:07:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:41006 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZEUVHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 17:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
References: <20090521095217.GU8633@ZenIV.linux.org.uk> <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 21 May 2009 23:07:29 +0200
Message-ID: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
Subject: Re: How to tell whether a struct file is held by a process?
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 16:06, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 21 May 2009, Al Viro wrote:
>> On Tue, May 19, 2009 at 12:57:21PM -0400, Alan Stern wrote:
>> > What's the best way to tell whether the current process has a
>> > particular struct file among its open files?  Is there any better way
>> > to find out than blindly calling fget() for each possible fd?
>> >
>> > Is this a totally insane thing to do?
>>
>> It is insane.  You might lock fdtable and scan it, but as soon as you
>> drop the spinlock your return value is worthless.
>
> In this case, I believe that changes after the check has been made
> won't hurt -- everything relevant to my work will be serialized by a
> separate lock.
>
>> What are you trying to do?  If the process is cooperating, you don't really
>> need that in the kernel, if it's not, the check is not usable...
>
> I'm trying to work out a good way to reserve access rights to a device
> -- even if that device doesn't exist yet.
>
> Here's the story.  People have requested that the kernel add a
> mechanism whereby a user program can get more-or-less exclusive access
> rights to a USB device.  In fact, they'd like to reserve these rights
> for any device plugged into a particular USB port.  So even if no
> device is plugged into that port at the moment, the program should get
> exclusive access as soon as a new device is detected there.
>
> In order to prevent programs from dying without releasing their
> exclusive rights, it seems natural to implement these rights as open
> files.  Thus, opening file A(P) will give a program exclusive access
> rights to any device plugged into USB port P.  Closing A(P) releases
> the rights.  (The A(P) files would be implemented as single-open files,
> probably in sysfs.)
>
> The problem is this.  Let D be the device plugged into port P.  When
> some program opens D's device file, it's necessary to check whether
> that same program has an open file reference for A(P), i.e., has opened
> A(P), or has inherited a descriptor for A(P) from its parent, or has
> been passed such a descriptor over a Unix socket, etc.  If not, and if
> A(P) is open (owned by someone else), then access to D is denied.
>
> If you can think up a better way to implement these exclusive access
> rights, I'd be glad to hear it.

Not sure, if we already discussed that with a conclusion: this
"prevent access to a future device" interface needs to work at the pid
level, or would a uid/gid check be sufficient?

Root can do all that stuff anyway, even with the locking in place.
Uid/gid file permissions need to be applied to the "lock file", so
specified non-root users can use that interface.

Maybe it would be good enough, to check that the one that opened the
"lock file" has the same uid/gid as the on that tries to open the
device when it has shown up?

Kay
