Return-Path: <linux-kernel-owner+w=401wt.eu-S933132AbZLNWTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbZLNWTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbZLNWTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:19:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49420 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbZLNWTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:19:11 -0500
Message-ID: <4B26BA4A.7080602@gmail.com>
Date: Mon, 14 Dec 2009 23:20:58 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, arjan@infradead.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org> <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214123636.GA7417@linux-sh.org>
In-Reply-To: <20091214123636.GA7417@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> I don't see anything relating to sparse in that mail. You've effectively
> lumped sparse and constification together in the same camp, but it's
> unclear why this makes constification a better option other than that
> it's simply the option you opted for. All of your arguments "against"
> sparse in that context are equally applicable to constification, so I'll
> reiterate that you haven't sufficiently addressed the sparse angle.
> 
> At present you seem to be the only one convinced that constification is
> the way to go, despite it being highly intrusive and ignoring the
> potential for more favourable and less intrusive options. You've also
> failed to adequately address the issues and suggestsions pointed out by
> others, and until this happens there is little point in posting any
> follow-up patches.
> 
>>> Until such a consensus is reached one way or the other, please refrain
>>> from sending hundreds of patches -- one or two are sufficient for showing
>>> what you want to do until folks are on board with it, as is the typical
>>> nature of mechanical changes.
>> I think there is consensus to constify ops variables as much as
>> possible (e.g., Alexey's similar patches).
>>
>> The discussions in these threads were about constifying the ops structure
>> fields themselves and I already explained why they are useful, see the
>> above link and this one: http://lkml.org/lkml/2009/12/8/492
> 
> And in here as well in the reply to that mail the same criticism exists
> as does the suggestion to look at doing it cleanly in sparse, which
> brings us back to what was already mentioned earlier.

Let me summarise the discussion so far:

As per Al Viro, Arjan and other developers the goal is to force
static allocations and prevent runtime modification of ops structures
(where it is possible, there are always exceptions like ata_port_operations).

The current strategy of constifying variables achieves the second goal only,
it still requires human review to catch violations of the first goal.

This is where consitfying the structure field becomes important: it prevents
direct modifications of runtime allocated ops structures therefore it
gives a strong signal to the programmer that he's trying to do something
undesired (this approach is in fact already used in the kernel, see: iwl_ops).
There is another benefit in that static but non-const ops structures cannot be
directly modified either, therefore it will be easier to make them const later.

Of course both constification efforts can be bypassed, a "clever" programmer can
write code in many ways that will write to otherwise "const" structures.
Nor is it possible to detect all such attempts by tools in fact, it would be
equivalent to solving the halting problem.

Therefore I think that it's a lot easier to have the compiler detect unwanted
direct modifications by constifying the structure fields than use sparse (which,
unlike a compiler, isn't used by everyone and would require more complex changes
than field constification for no real gain). In any case, constifying structure
fields is not exclusive of teaching sparse or other tools like checkpatch about
some bad code constructs, I will try my best on checkpatch.

To wrap it all up: human review will always be required to catch bad code and
we can help the process if we force would-be violators to go to lengths to
bypass the policy and make it easy for the reviewer to notice that something
is up.

> Thinking you have consensus because you don't see a difference and don't
> bother replying to the feedback you've gotten doesn't bode well for the
> future of your patch series or killfile avoidance strategy.

Please let me know whose feedback I didn't address.
--
Emese
