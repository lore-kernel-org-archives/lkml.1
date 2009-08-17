Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZHQMqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZHQMqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZHQMqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:46:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39810 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZHQMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:46:54 -0400
Date: Mon, 17 Aug 2009 18:16:41 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090817124641.GA13354@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	Please find a patch that enables kernel-space breakpoints to be
requested for a subset of the available CPUs in the system. This allows
per-CPU breakpoints and comes with the associated benefit of reduced
overhead during (un)registration.

This enhancement allows exploitation of hardware breakpoint registers by
'perf' which produces a CPU-wise information.

Design changes
--------------
- Every breakpoint request 'consumes' the first available debug register
  (starting from HBP_NUM) in each CPU represented by 'cpumask' field in
  'struct hw_breakpoint'.

- 'hbp_kernel_pos' (that separates kernel-space breakpoints from the
  free/user-space breakpoints) now points to the maximum of debug
  registers consumed on any given CPU.
  -- 'hbp_kernel_pos' is decremented (one-at-a-time) to allow a new-slot
     for kernel-space requests iff all debug registers on the given CPU
     (from HBP_NUM - 1 to 'hbp_kernel_pos' are already consumed.
  -- 'hbp_kernel_pos' is incremented (one-at-a-time) to free a slot iff
     a removal request results in the release of a bkpt request that
     consumed maximum debug registers for kernel-space.

- Every removal request results in compaction of breakpoint registers
  (on a per-cpu basis) to occupy the vacant debug register.
 
The patch is based on commit b6c720b811aed0eeda89f277f13c1bd1bdf721fd of
-tip tree and has been tested to work fine on an x86 machine for both
cases (i.e. system-wide kernel breakpoints and bkpts for a subset of CPUs).

Please let me know your comments on the same.

Thanks,
K.Prasad

