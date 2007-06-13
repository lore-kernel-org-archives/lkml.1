Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXFMSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXFMSO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 14:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbXFMSOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 14:14:53 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:45005 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbXFMSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 14:14:52 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
In-Reply-To: <17542.1181753455@turing-police.cc.vt.edu>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <17542.1181753455@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: IBM
Date: Wed, 13 Jun 2007 20:11:17 +0200
Message-Id: <1181758277.26375.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

On Wed, 2007-06-13 at 12:50 -0400, Valdis.Kletnieks@vt.edu wrote: 
> On Wed, 13 Jun 2007 17:06:57 +0200, holzheu said:
> > They are used to that, because all other operating systems on that
> > platform like z/OS, z/VM or z/VSE have message catalogs with detailed
> > descriptions about the semantics of the messages.
> 
> 25 years ago, I did OS/MVT and OS/VS1 for a living, so I know *all* about
> the infamous "What does IEF507E mean again?"...

:-)

> > In general we think, that also for Linux it is a good thing to have
> > documentation for the most important kernel/driver messages. Even
> > kernel hackers not always are aware of the meaning of kernel messages
> > for components, which they don't know in detail. Most of the messages
> > are self explaining but sometimes you get something like "Clocksource
> > tsc unstable (delta = 7304132729 ns)" and you wonder if your system is
> > going to explode.
> 
> This is probably best addressed by cleaning up the actual messages so they're
> a bit more informative.

Of course that would be good, too.

But I think, that we sometimes have the dilemma, that we want to keep
the printks short, but also want to provide as much information as
possible.

If the information is to big for the printk itself, because you would
need 10 lines to explain what happened, wouldn't it be good to have a
place where to put that information?

> > New macros KMSG_ERR(), KMSG_WARN(), etc. are defined, which have to be
> > used in printk. These macros have as parameter the message number and
> > are using a per c-file defined macro KMSG_COMPONENT.
> 
> Gaak. *NO*.
> 
> The *only* reason that the MVS and VM message catalogs worked at all is
> because each component had a message repository that went across *all* the
> source files - the instant you saw IEFnnns, you knew that IEF covered the
> job scheduler, nnn was a *unique* number, and s was a Severe/Warning/Info
> flag.  IGG was always data management, and so on.  This breaks horribly if
> you have 2 C files that define subtly different KMSG_COMPONENT values (or
> even worse, 2 or more duplicates).
> 
> [/usr/src/linux-2.6.22-rc4-mm2] find . -name '*.c' | wc -l
> 9959
> [/usr/src/linux-2.6.22-rc4-mm2] find . -name '*.h' | wc -l
> 9933
> [/usr/src/linux-2.6.22-rc4-mm2] find . -type d | wc -l
> 1736
> 
> You plan to maintain message uniqueness how?
> [/usr/src/linux-2.6.22-rc4-mm2]1 find . -name '*.c' | sed -r 's?.*/([^/]*)?\1?' | sort | uniq -c | sort -nr | head
>     105 setup.c
>      90 irq.c
>      66 time.c
>      58 init.c
>      50 inode.c
>      39 io.c
>      38 pci.c
>      37 file.c
>      32 signal.c
>      32 ptrace.c
> 
> Looks like you're going to have to embed a lot of the path in that KMSG_COMPONENT
> to make it unique - and you want to keep that message under 80 or so chars total.
> 

For each kernel component, like a device driver, we could have one
KMSG_COMPONENT (e.g. "acpi", "pci", etc). Within that component the
message ids have to be unique. A tool could check, if messages are
unique within the kernel sources.

We could use something like a Documentation/kmsg-components file with a
list of all component names using KMSG printks.

> > /**
> >  * message
> >  * @0: device number of device.
> >  *
> >  * Description:
> >  * An operation has been performed on the msgtest device, but the
> >  * device has not been set online. Therefore the operation failed
> 
> If you don't understand 'Device /dev/foo offline', this description
> doesn't help any.  And that's true for *most* of the kernel messages
> already - if you don't understand the message already, a paragraph
> explanation isn't going to help much.  Consider the average OOPS
> message, which contains stuff like 'EIP=0x..'.  Telling the user that
> EIP means Execution Instruction Pointer isn't likely to help - if they
> knew what the pointer *did*, they'd probably already know EIP.

I agree with you, that most of the kernel messages do not need further
documentation. But I am convinced, that there are plenty of printks,
where additional documentation would be helpful.

> >  *
> >  * User Response:
> >  * Operator should set device online.
> >  * Issue "chccwdev -e <device number>".
> 
> And this is where the weakness of this scheme *really* hits.  I've actually run
> into cases where an operator followed the listed "Operator Response" for a
> "device offline", and issued a 'VARY 0C0,ONLINE'.  And then we got a flood of
> I/O errors because the previous shift downed the device because it was having
> issues.  The response the operator *should* have done is "assign a different
> tape drive, like, oh maybe the operational ones at 0C1 through 0C4"...

I can understand your frustration here. But that's a general problem
with documentation. You never can foresee everything.

But should this mean, that we shouldn't document anything?

Michael

