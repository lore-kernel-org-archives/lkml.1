Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZBBHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZBBHKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 02:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBBHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 02:10:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:4639 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZBBHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 02:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C7+037+QJRCUggoK5Yqf94qqe3h9o8l0boLuzJcEQl+53actb+XlkVGf9uX2Suvx6/
         S5OgRg8/ELs29byoUr8CP2yHwravqDoZ/IQDUm6XixdAYQhBuCalwJ0eFOxLSIP2BP2B
         MWQ9NNrFobpj0+MKb7MHOYXiqID9SQlHrv2IM=
MIME-Version: 1.0
In-Reply-To: <20090202064509.GA20237@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
Date: Sun, 1 Feb 2009 23:10:21 -0800
Message-ID: <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 1, 2009 at 10:45 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Kaz Kylheku wrote:
>>
>> Basically, if you call pthread_exit from the main thread of a process, and keep
>> other threads running, the behavior is ugly.
>
> Yes, known problem.
>
> Please look at
>
>        [RFC,PATCH 3/3] do_wait: fix waiting for stopped group with dead leader
>        http://marc.info/?t=119713920000003
>
> I'll try to re-do and re-send this patch this week.

I believe that my straight-forward fix is pretty much good to go. I
checked into my distro, so we will see how it holds up.

It's a bad idea to allow the main thread to terminate. It should stick
around because it serves as a facade for the process as a whole. If
the main thread is allowed to bail all the way through do_exit, who
knows what kind of problems may show up because of that.

What if one of my developers is working on a server which has called
pthread_exit in the main thread, and wants to attach gdb to it? Will
that work if the main thread (a.k.a group leader) is a defunct
process?

I just tried this test case and it worked perfectly with my patch! gdb
attached to the process by the pid of teh group leader. It correctly
showed as that thread being stopped in __exit_thread. I can see the
other threads, etc.

bash:~# /projects/sw/kaz/bug-repro-programs/pthread-exit &
[1] 2093
bash:~# gdb -p 2093
GNU gdb 6.8
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "mips64-linux".
Attaching to process 2093
Reading symbols from /projects/sw/kaz/bug-repro-programs/pthread-exit...done.
Reading symbols from /lib32/libpthread.so.0...done.
[Thread debugging using libthread_db enabled]
[New Thread 0x2d46c4b0 (LWP 2098)]
[New Thread 0x2cc6c4b0 (LWP 2097)]
[New Thread 0x2c46c4b0 (LWP 2096)]
[New Thread 0x2bc6c4b0 (LWP 2095)]
[New Thread 0x2b46c4b0 (LWP 2094)]
Loaded symbols for /lib32/libpthread.so.0
Reading symbols from /lib32/libc.so.6...done.
Loaded symbols for /lib32/libc.so.6
Reading symbols from /lib32/ld.so.1...done.
Loaded symbols for /lib32/ld.so.1
Reading symbols from /lib32/libgcc_s.so.1...done.
Loaded symbols for /lib32/libgcc_s.so.1
0x2abd3da4 in __exit_thread () from /lib32/libc.so.6
(gdb) where
#0  0x2abd3da4 in __exit_thread () from /lib32/libc.so.6
#1  0x2ab18ab0 in __libc_start_main (main=0x10000710 <main>, argc=1,
    ubp_av=0x7fcd7524, init=<value optimized out>, fini=<value optimized out>,
    rtld_fini=<value optimized out>, stack_end=<value optimized out>)
    at libc-start.c:245
#2  0x100005dc in _ftext ()

If I try this on an unpatched kernel that allows a main thread to bail
through do_exit, this is what happens:

Attaching to process 14651
ptrace: No such process.
/root/14651: No such file or directory.

I don't think that this is solved by any patch that allows the group
leader to bail through do_exit. It's not just a problem of waiting on
a dead group leader. If you want to maintain the illusion that the OS
provides a process that contains threads, and the group leader is the
representation of that process, then you have to keep that leader
alive; the lifetime of that leader cannot be shorter than that of the
process illusion.

Patch:

http://sourceware.org/bugzilla/attachment.cgi?id=3702
