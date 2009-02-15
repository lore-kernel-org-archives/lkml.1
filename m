Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZBOLBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZBOLBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 06:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZBOLBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 06:01:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZBOLBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 06:01:35 -0500
Date: Sun, 15 Feb 2009 12:01:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215110104.GB31351@elte.hu>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215103445.GA2335@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Damien Wyart <damien.wyart@free.fr> wrote:

> So I followed the tracing steps in the tutorial (with the 1 sec sleep),
> which gave me this:
> http://damien.wyart.free.fr/trace_2.6.29-rc5_ksoftirqd_prob.txt.gz

thanks. There's definitely some weirdness visible in the trace,
for example:

  0)    gpm-1879    =>   ksoftir-4   
  ------------------------------------------

  0)   0.964 us    |    finish_task_switch();
  0) ! 1768184 us |  }
  0)               |  do_softirq() {
  0)               |    __do_softirq() {
  0)               |      rcu_process_callbacks() {

the 1.7 seconds 'overhead' there must be a fluke - you'd notice it if
ksoftirqd _really_ took that much time to execute.

One possibility for these symptoms would be broken scheduler timestamps.
Could you enable absolute timestamp printing via:

    echo funcgraph-abstime  > trace_options

Also, my guess is that if you boot via idle=poll, the symptoms go away.
This would strengthen the suspicion that it's scheduler-clock troubles.

	Ingo
