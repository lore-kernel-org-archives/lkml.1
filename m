Return-Path: <linux-kernel-owner+w=401wt.eu-S1161086AbXBACcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161086AbXBACcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161022AbXBACcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:32:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:35394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161086AbXBACcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:32:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,264,1167638400"; 
   d="scan'208"; a="41762803:sNHT32260068"
Message-ID: <45C1513F.1000706@linux.intel.com>
Date: Thu, 01 Feb 2007 10:32:31 +0800
From: "bibo,mao" <bibo_mao@linux.intel.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       artiom.myaskouvskey@intel.com, akpm@osdl.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
References: <1170183678.21603.73.camel@funkylaptop>	 <200701301217.47520.bjorn.helgaas@hp.com> <1170189677.21603.102.camel@funkylaptop>
In-Reply-To: <1170189677.21603.102.camel@funkylaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Riss wrote:
> Le mardi 30 janvier 2007 Ã  12:17 -0700, Bjorn Helgaas a Ã©crit :
>> On Tuesday 30 January 2007 12:01, FrÃ©dÃ©ric Riss wrote:
>>> When calling into an EFI firmware, the parameters need to be passed on
>>> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
>>> This patch is needed to allow the new Intel-based Macs to suspend to ram
>>> when run in EFI mode (efi.get_time is called during the suspend phase).
>>> ...
>>> This patch fixes the issue for x86, but the file is also used by IA64. I
>>> would have used asmlinkage to force arguments on the stack, but it has a
>>> special meaning on IA64, thus I used a raw regparm(0) GCC attribute.
>>> This attribute is documented only for x86, I hope it has no side effect
>>> on other archs.
>> It seems wrong to put this sort of architecture-dependent stuff in
>> an architecture-independent file.  If EFI needs a specific calling
>> convention on x86, x86 should provide wrappers that guarantee that
>> convention.  ia64 already provides such wrappers (phys_get_time(),
>> virt_get_time(), etc).
> 
> [ Disclaimer: I don't know much about EFI. I wanted to download the
> spec, but it required me to sign some sort of agreement about needing a
> license to write an implementation... I ran away. ]
> 
> You're totally right, I first thought it wasn't possible, but the
> functions in the 'struct efi' can be set to whatever is wanted. Bellow's
> a patch which won't have any impact on ia64 and fixes the issue on my
> Mac Mini. I don't think x86_64 can be configured to boot from EFI, so
> this shouldn't cause any regression on that front. How does that look?
currently x86_64 kernel does not support efi, efi convention comply to
MS convention. On ia32 parameter is passed on stack, on x86_64 parameter
is passed by registers but that is different from x86_64 linux convention.

How about adding EFIAPI prefix before efi runtime service function, this
prefix has different definition in different architecture. 

thanks
bibo,mao

--- 2.6.20-rc6/include/linux/efi.h.bak	2007-02-01 10:49:13.000000000 +0800
+++ 2.6.20-rc6/include/linux/efi.h	2007-02-01 10:54:24.000000000 +0800
@@ -157,22 +157,28 @@ typedef struct {
 	unsigned long reset_system;
 } efi_runtime_services_t;
 
-typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
-typedef efi_status_t efi_set_time_t (efi_time_t *tm);
-typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
+#ifdef CONFIG_X86_32 
+#define EFIAPI	asmlinkage
+# else
+#define EFIAPI
+# endif
+
+typedef EFIAPI efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
+typedef EFIAPI efi_status_t efi_set_time_t (efi_time_t *tm);
+typedef EFIAPI efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
 					    efi_time_t *tm);
-typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
-typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+typedef EFIAPI efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
+typedef EFIAPI efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
 					 unsigned long *data_size, void *data);
-typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
+typedef EFIAPI efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
 					      efi_guid_t *vendor);
-typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
+typedef EFIAPI efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
 					 unsigned long attr, unsigned long data_size, 
 					 void *data);
-typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
-typedef void efi_reset_system_t (int reset_type, efi_status_t status,
+typedef EFIAPI efi_status_t efi_get_next_high_mono_count_t (u32 *count);
+typedef EFIAPI void efi_reset_system_t (int reset_type, efi_status_t status,
 				 unsigned long data_size, efi_char16_t *data);
-typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
+typedef EFIAPI efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
 						unsigned long descriptor_size,
 						u32 descriptor_version,
 						efi_memory_desc_t *virtual_map);

