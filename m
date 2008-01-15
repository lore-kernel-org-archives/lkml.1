Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYAORYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYAORYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYAORX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:23:58 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:40749 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYAORX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:23:57 -0500
Date: Tue, 15 Jan 2008 18:23:55 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: "Radoslaw Szkodzinski (AstralStorm)" <lkml@astralstorm.puszkin.org>,
       Jarek Poplawski <jarkao2@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network
 packets
Message-Id: <20080115182355.c19426c0.dada1@cosmosbay.com>
In-Reply-To: <478CE9F1.8020409@nortel.com>
References: <20080115071950.GA1696@ff.dom.local>
	<478CC76B.1020804@nortel.com>
	<20080115161705.0724250d@astralstorm.puszkin.org>
	<478CE9F1.8020409@nortel.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 11:14:25 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Radoslaw Szkodzinski (AstralStorm) wrote:
> > On Tue, 15 Jan 2008 08:47:07 -0600
> > "Chris Friesen" <cfriesen@nortel.com> wrote:
> 
> >>Some of our hardware is not supported on mainline, so we need per-kernel 
> >>version patches to even bring up the blade.  The blades netboot via a 
> >>jumbo-frame network, so kernel extensions are needed to handle setting 
> >>the MTU before mounting the rootfs.
> 
> > Why? Can't you use a small initramfs to set it up?
> 
> Sure, if we changed our build system, engineered a suitable small 
> userspace, etc.  At this point it's easier to maintain a small patch to 
> the kernel dhcp parsing code so that we can specify mtu.
> 
> >>The blade in question uses CKRM 
> >>which doesn't exist for newer kernels so the problem may simply be 
> >>hidden by scheduling differences.
> 
> > Current spiritual successor is Ingo's realtime patchset I guess.
> 
> I think the group scheduling stuff for CFS is closer, but there are 
> design and API differences that would require us to rework our system.
> 
> >>The userspace application uses other 
> >>kernel features that are not in mainline (and likely some of them won't 
> >>ever be in mainline--I know because I've tried).
> 
> > What would these be? Some proc or sysfs files that were removed or
> > renamed?
> > Maybe they can be worked around w/o changing the application at all, or
> > very minor changes.
> 
> No, more than proc/sysfs.  Things like notification of process state 
> change (think like SIGCHLD but sent to arbitrary processes), additional 
> messaging protocol families, oom-killer protection, dirty page 
> monitoring, backwards compatibility for "dcbz" on the ppc970, nested 
> alternate signal stacks, and many others.  Between our kernel vendor's 
> patches and our own, there are something like 600 patches applied to the 
> mainline kernel.
> 
> > Also, be sure to check if there are pauses with other CPU hogs.
> 
> With the sctp hash patch applied we're now sitting with 45% cpu free on 
> one cpu, and about 25% free on the other, and we're still seeing 
> periodic bursts of rx fifo loss.  It's wierd.  Still trying to figure 
> out what's going on.

On old kernels, some softirq functions can hog cpu for quite long times.

NIC RX rings can be filled and eventually losses occur.

Recent kernels tried to move some time consuming task from softirq to workqueue.

Examples:

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.25.git;a=commit;h=29b7e29480029c896e7782ce2a45843abeea2f7a

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.25.git;a=commit;h=d90bf5a976793edfa88d3bb2393f0231eb8ce1e5

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.25.git;a=commit;h=39c90ece7565f5c47110c2fa77409d7a9478bd5b

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.25.git;a=commit;h=86bba269d08f0c545ae76c90b56727f65d62d57f

...
