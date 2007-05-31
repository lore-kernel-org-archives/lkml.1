Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXEaGgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXEaGgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbXEaGgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:36:01 -0400
Received: from holomorphy.com ([66.93.40.71]:58621 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbXEaGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:36:00 -0400
Date: Wed, 30 May 2007 23:36:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Peter Williams <pwil3058@bigpond.net.au>, kernel@kolivas.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, Kirill Korotaev <dev@sw.ru>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531063647.GC15426@holomorphy.com>
References: <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com> <20070531040926.GH6909@holomorphy.com> <20070531054828.GB663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531054828.GB663@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:09:26PM -0700, William Lee Irwin III wrote:
>> It's not all that tricky. 

On Thu, May 31, 2007 at 11:18:28AM +0530, Srivatsa Vaddagiri wrote:
> Hmm ..the fact that each task runs for a minimum of 1 tick seems to
> complicate the matters to me (when doing group fairness given a single
> level hierarchy). A user with 1000 (or more) tasks can be unduly
> advantaged compared to another user with just 1 (or fewer) task
> because of this?

Temporarily, yes. All this only works when averaged out.  The basic
idea is that you want a constant upper bound on the difference between
the CPU time a task receives and the CPU time it was intended to get.
This discretization is one of the larger sources of the "error" in the
CPU time granted. The constant upper bound usually only applies to the
largest difference for any task. When absolute values of differences
are summed across tasks the aggregate will be O(tasks) because there's
something almost like a constant per-task lower bound a la Heisenberg.
It would have to get more exact the more tasks there are on the system
for that to work, and something of the opposite actually holds.

It might be appropriate for the scheduler to dynamically adjust a
periodic timer's period or to set up one-shot timers at involuntary
preemption times in order to achieve more precise fairness in this
sort of situation. In the case of few preemption points such one-shot
code or low periodicity code would also save on taking interrupts that
would otherwise manifest as overhead.

In short, a user with many tasks can reap a temporary advantage
relative to users with fewer tasks because of this, but over time,
longer-running tasks will receive the CPU time intended to within
some constant upper bound, provided other things aren't broken.


-- wli
