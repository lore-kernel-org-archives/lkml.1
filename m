Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZKLLHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZKLLHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZKLLHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:07:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40339 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZKLLHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:07:54 -0500
Date: Thu, 12 Nov 2009 12:07:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
Message-ID: <20091112110741.GC24684@elte.hu>
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain>
 <4AF9BE3A.40409@kernel.org>
 <20091110193705.GA9011@elte.hu>
 <4AF9C402.9040800@kernel.org>
 <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain>
 <4AFA35CB.5030801@kernel.org>
 <20091111113147.GB7487@elte.hu>
 <4AFAAC32.4020104@kernel.org>
 <20091111195751.GA13574@elte.hu>
 <4AFBDF43.3010703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFBDF43.3010703@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> >         if (reserved && pcpu_reserved_chunk) {
> > 
> > into a helper inline function, something like __pcpu_alloc_reserved().
> > 
> > It's a rare special case anyway. It could be changed to return with the 
> > pcpu_lock always taken, so the above branch would look like this:
> > 
> > 	if (unlikely(reserved)) {
> > 		off = __pcpu_alloc_reserved(&chunk, size, align, &err);
> > 		if (off < 0)
> > 			goto fail_unlock;
> > 		goto area_found;
> > 	}
> > 
> > Which is a cleaner flow IMO, and which simplifes pcpu_alloc().
> 
> Hmmm... The thing is that the nesting isn't that deep there [...]

Well, the pcpu_alloc() function is 115 lines which is a bit long. It 
does 2-3 things while a function should try to do one thing.

Putting the reserved allocation into a separate function also makes the 
'main' path of logic more visible and obstructed less by rare details.

The indentation i pinpointed is 4 levels deep:

                                err = "failed to extend area map of "
                                        "reserved chunk";

which is a bit too much IMO - the code starts in the middle of the 
screen, there's barely any space to do anything meaningful.

But there's other line wrap artifacts as well further down:

                                if (pcpu_extend_area_map(chunk,
                                                         new_alloc) < 0) {

But ... there's no hard rules here and i've seen functions where 4 
levels of indentation were just ok. Anyway, i just gave you my opinion, 
and i'm definitely more on the nitpicky side of the code quality 
equilibrium, YMMV.

	Ingo
