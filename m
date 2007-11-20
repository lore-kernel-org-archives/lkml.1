Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbXKTWBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbXKTWBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXKTWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:01:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:54030 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751210AbXKTWBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:01:01 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19ArVwr9vtAgexD4VPfcyHvVUezp0zVZXz6Wc+vho
	kaT7OPDc49/Xcj
From: Helge Deller <deller@gmx.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Date: Tue, 20 Nov 2007 22:59:58 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
References: <200711182038.22055.deller@gmx.de> <200711182240.35015.deller@gmx.de> <20071120063120.GD17536@waste.org>
In-Reply-To: <20071120063120.GD17536@waste.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711202259.58745.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007, Matt Mackall wrote:
> On Sun, Nov 18, 2007 at 10:40:34PM +0100, Helge Deller wrote:
> > On Sunday 18 November 2007, Andrew Morton wrote:
> > > On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:
> > > 
> > > > Title: Add time-based RFC 4122 UUID generator
> > > > 
> > > > The current Linux kernel currently contains the generate_random_uuid() 
> > > > function, which creates - based on RFC 4122 - truly random UUIDs and 
> > > > provides them to userspace through /proc/sys/kernel/random/boot_id and 
> > > > /proc/sys/kernel/random/uuid.
> > > > 
> > > > This patch additionally adds the "Time-based UUID" variant of RFC 4122, 
> > > > with which userspace applications can easily get real unique time-based 
> > > > UUIDs through /proc/sys/kernel/random/uuid_time.
> > > > A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is available,
> > > > so that the clock_seq value can be retained across system bootups (which
> > > > is required by RFC 4122).
> > > > 
> > > > The attached implementation uses getnstimeofday() to get very fine-grained
> > > > granularity. This helps, so that userspace tools can get a lot more UUIDs 
> > > > (if needed) per time than before.
> > > > A mutex takes care of the proper locking against a mistaken double creation 
> > > > of UUIDs for simultanious running processes.
> > 
> > 
> > > Who will use this feature, and for what?
> > > (In fact, who uses the existing UUID generators, and for what?)
> > 
> > Current users I know of (but there are more):
> > - e2fsprogs uses it e.g. to create unique UUIDs for disks (it ships an own library for that)
> > - http://commons.apache.org/sandbox/id/uuid.html uses it with own libraries
> > - SAP Netweaver on Linux uses it (http://www.sap.com/platform/netweaver/index.epx)
> > 
> > I'm mostly interested in fixing problems I see with SAP (I'm working for SAP).
> > SAP Netweaver often needs during a very short time frame lots of unique UUIDs 
> > (to reference the data afterwards) when new data is imported into the database.
> > Main problem with current implementations is, is that they don't 100% 
> > guarantee uniqness of the generated UUIDs. Sometimes, esp. on very fast 
> > multi-processor machines, double UUIDs are generated and returned to the 
> > application which is very bad and may result in unreliable behaviour.
> > 
> > Current implemenations use userspace-libraries. In userspace you e.g. can't 
> > easily protect the uniquness of a UUID against other running _processes_.
> > If you try do, you'll need to do locking e.g. with shared memory, which can 
> > get very expensive.
> 
> Even with a futex? Or userspace atomics? 

Yes, you'll need a futex or similiar.
The problem is then more, where will you put that futex to be able to protect against other processes ? 
Best solution is probably shared memory, but then the question will be, who is allowed to access this memory/futex ?
Will any process (shared library) be allowed to read/write/delete it ?
At this stage you then suddenly run from a locking-problem into a security problem, which is probably equally hard to solve.
Btw, this is how Novell tried to solve the time-based UUID generator problem in SLES and it's still not 100% fixed.

> I think something as simple 
> as a server stuffing a bunch of clock sequence numbers into a pipe
> for clients to pop into their generated UUIDs should be plenty fast
> enough.

Sounds simple and is probably fast enough.
But do you really want to add then another daemon to the Linux system, just in case "some" application needs somewhen a UUID ?
And I think such an implementation is more complex, would need more memory, file handles, and so on than this simple kernel patch.

> > The problem will get even worse with virtualization technologies like XEN and
> > containers. There it's even impossible to protect against processes in other VMs.
> 
> Nor does it make sense to try! A virtual machine is an independent machine
> after all.

Yes.

> > Another user which could benefit from it are embedded devices. They could 
> > drop their userspace-implementations in favour of this smaller kernel version
> > to create UUIDs for their disks, using it in the webservers, ...
> 
> That's a silly tradeoff. It's an unusual embedded device that ships
> with any need for a UUID, especially mkfs. 

I think mkfs was a very bad example from my side. I should not have mentioned this one.
Nevertheless, time-based UUIDs are used in quite many other and more critical applications than e2fsprogs tools.

> And generally, putting a 
> feature in the kernel has no inherent size advantage. In fact, it has
> a size disadvantage: it's no longer pageable.

True, but let's look at the facts.

Current libuuid.so (from e2fsprogs) library on Fedora 7 (i386):
   text    data     bss     dec     hex filename
   8101     368      40    8509    213d /lib/libuuid.so.1

And the kernel implementation:
   text    data     bss     dec     hex filename
   4877     604    2080    7561    1d89 drivers/char/random.o.without_uuid
   5976     752    2080    8808    2268 drivers/char/random.o.withuuid

So my patch increases the kernel by 1099 bytes text and 148 bytes data while guaranteeing 100% unique UUIDs.
libuuid.so takes 8k test and 368 bytes data, and does not guarantees the uniqueness. 
Of course libuuid.so has some helper functions as well in here, which - to be fair - shouldn't be counted.
Nevertheless, I think you can't get any smaller, faster and more secure implementation than only in the kernel.

Maybe it would make sense to add a CONFIG_TIME_UUID kernel option, so that distributors can decide themselves if they want the kernel UUID generator compiled in?
At least for Enterprise-ready Linux distributions it's a must.

> ps: I'm the listed random.c maintainer so you'll want to cc: me in the
> future.

Sure.

Helge
