Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0BNXFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:05:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab0BNXFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:05:50 -0500
Message-ID: <4B7881AC.5070209@redhat.com>
Date: Mon, 15 Feb 2010 00:05:16 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: prasad@linux.vnet.ibm.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere> <4B785952.8020706@redhat.com> <20100214204130.GD5479@nowhere>
In-Reply-To: <20100214204130.GD5479@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2010 09:41 PM, Frederic Weisbecker wrote:
> On Sun, Feb 14, 2010 at 09:13:06PM +0100, Michael Stefaniuc wrote:
>> Although Wine will map address 0x0 for DOS programs that isn't the
>> reason for those tests. Wine has to support games that come with
>> pointless copy protection schemes that employ that technique.
> Ah, which kind of protection?
No clue as I'm not into games. But the wiki has a page for that 
http://wiki.winehq.org/CopyProtection


>> Cool, thanks!
>> Any chance to get that fix into 2.6.33?
> Yeah.
>
> Could you please test the following patch on top of
> 2.6.33-rc9 ?
It is an improvement as I don't get an -EINVAL now but the data in DR7
is not what was written there and the test fails with:
exception.c:612: Test failed: failed to set debugregister 7 to 0x155, 
got 2aa

The corresponding ptrace calls for that test are:
ptrace(PTRACE_ATTACH, 3368, 0, 0)       = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 28, 
0x42424242) = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 32, 0) = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 36, 0) = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 40, 0) = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 52, 0) = 0
ptrace(PTRACE_POKEUSER, 3368, offsetof(struct user, i387) + 56, 0x155) = 0
ptrace(PTRACE_DETACH, 3368, 0x1, SIG_0) = 0
ptrace(PTRACE_ATTACH, 3368, 0, 0)       = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 28, 
[0xfffffffc42424242]) = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 32, 
[0xfffffffd00000000]) = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 36, 
[0xfffffffe00000000]) = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 40, 
[0xffffffff00000000]) = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 52, 
[0x200000000]) = 0
ptrace(PTRACE_PEEKUSER, 3368, offsetof(struct user, i387) + 56, 
[0x3000002aa]) = 0
ptrace(PTRACE_DETACH, 3368, 0x1, SIG_0) = 0

> I'm trying to build wine but it fails because my libx11 is
> incorrect for the linking (probably because I don't have a x86-32
> version of libx11.so):
The easiest to bootstrap the build environment is to use the package
management of the distribution, e.g. yum-builddep wine on Fedora.  But
there are also howto's for other distributions on
http://wiki.winehq.org/WineOn64bit

> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index 05d5fec..bb6006e 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -212,25 +212,6 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
>   	return (va>= TASK_SIZE)&&  ((va + len - 1)>= TASK_SIZE);
>   }
>
> -/*
> - * Store a breakpoint's encoded address, length, and type.
> - */
> -static int arch_store_info(struct perf_event *bp)
> -{
> -	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> -	/*
> -	 * For kernel-addresses, either the address or symbol name can be
> -	 * specified.
> -	 */
> -	if (info->name)
> -		info->address = (unsigned long)
> -				kallsyms_lookup_name(info->name);
> -	if (info->address)
> -		return 0;
> -
> -	return -EINVAL;
> -}
> -
>   int arch_bp_generic_fields(int x86_len, int x86_type,
>   			   int *gen_len, int *gen_type)
>   {
> @@ -362,10 +343,13 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
>   		return ret;
>   	}
>
> -	ret = arch_store_info(bp);
> -
> -	if (ret<  0)
> -		return ret;
> +	/*
> +	 * For kernel-addresses, either the address or symbol name can be
> +	 * specified.
> +	 */
> +	if (info->name)
> +		info->address = (unsigned long)
> +				kallsyms_lookup_name(info->name);
>   	/*
>   	 * Check that the low-order bits of the address are appropriate
>   	 * for the alignment implied by len.
>
>
>
>> I cannot test that as the corresponding test is directly affected by
>> this ABI change.
>
>
> Sure, let's fix the first problem to begin.
That regression isn't there anymore; I had seen it when the regression
search brought me to 66cb591. Now all other tests in ntdll/exception.c
pass just fine.

thanks
bye
	michael
