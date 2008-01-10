Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbYAJXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbYAJXGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbYAJXF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:05:59 -0500
Received: from neon.samage.net ([85.17.153.66]:49310 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759701AbYAJXF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:05:57 -0500
Message-ID: <36843.81.207.0.53.1200006346.squirrel@secure.samage.net>
In-Reply-To: <200801100457.m0A4vcoi024209@www262.sakura.ne.jp>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
    <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
    <20080106062609.GC20753@1wt.eu>
    <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
    <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
    <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
    <45796.81.207.0.53.1199807221.squirrel@secure.samage.net>
    <200801090439.m094d267092095@www262.sakura.ne.jp>
    <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
    <200801100457.m0A4vcoi024209@www262.sakura.ne.jp>
Date: Fri, 11 Jan 2008 00:05:46 +0100 (CET)
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: "Indan Zupancic" <indan@nul.nu>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: ee739817b6cd2655ac6326818c89325b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, January 10, 2008 05:57, Tetsuo Handa wrote:
> It seems to me that the alternatives you are proposing include
> modification of userland applications. But my assumption is
> that "Don't require modification of userland applications".

If you want a secure system it isn't that unreasonable to expect
applications to not do brain dead things, so not requiring any
modifications or config changes seems a bit optimistic to me.

> In other words, I want to implement without asking applications
> to use /dev/dynamic/ or something.
> This filesystem is intended to provide support for legacy applications.
> (In fact, this filesystem in TOMOYO Linux is for kernel 2.4.30/2.6.11 and
> later.)

Legacy applications should cope with a static /dev/.

What is the advantage of your filesystem compared to a static /dev/?

> Use of a tiny daemon that communicates with udev is not sufficient.
> The udev is not the only application that modifies /dev files.

Oh, it isn't? Which other applications do modify /dev files? I'd like to
hear about a few, no matter how obscure or proprietary. And please
tell how many of those will stop working with a static /dev with all
nodes they might create already existing.

> At least, the tiny daemon should communicate with the kernel
> so that all requests are checked by the tiny daemon.

No, why should the kernel be involved? The tiny daemon would be
the only one allowed to modify /dev/, so all mknod commands will
be done by it. Of course it means that you might need to modify
the two or three apps wanting to create device nodes, or you can
make an LD_PRELOAD lib that intercepts mknod commands and
sends them to the daemon.

The ammount of code will be the current parsing code + a few hundred
lines of code, including the preloaded library.

> But use of the tiny daemon (which is a process running in userland)
> causes a lot of troubles.

No, it doesn't, and most of those problems are true for all programs
that access /dev! If those are straced or whatever they can be forced
to open the wrong file, practically breaking the filename/attribute pairs.
So all security you think you need to have for the daemon process is
the same security you already need for all processes anyway to protect
them against each other.

>> If an administrator wants something else than
>> 3 or 5, you're breaking something.
> That's the fate of white-list based access control.
>
> Does this filesystem sound too strict to support dynamic device?
> May be this filesystem should be able to permit creation of device
> nodes that are not listed in the policy file.

Actually, I assumed that was the case, because if it's strictly white-list
based it's almost the same as a static /dev with some nodes hidden.
Without it has even less value, because it just complicates matters
compared to a normal static dev.

I thought it checked that if a device name was in the list, it has the
correct attributes, and was free to create nodes without restricted
names.

> From your next posting:
>> But I think doing more is getting ridiculous, because if a process can
>> create a device node, it can also access it and do whatever harm could
>> be done by the confusion caused by unexpected name/attribute pairs.
>
> FYI. Being able to create a device node is different from being able to access
> it and do whatever harm. You will need read and/or write permission to open
> that device.

Yes, but as the process creates the device it can also choose the file mode and
probably also ownership. And as it creates a new file there likely aren't strict
MAC rules in place restricting the process from reading or writing to it. So
yes, you're right, but in practise it isn't as easy to close that hole,
especially
not if the applications isn't very clean and single purpose. If it creates the
node
it probably wans to use it too, and that means read/write access. Even if it can
live without it, it could give access to the node to another process and let the
other process do the dirty work. Very tricky.

Greetings,

Indan


