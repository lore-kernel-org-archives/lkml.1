Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZKKT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZKKT6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZKKT6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:58:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46151 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZKKT57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:57:59 -0500
Date: Wed, 11 Nov 2009 20:57:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091111195751.GA13574@elte.hu>
References: <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain>
 <4AF9B1FD.1010408@kernel.org>
 <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
 <4AF9BE3A.40409@kernel.org>
 <20091110193705.GA9011@elte.hu>
 <4AF9C402.9040800@kernel.org>
 <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
 <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu>
 <4AFAAC32.4020104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFAAC32.4020104@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Ingo Molnar wrote:
> >> I was mostly worrying about introducing unrelated bug while changing. 
> >> Anyways, one patch it is.  I'll route it through tip as suggested by 
> >> Ingo in a few hours.
> > 
> > Btw., i'd suggest you keep it in your percpu tree as usual and send it 
> > to Linus directly - i offered testing for the cleanup patch (and can 
> > pull your patch for such a purpose), it doesnt 'have' to go via -tip.
> 
> Can you please then pull from the following tree for testing?  I'll 
> push it to Linus after a couple of days if nothing explodes.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus
> 
> Thanks.

Sure - pulled it into tip:master for testing earlier today and after a 
few hours of it's looking good so far in x86 runtime tests. I also did 
cross-build testing to a dozen non-x86 architectures and it was fine 
there too.

btw., there's some 80-cols checkpatch warning artifacts in the commit:

+                       if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
+                               err = "failed to extend area map of "
+                                       "reserved chunk";

which suggest that the logic here is perhaps nested a bit too deep. It 
could be improved by moving the reserved allocation branch of 
pcpu_alloc():

        if (reserved && pcpu_reserved_chunk) {

into a helper inline function, something like __pcpu_alloc_reserved().

It's a rare special case anyway. It could be changed to return with the 
pcpu_lock always taken, so the above branch would look like this:

	if (unlikely(reserved)) {
		off = __pcpu_alloc_reserved(&chunk, size, align, &err);
		if (off < 0)
			goto fail_unlock;
		goto area_found;
	}

Which is a cleaner flow IMO, and which simplifes pcpu_alloc().

And the error string should be:

		err = "failed to extend area map of reserved chunk";

(Ignore the checkpatch complaint.)

What do you think?

	Ingo
