Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbXHGA3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbXHGA3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933427AbXHGA3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:29:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58962 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933144AbXHGA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:29:41 -0400
Date: Tue, 7 Aug 2007 01:37:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: =?UTF-8?B?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
Message-ID: <20070807013708.406a22fd@the-village.bc.nu>
In-Reply-To: <46B7BF67.8010506@gmx.net>
References: <200708031903.10063.jimis@gmx.net>
	<200708051903.12414.jimis@gmx.net>
	<46B60FB7.8030301@interia.pl>
	<200708052142.14630.jimis@gmx.net>
	<46B748DE.1060108@interia.pl>
	<46B773F6.7060603@gmx.net>
	<20070806204853.6a693c4b@the-village.bc.nu>
	<46B7BF67.8010506@gmx.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > acpi_pm_read is capable of disappearing into  SMM traps which will make
> > it look very slow.
> 
> what is an SMM trap? I googled a bit but didn't get it...

One of the less documented bits of the PC architecture. It is possible to
arrange that the CPU jumps into a special mode when triggered by some
specific external event. Originally this was used for stuff like APM and
power management but some laptops use it for stuff like faking the
keyboard interface and the Geode uses it for tons of stuff.

As SMM mode is basically invisible to the OS what oprofile and friends
see isn't what really occurs. So you see

	pci write -> some address

you don't then see

	SMM
	CPU saves processor state
	Lots of code runs (eg i2c polling the battery)
	code executes RSM

	Back to the OS

and the next visible profile point. This can make an I/O operation look
really slow even if it isn't the I/O which is slow.

> the reason I'm talking about a "software driver limit" is because I am 
> sure about some facts:
> - The disks can reach very high speeds (60 MB/s on other systems with udma5)

Is UDMA5 being selected firstly ?

> So what is left? Probably only the corresponding kernel module.

Unlikely to be the disk driver as that really hasn't changed tuning for a
very long time. I/O scheduler interactions are however very possible.
