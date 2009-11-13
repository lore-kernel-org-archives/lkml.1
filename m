Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZKMRFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZKMRFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZKMRFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:05:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:39228 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZKMRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:05:14 -0500
Subject: Re: [PATCH] sys_times: fix utime/stime decreasing on thread exit
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20091113153653.GA4403@dhcp-lab-161.englab.brq.redhat.com>
References: <4AFB5019.7030901@jp.fujitsu.com>
	 <4AFB77C2.8080705@jp.fujitsu.com>
	 <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
	 <4AFB8C21.6080404@jp.fujitsu.com> <4AFB9029.9000208@jp.fujitsu.com>
	 <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com>
	 <1258038038.4039.467.camel@laptop>
	 <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com>
	 <20091113124235.GA26815@dhcp-lab-161.englab.brq.redhat.com>
	 <1258118219.22655.203.camel@laptop>
	 <20091113153653.GA4403@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 18:05:03 +0100
Message-ID: <1258131903.22655.582.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 16:36 +0100, Stanislaw Gruszka wrote:
> 
> But I don't like it much. Sad we can not do transition to opposite
> direction and remove task_{u,s}time. 

We need task_[us]time() for some thing like process monitors like top to
avoid tasks hiding from them.

Since the regular [us]time are only incremented on tick, if a task never
runs on the tick, it'll never accumulate any tick and hence it'll be
reported as not using cpu time.

task_[us]time() solve this by using the ns sum_exec_runtime and scale
that according to the [us]time ticks -- the only trouble is keeping it
monotonic.

CONFIG_VIRT_CPU_ACCOUNTING avoids this whole issue by tracking time on
each user/kernel transition, but at the obvious cost of having to track
time at every such transition.

Now since we clearly don't want to incur that overhead on any regular
setup (kernel entry/exit paths are extremely hot), we're (afais) stuck
using the current scheme of dividing the sum_exec_runtime in two
components system/user according to the tick ratio.

Now if we can reduce the task_[us]time muckery to the bare minimum that
would be good, but the way it looks now all this accounting seems too
interwoven to pull that off.


