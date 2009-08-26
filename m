Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZHZTBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZHZTBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZHZTBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:01:12 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:59308 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbZHZTBL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:01:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAMcflUpMROOX/2dsb2JhbACBU9dchBoF
Date: Wed, 26 Aug 2009 15:01:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826190108.GA1895@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <1251267669.7538.1195.camel@twins> <20090826170812.GC21456@Krystal> <20090826184116.GA20283@infradead.org> <20090826184236.GA24102@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090826184236.GA24102@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:51:03 up 8 days,  5:40,  2 users,  load average: 0.28, 0.46,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Wed, Aug 26, 2009 at 02:41:16PM -0400, Christoph Hellwig wrote:
> > We do not support system calls from kernelspace anymore.  All the
> > macros to do real system calls are gone, and there are very very few
> > places left calling sys_foo as normal function calls.
> > 
> > An how exactly is calling sys_foo as a normal function call different
> > from calling do_foo or vfs_foo?
> 

Not very different, no. But the fact is that we would not be
instrumenting do_foo nor vfs_foo because we would somehow expect all
callers to go through a system call, which ain't always true.

> And if you really need to trace direct callers of sys_foo just put
> a jprobe on it.
> 

Yep, that would do it. Getting the arguments of the function upon entry
and the return value on exit is pretty much all we need.

But I would like to ensure that we do not duplicate the instrumentation
done by the generic syscall instrumentation neither, so we don't end up
having:

syscall_entry X (args)
do_X (args)
do_X return (return value)
syscall_exit X (return value)

If I am not mistakened, the current execution paths are:

>From userland:

syscall -> sys_X() -> do_X()

>From the kernel:

do_X()

Adding a trampoline taken only when the kernel is doing the call might
be useful there to selectively trace calls made by the kernel.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
