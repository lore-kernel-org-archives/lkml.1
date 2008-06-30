Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbYF3Tag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbYF3Tag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYF3Ta0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:30:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbYF3TaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:30:23 -0400
Date: Mon, 30 Jun 2008 21:29:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 25/39] merge common parts of uaccess.
Message-ID: <20080630192954.GB6584@elte.hu>
References: <1214602486-17080-21-git-send-email-gcosta@redhat.com> <1214602486-17080-22-git-send-email-gcosta@redhat.com> <1214602486-17080-23-git-send-email-gcosta@redhat.com> <1214602486-17080-24-git-send-email-gcosta@redhat.com> <1214602486-17080-25-git-send-email-gcosta@redhat.com> <1214602486-17080-26-git-send-email-gcosta@redhat.com> <20080630063030.GA31336@elte.hu> <48692A76.70304@redhat.com> <20080630185311.GB27398@elte.hu> <48692D58.7090208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48692D58.7090208@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo Molnar wrote:
>> * Glauber Costa <gcosta@redhat.com> wrote:
>>
>>> Ingo Molnar wrote:
>>>> * Glauber Costa <gcosta@redhat.com> wrote:
>>>>
>>>>> common parts of uaccess_32.h and uaccess_64.h
>>>>> are put in uaccess.h.
>>>> -tip testing found that it causes this build failure:
>>>>
>>>>   fs/binfmt_aout.c: Assembler messages:
>>>>   fs/binfmt_aout.c:152: Error: suffix or operands invalid for `cmp'
>>>>
>>>> with:
>>>>
>>>>   http://redhat.com/~mingo/misc/config-Mon_Jun_30_08_17_42_CEST_2008.bad
>>>>
>>>> and comparing the 32-bit and unified version is not simple and the  
>>>> commit is rather large.
>>>>
>>>> I'm sure the fix is simple, but this bug shows a structural problem 
>>>> with this unification patch. The proper way to unify files is to 
>>>> first bring both the 32-bit and the 64-bit version up to a unified 
>>>> form via  finegrained changes, so that uaccess_32.h and 
>>>> uaccess_64.h becomes  exactly the same file.
>>>>
>>>> ... _then_ only, in a final 'mechanic unification' step the two 
>>>> files  are merged into uaccess.h. (but no change is done to the 
>>>> content)
>>>>
>>>> If anything breaks during such a series it's bisectable to a  
>>>> finegrained patch on either the 32-bit or the 64-bit side. If this  
>>>> commit was shaped that way i could now report to you the exact  
>>>> bisection result - instead of this too-broad bisection result.
>>>>
>>>> So please rework this commit in that fashion (not just to fix this  
>>>> breakage but in anticipation of future commits) - uaccess.h is 
>>>> central  enough for us to be super careful about it.
>>>>
>>>> 	Ingo
>>> Fair.
>>>
>>> However, as I wrote in the first patch of the series, I'm not doing a 
>>>  complete unification of uaccess.h. Part of it is left for future 
>>> work,  since it's a little bit trickier.
>>>
>>> So I didn't have the option of a mechanical move. I did tried, 
>>> however,  to make sure this patch was only a code move, with 
>>> everything that is  going to the common file being equal in both 
>>> files.
>>>
>>> Needless to say, I failed. ;-) This was for a very tiny piece, but still...
>>>
>>> The options I see are:
>>>
>>> * to redo the uaccess.h unification this way, making sure a diff  
>>> between the diffs of the arch-files report nothing different, or: * 
>>> to remove the topmost patches that touches uaccess*.h, and leave only 
>>> the ones that integrate the .c and .S files, until I can really 
>>> integrate the whole of it.
>>>
>>> For the second, however, although I was careful to make incremental  
>>> changes, some small differences may exist. Examples of these  
>>> differences are places in which I introduce a few ifdefs. It's close  
>>> to nothing, but still not mechanical. Because of that, you might want 
>>> me to redo the whole series.
>>>
>>> Your call.
>>
>> well the primary worry is the build failure with gcc 4.3.1 that i've  
>> posted. If that's simple to fix we could re-try with your existing  
>> series.
>>
>> But to be defensive it's alway useful to move one component at a time.  
>> Even if you dont end up doing a mechanical unification - the stuff you  
>> move you should be able to claim to be exactly identical. I.e. the 
>> final step can be mechanic in that it unifies exactly the same content 
>> (even though both files still have remaining bits).
>>
>> Then we'll end up with nice bisection reports to the specific area that 
>> is impacted by a problem.
>>
>> 	Ingo
>
> I already have a fix for that. But I'll repost it in a way in which I 
> can claim the (part of the) files to be identical. For now, can you 
> trim the tree at that point? I think it's the best option.

sounds good. Could you git branch for that, and post the pull request 
plus the shortlog+diffstat to lkml?

To construct that branch you can merge any subset of the existing 
tip/x86/unify-lib series into that. I.e. you can cut the tree yourself 
at the point you find most appropriate - and we can then reset 
tip/x86/unify-lib and pull your tree into it.

Due to the test failure the topic is not integrated yet externally so it 
has no append-only constraints.

> As for bisection, note that I did everything with bisection in mind, 
> so I do know the importance of it. It's more a failure than a 
> fundamental mistake.

yeah, i know that and i'm not complaining :)

	Ingo
