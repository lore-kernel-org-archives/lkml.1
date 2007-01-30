Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbXA3TSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbXA3TSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXA3TSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:18:03 -0500
Received: from atlrel7.hp.com ([156.153.255.213]:48934 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbXA3TSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:18:00 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: =?iso-8859-15?q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>
Subject: Re: [PATCH] EFI x86: pass firmware call parameters on the stack
Date: Tue, 30 Jan 2007 12:17:47 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, artiom.myaskouvskey@intel.com, akpm@osdl.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1170183678.21603.73.camel@funkylaptop>
In-Reply-To: <1170183678.21603.73.camel@funkylaptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200701301217.47520.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 12:01, Frédéric Riss wrote:
> When calling into an EFI firmware, the parameters need to be passed on
> the stack. The recent change to use -mregparm=3 breaks x86 EFI support.
> This patch is needed to allow the new Intel-based Macs to suspend to ram
> when run in EFI mode (efi.get_time is called during the suspend phase).
> ...
> This patch fixes the issue for x86, but the file is also used by IA64. I
> would have used asmlinkage to force arguments on the stack, but it has a
> special meaning on IA64, thus I used a raw regparm(0) GCC attribute.
> This attribute is documented only for x86, I hope it has no side effect
> on other archs.

It seems wrong to put this sort of architecture-dependent stuff in
an architecture-independent file.  If EFI needs a specific calling
convention on x86, x86 should provide wrappers that guarantee that
convention.  ia64 already provides such wrappers (phys_get_time(),
virt_get_time(), etc).

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index df1c918..1db5321 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -157,25 +157,35 @@ typedef struct {
>  	unsigned long reset_system;
>  } efi_runtime_services_t;
>  
> -typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
> -typedef efi_status_t efi_set_time_t (efi_time_t *tm);
> +typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc)
> +			__attribute__((regparm(0)));
> +typedef efi_status_t efi_set_time_t (efi_time_t *tm)
> +			__attribute__((regparm(0)));
>  typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
> -					    efi_time_t *tm);
> -typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm);
> +					    efi_time_t *tm)
> +			__attribute__((regparm(0)));
> +typedef efi_status_t efi_set_wakeup_time_t (efi_bool_t enabled, efi_time_t *tm)
> +			__attribute__((regparm(0)));
>  typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
> -					 unsigned long *data_size, void *data);
> +					 unsigned long *data_size, void *data)
> +			__attribute__((regparm(0)));
>  typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
> -					      efi_guid_t *vendor);
> +					      efi_guid_t *vendor)
> +			__attribute__((regparm(0)));
>  typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
>  					 unsigned long attr, unsigned long data_size, 
> -					 void *data);
> -typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
> +					 void *data)
> +			__attribute__((regparm(0)));
> +typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count)
> +			__attribute__((regparm(0)));
>  typedef void efi_reset_system_t (int reset_type, efi_status_t status,
> -				 unsigned long data_size, efi_char16_t *data);
> +				 unsigned long data_size, efi_char16_t *data)
> +			__attribute__((regparm(0)));
>  typedef efi_status_t efi_set_virtual_address_map_t (unsigned long memory_map_size,
>  						unsigned long descriptor_size,
>  						u32 descriptor_version,
> -						efi_memory_desc_t *virtual_map);
> +						efi_memory_desc_t *virtual_map)
> +			__attribute__((regparm(0)));
>  
>  /*
>   *  EFI Configuration Table and GUID definitions
> 
> 
> 
