Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZDVNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZDVNmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZDVNmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:42:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbZDVNmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:42:04 -0400
Message-ID: <49EF1E99.7070503@suse.com>
Date: Wed, 22 Apr 2009 09:41:45 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
References: <49E89D1B.7060800@suse.com> <49E9904A.5030201@web.de> <49EA2F81.7030302@suse.com> <20090418200623.GA27294@elte.hu> <49EA373A.8060105@web.de> <20090418203227.GC30144@elte.hu> <49EA3C28.9010209@web.de> <20090422101950.GA32009@alberich.amd.com>
In-Reply-To: <20090422101950.GA32009@alberich.amd.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Herrmann wrote:
> On Sat, Apr 18, 2009 at 10:46:32PM +0200, Jan Kiszka wrote:
>> Ingo Molnar wrote:
>>> * Jan Kiszka <jan.kiszka@web.de> wrote:
>>>
>>>> Ingo Molnar wrote:
>>>>> * Jeff Mahoney <jeffm@suse.com> wrote:
>>>>>
>>>>>>> Hmmmmm. That somehow reminds me of what I thought I had to fix in the
>>>>>>> HPET emulation of QEMU just recently [1] - because of 2.6.30-rc's behavior.
>>>>>>>
>>>>>>> Could you try if writing 'delta' a second time makes any difference on
>>>>>>> that box?
>>>>>>>
>>>>>>> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>>>>>>> index 648b3a2..523d72b 100644
>>>>>>> --- a/arch/x86/kernel/hpet.c
>>>>>>> +++ b/arch/x86/kernel/hpet.c
>>>>>>> @@ -324,6 +324,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
>>>>>>>  		       HPET_TN_SETVAL | HPET_TN_32BIT;
>>>>>>>  		hpet_writel(cfg, HPET_Tn_CFG(timer));
>>>>>>>  		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>>>>>> +		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>>>>>>  		hpet_start_counter();
>>>>>>>  		hpet_print_config();
>>>>>>>  		break;
>>>>>>>
>>>>>> Thanks, Jan.
>>>>>>
>>>>>> That fixed it for me.
>>>>> I've queued it up (and i've got a test-system that might be affected 
>>>>> by a similar problem - it shows a similar crash very rarely), but it 
>>>>> would be nice to know why this duplicate writeout makes a 
>>>>> difference. Jan?
>>>>>
>>>>> 	Ingo
>>>> Well, if you look at the HPET spec [1], you first find the explanation
>>>> of the Tn_VAL_SET_CNF bit (HPET_TN_SETVAL):
>>>>
>>>> "[...] By writing this bit to a 1, the software is then allowed to
>>>> directly set a periodic timer's accumulator."
>>>>
>>>> That may sound like "you write to the comparator register if 0, and if
>>>> 1, you set the accumulator". That's also how HPET was emulated in QEMU
>>>> so far.
>>>>
>>>> But then you read on about changing the period of a running timer:
>>>>
>>>> "If the software resets the main counter, the value in the comparator’s
>>>> value register needs to reset as well. This can be done by setting the
>>>> Tn_VAL_SET_CNF bit. Again, to avoid race conditions, this should be
>>>> done with the main counter halted. The following usage model is expected:
>>>> 1) Software clears the GLOBAL_ENABLE_CNF bit to prevent any interrupts
>>>> 2) Software Clears the main counter by writing a value of 00000000h to it.
>>>> 3) Software sets the TIMER0_VAL_SET_CNF bit.
>>>> 4) Software writes the new value in the TIMER0_COMPARATOR_VAL register
>>>> 5) Software sets the GLOBAL_ENABLE_CNF bit to enable interrupts."
>>>>
>>>> And that somehow sounds like you only need to write the new period once,
>>>> with Tn_VAL_SET_CNF = 1.
>>>>
>>>> I bet now that both interpretations are implemented in silicon somewhere
>>>> out there - but I'm all ears to learn the right one (and potentially
>>>> re-fix QEMU).
>>>>
>>>> Jan
>>>>
>>>> [1] http://www.intel.com/hardwaredesign/hpetspec_1.pdf
>>> i might be a bit slow today, but how does the above transform into:
>>>
>>>   		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>> 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>>
>>> ? It sets the same register twice.
>> No, sorry, I missed to cite also this from the Tn_SET_VAL_CFG
>> explanation: "Software does NOT have to write this bit back to 0 (it
>> automatically clears)." So the second write will already take place
>> without it.
>>
>>> I'm totally happy if it does transform into that under some quirky 
>>> interpretation. Since it solved the problem for Jeff, we'll likely 
>>> add it even if there's no actual explanation ;-) But it would be 
>>> nice to somehow come up with a line of reasoning that ends with:
>>>
>>>  ... and for that reason, we set the value twice:
>>>
>>>   		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>> 		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
>>>
>>> right?
>>>
>>> 	Ingo
>> I'd like to give someone from AMD or Intel or whoever already
>> implemented such a logic a chance to comment on it. If this doesn't
>> happen, you may add:
> 
> I didn't implement logic but checked the AMD 81xx documentation.  And
> this exactly describes that depending on HPET_TN_SETVAL either
> accumulator or comparator is set. That is the reason why my last HPET
> patch broke HPET on that chipset. I've provided a patch to partially
> revert that commit. See
> 
> http://marc.info/?l=linux-kernel&m=124033700530097
> 
> The patch was successfully verified for bugzilla
> http://bugzilla.kernel.org/show_bug.cgi?id=12961
> 
> IMHO it should be applied asap to tip tree.

Just to chime in here, my system works with this patch as well.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknvHpkACgkQLPWxlyuTD7IrOACgjzfCJ2XkFNJCRFOpbEg/Vv5v
VtgAnAnXuZETej+f5z4WjGosm7RcGIcW
=5f/F
-----END PGP SIGNATURE-----
