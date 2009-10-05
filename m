Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZJEGYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZJEGYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZJEGYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:24:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39421 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZJEGYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:24:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC990E1.7030708@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:23:29 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

Huang Ying wrote:
> Current MCE log ring buffer has following bugs and issues:
> 
> - On larger systems the 32 size buffer easily overflow, losing events.
> 
> - We had some reports of events getting corrupted which were also
>   blamed on the ring buffer.
> 
> - There's a known livelock, now hit by more people, under high error
>   rate.
> 
> We fix these bugs and issues via making MCE log ring buffer as
> lock-less per-CPU ring buffer.

Now I have a real problem on the small MCE log buffer on my new large
system with Nehalem which has many cpus/banks in one socket...
So I'd like to solve the problem asap.  I think this problem might block
some distros to support new processor.

Last week I reviewed your patch again and noticed that it is doing a lot
of changes at once.  I suppose that this method must be one of reasons
why your patch seems to be so hard to review, and why it is taking long
time to be accepted by x86 maintainers.

Fortunately I had some spare time so I carefully broke your patch into
some purpose-designed pieces.  It would be the most significant change 
that now there are 2 steps to convert the buffer structure - 1) to make
it per-CPU and 2) to make it ring buffer.

Also I fixed some problem in your patch, found on the way to make this
patch set.  I'll explain about my changes later using diff from your
change.  Comments are welcomed.

Thanks,
H.Seto


Hidetoshi Seto (10):
      x86, mce: remove tsc handling from mce_read
      x86, mce: mce_read can check args without mutex
      x86, mce: change writer timeout in mce_read
      x86, mce: use do-while in mce_log
      x86, mce: make mce_log buffer to per-CPU, prep
      x86, mce: make mce_log buffer to per-CPU
      x86, mce: remove for-loop in mce_log
      x86, mce: change barriers in mce_log
      x86, mce: make mce_log buffer to ring buffer
      x86, mce: move mce_log_init() into mce_cap_init()

 arch/x86/include/asm/mce.h       |   43 ++++--
 arch/x86/kernel/cpu/mcheck/mce.c |  299 +++++++++++++++++++++++---------------
 2 files changed, 211 insertions(+), 131 deletions(-)

