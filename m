Return-Path: <linux-kernel-owner+w=401wt.eu-S936593AbZDIUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593AbZDIUoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763072AbZDIUoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:44:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762151AbZDIUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:43:59 -0400
Date: Thu, 9 Apr 2009 13:42:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hua Zhong <hzhong@gmail.com>
cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: page corruption bug in recent kernel (2.6.29)?
In-Reply-To: <013601c9b94f$3e73c820$bb5b5860$@com>
Message-ID: <alpine.LFD.2.00.0904091326480.4583@localhost.localdomain>
References: <013601c9b94f$3e73c820$bb5b5860$@com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Hua Zhong wrote:
> 
> I have a test that runs a home-grown user-space nfs server, as part of which
> there are checksum computations to verify data integrity. With the recent
> kernel the test fails almost every time as the input buffer and its copy
> differ in the end:
> 
>  0100040 534d 7b80 a080 e2dc 2003 7c7c 2382 6601
>  0100060 ff89 6401 f68c b383 4303 5f5f 1440 080b
>  0100100 5553 504e 4f52 435f 1640 050b 7063 756c
> -0100120 9073 9004 0217 5f5f 2280 5406 544f 5059
> -0100140 9045 c05f c051 0770 6128 6772 2973 9020
> +0100120 9073 9004 0217 5f5f 0000 0000 0000 0000
> +0100140 0000 0000 0000 0000 6128 6772 2973 9020
>  0100160 8006 c17b 4022 1223 2801 0270 8001 02c2
>  0100200 6669 1741 bf08 81fa 0261 7265 4f85 5f05
>  0100220 7566 636e eb98 4b80 9981 b780 5c81 7684
> 
> Exactly 16-bytes are different.
> 
> I originally suspected a bug in my own code (which is very complicated), but
> the same thing doesn't seem to happen with FC4's stock 2.6.17, so I am also
> suspecting a page corruption bug, so I'm posting to see if anyone
> encountered anything similar, or if there are any quick suggestions. In the
> mean time I'll see if I can narrow it down a little more.

So this looks unlikely to be a kernel bug, because kernel bugs _usually_ 
end up being aligned by fundamental kernel constants like PAGE_SIZE 
etc. Yours does not seem to match that kind of common kernel pattern.

On the other hand, since you're doing an NFS server, you're using either 
UDP or TCP, and now there are packet boundaries, and those have other 
alignment (eg 1460-byte payloads etc). So getting 16 bytes of zero in the 
middle of a page isn't all that unlikely. And wild pointers can point 
anywhere, of course.

So you also certainly cannot rule out kernel bugs. It sounds rather 
unlikely, but the kernel can certainly screw up anything.

That said, it's almost impossible to make any good judgement based on the 
data you give. It's certainly possible that it's a kernel bug - but it's 
equally possible that your kernel version dependency comes from simply 
some timing dependency, or all the updates that mean that we have less 
serialization in the kernel these days, which can open up new race windows 
in user space - that were just much harder to hit before.

We also don't know what you actually _do_ with that particular data to 
possibly trigger problems. For example, if the corruption is in a file, 
then heavy mmap usage (shared writable mmaps?) tends to have very 
different bugs than using plain read-write system calls would have. What 
filesystem you use would also matter.

As you say that you can trigger this fairly easily, one thing that you 
could try is to bisect it down the which kernel release it starts 
happening with. And even if it's not a kernel bug, doint that may give 
hints about perhaps what kind of things trigger the behavior, and might 
help you figure out where the bug is even if it's somewhere else.

			Linus
