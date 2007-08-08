Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbXHHKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbXHHKCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbXHHKCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:48264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Date: Wed, 8 Aug 2007 11:44:02 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865468394005-git-send-email-gcosta@redhat.com> <11865468431616-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865468431616-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081144.04119.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> -static void discover_ebda(void)
> +void native_ebda_info(unsigned *addr, unsigned *size)

I guess it would be better to use the resources frame work here. 
Before checking EBDA check if it is already reserved. Then lguest/Xen
can reserve these areas and stop using it.


> +/* Overridden in paravirt.c if CONFIG_PARAVIRT */
> +void __attribute__((weak)) memory_setup(void)
> +{
> +       return setup_memory_region();
> +}
> +
> +
>  void __init setup_arch(char **cmdline_p)
>  {
>  	printk(KERN_INFO "Command line: %s\n", boot_command_line);
> @@ -231,12 +255,19 @@ void __init setup_arch(char **cmdline_p)
>  	saved_video_mode = SAVED_VIDEO_MODE;
>  	bootloader_type = LOADER_TYPE;
>
> +	/*
> +	 * By returning non-zero here, a paravirt impl can choose to
> +	 * skip the rest of the setup process
> +	 */
> +	if (paravirt_arch_setup())
> +		return;

Sorry, but that's an extremly ugly and clumpsy interface and will lead
to extensive code duplication in hypervisors because so much code
is disabled.

This needs to be solved in some better way.


-Andi
