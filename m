Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbXCPP3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbXCPP3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 11:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXCPP3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 11:29:12 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47528 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXCPP3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 11:29:11 -0400
Message-ID: <45FAB6C5.8050302@student.ltu.se>
Date: Fri, 16 Mar 2007 16:24:53 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [RFC] A need for "yesno"-function? (and "cleanup" of kernel.h) (was:
 Re: [KJ] [RFC] A need for a "yesno"-function?)
References: <45F95351.60308@student.ltu.se> <39e6f6c70703152036m778ea054gf32723d0eda2be68@mail.gmail.com>
In-Reply-To: <39e6f6c70703152036m778ea054gf32723d0eda2be68@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added LKML to the Cc: to see if there is someone there who also have any 
comments...

Arnaldo Carvalho de Melo wrote:
> On 3/15/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>> Hi
>>
>> Was just checking up the 'sparse' when I saw something like "abc"[value]
>> and thought: what about the (statement) ? "yes" : "no" I have seen in
>> the kernel.
>>
>> Ran:
>> grep -Enr "\?.*y.*\:.*n" *
>> and to my surprise, it was not so false-positive-prone and there are
>> many who does it. (Piping it to "grep yes" resulted in 153 hits) So I
>> thought, if we could standardize this and eliminate some jmp-commands
>> while doing it (the compiler should make the functions below inline), it
>> might be interesting.
>>
>> char yesno_chr(const bool value)
>> {
>>         return "ny"[value];
>> }
>>
>> char *yesno_str(const bool value)
>> {
>>         return &"no\0yes"[3 * value];
>> }
>>
>>
>> (there may be better names for them)
>> I believe this should be slightly faster. I wrote two programs (one for
>> each approach) and used 'time' while running them, and in a loop of
>> 1000,000 I found the above to be slightly faster, but the variations
>> between runs were larger.
>> So maybe it is as well to write: return value ? "yes" : "no"; but i
>> think there is a need for this kind of functions at least.
>>
>> Thoughts?
>
> The function makes sense, how you implement it? Something simple as
> this is hardly on a fast path 8)
True, but every cycled wasted... ;)
But a (condition) ? "yes" : "no" is preferable here, I guess (as it is 
more readable). The big problem is, where to put it? Seems wrong to put 
in <linux/string.h> since it appear to be a replica of userspace's 
<string.h> (otherwise, why put mem*-functions in there?).
A new file? What would it be then, "string_generic.h" maybe, and perhaps 
put in the pr_(info/debug), KERN_(WARN/...) and v?printk() (well, all 
those functions) in there. This means it will have to be included by 
<linux/kernel.h> but I think it would be a good thing to split out a few 
functions from it.

Just putting some ideas out there, any suggestions?

Richard Knutsson

