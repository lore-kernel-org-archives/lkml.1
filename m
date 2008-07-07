Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYGGOm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYGGOm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYGGOmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:42:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbYGGOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:42:14 -0400
Date: Mon, 7 Jul 2008 16:42:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jinkai Gao <mickeygjk@gmail.com>
cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Suggestion: LKM should be able to add system call for itself
In-Reply-To: <fb82a8210807070536o3e6a1ed8ld05505b0d80112f3@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807071616280.8248@fbirervta.pbzchgretzou.qr>
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>  <e2e108260807070140l3f8eaf06w7ee7e8a4ae42f2c2@mail.gmail.com> <fb82a8210807070536o3e6a1ed8ld05505b0d80112f3@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-07 14:36, Jinkai Gao wrote:
>
>Yes, all kinds of alternatives exist. But they are alternatives
>anyway, which are tricky ways to do things when you can't find a
>reasonable ways. Actually,to communication between userspace and
>kernel modules, all I need is a interface with two parameters, all the
>system calls can be implemented out of that. So basically you can
>write every system call using something like ioctl. But ioctl is not
>designed for generic purpose after all.

Two parameters? (I take it, syscall number and a pointer to data.)
ioctl can do the same. It takes a number and an unsigned long
(sufficent for a pointer) to data. I could do the same over a cdev, a
32-bit quantity serving as a number and a 64-bit quantity as a
pointer. The same holds for netlink. There are endless ways to pass
on bits into the kernel, and be it an ICMP packet. Once you have the
addresses, you can use copy_from_user(), and be done. That still
does not say why syscalls are better than ioctl or netlink.

Well, nl and cdevs become especially handy when passing on more data
than just a pointer... usually you can do away with the pointer
indirection, e.g.

	struct timespec n;
	syscall(123, &n);
vs	ioctl(somefd, 123, &n);
vs	write(cdevfd, &n, sizeof(n));
vs	nlmsg_write(it's not so easy in NL after all);

hooray. Win = 0.

>Why the number of system calls is growing?

It is not. The reiser4() system call was just as heavily debated
because it just did not seem to fit. 

>because the kernel is
>growing. why we don't use the alternatives to implement the new need
>for system calls? Because it doesn't make any sense.

It does not make any sense to discuss here. Each task to achieve has
a specific preferred method (syscalls, cdev, libnl, ioctl) to do it
over.


Maybe syscalls have been ok 20+ years ago. Maybe people still don't 
know cdevs or netlink because they are submerged in teaching DOS 
semantics only.
If syscalls were so übergreat, then /dev would be a lot less populated:
Where's my nvidiactl() syscall?
