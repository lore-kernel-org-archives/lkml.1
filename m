Return-Path: <linux-kernel-owner+w=401wt.eu-S932797AbYBNWN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797AbYBNWN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759296AbYBNWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:13:45 -0500
Received: from r00tworld.com ([212.85.137.21]:41427 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbYBNWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:13:43 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Feb 2008 23:12:56 +0200
MIME-Version: 1.0
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <47B4CAF8.2430.41D95D@pageexec.freemail.hu>
In-reply-to: <20080214202535.GA25316@elte.hu>
References: <20080214190050.GA32258@elte.hu>, <47B4AAB8.106.FEA5232@pageexec.freemail.hu>, <20080214202535.GA25316@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 14 Feb 2008 23:11:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2008 at 21:25, Ingo Molnar wrote:
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > really, the best defense is to reduce the useful lifetime of any 
> > leaked canary, and you can't get better than syscall granularity 
> > without disproportional effort and impact elsewhere (and i'm sure some 
> > would find even this disproportional ;).
> 
> hm, i think per syscall canaries are really expensive.

it depends on how it's implemented and what expensive is. i'd say
offering this as a config option would make sense for those who want
to turn ssp from a debugging feature (which it is at the moment) into
a security one (i know i will do it once i port the kernel stack
randomization to amd64 in PaX, it's the same code path).

speaking of that, for years PaX has had a feature to randomize the kernel
stack ptr on each kernel->user transition based on rdtsc (using only a few
bits of it obviously). its performance impact is really hard to measure
on anything (i mean, macrobenchmarks) and frankly, people blindly enable
it without having second thoughts about its impact because it just doesn't
matter.

as Arjan said, this ssp canary randomization could be done cheaply from
a PRNG, or heck, even just a simple ror by a random amount from rdtsc on
it will raise the bar enough (and the PRNG state is subject to info leaking
itself whereas rdtsc isn't ;).

in short, i suggest that this per-syscall canary be offered as a config
option at least and use something cheap and not particularly strong
(in crypto terms) just to raise the bar enough that no attacker would
accept the risk of panic'ing the box should the opportunity arise.

> The per function call overhead from stackprotector is already pretty 
> serious IMO,

it's a mov/mov/.../mov/xor/jz on the normal path basically, it's a
few cycles except for the forward jz but that should be easy to fix
in gcc.

with that said, this whole ssp business should have been changed into
return address verification a long time ago (i.e., use the saved return
address as the canary itself), that would detect both stack overflows
and prevent ret2libc style attacks for practical purposes.

> But per syscall canary randomization is something that would be a drag 
> on our null syscall latency forever. I'm really unsure about it. It will 
> also be driven in the wrong direction: people would try to "optimize" 
> the per syscall random number generation which is a constant erosive 
> force on its strength and there's no strong counter-force. (and no clear 
> boundary either 'random32 should be plenty enough' is too vague as 
> limit.)

i think you're getting lost in the details a bit here. the purpose of
changing the canary is to create a guaranteed minimum risk for an attacker
to abuse a leaked canary. obviously a constant (per task) canary means
0 risk for an attacker, so we can get only better than that. how much
better we want to get is mainly limited by what is considered cheap
implementation-wise and 'good enough' from a risk assessment point of
view.

say, if you were to flip a random bit in the canary then a leaked canary
would give an attacker 50% chance to succeed and 50% chance to panic the
box. even that is already high (for an attacker) but you see where i'm
getting at when you increase the randomly changed bits in the canary.

in practice, there's no need to change all 32/64 bits, that's for crypto
nuts only, but for real life attackers there's no difference between 99%
and 99.99999% chances of panic'ing a box (or even a box farm, one alarm
raised is an alarm that will draw attention regardless of how many other
boxes panic'ed). that's why i keep saying that as simple a thing as using
rdtsc/xor/ror/etc is 'plenty good'. i know it's not good for a cryptanalyst
in a generic setting, but this is a special situation (if you fail to guess
you don't get to try infinitely, you fail hard) and we can relax the crypto
requirements.

> So lets perhaps also analyze the security effects of not having per 
> system call canaries and make the best out of it: the main threat is 
> information leaks via padding and similar initialization mistakes [which 
> have almost zero accidental discovery rate], right?

that was only an example for a bug class that could provide/leak such
info, but obviously programmers are a lot more creative in accomplishing
the same.

the problem with kmemcheck is that it's a debugging aid, it obviously
cannot be used in production. also it's not comprehensive when you have
bugs that leak memory like the do_brk (or mremap, i forget) one did: a
valid userland pte kept pointing to a free'd and later reused page. i'm
not saying that one would use such a bug for canary leaking when it can
be abused other ways a lot better, it's just to say that there're many
more bug classes in the kernel than userland.

