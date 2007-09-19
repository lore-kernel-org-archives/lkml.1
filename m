Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbXISHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbXISHvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXISHvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:51:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:37903 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752426AbXISHvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:51:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19vkDNxMlNvIBlzj+zfpsbRAngiUeAC3h2B+afr37
	9J95o2wBXXR/hT
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1190183324.9737.7.camel@Homer.simpson.net>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 09:51:01 +0200
Message-Id: <1190188261.9185.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 08:28 +0200, Mike Galbraith wrote:
> Greetings,
> 
> On Tue, 2007-09-18 at 23:03 -0700, Tong Li wrote:
> > This patch attempts to improve CFS's SMP global fairness based on the new 
> > virtual time design.
> > 
> > Removed vruntime adjustment in set_task_cpu() as it skews global fairness.
> 
> Since I'm (still) encountering Xorg latency issues (which go away if
> load is hefty instead of light) even with that migration adjustment and
> synchronization, and am having difficulty nailing it down to a specific
> event, I'll test this immediately.

(had to apply manually to freshly pulled tree)

Drat.  This didn't cure the latency hits with a Xorg at nice -5 running
with a make -j2 at nice 0, but seems to have reinstated a latency issue
which was previously cured.

Xorg 1 sec. max latency samples:
(trimmed to only show >20ms latencies)
se.wait_max              :            23343582
se.wait_max              :            20119460
se.wait_max              :            20771573
se.wait_max              :            21084567
se.wait_max              :            31338500
se.wait_max              :            35368148
se.wait_max              :            39199642
se.wait_max              :            22889062
se.wait_max              :            40285501
se.wait_max              :            21002720
se.wait_max              :            21002266
se.wait_max              :            21680578
se.wait_max              :            22012913
se.wait_max              :            94646331
se.wait_max              :            29003693
se.wait_max              :            20812613

(boot with maxcpus=1 or nail X+make to one cpu and these latencies are
gone, so it does seem to be the migration logic - why i was so
interested in testing your patch)

The scenario which was previously cured was this:
taskset -c 1 nice -n 0 ./massive_intr 2 9999
taskset -c 1 nice -n 5 ./massive_intr 2 9999
click link
(http://pages.cs.wisc.edu/~shubu/talks/cachescrub-prdc2004.ppt) to bring
up browser and OpenOffice Impress.

Xorg (at nice -5 + above scenario) latency samples:
se.wait_max              :            57985337
se.wait_max              :            25163510
se.wait_max              :            37005538
se.wait_max              :            66986511
se.wait_max              :            53990868
se.wait_max              :            80976761
se.wait_max              :            96967501
se.wait_max              :            80989254
se.wait_max              :            53990897
se.wait_max              :           181963905
se.wait_max              :            85985181

	-Mike

