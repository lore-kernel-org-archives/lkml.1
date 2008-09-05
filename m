Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbYIEPnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbYIEPnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYIEPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:42:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbYIEPmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:42:51 -0400
Date: Fri, 5 Sep 2008 17:42:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905154221.GF10292@elte.hu>
References: <20080905114233.GA27878@elte.hu> <48C11F66.18988.341780A@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C11F66.18988.341780A@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 5 Sep 2008 at 13:42, Ingo Molnar wrote:
> > The other, more fundamental problem that nobody has mentioned so far is 
> > that the check returns -ENOSYS and thus makes rootkit attacks _more 
> > robust_ and hence more likely!
> > 
> > The far better solution would be to insert uncertainty into the 
> > picture: some sort of low-frequency watchdog [runs once a second or 
> > so] that tries to hide itself from the general kernel scope as much 
> > as possible, perhaps as ELF-PIC code at some randomized location, 
> > triggered by some frequently used and opaque kernel facility that an 
> > attacker can not afford to block or fully filter, and which would 
> > just check integrity periodically and with little cost.
> 
> there's that adage about history being repeated by those not knowing it ;)
> for details see the series based around bypassing Vista's PatchGuard at:
> 
>   http://uninformed.org/?v=3
>   http://uninformed.org/?v=6
>   http://uninformed.org/?v=8

i think Linux is fundamentally different here as we have the source 
code, and could apply the randomization technique i mentioned:

> > [ It would be nice to have a 'randomize instruction scheduling' 
> >   option for gcc, to make automated attacks that recognize specific 
> >   instruction patterns less reliable. ]

and every box where it matters we could have a _per box_ randomized 
kernel image in essence, with non-essential symbols thrown away, and 
with a few checks inserted in random locations - inlined and in essence 
unrecognizable from the general entropy of randomization.

Not that a randomizing compiler which inserts true, hard to eliminate 
entropy would be easy to implement. But once done, the cat and mouse 
game is over and the needle is hidden in the hay-stack. At least as long 
as transparent rootkits are involved.

a successful attack that wants to disable the checks reliably would have 
to patch the IDT and would have to emulate full kernel execution and 
would have to detect the pattern of an alert on the hardware API level - 
as that would be the only reliably observable output of the system. 
Besides being impractical at best, at minimum a huge slow-down would 
occur.

the only other option would be for a rootkit to transparently switch to 
another, new, non-checked kernel image on the fly, while keeping all 
user-space context safe. That's a feature Linux would like to have 
anyway ;-) [and this could be made really difficult as well if gcc 
inserted a modest amount of per kernel random noise in the layout of all 
data structures / field offsets.]

	Ingo
