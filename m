Return-Path: <linux-kernel-owner+w=401wt.eu-S2992536AbXEBCtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992536AbXEBCtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXEBCtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:49:11 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:36177 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992536AbXEBCtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:49:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=wYKJNO3uoW5mMZnFILSIM6At5kcJza2LPlsT4KuY/FDVRM4rQpXLMW3NB4FsbNXVSXe2mP6gwuq1tsWlAKXgnws5c67AcMXDKxl28OjEg6rLoraRJG5jH4zW+AiV/1N7jp46J1mQnV+uR7/JgdgGLzl5RgRefjOyVHpUf6EjhSQ=  ;
X-YMail-OSG: wr6rIQEVM1nVGCe5XuNCieZ81bT8e_bVHNbycGJHum2MItdR1bO9QiTbct6UjWn2OBC6svWvJcHTDpXuAOfZ41LURDih9k2oFb_jL2haHOwbjA4Uk2k-
Message-ID: <4637FC1D.4040300@yahoo.com.au>
Date: Wed, 02 May 2007 12:49:01 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 4/6] UML - free() wrapper should call libc free
References: <20070501182158.GA8358@c2.user-mode-linux.org>
In-Reply-To: <20070501182158.GA8358@c2.user-mode-linux.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> The libc free wrapper wasn't correctly detecting buffers obtained with
> malloc().  This is now done by seeing if the page was reserved.  This is
> the case for memory which is left aside for libc and isn't given to
> the page allocator.  If we free a pointer in a reserved page, it is
> given to free() rather than kfree().

I want to get rid of PG_reserved eventually. Is it possible to use PG_arch_1
for this?

> 
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
>  arch/um/include/user.h   |    1 +
>  arch/um/kernel/um_arch.c |    7 +++++++
>  arch/um/os-Linux/main.c  |    6 +++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-mm/arch/um/include/user.h
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/include/user.h	2007-04-26 17:33:01.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/include/user.h	2007-04-27 14:21:35.000000000 -0400
> @@ -27,5 +27,6 @@ extern int in_aton(char *str);
>  extern int open_gdb_chan(void);
>  extern size_t strlcpy(char *, const char *, size_t);
>  extern size_t strlcat(char *, const char *, size_t);
> +extern int reserved_address(void *addr);
>  
>  #endif
> Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-04-26 17:41:21.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-04-27 14:30:36.000000000 -0400
> @@ -500,6 +500,13 @@ void __init check_bugs(void)
>  	os_check_bugs();
>  }
>  
> +int reserved_address(void *addr)
> +{
> +	struct page *page = virt_to_page(addr);
> +
> +	return(PageReserved(page));
> +}
> +
>  void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
>  {
>  }
> Index: linux-2.6.21-mm/arch/um/os-Linux/main.c
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/os-Linux/main.c	2007-04-26 17:41:10.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/os-Linux/main.c	2007-04-27 14:30:31.000000000 -0400
> @@ -266,6 +266,8 @@ void __wrap_free(void *ptr)
>  	/* We need to know how the allocation happened, so it can be correctly
>  	 * freed.  This is done by seeing what region of memory the pointer is
>  	 * in -
> +	 *	in a reserved page - free, assume the pointer was
> +	 *	    acquired with malloc, since it couldn't have been kmalloced.
>  	 * 	physical memory - kmalloc/kfree
>  	 *	kernel virtual memory - vmalloc/vfree
>  	 * 	anywhere else - malloc/free
> @@ -281,7 +283,9 @@ void __wrap_free(void *ptr)
>  	 * there is a possibility for memory leaks.
>  	 */
>  
> -	if((addr >= uml_physmem) && (addr < high_physmem)){
> +	if(kmalloc_ok && reserved_address(ptr))
> +		__real_free(ptr);
> +	else if((addr >= uml_physmem) && (addr < high_physmem)){
>  		if(CAN_KMALLOC())
>  			kfree(ptr);
>  	}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
SUSE Labs, Novell Inc.
