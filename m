Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbXKTXa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbXKTXa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXKTXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:30:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:45580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753030AbXKTXaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:30:12 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/2SAUQlKr2xMBO1lO4ZRsYbec4kwu35W/VkRsGRb
	/fHNU52sO9v0m/
From: Helge Deller <deller@gmx.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Date: Wed, 21 Nov 2007 00:30:05 +0100
User-Agent: KMail/1.9.7
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200711182038.22055.deller@gmx.de> <200711202259.58745.deller@gmx.de> <20071120230012.GF26022@thunk.org>
In-Reply-To: <20071120230012.GF26022@thunk.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210030.05961.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007, Theodore Tso wrote:
> On Tue, Nov 20, 2007 at 10:59:58PM +0100, Helge Deller wrote:
> > > Even with a futex? Or userspace atomics? 
> > 
> > Yes, you'll need a futex or similiar.
> >
> > The problem is then more, where will you put that futex to be able
> > to protect against other processes ?
> > 
> > Best solution is probably shared memory, but then the question will
> > be, who is allowed to access this memory/futex ?
> >
> > Will any process (shared library) be allowed to read/write/delete it?
> >
> > At this stage you then suddenly run from a locking-problem into a
> > security problem, which is probably equally hard to solve.
> 
> Basically, the only way to solve this problem 100% in userspace would
> be with a userspace daemon running as a privileged user, and some kind
> of Unix domain socket.

Yes, probably.
 
> Patches to implement this in the e2fsprogs UUID library would be
> greatfully accepted.
> 
> > Sounds simple and is probably fast enough.
> >
> > But do you really want to add then another daemon to the Linux
> > system, just in case "some" application needs somewhen a UUID ?
> > 
> > And I think such an implementation is more complex, would need more
> > memory, file handles, and so on than this simple kernel patch.
> 
> Well, it probably is less code, but keep in mind to really get things
> right, you need to store the UUID counter on disk, so there is some
> complexity which is needed in userspace anyway.

Yes, it's at least needed for the case when the wall clock is wrong.
If it's syncronized with NTP (or similiar), it's not really needed.

Anyway, if this patch is accepted, I'll be happy send patches against the 
various bootup scripts to save the last seq_number at shutdown and
restore it at bootup. Maybe something similiar as the /var/lib/random-seed
which is saved by /etc/init.d/halt in Fedora.
 
> One bigger question which is why do you want to use time-based UUID's?
> With the kernels random number generator, the random UUID's should be
> quite good enough for your purposes.

The big difference between random UUIDs and time-based UUIDs is that
time-based UUIDs can be used more efficiently as indexing keys in databases.
The true randomness of random UUIDs just break performance, while
with some further tricks you can get time-based UUIDs easily sorted.
At least we saw a big speed difference when we used time-based keys, as
they e.g. were used on Windows with MS SQL server. On Linux I personally 
would like to see a similiar speedup and for that really unique time-based
UUIDs are needed.

> > I think mkfs was a very bad example from my side. I should not have
> > mentioned this one.  Nevertheless, time-based UUIDs are used in
> > quite many other and more critical applications than e2fsprogs
> > tools.
> 
> Actually, these days e2fsprogs uses random-based UUID's.

Yes, but still libuuid from e2fsprogs does a good job for what's really 
needed and sufficient for the e2fsprogs tools like mkfs.
Sadly the time-based variant of libuuid still hase some way to go.
Initially I really wanted to send patches for libuuid to fix the 
time-based variant, but now I really think the kernel-solution is 
the better, smaller, cleaner and more reliable approach.

Helge
