Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZINXy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZINXy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 19:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZINXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 19:54:56 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61417 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbZINXyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 19:54:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pz4xa3MjfSIKdnkiWtInodCUANrauJ8glcQ/6cfTq3uhV4SSWcJIXcNnXYssIRqYSv
         De+5tOT8oVRcGFx7J5QcjcWtpA1+Fq6ptPitrBcx/PnWKjRxIgLthKm3RLwHe/Wu2hvW
         ewkwtM5NLzyje7ZCf3RwHtajag8yE0y+z8sFw=
MIME-Version: 1.0
In-Reply-To: <4AAED18E.7030903@caviumnetworks.com>
References: <4AAEBAC2.1050905@caviumnetworks.com>
	 <1252965340-31735-11-git-send-email-ddaney@caviumnetworks.com>
	 <73c1f2160909141612i32f46361q7430cecf0b68d07b@mail.gmail.com>
	 <4AAED18E.7030903@caviumnetworks.com>
Date: Mon, 14 Sep 2009 19:54:57 -0400
Message-ID: <73c1f2160909141654w51df78n4f2319cfd2f9362e@mail.gmail.com>
Subject: Re: [PATCH 11/11] Use unreachable() in asm-generic/bug.h for 
	!CONFIG_BUG case.
From: Brian Gerst <brgerst@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 7:28 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> Brian Gerst wrote:
>>
>> On Mon, Sep 14, 2009 at 5:55 PM, David Daney <ddaney@caviumnetworks.com>
>> wrote:
>>>
>>> The subject says it all (most).  The only drawback here is that for a
>>> pre-GCC-5.4 compiler, instead of expanding to nothing we now expand
>>> BUG() to an endless loop.  Before the patch when configured with
>>> !CONFIG_BUG() you might get some warnings, but the code would be
>>> small.  After the patch there are no warnings, but there is an endless
>>> loop at each BUG() site.
>>>
>>> Of course for the GCC-4.5 case we get the best of both worlds.
>>>
>>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>>> Suggested-by: Ingo Molnar <mingo@elte.hu>
>>> CC: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  include/asm-generic/bug.h |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
>>> index 4b67559..e952242 100644
>>> --- a/include/asm-generic/bug.h
>>> +++ b/include/asm-generic/bug.h
>>> @@ -89,11 +89,11 @@ extern void warn_slowpath_null(const char *file,
>>> const int line);
>>>
>>>  #else /* !CONFIG_BUG */
>>>  #ifndef HAVE_ARCH_BUG
>>> -#define BUG() do {} while(0)
>>> +#define BUG() unreachable()
>>>  #endif
>>>
>>>  #ifndef HAVE_ARCH_BUG_ON
>>> -#define BUG_ON(condition) do { if (condition) ; } while(0)
>>> +#define BUG_ON(condition) do { if (condition) unreachable(); } while (0)
>>>  #endif
>>>
>>>  #ifndef HAVE_ARCH_WARN_ON
>>> --
>>
>> This seems wrong to me.  Wouldn't you always want to do the endless
>> loop?  In the absence of an arch-specific method to jump to an
>> exception handler, it isn't really unreachable.  On gcc 4.5 this would
>> essentially become a no-op.
>>
>
> Several points:
>
> * When you hit a BUG() you are screwed.
>
> * When you configure with !CONFIG_BUG you are asserting that you don't want
> to try to trap on BUG();.
>
> The existing code just falls through to whatever happens to follow the
> BUG().  This is not what the programmer intended, but the person that chose
> !CONFIG_BUG decided that they would like undefined behavior in order to save
> a few bytes of code.
>
> With the patch one of two things will happen:
>
> pre-GCC-4.5) We will now enter an endless loop and not fall through. This
> makes the code slightly larger than pre patch.
>
> post-GCC-4.5) We do something totally undefined.  It will not necessarily
> fall through to the code after the BUG()  It could really end up doing
> almost anything.  On the plus side, we save a couple of bytes of code and
> eliminate some compiler warnings.
>
> If you don't like it, don't configure with !CONFIG_BUG.  But the patch
> doesn't really change the fact that hitting a BUG() with !CONFIG_BUG leads
> to undefined behavior.  It only makes the case where you don't hit BUG()
> nicer.
>
> David Daney
>

Let me rephrase this.  The original BUG() is simply a no-op, not an
infinite loop.  GCC will optimize it away (and possibly other dead
code around it).  Adding unreachable() makes the code do potentially
unpredictable things.  It's not necessary.  The same goes for BUG_ON.
In that case the test does get optimized away too, but is still needed
to silence warnings about unused variables, etc.

--
Brian Gerst
