Return-Path: <linux-kernel-owner+w=401wt.eu-S1761599AbYDTMb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761599AbYDTMb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbYDTMbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:31:49 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:47142 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbYDTMbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:31:48 -0400
Date: Sun, 20 Apr 2008 15:31:46 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Joe Perches <joe@perches.com>, Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Alternative implementation of the generic __ffs
Message-ID: <20080420123146.GN3700@mea-ext.zmailer.org>
References: <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org> <1208563762.10414.19.camel@brick> <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org> <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick> <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org> <1208573728.11990.14.camel@localhost> <20080419222911.GJ3700@mea-ext.zmailer.org> <1208660817.12388.40.camel@localhost> <1208680941.5276.1248837773@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208680941.5276.1248837773@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 10:42:21AM +0200, Alexander van Heukelum wrote:
> On Sat, 19 Apr 2008 20:06:57 -0700, "Joe Perches" <joe@perches.com>
> said:
> > On Sun, 2008-04-20 at 01:29 +0300, Matti Aarnio wrote:
> > > I am curious, why not take the code already in glibc ffs() for ARM ?
> > > That is, if the ffs() is all that important detail in kernel ?
> 
> Hi,
> 
> The glibc version is based on a table-lookup. This makes it
> behave differently in hot and cold cache situations. That's
> fine if __ffs is used in tight loops, but in the kernel such
> use of __ffs is avoided because it might be slow. I added it
> to the benchmark, but it would need testing for the cold
> cache case too.
> 
> As for the importance of __ffs in the kernel: as far as I
> know the hot-spots in the kernel using __ffs are the
> schedular (sched_find_first_bit) and the cpu mask walking
> code (for_each_cpu_mask).

Perhaps those hot-spots would benefit from more broadly
accelerable algorithms.   ARM architecture v5 introduced
a CLZ instruction -- Count Leading Zeroes.

Well, gcc's  __builtin_ffs() for ARM Arch5 and up (including
XScale) does things in a bit more interesting way:

  http://mail-index.netbsd.org/port-arm/2002/08/20/0001.html

$ cat try.c
int foo(int i)
{
        return __builtin_ffs(i);
}
$ arm-gp2x-linux-gcc -S -O -march=armv5 try.c 
$ more try.s 
        .file   "try.c"
        .text
        .align  2
        .global foo
        .type   foo, %function
foo:
        @ args = 0, pretend = 0, frame = 0
        @ frame_needed = 0, uses_anonymous_args = 0
        @ link register save eliminated.
        @ lr needed for prologue
        rsb     r3, r0, #0
        and     r3, r3, r0
        clz     r3, r3
        rsb     r0, r3, #32
        bx      lr
        .size   foo, .-foo
        .ident  "GCC: (GNU) 4.1.2 (Fedora GP2X 4.1.2-8.fc9)"


> Greetings,
>     Alexander

/Matti Aarnio
