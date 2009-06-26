Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbZFZS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbZFZS7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZFZS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:59:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbZFZS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:59:16 -0400
Date: Fri, 26 Jun 2009 11:57:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: tj@kernel.org, max@stro.at, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: >= 2.6.30 broken alpha smp build
Message-Id: <20090626115746.09314757.akpm@linux-foundation.org>
In-Reply-To: <20090626124705.GA25147@jurassic.park.msu.ru>
References: <20090625090842.GA17936@stro.at>
	<20090625115423.6a31b49c.akpm@linux-foundation.org>
	<4A4419AA.2040400@kernel.org>
	<20090626124705.GA25147@jurassic.park.msu.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 16:47:05 +0400
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Fri, Jun 26, 2009 at 09:43:22AM +0900, Tejun Heo wrote:
> > The __used attribute is dropped by a patch in percpu patchset as it
> > caused build warning on my test builds and wasn't even effective
> > as-was (overriden by later NULL definition).  Ivan, any ideas why it's
> > there?
> 
> It was intended for suppressing the compiler warnings about "unused"
> static per-cpu variables, as they were only referenced inside the asm code.
> 
> Now it seems to be broken with DECLARE_PER_CPU thing, so I think your
> patch that kills __used attribute should go in as a compile fix ASAP -
> we can live with a few compile warnings until the rest of percpu patchset
> gets merged.
> 

OK, we have a wart.


When I do this:

--- a/arch/alpha/include/asm/percpu.h~a
+++ a/arch/alpha/include/asm/percpu.h
@@ -49,7 +49,6 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
 
 #endif /* MODULE */
 
_


I get

In file included from include/linux/sched.h:89,
                 from /usr/src/devel/arch/alpha/include/asm/uaccess.h:5,
                 from arch/alpha/kernel/srm_env.c:37:
include/linux/hrtimer.h:314: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'typeof'
In file included from /usr/src/devel/arch/alpha/include/asm/uaccess.h:5,
                 from arch/alpha/kernel/srm_env.c:37:
include/linux/sched.h:138: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'typeof'


But hrtimer.h correctly includes percpu.h.  I would have expected the
above patch to fix the build.

The reason for it not fixing the build is that this:

#ifndef PER_CPU_ATTRIBUTES
#define PER_CPU_ATTRIBUTES
#endif

is in asm-generic/percpu.h, which alpha does not use.

Would it not have been better to put the above three lines into
linux/percpu.h so that alpha's asm/percpu.h doesn't need to define
PER_CPU_ATTRIBUTES at all?


Ho hum.  Anyway, we need a backportable fix, so I'll put this through
some build testing:

--- a/arch/alpha/include/asm/percpu.h~a
+++ a/arch/alpha/include/asm/percpu.h
@@ -49,7 +49,7 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
+#define PER_CPU_ATTRIBUTES
 
 #endif /* MODULE */
 
_

