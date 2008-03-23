Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYCWSq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYCWSq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 14:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbYCWSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 14:46:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:29804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339AbYCWSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 14:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GVH7LKg4cM3jVV/Bn5boHwK1u8MKhCBspyLJsf/fNffT82RX/l1ysQ7idp0ok1E+UyebqiCvveV36xtcFGTo5nbJjyCV9vBfliznLBq8hizYBRjGVFCG6fKWvnyCz/CAd81/Tr/aaNd/jS1in/iMT8LN9v/YxvsCXLjcsNt3zZs=
Date: Sun, 23 Mar 2008 19:46:10 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Message-ID: <20080323184427.GA6691@joi>
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy> <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy> <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206287670.6437.113.camel@lappy>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2008 at 04:54:29PM +0100, Peter Zijlstra wrote:
> On Sun, 2008-03-23 at 16:44 +0100, Marcin Slusarz wrote:
> > On Sun, Mar 02, 2008 at 08:58:37PM +0100, Peter Zijlstra wrote:
> > > 
> > > On Sun, 2008-03-02 at 20:47 +0100, Marcin Slusarz wrote:
> > > > On Sun, Mar 02, 2008 at 08:11:11PM +0100, Peter Zijlstra wrote:
> > > > > 
> > > > > On Sun, 2008-03-02 at 20:00 +0100, Marcin Slusarz wrote:
> > > > > > Hi
> > > > > > Since early 2.6.25 days I'm having strange lockup on boot. As it happens
> > > > > > rarely (in ~10% of boots), I couldn't bisect it. No kernel panic, SysRq
> > > > > > didn't work, so I couldn't provide any useful informations to LK community.
> > > > > > I hoped someone else would fix it... :)
> > > > > > 
> > > > > > It's rc3 so I decided to narrow it down myself. I enabled netconsole 
> > > > > > to see whether some other informations are printed before lockup.
> > > > > > It didn't help, but I noticed that lockup happens much more frequenly! (~50%)
> > > > > > So I bisected it down to:
> > > > > > 
> > > > > > 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> > > > > > commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> > > > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > > Date:   Fri Jan 25 21:08:29 2008 +0100
> > > > > > 
> > > > > >     sched: high-res preemption tick
> > > > > > 
> > > > > >     Use HR-timers (when available) to deliver an accurate preemption tick.
> > > > > > 
> > > > > >     The regular scheduler tick that runs at 1/HZ can be too coarse when nice
> > > > > >     level are used. The fairness system will still keep the cpu utilisation 'fair'
> > > > > >     by then delaying the task that got an excessive amount of CPU time but try to
> > > > > >     minimize this by delivering preemption points spot-on.
> > > > > > 
> > > > > >     The average frequency of this extra interrupt is sched_latency / nr_latency.
> > > > > >     Which need not be higher than 1/HZ, its just that the distribution within the
> > > > > >     sched_latency period is important.
> > > > > > 
> > > > > >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > > > 
> > > > > > :040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1 f1742e1d225a72aecea9d6961ed989b5943d31d8 M      arch
> > > > > > :040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe ae61510186b4fad708ef0211ac169decba16d4e5 M      include
> > > > > > :040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26 950832cc1dc4d30923f593ecec883a06b45d62e9 M      kernel
> > > > > > 
> > > > > > I can't revert it on top of rc3 because of conflicts.
> > > > > 
> > > > > This should do, I guess. Weird though, I haven't had trouble with this
> > > > > patch in a long long while. Nor I suppose has Ingo's QA setup.
> > > > Ok. It did the trick. But it's temporary fix, right?
> > > 
> > > Yeah, for a proper fix I'd need to understand what goes wrong.. and that
> > > requires I get more information. Hopefully I can reproduce your issue.
> > > 
> > > > > Will try if I can reproduce using your .config.
> > > > I think this lockup might depend on use of dhcp and/or parallel
> > > > starting of services...
> > > 
> > > It _should_ not.. :-) I can try dhcp quite easily, if nothing comes up I
> > > can try installing gentoo on a test box, stage3 installs are easy
> > > enough.
> > 
> > I'm still having this lockup on 2.6.25-rc6 (028011e1391eab27e7bc113c2ac08d4f55584a75).
> > What informations do you need?
> 
> Does the NMI watchdog (append nmi_watchdog=2) report anything?
> 
> I've never been able to reproduce myself :-/

4 different lockups:
http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.03.23-lockup/ 

Are there any downsides of using nmi_watchdog=2 all the time?

ps: Documentation/nmi_watchdog.txt says: "Currently, local APIC mode
(nmi_watchdog=2) does not work on x86-64.". It's not true, so maybe someone
should update this file?
