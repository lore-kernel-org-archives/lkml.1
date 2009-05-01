Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbZEAVNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbZEAVNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZEAVNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:13:45 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:38164 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZEAVNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bWPqbeCD4U2baeACM53H6vrJPi3l9PZw9ly48Vd3+fDodTNkYsbdOk4JgwAJ6aNMiL
         cX3mr9GU1OC864lB4KfuMkYivh9fNgYMd73m/ggB3vj9YObysDN14huJXN/04EhWDp7V
         iOlA0uPzMElxeH/K7SZ1YEAhfBatvmW/pr8pY=
MIME-Version: 1.0
In-Reply-To: <20090501160444.GA17325@kroah.com>
References: <1241097822.2516.3.camel@poy>
	 <20090501065754.GA30626@puku.stupidest.org>
	 <20090501140108.GA20846@kroah.com>
	 <9b2b86520905010843p63daf856pd537adcb439cbaed@mail.gmail.com>
	 <20090501160444.GA17325@kroah.com>
Date: Fri, 1 May 2009 22:13:42 +0100
Message-ID: <9b2b86520905011413y21195335mbaaf08feb49f6bee@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: Chris Wedgwood <cw@f00f.org>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Greg KH <greg@kroah.com> wrote:
> On Fri, May 01, 2009 at 04:43:49PM +0100, Alan Jenkins wrote:
>> On 5/1/09, Greg KH <greg@kroah.com> wrote:
>> > On Thu, Apr 30, 2009 at 11:57:54PM -0700, Chris Wedgwood wrote:
>> >> On Thu, Apr 30, 2009 at 03:23:42PM +0200, Kay Sievers wrote:
>> >>
>> >> > Devtmpfs lets the kernel create a tmpfs very early at kernel
>> >> > initialization, before any driver core device is registered. Every
>> >> > device with a major/minor will have a device node created in this
>> >> > tmpfs instance. After the rootfs is mounted by the kernel, the
>> >> > populated tmpfs is mounted at /dev. In initramfs, it can be moved to
>> >> > the manually mounted root filesystem before /sbin/init is executed.
>> >>
>> >> Why can't the initramfs create /dev and populate it?
>> >
>> > Right now it does, and it takes about 1-2 seconds to do so depending on
>> > the hardware.
>> >
>> > Which is over double the time it takes to boot the kernel entirely these
>> > days, so it is quite noticable.
>>
>> Please, this argument is pants.
>
> Is that short pants?  Jeans?  Khakis?  What color? :)

Damned international communication :-).

   Adjective
    pants (comparative more pants, superlative most pants)

    (British, slang) Of inferior quality, rubbish
    Your mobile is pants — why don’t you get one like mine?

And - apologies, for raising my voice for something which doesn't deserve it.

>> The initramfs _could_  create /dev and populate it.
>
> How?  With a bash script like Android does?  Do you want to maintain two
> different code streams for this kind of thing?

I hypothesized a small, "obviously correct", C program.  It would make
sense to maintain it as part of udev.  Seeing as most initramfs' will
still use udev, and just ask it to do less.

>> Neither crawling /sys or creating device nodes is horribly expensive.
>
> No, but it is measurable.
>
>> It's udev that adds overhead which is not needed at this point.
>> If the initramfs was optimised to do the same as devtmpfs, it needn't
>> take more than 50ms on my eeepc.
>
> It would take longer than 50ms.

> But first, time it with an initramfs with the load time of your script
> and the rest of the stuff you need to do there to get it running.  And
> also drop your caches before doing such a test as well to make it
> "real".

I was trying to measure the system calls required.  I'm all too aware
of the overhead of fork() even without exec(), so I wouldn't write it
in shell.  And I was comparing initramfs w/"makedev.c" to initramfs
w/devtmpfs.

>> If this deserves to live in the kernel, let's not pretend that it is
>> because it works dramatically faster.
>
> But it does.
>
> And it's also a solution for the embedded people, and the rescue disk
> users, and the others of us that have to drop down to init=/bin/bash at
> times.
>
> If you don't like it,

I said upthread that I would love it for all of those reasons.
Seriously, I've done all three in the past, this sounds pretty
attractive.

I'm trying to gain an honest understanding of the idea, and what it
will mean, in part by comparing it to the alternatives.  I am very
confused when you answer "why put this in the kernel" with "it's too
slow at the moment", because there is no _direct_ connection between
the two.

I think what your answer missed is that you're making the process much
_simpler_, which explains both why it can be faster, and why it should
be considered as a legitimate role for the kernel.

<deleted comprehensive notes which explain the nature of the
simplification among other things, but probably aren't worth restating
here>.

The problem is that the simplification is the important part of the
change, it has tradeoffs, and glossing over tradeoffs can come over
all suspicious.  But I'm happy  that Kay's taken the time to answer
all the questions I had now.

> don't build it into your kernel, it's only 300
> lines of code to keep away from your machine.

I refuse to rise to that :).  I think on the contrary, it will become
difficult to disable when future initramfs' rely on it.  But I won't
want to at that point.

Thanks
Alan
