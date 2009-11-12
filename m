Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZKLL2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZKLL2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZKLL2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:28:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:48894 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbZKLL2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:28:51 -0500
Message-ID: <4AFBF1B0.8010906@kernel.org>
Date: Thu, 12 Nov 2009 20:29:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
References: <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu> <4AF9C402.9040800@kernel.org> <alpine.LFD.2.01.0911101338190.31845@localhost.localdomain> <4AFA35CB.5030801@kernel.org> <20091111113147.GB7487@elte.hu> <4AFAAC32.4020104@kernel.org> <20091111195751.GA13574@elte.hu> <4AFBDF43.3010703@kernel.org> <20091112110741.GC24684@elte.hu>
In-Reply-To: <20091112110741.GC24684@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

11/12/2009 08:07 PM, Ingo Molnar wrote:
> Well, the pcpu_alloc() function is 115 lines which is a bit long. It 
> does 2-3 things while a function should try to do one thing.

I agree for low level / utility functions but for top level functions
which direct the flow of the whole logic, I usually prefer to put them
flat.  To me, that way things seem less obfuscated.

> Putting the reserved allocation into a separate function also makes the 
> 'main' path of logic more visible and obstructed less by rare details.
> 
> The indentation i pinpointed is 4 levels deep:
> 
>                                 err = "failed to extend area map of "
>                                         "reserved chunk";
> 
> which is a bit too much IMO - the code starts in the middle of the 
> screen, there's barely any space to do anything meaningful.

Well, all that's there is error exit.  Surrounding code segment is,

			if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
				err = "failed to extend area map of "
					"reserved chunk";
				goto fail_unlock_mutex;
			}

So, we might as well just do

			err = "failed to extend area map of reserved chunk";
			if (pcpu_extend_area_map(chunk, new_alloc) < 0)
				goto fail_unlock_mutex;

> But there's other line wrap artifacts as well further down:
> 
>                                 if (pcpu_extend_area_map(chunk,
>                                                          new_alloc) < 0) {

This one is uglier and one level deeper than the previous one.  The
resulting nesting was one of the reasons why I factored out
pcpu_extend_area_map() as a whole and switched on the return value but
that obfuscated locking.  Although it nests quite a bit, I don't think
the loop there is too bad.  It shows what it does pretty well.

> But ... there's no hard rules here and i've seen functions where 4 
> levels of indentation were just ok. Anyway, i just gave you my opinion, 
> and i'm definitely more on the nitpicky side of the code quality 
> equilibrium, YMMV.

Indentation and code style are actually something I end up spending
quite some time on and I did think about the second one.  Factoring
out without hiding locking is a bit difficult but if I rename
new_alloc to new_len, I can fit that thing onto a single line but that
would probably require renaming matching local variable in
pcpu_extend_area_map() which will end up generating unnecessary amount
of diff obfuscating the real change.  At that point, I just thought we
could live with one slightly ugly line break.

So, I don't know.  Pros and cons on these things depend too much on
personal tastes (and even mood at the time of writing) to form uniform
standard to follow.

Thanks.

-- 
tejun
