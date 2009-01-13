Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZAMIGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZAMIGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZAMIGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:06:41 -0500
Received: from yop.chewa.net ([91.121.105.214]:49920 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZAMIGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:06:41 -0500
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: RFC: Network privilege separation.
MIME-Version: 1.0
Date: Tue, 13 Jan 2009 09:06:39 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org
Organization: Remlab.net
In-Reply-To: <20090112215001.GG23848@one.firstfloor.org>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901122230.25976.rdenis@simphalempin.com> <20090112205547.GE23848@one.firstfloor.org> <200901122247.22059.rdenis@simphalempin.com> <20090112215001.GG23848@one.firstfloor.org>
Message-ID: <e81d9c0cbc85262051b2246783bb193b@chewa.net>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


   Hello,

On Mon, 12 Jan 2009 22:50:01 +0100, Andi Kleen <andi@firstfloor.org> wrote:
>> Fair enough. It's just way too much interface/adaptation work compared
>> to the benefit. Especially considering that it would be much easier, and
>> almost as secure, with a "relaxed" SECCOMP.
> 
> What system calls would you want in a relaxed SECCOMP?

I already listed them on a high level. At the very very least, brk(),
sbrk(), mmap(), mremap(), getpagesize() and munmap() so that we can re-use
the libc memory allocator. If one wants to limit memory usage, there is
always setrlimit() before enabling SECCOMP.

Also readv() and writev() could not hurt; I suppose neither could
vmsplice().

I don't know what are the security implications of inter-process futex(). I
assume it's possible to freeze, and perhaps busy loop other task that would
use the same futexes. That is OK to me. But it's not clear to me if
something really bad, like arbitrary memory access could be achieved.
Notably, with futex() allowable, we can also grant clone(), gettid() and
then we can run parallelized codecs on SMP.

>> And on top of that, it's causing
>> unnecessary overhead (we're also interested in those small Linux-based
> 
> Would be interesting to try that out -- just adding two memcpyies to
> the existing code and see how much slower it gets. My guess
> would be not very, even e.g. on a Atom system (which are really
> not all that slow).
> 
> Presumably you could always #ifdef it if it's really a problem
> on some specific system. That would be needed anyways for
> non linux systems.

In practice, I suspect the most work would come from reworking the build
system such that codecs are executable rather than libraries. I suspect a
plain fork() with _no_ exec() would leave to many unused anonymous pages
from the main media player process, not to mention information leakage.

I'd like to point out that, from my personnal experience, we've had more
problem this far with file format parsers than codecs. I don't know why. It
might be because they are easier for pirates to talk to, as they're one
step closer to the data than codecs. Or it is that the VideoLAN project is
writing overall more buggy code than, say, FFMPEG :-( ?

To sandbox parsers, we might need a whole lot more stuff, especially timers
and events handling stuff.

-- 
Rémi Denis-Courmont

