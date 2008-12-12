Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYLLSCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYLLSCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbYLLSC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:02:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:42431 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbYLLSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:02:29 -0500
Subject: Re: [PATCH 12/15] kmemleak: Enable the building of the memory leak
	detector
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1229102826.15045.75.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182800.30323.49209.stgit@pc1117.cambridge.arm.com>
	 <1228936817.9737.102.camel@nimitz>
	 <1229102826.15045.75.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Dec 2008 10:02:18 -0800
Message-Id: <1229104938.17206.86.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 17:27 +0000, Catalin Marinas wrote:
> On Wed, 2008-12-10 at 11:20 -0800, Dave Hansen wrote:
> > On Wed, 2008-12-10 at 18:28 +0000, Catalin Marinas wrote:
> > > +config DEBUG_MEMLEAK
> > > +       bool "Kernel memory leak detector"
> > > +       default n
> > > +       depends on EXPERIMENTAL
> > > +       select DEBUG_SLAB if SLAB
> > > +       select SLUB_DEBUG if SLUB
> > > +       select DEBUG_FS
> > > +       select STACKTRACE
> > > +       select FRAME_POINTER
> > > +       select KALLSYMS
> > 
> > So, not all architectures have STACKTRACE or FRAME_POINTER.  I think a
> > few of these should at least be done with depends.
> 
> I think it could depend on STACKTRACE_SUPPORT. Alternatively, it could
> select STACKTRACE only if it is supported, though for architectures
> without it, the kmemleak reports wouldn't be very useful.

I think they'd still be pretty useful.  They would be certainly harder
to track down, but "something allocating N bytes from the slab is
leaking" is certainly better than nothing.  

> Does FRAME_POINTER even matter? I think STACKTRACE should be enough to
> get the backtrace. I even have some ARM patches for stack unwinding
> where FRAME_POINTER is disabled (and shouldn't be enabled).

It is supposed to give cleaner stack traces.  But if you don't strictly
require it, I'd leave it up to whatever the user had set before.  If
people are getting crappy stack traces from anywhere in the kernel, I
think they know where to go to fix it. ;)

> > Is this feature accessible if DEBUG_FS=n?  It seems to compile OK, but I
> > wonder if it is useful.
> 
> Well, it is recommended. If you don't have this, you can't trigger a
> scan manually by reading the /sys/kernel/debug/memleak file (have to
> rely on the automatic thread). In my local tree (not published yet), I
> also added support for run-time configuration by writing to this file.
> Is there any disadvantage in always selecting DEBUG_FS?

I was just worried that debugfs was the only mechanism for this feature
to get its data in and out of the kernel.  If it was not there, that
this feature was useless.

The problem with 'select' when it is "mixed" with 'depends':

config DEBUG_FS
        bool "Debug Filesystem"
        depends on SYSFS

When you 'select DEBUG_FS' it will *not* turn on SYSFS:

$ egrep 'DEBUG_FS|MEMLEAK|G_SYSFS' .config
# CONFIG_SYSFS is not set
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_MEMLEAK=y
CONFIG_DEBUG_MEMLEAK_TEST=y

I also tried compiling your feature with a bunch of things turned off in
my .config: http://sr71.net/~dave/linux/kmemleak.config

I got a compile error:

/home/dave/work/temp/linux-2.6/mm/memleak-test.c: In function ‘memleak_test_init’:
/home/dave/work/temp/linux-2.6/mm/memleak-test.c:61: error: ‘files_cachep’ undeclared (first use in this function)
/home/dave/work/temp/linux-2.6/mm/memleak-test.c:61: error: (Each undeclared identifier is reported only once
/home/dave/work/temp/linux-2.6/mm/memleak-test.c:61: error: for each function it appears in.)

make allnoconfig is cool. :)

-- Dave

