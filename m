Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZIOQDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZIOQDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZIOQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:03:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11416 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZIOQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:03:06 -0400
Message-ID: <4AAFBAA2.3020603@caviumnetworks.com>
Date: Tue, 15 Sep 2009 09:02:42 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for 	!CONFIG_BUG
 case.
References: <4AAEBAC2.1050905@caviumnetworks.com>	 <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com>	 <73c1f2160909141612i32f46361q7430cecf0b68d07b@mail.gmail.com>	 <4AAED18E.7030903@caviumnetworks.com> <73c1f2160909141654w51df78n4f2319cfd2f9362e@mail.gmail.com>
In-Reply-To: <73c1f2160909141654w51df78n4f2319cfd2f9362e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Sep 2009 16:02:43.0297 (UTC) FILETIME=[F56CA510:01CA361D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Mon, Sep 14, 2009 at 7:28 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>> Brian Gerst wrote:
>>> On Mon, Sep 14, 2009 at 5:55 PM, David Daney <ddaney@caviumnetworks.com>
>>> wrote:
>>>> The subject says it all (most).  The only drawback here is that for a
>>>> pre-GCC-5.4 compiler, instead of expanding to nothing we now expand
>>>> BUG() to an endless loop.  Before the patch when configured with
>>>> !CONFIG_BUG() you might get some warnings, but the code would be
>>>> small.  After the patch there are no warnings, but there is an endless
>>>> loop at each BUG() site.
>>>>
>>>> Of course for the GCC-4.5 case we get the best of both worlds.
>>>>
>>>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>>>> Suggested-by: Ingo Molnar <mingo@elte.hu>
>>>> CC: Ingo Molnar <mingo@elte.hu>
>>>> ---
>>>>  include/asm-generic/bug.h |    4 ++--
>>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>>>> index 4b67559..e952242 100644
>>>> --- a/include/asm-generic/bug.h
>>>> +++ b/include/asm-generic/bug.h
>>>> @@ -89,11 +89,11 @@ extern void warn_slowpath_null(const char *file,
>>>> const int line);
>>>>
>>>>  #else /* !CONFIG_BUG */
>>>>  #ifndef HAVE_ARCH_BUG
>>>> -#define BUG() do {} while(0)
>>>> +#define BUG() unreachable()
>>>>  #endif
>>>>
>>>>  #ifndef HAVE_ARCH_BUG_ON
>>>> -#define BUG_ON(condition) do { if (condition) ; } while(0)
>>>> +#define BUG_ON(condition) do { if (condition) unreachable(); } while (0)
>>>>  #endif
>>>>
>>>>  #ifndef HAVE_ARCH_WARN_ON
>>>> --
>>> This seems wrong to me.  Wouldn't you always want to do the endless
>>> loop?  In the absence of an arch-specific method to jump to an
>>> exception handler, it isn't really unreachable.  On gcc 4.5 this would
>>> essentially become a no-op.
>>>
>> Several points:
>>
>> * When you hit a BUG() you are screwed.
>>
>> * When you configure with !CONFIG_BUG you are asserting that you don't want
>> to try to trap on BUG();.
>>
>> The existing code just falls through to whatever happens to follow the
>> BUG().  This is not what the programmer intended, but the person that chose
>> !CONFIG_BUG decided that they would like undefined behavior in order to save
>> a few bytes of code.
>>
>> With the patch one of two things will happen:
>>
>> pre-GCC-4.5) We will now enter an endless loop and not fall through. This
>> makes the code slightly larger than pre patch.
>>
>> post-GCC-4.5) We do something totally undefined.  It will not necessarily
>> fall through to the code after the BUG()  It could really end up doing
>> almost anything.  On the plus side, we save a couple of bytes of code and
>> eliminate some compiler warnings.
>>
>> If you don't like it, don't configure with !CONFIG_BUG.  But the patch
>> doesn't really change the fact that hitting a BUG() with !CONFIG_BUG leads
>> to undefined behavior.  It only makes the case where you don't hit BUG()
>> nicer.
>>
>> David Daney
>>
> 
> Let me rephrase this.  The original BUG() is simply a no-op, not an
> infinite loop.  GCC will optimize it away (and possibly other dead
> code around it).  Adding unreachable() makes the code do potentially
> unpredictable things.

The code already does unpredictable things (also known as undefined 
behavior) without the patch.  Consider this code:

enum values {GOOD, BAD, RUN_NORMALLY};

int foo(int a)
{
	if (a = GOOD)
		return RUN_NORMALLY;
	BUG();
}


void bar(void)
{
	if (foo(BAD) == RUN_NORMALLY)
		do_something_useful();
	else
		irreversibly_damage_hardware();
}


Q: What does this do with CONFIG_BUG?

A: It traps in BUG().

Q: What does this do with !CONFIG_BUG?

A: The compiler issues a warning about reaching the end of a non-void 
function.  At runtime we don't know what happens.

With my patch the answer to the second question changes to:

A: No compiler warnings are issued.  Depending on compiler version code 
may be larger. Runtime behavior depends on compiler version (either an 
endless loop in BUG, or undefined).

Since the behavior of the program when configured !CONFIG_BUG is 
undefined for cases that would trap had CONFIG_BUG be selected, the only 
tangible differences pre and post patch are:

GCC-4.4: No warnings, slightly larger code.

GCC-4.5: No warnings, code should not be any larger.

>  It's not necessary.

Many patches are 'not necessary', the question should be: are they 
desirable.

> The same goes for BUG_ON.
> In that case the test does get optimized away too, but is still needed
> to silence warnings about unused variables, etc.

For the GCC-4.5 case, the patch is even better.  Not only does the 
evaluation of the condition get optimized away, the compiler knows the 
condition is false in the code following the the BUG() and can propagate 
that knowledge into optimizations on the following code.


David Daney
