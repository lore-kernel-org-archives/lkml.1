Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXGHNf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXGHNf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 09:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbXGHNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXGHNfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:35:48 -0400
Date: Sun, 8 Jul 2007 15:35:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
Message-ID: <20070708133539.GA12597@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11838994974161-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> +#ifdef CONFIG_SCHED_KVM
> +static __read_mostly struct sched_kvm_hooks kvm_hooks;
> +#endif

please just add a current->put_vcpu() function pointer instead of this 
hooks thing.

>  static inline void prepare_task_switch(struct rq *rq, struct task_struct *next)
>  {
> +	unload_kvm_vcpu(current);
>  	prepare_lock_switch(rq, next);
>  	prepare_arch_switch(next);
>  }
> @@ -1860,6 +1912,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	prev_state = prev->state;
>  	finish_arch_switch(prev);
>  	finish_lock_switch(rq, prev);
> +	reload_kvm_vcpu(current);

ok, this looks certainly cheap enough from a scheduler POV, and it 
cleans up the whole KVM/scheduling interaction quite nicely. (I'd not 
bother with tweaking the migration logic, there's enough incentive for 
the scheduler to keep tasks from migrating unnecessarily.)

	Ingo
