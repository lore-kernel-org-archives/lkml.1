Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbYLXXJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYLXXJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 18:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLXXJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 18:09:16 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:56406 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYLXXJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 18:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vs26+TcB7EM9l6Tqois2imUckEpviV3kDxw8P0gRy1bobJ3pYTSuJjHkllWbIVsIPA
         VxFSgv850J0SUdzaaQ3N6YICN5HnDSZ08zM09j1fwTkNUlSKVTjhvpz3gT+LwONltXPx
         F3HTDcDOm4KvX15FJpz/b23G3Jv9js97rEXHI=
Message-ID: <86802c440812241509u1701d518ped6d33b0b6752de8@mail.gmail.com>
Date: Wed, 24 Dec 2008 15:09:12 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: linux-next: parsing mem=700M broken
Cc: "Ingo Molnar" <mingo@elte.hu>, "Hugh Dickins" <hugh@veritas.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4951EE20.5080004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
	 <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com>
	 <20081223143327.GF29151@elte.hu>
	 <200812241808.16195.rusty@rustcorp.com.au>
	 <4951EE20.5080004@kernel.org>
X-Google-Sender-Auth: 8229b962aea10929
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 12:09 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Rusty Russell wrote:
>> On Wednesday 24 December 2008 01:03:27 Ingo Molnar wrote:
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> On Mon, Dec 22, 2008 at 7:06 PM, Hugh Dickins <hugh@veritas.com> wrote:
>>>>> Hi Rusty,
>>>>>
>>>>> I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
>>>>> and have bisected it down to your patch below; but now I'm off to bed
>>>>> without working out just what goes wrong (I'll bet it's the "=").
>>
>> Thanks for the report and analysis.
>>
>>> Rusty, will you fix or revert it?
>>
>> mem= is actually easy, memmap= is harder.  This is tested and pushed.
>>
>> This commit is actually orthogonal to the other changes, but makes most
>> sense I think in the bootparam tree.
>>
>> commit b69cab1078c69a568afdd2eb8ee6f8559b769e2c
>> Author: Rusty Russell <rusty@rustcorp.com.au>
>> Date:   Wed Dec 24 18:04:19 2008 +1030
>>
>>     Fix mem= and memmap= parsing: now it happens *before* e820 setup.
>>
>>     Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>
>
> for cpu caps on boot cpu setup still need
>
> could be in tip your tree.
>
> ---
>
> [PATCH] x86: clean up setup_clear/force_cpu_cap handling
>
> Impact: fix and cleanup
>
> setup_force_cpu_cap() only have one user xen
> but it should not reuse cleared_cpu_cpus. it will have problem
> for smp.
>
> need to have cpu_cpus_set array too.
> also need to setup handling before all cpus cap AND
>
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>
> ---
> ---
> could be put in next:
>
> [PATCH] x86: update boot_cpu x86 cap according in early_identify_cpu
>
> Impact: fix
>
> early_param is moved more earlier. So need to update boot_cpu_data x86 cap
> in early_identify_cpu() to make sure that is right.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  arch/x86/kernel/cpu/common.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> Index: linux-2.6/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> +++ linux-2.6/arch/x86/kernel/cpu/common.c
> @@ -552,6 +552,16 @@ static void __init early_identify_cpu(st
>        if (this_cpu->c_early_init)
>                this_cpu->c_early_init(c);
>
> +       /*
> +        * Clear/Set all flags overriden by options, need do it
> +        * because early_param is done before early_cpu_init now.
> +        * We can get boot_cpu_data.x86_capability right.
> +        */
> +       for (i = 0; i < NCAPINTS; i++) {
> +               c->x86_capability[i] &= ~cpu_caps_cleared[i];
> +               c->x86_capability[i] |= cpu_caps_set[i];
> +       }
> +
>        validate_pat_support(c);
>
>  #ifdef CONFIG_SMP
> --

...


also

/*
 * noexec = on|off
 *
 * Control non executable mappings.
 *
 * on      Enable
 * off     Disable
 */
static int __init noexec_setup(char *str)
{
        if (!str || !strcmp(str, "on")) {
                if (cpu_has_nx) {
                        __supported_pte_mask |= _PAGE_NX;
                        disable_nx = 0;
                }
        } else {
                if (!strcmp(str, "off")) {
                        disable_nx = 1;
                        __supported_pte_mask &= ~_PAGE_NX;
                } else {
                        return -EINVAL;
                }
        }

        return 0;
}
early_param("noexec", noexec_setup);


they are using cpu_has_nx already.

wonder if just move early_cpu_init() and before in setup_arch() to
x86_start_kernel/x86_64_start_kernel
directly.

YH
