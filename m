Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbXFMQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbXFMQvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759091AbXFMQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:51:16 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49385 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799AbXFMQvO (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:51:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: holzheu@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       gregkh@suse.de, mtk-manpages@gmx.net, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
In-Reply-To: Your message of "Wed, 13 Jun 2007 17:06:57 +0200."
             <1181747217.29512.9.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1181747217.29512.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1181753455_3457P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jun 2007 12:50:55 -0400
Message-ID: <17542.1181753455@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1181753455_3457P
Content-Type: text/plain; charset=us-ascii

On Wed, 13 Jun 2007 17:06:57 +0200, holzheu said:
> They are used to that, because all other operating systems on that
> platform like z/OS, z/VM or z/VSE have message catalogs with detailed
> descriptions about the semantics of the messages.

25 years ago, I did OS/MVT and OS/VS1 for a living, so I know *all* about
the infamous "What does IEF507E mean again?"...

> In general we think, that also for Linux it is a good thing to have
> documentation for the most important kernel/driver messages. Even
> kernel hackers not always are aware of the meaning of kernel messages
> for components, which they don't know in detail. Most of the messages
> are self explaining but sometimes you get something like "Clocksource
> tsc unstable (delta = 7304132729 ns)" and you wonder if your system is
> going to explode.

This is probably best addressed by cleaning up the actual messages so they're
a bit more informative.

> New macros KMSG_ERR(), KMSG_WARN(), etc. are defined, which have to be
> used in printk. These macros have as parameter the message number and
> are using a per c-file defined macro KMSG_COMPONENT.

Gaak. *NO*.

The *only* reason that the MVS and VM message catalogs worked at all is
because each component had a message repository that went across *all* the
source files - the instant you saw IEFnnns, you knew that IEF covered the
job scheduler, nnn was a *unique* number, and s was a Severe/Warning/Info
flag.  IGG was always data management, and so on.  This breaks horribly if
you have 2 C files that define subtly different KMSG_COMPONENT values (or
even worse, 2 or more duplicates).

[/usr/src/linux-2.6.22-rc4-mm2] find . -name '*.c' | wc -l
9959
[/usr/src/linux-2.6.22-rc4-mm2] find . -name '*.h' | wc -l
9933
[/usr/src/linux-2.6.22-rc4-mm2] find . -type d | wc -l
1736

You plan to maintain message uniqueness how?

[/usr/src/linux-2.6.22-rc4-mm2]1 find . -name '*.c' | sed -r 's?.*/([^/]*)?\1?' | sort | uniq -c | sort -nr | head
    105 setup.c
     90 irq.c
     66 time.c
     58 init.c
     50 inode.c
     39 io.c
     38 pci.c
     37 file.c
     32 signal.c
     32 ptrace.c

Looks like you're going to have to embed a lot of the path in that KMSG_COMPONENT
to make it unique - and you want to keep that message under 80 or so chars total.

> /**
>  * message
>  * @0: device number of device.
>  *
>  * Description:
>  * An operation has been performed on the msgtest device, but the
>  * device has not been set online. Therefore the operation failed

If you don't understand 'Device /dev/foo offline', this description
doesn't help any.  And that's true for *most* of the kernel messages
already - if you don't understand the message already, a paragraph
explanation isn't going to help much.  Consider the average OOPS
message, which contains stuff like 'EIP=0x..'.  Telling the user that
EIP means Execution Instruction Pointer isn't likely to help - if they
knew what the pointer *did*, they'd probably already know EIP.

>  *
>  * User Response:
>  * Operator should set device online.
>  * Issue "chccwdev -e <device number>".

And this is where the weakness of this scheme *really* hits.  I've actually run
into cases where an operator followed the listed "Operator Response" for a
"device offline", and issued a 'VARY 0C0,ONLINE'.  And then we got a flood of
I/O errors because the previous shift downed the device because it was having
issues.  The response the operator *should* have done is "assign a different
tape drive, like, oh maybe the operational ones at 0C1 through 0C4"...

And it's the same here - if you get a message that /dev/sdb1 has no media
present, there's a good chance that you typo'ed, and meant /dev/sda1 or /dev/sdc1
So following the directions for 'sdb1 offline' and putting in a blank DVD
because sdb is the DVD burner won't fix things if what you were trying to do is
mkfs something on another disk... ;)

And while we're at it, I'll point out that any attempt to "fix" the kernel
messages on this scale had *better* solve all the I18N problems while we're
there....




--==_Exmh_1181753455_3457P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGcCBvcC3lWbTT17ARAsaQAJ0ZMqzxE27+Di4NoDruGItKVyyJbwCfdm96
EUETtLPIqWIiSpBGq7q2URw=
=f8uU
-----END PGP SIGNATURE-----

--==_Exmh_1181753455_3457P--
