Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZKWRgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZKWRgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZKWRgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:36:05 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38763 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbZKWRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:36:03 -0500
Date: Mon, 23 Nov 2009 23:06:01 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
	perf tools
Message-ID: <20091123173601.GA7273@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com> <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:42:35PM +0100, Frederic Weisbecker wrote:
> Add the breakpoint events support with this new sysnopsis:
> 
> mem:addr[:access]
> 
> Where addr is a raw addr value in the kernel and access can be
> either [r][w][x]
> 
> Example to profile tasklist_lock:
> 
> 	$ grep tasklist_lock /proc/kallsyms
> 	ffffffff8189c000 D tasklist_lock
> 
> 	$ perf record -e mem:0xffffffff8189c000:rw -a -f -c 1
> 	$ perf report

The problem in obtaining just the breakpoint address is that there can
be a variety of breakpoint lengths that can be associated with them -
assigning the smallest possible length (1-Byte) may cause loss of
exceptions and a higher length would lead to stray exceptions (such
dilemmas led to the support of symbol-only breakpoint in ksym_tracer and
perf-tools in my patchset...the default 1-Byte breakpoint length being a
temporary fix).

With kernel symbols as input it would be possible to derive the bkpt
length based on the symbol-size, say using
kallsyms_lookup_size_offset() (although the corresponding length may not
be available on the host processor such requests can be failed or
over-ridden by the user using a smaller length), but for addresses I think
it is vital to know what breakpoint length is desired by the user.

This comes at the cost of exposing the user to variations in
breakpoint implementation across architectures and demand processor-specific
knowledge, but specifying a kernel-space address would anyway require the
user to penetrate beyond the normal abstraction provided by the
interface/tool...so I presume it must be acceptable.

On a related note, the supported breakpoint length for PPC64 is a fixed
8-Byte length (which means all extraneous exceptions must be filtered by
the breakpoint architecture) and Book-E Power processors matching
addresses against a bitmask; for S390 it can be practically anything
(bound by a set of start and end addresses)...and you see what a
quandary it leads to!

Thanks,
K.Prasad

