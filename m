Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZJXJMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZJXJMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZJXJMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:12:13 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53475 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZJXJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:mail-followup-to:cc:subject:references:from:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        b=K0qBcdCdXa3XHP0vyr+T7jgKO/sGPrMMj9/eLvn9N/I7NkADOPzbmzhaM01q/5EZ/r
         W+9+Vjva3HZWOGACnVaCvIk6RAa2w2FF5qUIkhZbibDC2v72TSLlpTdHx/OyGkuDFuEY
         VyUOevClwPDag7tvgkEXhXXoZJa9gG2s0pJTE=
To: David Daney <ddaney@caviumnetworks.com>
Mail-Followup-To: David Daney <ddaney@caviumnetworks.com>,GCC Patches <gcc-patches@gcc.gnu.org>,  wuzhangjin@gmail.com, Adam Nemet <anemet@caviumnetworks.com>,  rostedt@goodmis.org, linux-kernel@vger.kernel.org,  linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>, Ralf Baechle <ralf@linux-mips.org>, Nicholas Mc Guire <der.herr@hofr.at>, rdsandiford@googlemail.com
Cc: GCC Patches <gcc-patches@gcc.gnu.org>, wuzhangjin@gmail.com,
       Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] MIPS: Add option to pass return address location to _mcount. Was: [PATCH -v4 4/9] tracing: add static function tracer support for MIPS
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	<2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	<3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	<ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	<1256138686.18347.3039.camel@gandalf.stny.rr.com>
	<1256233679.23653.7.camel@falcon>
	<4AE0A5BE.8000601@caviumnetworks.com> <87y6n36plp.fsf@firetop.home>
	<4AE232AD.4050308@caviumnetworks.com>
From: Richard Sandiford <rdsandiford@googlemail.com>
Date: Sat, 24 Oct 2009 10:12:06 +0100
In-Reply-To: <4AE232AD.4050308@caviumnetworks.com> (David Daney's message of "Fri\, 23 Oct 2009 15\:48\:13 -0700")
Message-ID: <87my3htau1.fsf@firetop.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.

David Daney <ddaney@caviumnetworks.com> writes:
> Richard Sandiford wrote:
>> David Daney <ddaney@caviumnetworks.com> writes:
>>> Wu Zhangjin wrote:
>>>> On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
>>> [...]
>>>>>> +
>>>>>> +NESTED(_mcount, PT_SIZE, ra)
>>>>>> +	RESTORE_SP_FOR_32BIT
>>>>>> +	PTR_LA	t0, ftrace_stub
>>>>>> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
>>>>> Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
>>>>> the dynamics of C function ABI.
>>>> So, perhaps we can use the saved registers(a0,a1...) instead.
>>>>
>>> a0..a7 may not always be saved.
>>>
>>> You can use at, v0, v1 and all the temporary registers.  Note that for 
>>> the 64-bit ABIs sometimes the names t0-t4 shadow a4-a7.  So for a 64-bit 
>>> kernel, you can use: $1, $2, $3, $12, $13, $14, $15, $24, $25, noting 
>>> that at == $1 and contains the callers ra.  For a 32-bit kernel you can 
>>> add $8, $9, $10, and $11
>>>
>>> This whole thing seems a little fragile.
>>>
>>> I think it might be a good idea to get input from Richard Sandiford, 
>>> and/or Adam Nemet about this approach (so I add them to the CC).
>>>
>>> This e-mail thread starts here:
>>>
>>> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00286.html
>>>
>>> and here:
>>>
>>> http://www.linux-mips.org/archives/linux-mips/2009-10/msg00290.html
>> 
>> I'm not sure that the "search for a save of RA" thing is really a good idea.
>> The last version of that seemed to be "assume that any register stores
>> will be in a block that immediately precedes the move into RA", but even
>> if that's true now, it might not be in future.  And as Wu Zhangjin says,
>> it doesn't cope with long calls, where the target address is loaded
>> into a temporary register before the call.
>> 
>> FWIW, I'd certainly be happy to make GCC pass an additional parameter
>> to _mcount.  The parameter could give the address of the return slot,
>> or null for leaf functions.  In almost all cases[*], there would be
>> no overhead, since the move would go in the delay slot of the call.
>> 
>> [*] Meaning when the frame is <=32k. ;)  I'm guessing you never
>>     get anywhere near that, and if you did, the scan thing wouldn't
>>     work anyway.
>> 
>> The new behaviour could be controlled by a command-line option,
>> which would also give linux a cheap way of checking whether the
>> feature is available.
>> 
>
> How about this patch, I think it does what you suggest.
>
> When we pass -pg -mmcount-raloc, the address of the return address 
> relative to sp is passed in $12 to _mcount.  If the return address is 
> not saved, $12 will be zero.  I think this will work as registers are 
> never saved with an offset of zero.  $12 is a temporary register that is 
> not part of the ABI.

Hmm, well, the suggestion was to pass a pointer rather than an offset,
but both you and Wu Zhangjin seem to prefer the offset.  Is there a
reason for that?  I suggested a pointer because

  (a) they're more C-like
  (b) they're just as quick and easy to compute
  (c) MIPS doesn't have indexed addresses (well, except for a few
      special cases) so the callee is going to have to compute the
      pointer at some stage anyway

(It sounds from Wu Zhangjin's reply like he'd alread suggested the
offset thing before I sent my message.  If so, sorry for not using
that earlier message as context.)

> +  if (TARGET_RALOC)
> +    {
> +      /* If TARGET_RALOC load $12 with the offset of the ra save
> +	 location.  */
> +      if (mips_raloc_in_delay_slot_p())
> +	emit_small_ra_offset = 1;
> +      else
> +	{
> +	  if (Pmode == DImode)
> +	    fprintf (file, "\tdli\t%s,%d\t\t# offset of ra\n", reg_names[12],
> +		     cfun->machine->frame.ra_fp_offset);
> +	  else
> +	    fprintf (file, "\tli\t%s,%d\t\t# offset of ra\n", reg_names[12],
> +		     cfun->machine->frame.ra_fp_offset);
> +	}
> +    }

We shouldn't need to do the delay slot dance.  With either the pointer
((D)LA) or offset ((D)LI) approach, the macro won't use $at, so we can
insert the new code immediately before the jump, leaving the assembler
to fill the delay slot.  This is simpler and should mean that the delay
slot gets filled more often in the multi-insn-macro cases.

Looks good otherwise, but I'd be interested in other suggestions for
the option name.  I kept misreading "raloc" as a typo for "reloc".

Richard