> 
> 
> When calling into the EFI firmware, the parameters need to be passed on
> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
> This patch is needed to allow the new Intel-based Macs to suspend to ram
> (efi.get_time is called during the suspend phase).
> 
> Signed-off-by: Frederic Riss <frederic.riss@gmail.com>
> 
> ---
> 
> diff --git a/arch/i386/kernel/efi.c b/arch/i386/kernel/efi.c
> index b92c7f0..6196314 100644
> --- a/arch/i386/kernel/efi.c
> +++ b/arch/i386/kernel/efi.c
> @@ -472,6 +472,70 @@ static inline void __init check_range_fo
>  	}
>  }
>  
> +/* 
> + * Wrap all the virtual calls in a way that forces the parameters on the stack.
> + */
> +
> +#define efi_call_virt(f, args...) \
> +     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
> +
> +static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> +{
> +	return efi_call_virt(get_time, tm, tc);
> +}
> +
> +static efi_status_t virt_efi_set_time (efi_time_t *tm)
> +{
> +	return efi_call_virt(set_time, tm);
> +}
> +
> +static efi_status_t virt_efi_get_wakeup_time (efi_bool_t *enabled, 
> +					      efi_bool_t *pending,
> +					      efi_time_t *tm)
> +{
> +	return efi_call_virt(get_wakeup_time, enabled, pending, tm);
> +}
> +
> +static efi_status_t virt_efi_set_wakeup_time (efi_bool_t enabled,
> +					      efi_time_t *tm)
> +{
> +	return efi_call_virt(set_wakeup_time, enabled, tm);
> +}
> +
> +static efi_status_t virt_efi_get_variable (efi_char16_t *name,
> +					   efi_guid_t *vendor, u32 *attr,
> +					   unsigned long *data_size, void *data)
> +{
> +	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
> +}
> +
> +static efi_status_t virt_efi_get_next_variable (unsigned long *name_size,
> +						efi_char16_t *name,
> +						efi_guid_t *vendor)
> +{
> +	return efi_call_virt(get_next_variable, name_size, name, vendor);
> +}
> +
> +static efi_status_t virt_efi_set_variable (efi_char16_t *name,
> +					   efi_guid_t *vendor,
> +					   unsigned long attr, 
> +					   unsigned long data_size, void *data)
> +{
> +	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
> +}
> +
> +static efi_status_t virt_efi_get_next_high_mono_count (u32 *count)
> +{
> +	return efi_call_virt(get_next_high_mono_count, count);
> +}
> +
> +static void virt_efi_reset_system (int reset_type, efi_status_t status,
> +				   unsigned long data_size,
> +				   efi_char16_t *data)
> +{
> +	efi_call_virt(reset_system, reset_type, status, data_size, data);
> +}
> +
>  /*
>   * This function will switch the EFI runtime services to virtual mode.
>   * Essentially, look through the EFI memmap and map every region that
> @@ -525,22 +589,15 @@ void __init efi_enter_virtual_mode(void)
>  	 * pointers in the runtime service table to the new virtual addresses.
>  	 */
>  
> -	efi.get_time = (efi_get_time_t *) efi.systab->runtime->get_time;
> -	efi.set_time = (efi_set_time_t *) efi.systab->runtime->set_time;
> -	efi.get_wakeup_time = (efi_get_wakeup_time_t *)
> -					efi.systab->runtime->get_wakeup_time;
> -	efi.set_wakeup_time = (efi_set_wakeup_time_t *)
> -					efi.systab->runtime->set_wakeup_time;
> -	efi.get_variable = (efi_get_variable_t *)
> -					efi.systab->runtime->get_variable;
> -	efi.get_next_variable = (efi_get_next_variable_t *)
> -					efi.systab->runtime->get_next_variable;
> -	efi.set_variable = (efi_set_variable_t *)
> -					efi.systab->runtime->set_variable;
> -	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
> -					efi.systab->runtime->get_next_high_mono_count;
> -	efi.reset_system = (efi_reset_system_t *)
> -					efi.systab->runtime->reset_system;
> +	efi.get_time = virt_efi_get_time;
> +	efi.set_time = virt_efi_set_time;
> +	efi.get_wakeup_time = virt_efi_get_wakeup_time;
> +	efi.set_wakeup_time = virt_efi_set_wakeup_time;
> +	efi.get_variable = virt_efi_get_variable;
> +	efi.get_next_variable = virt_efi_get_next_variable;
> +	efi.set_variable = virt_efi_set_variable;
> +	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
> +	efi.reset_system = virt_efi_reset_system;
>  }
>  
>  void __init
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
