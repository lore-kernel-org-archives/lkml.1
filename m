Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbXITM0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbXITM0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXITM0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:26:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXITM0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:26:05 -0400
Date: Thu, 20 Sep 2007 17:58:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 6/4] [-mm patch] use the existing offsetof().
In-Reply-To: <46F205DB.70209@mxs.nes.nec.co.jp>
Message-ID: <alpine.LFD.0.999.0709201752310.17093@enigma.security.iitk.ac.in>
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F942.5070007@mxs.nes.nec.co.jp>
 <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp>
 <46F205DB.70209@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Ken'ichi Ohmichi wrote:
> 
> [PATCH 6/4] [-mm patch] use the existing offsetof().
>  It is better that offsetof() is used for VMCOREINFO_OFFSET().
>  This idea is Joe Perches's.
> 
> 
> 
> Thanks
> Ken'ichi Ohmichi 
> 
> ---
> Signed-off-by: Joe Perches <joe@perches.com>

Same deal here ...


> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
> ---
> diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
> --- a/include/linux/kexec.h	2007-09-18 15:23:22.000000000 +0900
> +++ b/include/linux/kexec.h	2007-09-18 15:27:29.000000000 +0900
> @@ -137,7 +137,7 @@ unsigned long paddr_vmcoreinfo_note(void
>  			      (unsigned long)sizeof(struct name))
>  #define VMCOREINFO_OFFSET(name, field) \
>  	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
> -			      (unsigned long)&(((struct name *)0)->field))
> +			      (unsigned long)offsetof(struct name, field))
>  #define VMCOREINFO_LENGTH(name, value) \
>  	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)

... and here. Use %zu and lose the casts.

BTW I don't think these macros are such a big win in readability or
code clarity anyway. And I noticed that there are still some open
calls to vmcoreinfo_append_str() in kexec.c (such as for the OS_RELEASE
case) which you haven't macro-ized ... we end up having code that looks
like:

	vmcoreinfo_append_str(...);
	...

	...
	VMCOREINFO_OFFSET(...);
	...

and it's not even obvious (unless you follow on to the definition of the
later macro) that the above two are *exactly* the same. So you could also
consider just losing the macros altogether.


Satyam
