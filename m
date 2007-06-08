Return-Path: <linux-kernel-owner+w=401wt.eu-S939068AbXFHLFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939068AbXFHLFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938246AbXFHLFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:05:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52356 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938240AbXFHLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:05:43 -0400
Date: Fri, 8 Jun 2007 12:10:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: JIT emulator needs
Message-ID: <20070608121059.4efcd338@the-village.bc.nu>
In-Reply-To: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is an SE Linux execmem restriction that enforces W^X.

This depends on whatever SELinux rulesets you are running. Its just a
good rule to have present that most programs shouldn't be self patching,
and then label those that do differently.

> Sometimes it is very helpful to have the read/write mapping
> be a fixed offset from the read/exec mapping. A power of 2
> can be especially desirable.

mmap MAP_FIXED can do this but you need to know a lot about the memory
layout of the system so it gets a bit platform specific.

> Emulators often need a cheap way to change page permissions.

mprotect(, range) rather than a page at a time. The kernel will do
merging. 

> a. sysctl to set IPC_RMID by default
> b. shmget() flag to set IPC_RMID by default

Use POSIX shared memory

> c. open() flag to unlink a file before returning the fd

Is it really that costly to create a blank file, why do you need to do it
a lot in a JIT ?

> e. mremap() flag to get a read/write mapping of a read/exec one
> f. mremap() flag to get a read/exec mapping of a read/write one
> g. mremap() flag to make the 5th arg (new addr) be the upper limit

This is all mprotect and munmap.

> h. 6-bit wide mremap() "flag" to set the upper limit above given base
> i. support the prot argument to remap_file_pages
> j. a documented way (madvise?) to punch same-VMA zero-page holes

mmap (although you get more VMAs from that) so memset() is probably
genuinely cheaper if the permissions are not changing.

