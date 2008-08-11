Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYHKSd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYHKSd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHKSdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:33:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbYHKSdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:33:19 -0400
Date: Mon, 11 Aug 2008 20:33:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
Message-ID: <20080811183300.GB9627@elte.hu>
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl> <48A05EB1.3050508@keyaccess.nl> <20080811164508.GA18969@lenovo> <48A074D1.4070803@keyaccess.nl> <20080811174147.GO4524@elte.hu> <48A07FC1.5040806@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A07FC1.5040806@keyaccess.nl>
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


* Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 11-08-08 19:41, Ingo Molnar wrote:
>
>> * Rene Herman <rene.herman@keyaccess.nl> wrote:
>
>>> Ah, I was unaware of that difference, thank you. Ingo, can you 
>>> replace  the previous incarnation with this one?
>>
>> sure - but some other commits were queued already so i've applied the  
>> delta fix below.
>
> Thanks and fine ofcourse but from the Cheats 'R Us GIT handbook, when  
> there's n patches on top of the one I want to edit:
>
> $ mkdir tmp
> $ git format-patch -o tmp HEAD~n
> $ git reset --hard HEAD~n
> $ git reset --soft HEAD^
> <fix>
> $ git commit -a -c ORIG_HEAD
> $ git am tmp/*
> $ rm -rf tmp
>
> Just in case someone finds it interesting... :-)

i think something like this would do it as well:

    git-rebase -i HEAD~$[n+1]

Change the patch you want to edit from 'pick' to 'edit', and do a "git 
commit --amend" to fix it up and then a "git rebase continue" to reapply 
the other n patches ontop of the changed patch. (This is straight from 
the Cheats 'R Us GIT handbook, second edition ;-)

The problem with rebasing though is that it does not interact with 
normal Git workflows very nicely. Someone might have based further work 
on those sha1's that we now change under them. When that further work is 
backmerged later on we have overlapping sha1's.

There are two further specific non-Git-workflow arguments in favor of 
the delta patch as well:

- in this case your first change was the obvious one and your NULL fix 
  and your cleanup to the parameter expose a fundamental weakness of
  early_param conversions - and i think highlighting that as separate 
  commits might give someone ideas to improve the early_param() 
  facility, if they see the fix patterns.

- Also, the NULL condition is obscure, so there's no bisection breakage
  risk and it's the easiest for me to do append-only patches. The effort
  and thought process you and Cyrill have put into it deserve a separate
  commit as well anyway - and others might learn from it when looking at
  logs.

	Ingo
