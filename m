Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZAOJuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZAOJuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbZAOJuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:50:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224AbZAOJt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:49:58 -0500
Date: Thu, 15 Jan 2009 10:49:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
Message-ID: <20090115094938.GB5833@elte.hu>
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu> <496E4211.6040503@sgi.com> <20090114201152.GA31581@elte.hu> <496E587E.6010503@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E587E.6010503@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Very cool, thanks!!
> 
> The one thing I always get hung up on is what args to use with the git 
> rebase -i command.  Say I want to edit 4a046d1 (which I do ;-), I see it 
> in my repo with git-log (3rd one down):

You shouldnt edit 4a046d1 anymore as i already pulled it - you can queue 
up a fix commit. (Or we can decide to drop the whole tree and re-pull 
yours - but that is an emergency path not to be taken lightly.)

Btw., to 'edit' your own commits, you can always do something like this. 
For example, if this is the current lineup of your own commits (not yet 
pulled by anyone):

 a4a0acf: x86: fix broken flush_tlb_others_ipi()
 28e0886: xen: fix too early kmalloc call
 92296c6: cpumask, irq: non-x86 build failures
 542d865: kstat: modify kstat_irqs_legacy to be variable sized
 9332fcc: irq: initialize nr_irqs based on nr_cpu_ids
 0fa0ebb: irq: allocate irq_desc_ptrs array based on nr_irqs
 e2f4d06: irq: use WARN() instead of WARN_ON().

... and you realize that there's a bug in the middle, at 542d865, that 
you'd like to fix locally before pushing it out for others to pull.

In this case you can rebase and fix in "two phases". The first phase is to 
'reorder commits':

  git rebase -i 542d865^1

i.e. you start your rebase _from before_ the commit in question. All old 
history will be preserved (which is always good - you always want the 
minimum rebase - avoid full rebases as much as possible).

You will be offered this git-rebase screen:

 pick 542d865 kstat: modify kstat_irqs_legacy to be variable sized
 pick 92296c6 cpumask, irq: non-x86 build failures
 pick 28e0886 xen: fix too early kmalloc call
 pick a4a0acf x86: fix broken flush_tlb_others_ipi()

Edit it to move the first line to the last, like this:

 pick 92296c6 cpumask, irq: non-x86 build failures
 pick 28e0886 xen: fix too early kmalloc call
 pick a4a0acf x86: fix broken flush_tlb_others_ipi()
 pick 542d865 kstat: modify kstat_irqs_legacy to be variable sized

and run the rebase. Now you'll have a new lineup with the buggy commit at 
the end. (lets assume there were no conflicts caused by the reordering) 
For example you could get:

 b304542: kstat: modify kstat_irqs_legacy to be variable sized
 d398631: x86: fix broken flush_tlb_others_ipi()
 ab6211f: xen: fix too early kmalloc call
 ef3b48b: cpumask, irq: non-x86 build failures
 9332fcc: irq: initialize nr_irqs based on nr_cpu_ids
 0fa0ebb: irq: allocate irq_desc_ptrs array based on nr_irqs
 e2f4d06: irq: use WARN() instead of WARN_ON().

note how there's new commit IDs starting at ef3b48b - but all previous 
commits (9332fcc, 0fa0ebb, e2f4d06) were preserved.

Now comes 'phase 2': the problematic commit is at the end of the lineup 
and you can fix it in multiple development steps, by editing the buggy 
source and adding it to the commit via:

   git add kernel/file.c
   git commit --amend

Ok?

( Or if you are sure you can fix the bug via a single pass, you can change 
  the 'pick' line to 'edit' and do the editing and 'git commit --amend' 
  right during the rebase. If it's still not perfect it needs another 
  rebase though and it's easy to mess up rebases. )

	Ingo
