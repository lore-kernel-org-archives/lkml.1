Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYBNT4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYBNT4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYBNT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:56:34 -0500
Received: from r00tworld.com ([212.85.137.21]:57857 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbYBNT4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:56:33 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Feb 2008 20:55:20 +0200
MIME-Version: 1.0
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <47B4AAB8.106.FEA5232@pageexec.freemail.hu>
In-reply-to: <20080214190050.GA32258@elte.hu>
References: <20080214170058.GA2043@elte.hu>, <47B49384.23437.F8FB16A@pageexec.freemail.hu>, <20080214190050.GA32258@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 14 Feb 2008 20:53:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2008 at 20:00, Ingo Molnar wrote:

> > the best practical defense against leaking the canary is to change its 
> > value on every syscall but it has some performance impact in 
> > microbenchmarks.
> 
> yeah, that's not really practical (especially as it would deplete our 
> entropy pool pretty fast would could in some circumstances introduce a 
> higher risk to the system than the risk of a canary leaking).

you don't necessarily have to use the heavy-handed ip id code as it
is used now, random32 is plenty good here.

> I think we can avoid the leakage across tasks by being careful during 
> context-switch time: never calling with the old canary still in the PDA. 
> I think this should be fairly easy as we'd just have to load the new 
> pdaptr in the switch_to() assembly code.

i don't think you have to worry about cross-task leaking at all, a
hypothetical exploit is happy to learn its own canary and that's
actually easier than learning some other task's canary by virtue
of bugs that leak uninitialized struct padding and stuff...

really, the best defense is to reduce the useful lifetime of any
leaked canary, and you can't get better than syscall granularity
without disproportional effort and impact elsewhere (and i'm sure
some would find even this disproportional ;).

> TODO: perhaps all vsyscall functions need to move into separate .o 
> files. (probably academic as the functions affected by that tend to be 
> very simple and do not deal with anything overflowable.)

yeah, i wasn't suggesting it for its security value, more like for
'full coverage'. if such a separation isn't useful otherwise (no idea
if not having the .vsyscall* code along with related kernel code would be
confusing for the reader for example), i'd say this isn't important.

