Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbZJOJ0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbZJOJ0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbZJOJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:26:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:45695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbZJOJ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:26:13 -0400
Message-ID: <4AD6EA57.6020105@kernel.org>
Date: Thu, 15 Oct 2009 18:24:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:24:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(microblaze maintainer cc'd, hello)

Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Tejun Heo wrote:
> 
>> @@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
>>   * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
>>   * more efficient.
>>   */
>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>> +#define __ia64_per_cpu_var(var)	var
> 
> IA64 could completely drop the macro? Tony?

Being discussed but I think we should just add sparse annotation there
instead.

>> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
>> index 61abbd2..ec89f2a 100644
>> --- a/arch/microblaze/include/asm/entry.h
>> +++ b/arch/microblaze/include/asm/entry.h
>> @@ -21,7 +21,7 @@
>>   * places
>>   */
>>
>> -#define PER_CPU(var) per_cpu__##var
>> +#define PER_CPU(var) var
> 
> Microblaze too.

This macro is used only in assemblies which wouldn't be covered by
sparse so in this case this patch series actually removes protection,
so I wasn't too sure about ripping the macro off.  Any ideas what we
can do here?  Just kill it?

>> +#define PER_CPU(var, reg)	__percpu_mov_op $var, reg
>> +#define PER_CPU_VAR(var)	var
> 
> Drop X86 PER_CPU_VAR

No can do.  SMP variant isn't null op.

>> -#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
>> -					       "m" (per_cpu__##var))
>> -#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
>> -					       "p" (&per_cpu__##var))
>> -#define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
>> -#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
>> -#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
>> -#define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
>> -#define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
>> -#define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
>> +#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
>> +#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
>> +#define percpu_write(var, val)		percpu_to_op("mov", var, val)
>> +#define percpu_add(var, val)		percpu_to_op("add", var, val)
>> +#define percpu_sub(var, val)		percpu_to_op("sub", var, val)
>> +#define percpu_and(var, val)		percpu_to_op("and", var, val)
>> +#define percpu_or(var, val)		percpu_to_op("or", var, val)
>> +#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
> 
> The percpu_xx definitions are now equal to __this_cpu_xx(). They could be
> dropped for the core.

Yeap, will do so with further patches.

>>  #define __get_cpu_var(var) \
>> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
>> +	(*SHIFT_PERCPU_PTR(&(var), my_cpu_offset))
> 
> == this_cpu_read(var) or this_cpu_write(var, value)
> 
>>  #define __raw_get_cpu_var(var) \
>> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
>> +	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))
> 
> == __this_cpu_read() or this_cpu_write(var, value)
> 
> __raw? Combination of __ and raw? Can we clearly define what each means?
>
>> -	typeof(per_cpu_var(var)) __tmp_var__;				\
>> +	typeof(var) __tmp_var__;					\
>>  	__tmp_var__ = get_cpu_var(var);					\
>>  	put_cpu_var(var);						\
>>  	__tmp_var__;							\
> 
> == this_cpu_read(var)

For all of above comments, yeap, we definitely need to clean all these
up, but let's do that once sparse annotation is working.

> Great work. There is lots more possible cleanup work that could be done
> after this patch has merged.
> 
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

Thanks.

-- 
tejun
