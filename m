Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbXKTGbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbXKTGbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXKTGbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:31:38 -0500
Received: from waste.org ([66.93.16.53]:40269 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbXKTGbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:31:37 -0500
Date: Tue, 20 Nov 2007 00:31:20 -0600
From: Matt Mackall <mpm@selenic.com>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071120063120.GD17536@waste.org>
References: <200711182038.22055.deller@gmx.de> <20071118130503.7d5ec842.akpm@linux-foundation.org> <200711182240.35015.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711182240.35015.deller@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2007 at 10:40:34PM +0100, Helge Deller wrote:
> On Sunday 18 November 2007, Andrew Morton wrote:
> > On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:
> > 
> > > Title: Add time-based RFC 4122 UUID generator
> > > 
> > > The current Linux kernel currently contains the generate_random_uuid() 
> > > function, which creates - based on RFC 4122 - truly random UUIDs and 
> > > provides them to userspace through /proc/sys/kernel/random/boot_id and 
> > > /proc/sys/kernel/random/uuid.
> > > 
> > > This patch additionally adds the "Time-based UUID" variant of RFC 4122, 
> > > with which userspace applications can easily get real unique time-based 
> > > UUIDs through /proc/sys/kernel/random/uuid_time.
> > > A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is available,
> > > so that the clock_seq value can be retained across system bootups (which
> > > is required by RFC 4122).
> > > 
> > > The attached implementation uses getnstimeofday() to get very fine-grained
> > > granularity. This helps, so that userspace tools can get a lot more UUIDs 
> > > (if needed) per time than before.
> > > A mutex takes care of the proper locking against a mistaken double creation 
> > > of UUIDs for simultanious running processes.
> 
> 
> > Who will use this feature, and for what?
> > (In fact, who uses the existing UUID generators, and for what?)
> 
> Current users I know of (but there are more):
> - e2fsprogs uses it e.g. to create unique UUIDs for disks (it ships an own library for that)
> - http://commons.apache.org/sandbox/id/uuid.html uses it with own libraries
> - SAP Netweaver on Linux uses it (http://www.sap.com/platform/netweaver/index.epx)
> 
> I'm mostly interested in fixing problems I see with SAP (I'm working for SAP).
> SAP Netweaver often needs during a very short time frame lots of unique UUIDs 
> (to reference the data afterwards) when new data is imported into the database.
> Main problem with current implementations is, is that they don't 100% 
> guarantee uniqness of the generated UUIDs. Sometimes, esp. on very fast 
> multi-processor machines, double UUIDs are generated and returned to the 
> application which is very bad and may result in unreliable behaviour.
> 
> Current implemenations use userspace-libraries. In userspace you e.g. can't 
> easily protect the uniquness of a UUID against other running _processes_.
> If you try do, you'll need to do locking e.g. with shared memory, which can 
> get very expensive.

Even with a futex? Or userspace atomics? I think something as simple
as a server stuffing a bunch of clock sequence numbers into a pipe
for clients to pop into their generated UUIDs should be plenty fast
enough.

> The problem will get even worse with virtualization technologies like XEN and
> containers. There it's even impossible to protect against processes in other VMs.

Nor does it make sense to try! A virtual machine is an independent machine
after all.

> Another user which could benefit from it are embedded devices. They could 
> drop their userspace-implementations in favour of this smaller kernel version
> to create UUIDs for their disks, using it in the webservers, ...

That's a silly tradeoff. It's an unusual embedded device that ships
with any need for a UUID, especially mkfs. And generally, putting a
feature in the kernel has no inherent size advantage. In fact, it has
a size disadvantage: it's no longer pageable.

ps: I'm the listed random.c maintainer so you'll want to cc: me in the
future.
-- 
Mathematics is the supreme nostalgia of our time.
