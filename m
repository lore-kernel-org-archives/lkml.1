Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYJMWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYJMWkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYJMWka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:40:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:9540 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbYJMWk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=albW5I/8ukuo58ownr9OoiD/ijx0gNTqB13gth6qE1QbHrcamHA7DtFSasvNess+UA
         Yj2Bs1OlD2tol3s7l08q0E0TY2ytR/xsLYVVdI71kG2n1Ayhn4ISQhv1LfDrJK34AK+N
         C5I9/Ghgwfn1yF0efzvWUNEri648f674cxqU8=
Message-ID: <86802c440810131540x492fb7eq9813e644fb0cb9d@mail.gmail.com>
Date: Mon, 13 Oct 2008 15:40:28 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix v7
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Tony Luck" <tony.luck@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
	 <20080904121627.bc182da7.akpm@linux-foundation.org>
	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
	 <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
	 <48F3BA28.2010605@zytor.com>
	 <alpine.LFD.2.00.0810131431510.3288@nehalem.linux-foundation.org>
X-Google-Sender-Auth: bb27e4a1f3746d68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 2:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 13 Oct 2008, H. Peter Anvin wrote:
>>
>> Here is a fix... currently running standard tests on it.
>
> Or we could do what Andrew suggested some time ago, and extend %p to do
> resource printing, like %pS and %pF.
>
> TOTALLY UNTESTED! But something like this might allow
>
>        printk(KERN_DEBUG "  reserve_region: (%s) %pR\n"
>                res->name, res);
>
> and if I did things right it should print
>
>        reserve_region: (name) [xx-xx]
>
> and maybe it's worth it. We certainly do seem to have a fair number of
> those irritating casts for resource printouts.
>
>                Linus
> ---
>  lib/vsprintf.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index c399bc1..dd62557 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -24,6 +24,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kallsyms.h>
>  #include <linux/uaccess.h>
> +#include <linux/ioport.h>
>
>  #include <asm/page.h>          /* for PAGE_SIZE */
>  #include <asm/div64.h>
> @@ -528,6 +529,21 @@ static char *symbol_string(char *buf, char *end, void *ptr, int field_width, int
>  #endif
>  }
>
> +static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
> +{
> +       char sym[4*sizeof(resource_size_t) + 4];
> +       char *p = sym, *pend = sym + sizeof(sym);
> +
> +       *p++ = '[';
> +       p = number(p, pend, res->start, 16, -1, -1, 0);
> +       *p++ = '-';
> +       p = number(p, pend, res->end, 16, -1, -1, 0);
> +       *p++ = ']';
> +       *p = 0;
> +
> +       return string(buf, end, sym, field_width, precision, flags);

can we have
       printk(KERN_DEBUG "  reserve_region: (%s) %04pR\n"
               res->name, res);
or
       printk(KERN_DEBUG "  reserve_region: (%s) %08pR\n"
               res->name, res);

because io port resource will only 4 digi only.

YH
