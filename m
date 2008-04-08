Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbYDHWT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbYDHWT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 18:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYDHWTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 18:19:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:2841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYDHWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 18:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Dw45/WlSs7PaLNLULgizdgI8eR3Lje3ski2tVqwtLlIucCXA/UE6pWR183jwBg8at/KqAFLUoTfX7HuAf71AqdfCepPTipKL5PoVQZ8RtHjh/uJ7oW/qBKJ0juUwkMgIg64ZfvpppnWRaUQ6m7TWHf7MELHr44b0HsFlIrAD7fc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] drivers/char/specialix.c: stop inlining largish static functions
Date: Wed, 9 Apr 2008 00:18:53 +0200
User-Agent: KMail/1.8.2
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, R.E.Wolff@bitwizard.nl
References: <200804081244.53894.vda.linux@googlemail.com> <47FBE5C3.1040105@gmail.com>
In-Reply-To: <47FBE5C3.1040105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804090018.53053.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008 23:38, Jiri Slaby wrote:
> > drivers/char/specialix.c has unusually large number
> > of static inline functions - 22.
> > 
> > I looked through them. The file is positively inline-happy.
> > Inlines with udelay() calls. Inlines with complex loops.
> > Nested inlines. Rarely called inlines (e.g. with request_region
> > inside).
> > 
> > This patch removes "inline" from 15 static functions
> > (regardless of number of callsites - gcc nowadays auto-inlines
> > statics with one callsite).
> > 
> > Size difference for 32bit x86:
> >    text    data     bss     dec     hex filename
> >   21669     204    8780   30653    77bd linux-2.6-ALLYES/drivers/char/specialix.o
> >   18470     204    8780   27454    6b3e linux-2.6.inline-ALLYES/drivers/char/specialix.o
> > 
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> -	static const char *badmagic =
> +	static const char badmagic[] =
>   		KERN_ERR "sx: Warning: bad specialix port magic number for device %s in %s\n";
> -	static const char *badinfo =
> +	static const char badinfo[] =
>   		KERN_ERR "sx: Warning: null specialix port for device %s in %s\n";
> 
> 
> BTW what's this good for? I mean, why we need this as a variable not directly as 
> a parameter?
> 
>   	if (!port) {
>   		printk(badinfo, name, routine);
>   		return 1;
>   	}
>   	if (port->magic != SPECIALIX_MAGIC) {
>   		printk(badmagic, name, routine);
>   		return 1;
>   	}

I am sure these strings can be used directly in printk,
there should be no size difference (sans gcc adding padding
to string arrays "just because").

I chose to make minimal change which only eliminates the waste
of having a pinter to these strings (char *msg = "xxx"
versus char msg[] = "xxx"), leaving more extensive editing
to someone who wants to attack specialix.c on the wider front.
--
vda
