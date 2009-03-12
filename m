Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZCLL4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZCLL4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZCLL4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:56:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZCLL4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:56:21 -0400
Date: Thu, 12 Mar 2009 12:55:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86-64: fix unwind annotations in entry_64.S
Message-ID: <20090312115501.GA10391@elte.hu>
References: <49B8F2DF.76E4.0078.0@novell.com> <20090312104834.GA30204@elte.hu> <49B8FE3C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8FE3C.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> > The current annotations might be completely broken but at 
> > least they _look_ structured and attempt to bring some order 
> > into the CFI annotations chaos.
> 
> There was no chaos. Everything was working fine (and was 
> understandable to someone familiar with CFI annotations). 
> [...]

Well, in the patch you remove a ton of incorrect annotations, 
which all came from the old code. So the old code was all but 
fine - it was ugly and kept breaking all the time.

The thing is, we were this -->.<-- close to removing _all_ CFI 
annotations from x86 assembly files about a year ago. I actually 
wrote all the patches for that and committed them back then.

The reason: they made the assembly code even harder to read and 
distracted from the primary, functional purpose of the code - 
which is functionality. Writing assembly code is hard enough, we 
dont need hundreds of additional CFI annotations to obscure them 
as well.

So when you add back CFI annotations this should be your main 
driving principle: make them as unintrusive as possible. Merge 
them to existing frame layout macros wherever possible. Dont add 
raw CFI annotations. You dont seem to understand and respect any 
of these principles.

You seem to regard them as on par with code but they are not. 
They are at most an afterthought and we will not tolerate them 
if they look ugly - and heck does your patch look ugly.

So we want to hide the CFI details as much as possible 
technically, and make it all as self-maintaining as possible.

Document each and every type of annotation and perhaps also 
write up a small blurb in one of the include files about the 
rules and practices needed for good CFI annotations. That way 
you teach others how to keep it all working fine. Perhaps think 
about writing a KGDB drivn self-test that finds CFI annotation 
bugs - _anything_ that brings this code out of obscurity.

I dont mind quirky features that external entities like your 
dwarf2 unwinder rely on - as long as they benefit the code and 
as long as you participate in the process and as long a you are 
willing to structure it all in a clean way. Coming out of the 
corporate woodwork every 6 months and complaining that "it is 
broken currently" and then going back into hiding without 
changing the dynamics of the code is not enough.

	Ingo
