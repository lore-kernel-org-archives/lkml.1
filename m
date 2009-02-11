Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZBKJeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZBKJeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZBKJeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:34:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49853 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBKJeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:34:13 -0500
Date: Wed, 11 Feb 2009 10:33:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090211093354.GD14265@elte.hu>
References: <20090209010233.GA26444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209010233.GA26444@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> I noticed by pure accident we have ptrace_fork() and friends. This was
> added by "x86, bts: add fork and exit handling", commit
> bf53de907dfdaac178c92d774aae7370d7b97d20
> 
> I can't test this, ds_request_bts() returns -EOPNOTSUPP, but I strongly
> believe this needs the fix. I think something like this program
> 
> 	int main(void)
> 	{
> 		int pid = fork();
> 
> 		if (!pid) {
> 			ptrace(PTRACE_TRACEME, 0, NULL, NULL);
> 			kill(getpid(), SIGSTOP);
> 			fork();
> 		} else {
> 			struct ptrace_bts_config bts = {
> 				.flags = PTRACE_BTS_O_ALLOC,
> 				.size  = 4 * 4096,
> 			};
> 
> 			wait(NULL);
> 
> 			ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACEFORK);
> 			ptrace(PTRACE_BTS_CONFIG, pid, &bts, sizeof(bts));
> 			ptrace(PTRACE_CONT, pid, NULL, NULL);
> 
> 			sleep(1);
> 		}
> 
> 		return 0;
> 	}
> 
> should crash the kernel.
> 
> If the task is traced by its natural parent ptrace_reparented() returns 0
> but we should clear ->btsxxx anyway.
> 
> This is a minimal fix for 2.6.29, we need further cleanups imho.

I've applied this fix to tip:x86/urgent for now, until the other fix
from Markus gets finalized.

	Ingo
