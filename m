Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZHOUm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZHOUm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZHOUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:42:26 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:62685 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZHOUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FChqBkc3l8bNTHGD6YQPRlHASFWDKyFJNPcNBc8hKzyrCVgIJSt9pDSRIiWQ+W1XDC
         W5/fDNWc/G06MlM2FeS4283U0nJAScK6FmX84NFSufzBhIp+10fEBYCkSTGAQ2EbNeKa
         MHMDmjn0Lj8AMhnt9PgeJwSc3+wU2Duq0qfUo=
Message-ID: <4A871DAF.10609@gmail.com>
Date: Sat, 15 Aug 2009 22:42:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
References: <20090815134312.GA7533@localdomain.by> <4A86BC96.9040702@gmail.com> <alpine.LFD.2.00.0908150947260.14440@localhost> <20090815141212.GA7692@localdomain.by>
In-Reply-To: <20090815141212.GA7692@localdomain.by>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 04:12 PM, Sergey Senozhatsky wrote:
> On (08/15/09 09:49), Robert P. J. Day wrote:
>> Date: Sat, 15 Aug 2009 09:49:15 -0400 (EDT)
>> From: "Robert P. J. Day" <rpjday@crashcourse.ca>
>> To: Jiri Slaby <jirislaby@gmail.com>
>> cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
>> 	Andrew Morton <akpm@linux-foundation.org>,
>> 	linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
>> User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
>>
>> On Sat, 15 Aug 2009, Jiri Slaby wrote:
>>
>>> On 08/15/2009 03:43 PM, Sergey Senozhatsky wrote:
>>>> Make an arithmetic right shift to divide by power of 2.
>>>
>>> Why? Is out there a compiler not doing that?
>>>
>>> Seems like it should be rather converted to DIV_ROUND_UP.
>>>
> 
>                                  
> It was duscussed, so I'll just copy paste my answer.
> On (08/08/09 09:35), Andi Kleen wrote:
>> DIV should be always slower than a SHIFT.
>>
>> But it has nothing really to do with the CPU. The point is that the compiler
>> always selects a suitable one by itself. Rewriting x / 2 to x >> 1 is
>> one of the easiest exercises in compiler optimizations.
>>
>> The only case when the compiler cannot do this easily by itself is
>> when the dividend is not a constant.

I think Andi (Cced again) meant divisor. When a divisor is constant, you
can always transform division to some of subs/adds/muls/shifts.

>         int width = (vc->vc_font.width + 7) >> 3;
> 
>> That said -Os sometimes screws us up on this, but it's still not worth
>> doing this change manually.
>>
> 
> My point is that it should 'look the same'.
> I mean there are 5
>         int width = (vc->vc_font.width + 7) >> 3;
> *not exactly this one, but vc->vc_font.width (+ 7)? >> 3
> 
> and _only_ one
>         int width = (vc->vc_font.width + 7) / 8;
> 
> 
>>   it does seem like a DIV_ROUND_UP would be better but perhaps another
>> solution would be to define a meaningful macro name for that
>> operation.  if that conversion is going to be done regularly, a macro
>> with an informative name might be in order.  if it's a one-shot
>> operation, though, not much point.
>>
> 
> No, it's not a one-shot.
> 
> grep -c '>>' bitblit.c
> 7

Then please use DIV_ROUND_UP macro (or whatever alias) all over the place.
