Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZAVIf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZAVIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZAVIfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:35:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZAVIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:35:10 -0500
Date: Thu, 22 Jan 2009 09:34:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: fweisbec@gmail.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v2] softlockup: remove hung_task_check_count
Message-ID: <20090122083457.GC7438@elte.hu>
References: <20090121111314.GA23469@elte.hu> <20090122005405.GA6067@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122005405.GA6067@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> > do the need_resched() check first (it's very lighweight) - and thus 
> > only do the heavy ops (get-task-struct & tasklist_lock unlock) if that 
> > is set?
> 
> Wanted to upper-bound the amount of time the lock is held. In order to 
> give others a chance to write_lock the tasklist, released the lock 
> regardless of whether a re-schedule is need.

but this:

> +static void check_hung_reschedule(struct task_struct *t)
> +{
> +	get_task_struct(t);
> +	read_unlock(&tasklist_lock);
> +	if (need_resched())
> +		schedule();
> +	read_lock(&tasklist_lock);
> +	put_task_struct(t);
> +}

does not actually achieve that. Releasing a lock does not mean that other 
CPUs will immediately be able to get it - if the ex-owner quickly 
re-acquires it then it will often succeed in doing so. Perhaps adding a 
cpu_relax() would increase the chance ... but still, it looks a bit weird.

	Ingo
