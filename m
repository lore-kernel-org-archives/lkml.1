Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbZE1D4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbZE1D4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbZE1D4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:56:09 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38206 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbZE1D4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:56:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18974.2897.822557.905261@drongo.ozlabs.ibm.com>
Date: Thu, 28 May 2009 13:56:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Introduce stricter C code checking
In-Reply-To: <tip-16f762a2ac5ecf8a11f6f0332e46cc3459220da5@git.kernel.org>
References: <20090526222155.GJ4424@ghostprotocols.net>
	<tip-16f762a2ac5ecf8a11f6f0332e46cc3459220da5@git.kernel.org>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Ingo Molnar writes:

> perf_counter tools: Introduce stricter C code checking
> 
> Tighten up our C code requirements:
> 
>  - disallow warnings

This causes failures when I compile it as a 64-bit executable on
powerpc:

    CC builtin-record.o
builtin-record.c: In function 'pid_synthesize_mmap_events':
builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 3 has type '__u64 *'
builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 4 has type '__u64 *'
builtin-record.c:241: warning: format '%llx' expects type 'long long unsigned int *', but argument 9 has type '__u64 *'

This is because u64 is an unsigned long in userspace for a 64-bit
build, not unsigned long long.  I'm not sure how best to solve this
problem.

If I compile it as a 32-bit executable, it doesn't generate warnings,
but when I try to run "perf top" (this is on a 64-bit kernel, of
course, since 32-bit powerpc kernels don't currently support
perf_counters), I get:

# perf top
 left: 0000000000000000
   ip: 00000000000891a4
right: 00000000ffffffff
KernelTop refresh period: 2 seconds
perf: builtin-top.c:453: record_ip: Assertion `left <= ip && ip <= right' failed.
Aborted

Paul.
