Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZK0SDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZK0SDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZK0SDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:03:13 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48618 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZK0SDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:03:12 -0500
Date: Fri, 27 Nov 2009 23:33:10 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hw-breakpoints: Use struct perf_event_attr to
	define user breakpoints
Message-ID: <20091127180310.GA18408@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1259294154-5197-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259294154-5197-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 04:55:53AM +0100, Frederic Weisbecker wrote:
> In-kernel user breakpoints are created using functions in which we pass
> breakpoint parameters as individual variables: address, length and
> type.
> 
> Although it fits well for x86, this just does not scale across
> archictectures that may support this api later as these may have
> more or different needs. Pass in a perf_event_attr structure
> instead because it is meant to evolve as much as possible into
> a generic hardware breakpoint parameter structure.
>

I suspect this further needs cleanup. Taking a quick look at all the
exported interfaces:

struct perf_event *
register_user_hw_breakpoint(struct perf_event_attr *attr,
                            perf_callback_t triggered,
                            struct task_struct *tsk);
struct perf_event *
modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
                          perf_callback_t triggered,
                          struct task_struct *tsk);

void unregister_hw_breakpoint(struct perf_event *bp);

struct perf_event **
register_wide_hw_breakpoint(struct perf_event_attr *attr,
                            perf_callback_t triggered);

void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);

It could be further improved to make them more intuitive and
symmetrical, for instance:

- Merge 'perf_callback_t triggered' with 'struct perf_event_attr' (it is
  very much an attribute of the breakpoint) (you may also want to rename
  'triggered' to something else...which is a pending suggestion from the
  community - 'triggered' indicates a boolean datatype and not a
  callback).

- Make register_<> always return 'struct perf_event *' (just like how
  unregister_<> always returns 'void').

- Both unregister_hw_breakpoint() and unregister_wide_hw_breakpoint()
  can accept 'struct perf_event *' as parameters.

Would you also like to rename register_wide_hw_breakpoint() to
register_kernel_hw_breakpoint() since a) It is used only for
kernel-space requests b) If a per-cpu kernel-space counter is desired in
future, register_wide_hw_breakpoint() name would shrink to
register_hw_breakpoint() causing ambiguity (user or kernel?) and
name-space collision.

Thanks,
K.Prasad

