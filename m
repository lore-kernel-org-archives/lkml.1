Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKFOS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKFOS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYKFOSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:18:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:42673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYKFOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:18:17 -0500
Subject: Re: [PATCH] ftrace: add an fsync tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081106060624.58a0f967@infradead.org>
References: <20081105094902.27ec4b39@infradead.org>
	 <1225976138.7803.4485.camel@twins>  <20081106060624.58a0f967@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Nov 2008 15:19:01 +0100
Message-Id: <1225981141.7803.4577.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 06:06 -0800, Arjan van de Ven wrote:
> On Thu, 06 Nov 2008 13:55:38 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2008-11-05 at 09:49 -0800, Arjan van de Ven wrote:
> > > From 63c1b869d94eb31a98015af09fb24e22151f2f00 Mon Sep 17 00:00:00
> > > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Tue, 4 Nov 2008 21:08:11 -0800
> > > Subject: [PATCH] ftrace: add an fsync tracer
> > > 
> > > fsync() (and its cousin, fdatasync()) are important chokepoints in
> > > the kernel as they imply very expensive operations, both in terms
> > > of filesystem operations (ext3 writes back its entire journal) as
> > > well as the block layer (fsync() implies sending a cache flushing
> > > barrier to the SATA/SCSI disk).
> > > 
> > > This tracer makes a log of which application calls fsync() on which
> > > file, so that developers and others interested in finding these
> > > choke points can locate them and fix them in the apps that call
> > > this function.
> > 
> > Sorry, but I have to object to such single purpose tracers..
> > 
> > If we go this way we'll end up with a gazillion little tracers, non of
> > which are really useful.
> 
> If we go this way we'll end up with a bunch of little tracers, all of
> which will be useful in their area, and people can also make "super
> tracers" out of the useful trace points.

I don't think: 

# cat available_tracers | wc -l
500

will do much good for people.

Also, I don't think do_fsync() is the right place to catch what you're
trying to catch.

> > 
> > Please work on getting something like a syscall tracer,
> 
> a syscall tracer will exactly not tell you which file(name) was being
> fsync()'d which was the whole point.

It will tell you the process and the fd, and when you have those two its
a simple step to find the actual file.

> LatencyTOP already KNOWS that fsync is the problem. What it doesn't
> know is which file is being fsync()d.
> 
> fsync is a problem when used incorrectly, not just for ext3 but also
> due to barriers. That's why it's important to be able to find who calls
> it when it impacts interactive performance.

Which suggests you want a tracer that gives more information about who
generates barriers, not specifically fsync().


