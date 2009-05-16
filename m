Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbZEPP0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbZEPP0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZEPP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:26:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbZEPP01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:26:27 -0400
Date: Sat, 16 May 2009 08:23:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Willy Tarreau <w@1wt.eu>
cc: Ingo Molnar <mingo@elte.hu>, security@kernel.org, Linux@hera.kernel.org,
       stable@kernel.org, Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan@hera.kernel.org, List <linux-kernel@vger.kernel.org>,
       Alan@hera.kernel.org, Eric Paris <eparis@redhat.com>,
       Jake Edge <jake@lwn.net>, linux-security-module@vger.kernel.org,
       mingo@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
In-Reply-To: <20090516135828.GA25283@1wt.eu>
Message-ID: <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain>
References: <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar>
 <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain> <20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu> <20090516103909.GB6261@elte.hu> <20090516135828.GA25283@1wt.eu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 May 2009, Willy Tarreau wrote:
> 
> I don't agree with your point. It is good when the user must choose
> between performance and security.

Well, quite frankly, historically "get_random_int()" has been exactly 
that.

It's based very much on top of the random number generator for networking, 
where performance was a primary goal. It's why the code has that 
re-seeding with "real" randomness that happens once a minute (or 
whatever): exactly because "real" randomness was too expensive (and would 
deplete the entropy pool).

So "get_random_int()" has _always_ been about a choice between performance 
and security. Ok, it's not been a "user" choice, but the thing is, most 
users really aren't capable of that choice - they may not think they care, 
until they get hacked (and not even necessarily then - the _bulk_ of 
hacked computers probably end up being used for DDoS kind of things, so 
the user itself is not even the primary target).

So I don't think that there are "insecure" and "secure" users - yes, 
there are people who care more, and people who care less, but we need to 
protect the people who care less even just to protect the people who care 
more ;)

But there very much _are_ performance vs "strength of hash" issues. And 
historically, "get_random_int()" has leaned towards the performance thing. 
It's just that it had a really outrageously stupid weakness that wasn't 
even really helping performance.

I think we've fixed the "outrageously stupid" part. It would certainly be 
good to make it even better.

And yes, giving out more of our pool (by remembering which part we've 
already given out) would make it possible to use a more expensive hash.

But at the same time, I personally suspect that it would be _much_ easier 
to attack the hash if we actually gave out the whole 16 bytes (over 
several iteration), when compared to what we do now (only give out a small 
part and then re-hash). I can't back that up with any proofs, though, but 
I suspect it's much harder to re-generate the hash if you never see more 
than a very small part of the output.

(That's especially true since whatever we do, the _one_ thing we can never 
do is to actually hide what hash we use. We can hide the data, but we 
can't hide the code. Others depend on also making it harder to guess 
even what the algorithm for the hash itself is).

			Linus
