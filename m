Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXCJGnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXCJGnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbXCJGnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:43:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:26240 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXCJGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FsYgHgHgrRZxpR5fmI1aTI3bvxXovr7EFiNEqy403+80i3vLfC3gD8B90Q1jEWE5DZ+txdR12thftqayXeAVViTyQiLZQwwBgF+6bGcctGCPD2xOVjGNhQL0vh4A4VDe/A3T1aRh56JtoQ1HcgWd1v4kyPX1NY4/MAD3wl5nNRI=
Message-ID: <f2b55d220703092243v226483ceve72cf654f61ee39f@mail.gmail.com>
Date: Fri, 9 Mar 2007 22:43:35 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070309145920.GJ6209@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	 <45F09F9C.4030801@cosmosbay.com>
	 <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
	 <45F0A71C.2000800@cosmosbay.com>
	 <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
	 <20070309013405.GI6209@kvack.org>
	 <f2b55d220703090419w755d42d0mea4f220e3caaa59a@mail.gmail.com>
	 <20070309145920.GJ6209@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize for throwing around words like "stupid".  Whether or not
the current semantics can be improved, that's not a constructive way
to characterize them.  I'm sorry.

As three people have ably pointed out :-), the particular case of a
pipe/FIFO isn't seekable and doesn't need the f_pos member anyway
(it's effectively always O_APPEND).  That's what I get for checking
against standards documents at 3AM.  Of course, this has nothing to do
with the point that led me to comment on pipes/FIFOs (which was that
there exist file types that never return 0<ret<nbytes).  And it was in
the context of a very explicit aside that f_pos is not _interesting_
on a pipe/FIFO, except as an indicator of total bytes written.  You
could only peek at this with an (admittedly non-portable) llseek(fd,
0, SEEK_CUR) anyway -- which you would only do for diagnostic
purposes.  But diagnosis of odd corner cases (rarely in my code,
usually in other people's) is what I do day in and day out, so for me
it would be worth having.

In any case, you're all right that the standard doesn't require you to
do anything useful with f_pos on a pipe/FIFO.  But you're permitted to
make it useful if you want to:

<1003.1 lseek()>
The behavior of lseek() on devices which are incapable of seeking is
implementation-defined. The value of the file offset associated with
such a device is undefined.
</1003.1>

Tracking f_pos accurately when writes from multiple threads hit the
same fd (pipe or not) isn't portable, but I recall situations where it
would have been useful.  And if f_pos has to be kept at all in the
uncontended case, it costs you little or nothing to do it in a
thread-safe manner -- as long as you don't overconstrain the semantics
such that you forbid the transient overshoot associated with a short
write.  In fact, unless there's something I've missed, increasing
f_pos before entering vfs_write() happens to be _faster_ than the
current code for common load patterns, both single- and multi-threaded
(although getting the full benefit in the multi-threaded case will
take some fiddling with f_count placement).

I say it costs "little or nothing" only because altering an loff_t
atomically is not free.  But even on x86, with its inability to
atomically modify any 64-bit entity in memory, an uncontended spinlock
on a cacheline already in L1 is so cheap that making the f_pos changes
atomic will (I think) be lost in the noise.

In any case, rewriting read_write.c is proving interesting.  I'll let
you all know if anything comes of it.  In the meantime, thanks for
your (really quite friendly under the circumstances) comments.

Cheers,
- Michael
