Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZGDCQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZGDCQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZGDCQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:16:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:11257 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZGDCQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DgT7tMmozH8jSPRBa4qxPGggDOPBpk/coF0g3KVXK8eHDXqg+fH/JWAiYP1qpWD6x0
         DywW73Ewea2kHJinfCdiB0EmR07X1PVrYYZzQyoeXf+RPmnUW/FZgofSHE9UcRCngPmB
         Ms+SwcmsXJu4boe6MyI3U5Lo/hLCxKDzlBqF8=
Date: Sat, 4 Jul 2009 11:14:13 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: fix usage of bios intcall()
Message-ID: <20090704021410.GA3050@localhost.localdomain>
References: <20090701021307.GA3127@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090701021307.GA3127@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone review this patch?

On Wed, Jul 01, 2009 at 11:13:07AM +0900, Akinobu Mita wrote:
> Some intcall() misuses the input biosregs as output in
> cf06de7b9cdd3efee7a59dced1977b3c21d43732
> 
> This fixes the problem vga=ask boot option doesn't show enough modes.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  arch/x86/boot/video-bios.c |    3 +--
>  arch/x86/boot/video-vesa.c |    4 ++--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
> index d660be4..49e0c18 100644
> --- a/arch/x86/boot/video-bios.c
> +++ b/arch/x86/boot/video-bios.c
> @@ -37,14 +37,13 @@ static int set_bios_mode(u8 mode)
>  	ireg.al = mode;		/* AH=0x00 Set Video Mode */
>  	intcall(0x10, &ireg, NULL);
>  
> -
>  	ireg.ah = 0x0f;		/* Get Current Video Mode */
>  	intcall(0x10, &ireg, &oreg);
>  
>  	do_restore = 1;		/* Assume video contents were lost */
>  
>  	/* Not all BIOSes are clean with the top bit */
> -	new_mode = ireg.al & 0x7f;
> +	new_mode = oreg.al & 0x7f;
>  
>  	if (new_mode == mode)
>  		return 0;	/* Mode change OK */
> diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
> index c700147..275dd17 100644
> --- a/arch/x86/boot/video-vesa.c
> +++ b/arch/x86/boot/video-vesa.c
> @@ -45,7 +45,7 @@ static int vesa_probe(void)
>  	ireg.di = (size_t)&vginfo;
>  	intcall(0x10, &ireg, &oreg);
>  
> -	if (ireg.ax != 0x004f ||
> +	if (oreg.ax != 0x004f ||
>  	    vginfo.signature != VESA_MAGIC ||
>  	    vginfo.version < 0x0102)
>  		return 0;	/* Not present */
> @@ -70,7 +70,7 @@ static int vesa_probe(void)
>  		ireg.di = (size_t)&vminfo;
>  		intcall(0x10, &ireg, &oreg);
>  
> -		if (ireg.ax != 0x004f)
> +		if (oreg.ax != 0x004f)
>  			continue;
>  
>  		if ((vminfo.mode_attr & 0x15) == 0x05) {
