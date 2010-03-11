Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0CKHyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:54:06 -0500
Received: from tenax.loup.net ([209.169.16.66]:47858 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab0CKHyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:54:04 -0500
Date: Thu, 11 Mar 2010 00:41:21 -0700
Message-Id: <201003110741.o2B7fLTH011465@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: mvds.00@gmail.com
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       linux-man@vger.kernel.org
In-reply-to: <4B983E88.5080901@gmail.com> (message from M vd S on Thu, 11 Mar
	2010 01:51:20 +0100)
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com> <4B9060DE.4080104@gmail.com>	<4B96ECDD.1070006@gmail.com> <x494oko5n2o.fsf@segfault.boston.devel.redhat.com> <4B97D258.7060702@gmail.com> <201003102350.o2ANousd007794@alien.loup.net> <4B983E88.5080901@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi M,

 > >  > > What you missed is that the native aio system calls require O_DIRECT.
 > >  > >   
 > >  > 
 > >  > Thanks, that made it work. It seems without O_DIRECT it's just like 
 > >  > aio_* but without the separate thread. But I now get the "benefits" of 
 > >  > O_DIRECT for free...
 > >
 > > That is awesome news; I was worried.  I saw that about O_DIRECT in the
 > > doc but assumed you were doing it.
 > >
 > >   
 > Where did you see that? I reverted to the kernel source where indeed I 
 > saw __generic_file_aio_read() in mm/filemap.c check for O_DIRECT.
 >
 > io_submit(3), io_setup(3) etc don't mention O_DIRECT. Even the example 
 > in io(3) doesn't do O_DIRECT, so it must be broken. The example has no 
 > means to see if it is in fact a non blocking system call. But io(3) 
 > states "The  libaio  library defines a new set of I/O operations which 
 > can significantly reduce the time an application spends waiting at I/O.  
 > The new functions allow a program to initiate one or more I/O operations 
 > and then immediately resume normal work while the I/O operations are 
 > executed in parallel."

Not in the linux man pages, but a few folks around have web pages I
was able to google about actual behavior:

http://lse.sourceforge.net/io/aio.html

Like you, I trusted that the man pages actually described the behavior
in my software design until the "nonblocking" read and writev calls
choked off the nonblocking sockets :-)  Now I am writing extra test code
for all system calls I consider using; not sure if there is actual public
test code or not.

You are absolutely right, the blocking behavior of libaio without
specifying O_DIRECT should also definitely be in the man pages.  Why
isn't it an error to not specify O_DIRECT when that's the only way
libaio to block devs is actual async io?  It seems a bit odd to go to
the trouble to use libaio if synchronous behavior is expected?!

You might want to wait and see if my man patch even gets applied
before going to the trouble to make another one.  Alan Cox suggested I
post a patch to spell out the actual behavior of the blocking
"O_NONBLOCK" read and write class of calls.  I did that and a number
of us vetted the patch before I posted it to linux-man like a week
ago, but no feedback there from Michael Kerrisk or anyone else yet.
Maybe he's on holiday, or maybe someone else can also carry the man
page pumpkin, I don't know...

Either way I imagine lkml sees this over and over again and fixing the
man pages would go a long way toward cutting down on confusion.

- Mike
