Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZJPGF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZJPGF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZJPGFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:05:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:13089 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZJPGFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:05:54 -0400
Message-ID: <4AD80CD6.7030204@monstr.eu>
Date: Fri, 16 Oct 2009 08:04:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org>
In-Reply-To: <4AD6EA57.6020105@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> (microblaze maintainer cc'd, hello)

Hi,

where is git repo with that patches?

Thanks
Michal

> 
> Christoph Lameter wrote:
>> On Wed, 14 Oct 2009, Tejun Heo wrote:
>>
>>> @@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
>>>   * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
>>>   * more efficient.
>>>   */
>>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>>> +#define __ia64_per_cpu_var(var)	var
>> IA64 could completely drop the macro? Tony?
> 
> Being discussed but I think we should just add sparse annotation there
> instead.
> 
>>> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
>>> index 61abbd2..ec89f2a 100644
>>> --- a/arch/microblaze/include/asm/entry.h
>>> +++ b/arch/microblaze/include/asm/entry.h
>>> @@ -21,7 +21,7 @@
>>>   * places
>>>   */
>>>
>>> -#define PER_CPU(var) per_cpu__##var
>>> +#define PER_CPU(var) var
>> Microblaze too.
> 
> This macro is used only in assemblies which wouldn't be covered by
> sparse so in this case this patch series actually removes protection,
> so I wasn't too sure about ripping the macro off.  Any ideas what we
> can do here?  Just kill it?
> 
>>> +#define PER_CPU(var, reg)	__percpu_mov_op $var, reg
>>> +#define PER_CPU_VAR(var)	var
>> Drop X86 PER_CPU_VAR
> 
> No can do.  SMP variant isn't null op.
> 
>>> -#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
>>> -					       "m" (per_cpu__##var))
>>> -#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
>>> -					       "p" (&per_cpu__##var))
>>> -#define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
>>> -#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
>>> -#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
>>> -#define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
>>> -#define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
>>> -#define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
>>> +#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
>>> +#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
>>> +#define percpu_write(var, val)		percpu_to_op("mov", var, val)
>>> +#define percpu_add(var, val)		percpu_to_op("add", var, val)
>>> +#define percpu_sub(var, val)		percpu_to_op("sub", var, val)
>>> +#define percpu_and(var, val)		percpu_to_op("and", var, val)
>>> +#define percpu_or(var, val)		percpu_to_op("or", var, val)
>>> +#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
>> The percpu_xx definitions are now equal to __this_cpu_xx(). They could be
>> dropped for the core.
> 
> Yeap, will do so with further patches.
> 
>>>  #define __get_cpu_var(var) \
>>> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
>>> +	(*SHIFT_PERCPU_PTR(&(var), my_cpu_offset))
>> == this_cpu_read(var) or this_cpu_write(var, value)
>>
>>>  #define __raw_get_cpu_var(var) \
>>> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
>>> +	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))
>> == __this_cpu_read() or this_cpu_write(var, value)
>>
>> __raw? Combination of __ and raw? Can we clearly define what each means?
>>
>>> -	typeof(per_cpu_var(var)) __tmp_var__;				\
>>> +	typeof(var) __tmp_var__;					\
>>>  	__tmp_var__ = get_cpu_var(var);					\
>>>  	put_cpu_var(var);						\
>>>  	__tmp_var__;							\
>> == this_cpu_read(var)
> 
> For all of above comments, yeap, we definitely need to clean all these
> up, but let's do that once sparse annotation is working.
> 
>> Great work. There is lots more possible cleanup work that could be done
>> after this patch has merged.
>>
>> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Thanks.
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
