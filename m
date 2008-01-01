Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYAAQWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYAAQWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYAAQWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:22:03 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46636 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbYAAQWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:22:01 -0500
Date: Tue, 1 Jan 2008 17:22:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/54] KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
Message-ID: <20080101162200.GA30024@uranus.ravnborg.org>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com> <1199201780-14001-22-git-send-email-avi@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199201780-14001-22-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 05:35:47PM +0200, Avi Kivity wrote:
> Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
> only if the arch actually supports it.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---
>  arch/x86/Kconfig     |    4 ++++
>  drivers/kvm/Kconfig  |    4 ++--
>  include/linux/Kbuild |    2 +-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80b7ba4..e029a93 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -116,6 +116,10 @@ config ARCH_SUPPORTS_OPROFILE
>  	bool
>  	default y
>  
> +config ARCH_SUPPORTS_KVM
> +	bool
> +	default y
> +
>  
>  config ZONE_DMA32
>  	bool
> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
> index 6569206..4086080 100644
> --- a/drivers/kvm/Kconfig
> +++ b/drivers/kvm/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  menuconfig VIRTUALIZATION
>  	bool "Virtualization"
> -	depends on X86
> +	depends on ARCH_SUPPORTS_KVM || X86
>  	default y
>  	---help---
>  	  Say Y here to get to see options for using your Linux host to run other
> @@ -16,7 +16,7 @@ if VIRTUALIZATION
>  
>  config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
> -	depends on X86 && EXPERIMENTAL
> +	depends on ARCH_SUPPORTS_KVM && EXPERIMENTAL
>  	select PREEMPT_NOTIFIERS
>  	select ANON_INODES
>  	---help---

An approach like the following is preferred:
kvm/Kconfig:

# config symbols to be selected by archs that implment virtualization/kvm
config HAVE_VIRTUALIZATION
config HAVE_KVM

menuconfig VIRTUALIZATION
	bool "..."
	depends on HAVE_VIRTUALIZATION

config KVM
	tristate "..."
	depends on HAVE_KVM

arch/x86/Kconfig:

config X86
	select HAVE_VIRTUALIZATION
	select HAVE_KVM


I dunno about the additional "HAVE_VIRTUALIZATION" - I added it
because I assume virtualization is more than just kvm.

The rationales behinds this approach is:

-> We do not define a new config variable for each arch
-> We have a common way to say that an arch supports a feature
-> We have a common naming scheme


	Sam
