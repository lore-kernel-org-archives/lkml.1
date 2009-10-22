Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZJVWRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZJVWRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZJVWRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:17:06 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45448 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZJVWRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:mail-followup-to:cc:subject:references:from:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        b=h61SyMrOGBC4rTshUSUUg73Z5CaKDUI9pmZdhCsxUhGhcZlVK91mGAoAypivYKvTWQ
         E5O0bYUhY6GzTari4FtcMA6k9woANPHo/hdAbX66jHTdkPORIZwpu+SQB39Qo8KlR03w
         uK5jTzXJquP12ZFlZum4K8Ppf+fw+oJjUpjRo=
To: David Daney <ddaney@caviumnetworks.com>
Mail-Followup-To: David Daney <ddaney@caviumnetworks.com>,wuzhangjin@gmail.com,  Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,  linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,  Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>, Nicholas Mc Guire <der.herr@hofr.at>, rdsandiford@googlemail.com
Cc: wuzhangjin@gmail.com, Adam Nemet <anemet@caviumnetworks.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support for MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	<2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	<3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	<ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	<1256138686.18347.3039.camel@gandalf.stny.rr.com>
	<1256233679.23653.7.camel@falcon>
	<4AE0A5BE.8000601@caviumnetworks.com>
From: Richard Sandiford <rdsandiford@googlemail.com>
Date: Thu, 22 Oct 2009 23:17:06 +0100
In-Reply-To: <4AE0A5BE.8000601@caviumnetworks.com> (David Daney's message of "Thu\, 22 Oct 2009 11\:34\:38 -0700")
Message-ID: <87y6n36plp.fsf@firetop.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney@caviumnetworks.com> writes:
> Wu Zhangjin wrote:
>> On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
> [...]
>>>> +
>>>> +NESTED(_mcount, PT_SIZE, ra)
>>>> +	RESTORE_SP_FOR_32BIT
>>>> +	PTR_LA	t0, ftrace_stub
>>>> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
>>> Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
>>> the dynamics of C function ABI.
>> 
>> So, perhaps we can use the saved registers(a0,a1...) instead.
>> 
>
> a0..a7 may not always be saved.
>
> You can use at, v0, v1 and all the temporary registers.  Note that for 
> the 64-bit ABIs sometimes the names t0-t4 shadow a4-a7.  So for a 64-bit 
> kernel, you can use: $1, $2, $3, $12, $13, $14, $15, $24, $25, noting 
> that at == $1 and contains the callers ra.  For a 32-bit kernel you can 
> add $8, $9, $10, and $11
>
> This whole thing seems a little fragile.
>
> I think it might be a good idea to get input from Richard Sandiford, 
> and/or Adam Nemet about this approach (so I add them to the CC).
>
> This e-mail thread starts here:
>
> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00286.html
>
> and here:
>
> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00290.html

I'm not sure that the "search for a save of RA" thing is really a good idea.
The last version of that seemed to be "assume that any register stores
will be in a block that immediately precedes the move into RA", but even
if that's true now, it might not be in future.  And as Wu Zhangjin says,
it doesn't cope with long calls, where the target address is loaded
into a temporary register before the call.

FWIW, I'd certainly be happy to make GCC pass an additional parameter
to _mcount.  The parameter could give the address of the return slot,
or null for leaf functions.  In almost all cases[*], there would be
no overhead, since the move would go in the delay slot of the call.

[*] Meaning when the frame is <=32k. ;)  I'm guessing you never
    get anywhere near that, and if you did, the scan thing wouldn't
    work anyway.

The new behaviour could be controlled by a command-line option,
which would also give linux a cheap way of checking whether the
feature is available.

Richard
