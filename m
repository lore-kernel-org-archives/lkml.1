Return-Path: <linux-kernel-owner+w=401wt.eu-S966864AbXFHHJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966864AbXFHHJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764164AbXFHHJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:09:29 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:56694 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763664AbXFHHJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:09:28 -0400
Message-ID: <4669009E.3000702@cosmosbay.com>
Date: Fri, 08 Jun 2007 09:09:18 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Albert Cahalan <acahalan@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: JIT emulator needs
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
In-Reply-To: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 08 Jun 2007 09:09:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan a écrit :
> Right now, Linux isn't all that friendly to JIT emulators.
> Here are the problems and suggestions to improve the situation.
> 
> There is an SE Linux execmem restriction that enforces W^X.
> Assuming you don't wish to just disable SE Linux, there are
> two ugly ways around the problem. You can mmap a file twice,
> or you can abuse SysV shared memory. The mmap method requires
> that you know of a filesystem mounted rw,exec where you can
> write a very large temporary file. This arbitrary filesystem,
> rather than swap space, will be the backing store. The SysV
> shared memory method requires an undocumented flag and is
> subject to some annoying size limits. Both methods create
> objects that will fail to be deleted if the program dies
> before marking the objects for deletion.
> 
> Processors often have annoying limits on the immediate values
> in instructions. An x86 or x86_64 JIT can go a bit faster if
> all allocations are kept to the low 2 GB of address space.
> There are also reasons for a 32bit-to-x86_64 JIT to chose
> a nearly arbitrary 2 GB region that lies above 4 GB.
> Other archs have other limits, such as 32 MB or 256 MB.
> 
> Sometimes it is very helpful to have the read/write mapping
> be a fixed offset from the read/exec mapping. A power of 2
> can be especially desirable.
> 
> Emulators often need a cheap way to change page permissions.
> One VMA per page is no good. Besides taking up space and making
> many things generally slower, having one VMA per page causes
> a huge performance loss for snapshot roll-back operations.
> Just tearing down all those VMAs takes a good while.
> 
> Additions to better support JIT emulators:
> 
> a. sysctl to set IPC_RMID by default

Not very good, this will break some apps.

> b. shmget() flag to set IPC_RMID by default

This is better :)

> c. open() flag to unlink a file before returning the fd


Well, I assume you would like fd = open("/path/somefile", O_RDWR | O_CREAT | 
O_UNLINK, 0644)

(ie allocate a file handle but no name ?)

Quite difficult to implement this atomically with current vfs, maybe a new 
syscall would be better. (Linus will kill me for that :) )

(We dont need to insert "somefile" in one directory, then unlink it, we only 
need to allocate an unnamed inode to get some backing store)

This is a generalization of anonymous inodes ( fs/anon_inodes.c  )


