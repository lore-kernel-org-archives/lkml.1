Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZHTL6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZHTL6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZHTL6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:58:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:36831 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750856AbZHTL6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:58:32 -0400
Cc: linux-kernel@vger.kernel.org, roland@redhat.com,
       linux-parisc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 20 Aug 2009 13:58:30 +0200
From: "Helge Deller" <deller@gmx.de>
In-Reply-To: <1250549376.7858.96.camel@mulgrave.site>
Message-ID: <20090820115830.123490@gmx.net>
MIME-Version: 1.0
References: <4A89CC4D.5040801@gmx.de> <1250549376.7858.96.camel@mulgrave.site>
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: James Bottomley <James.Bottomley@HansenPartnership.com>
X-Authenticated: #1045983
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+P2xVt/VmPl12prYCeQ4uUj2bqB5h610zbXEOihi
 5IoQyYhwU85S0OPhEugs72WVJQg0CQiV999g== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: CU/keXB+eWUkfq2TZm9nWd0jL0tsZg17
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The root cause is a duplicate section name (.text); is this legal?
> 
> However, there's a problem with commit
> 6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
> a mod->sect_attrs (in this case it's null because of the duplication),
> it still gets used without checking in add_notes_attrs()
> 
> This should fix it
> 
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>


Thanks!
I tested it, and it does at least fix the kernel crash.

Tested-by: Helge Deller <deller@gmx.de>


 
> diff --git a/kernel/module.c b/kernel/module.c
> index fd14114..a703c49 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2353,7 +2353,8 @@ static noinline struct module *load_module(void
> __user *umod,
>  	if (err < 0)
>  		goto unlink;
>  	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> -	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
> +	if (mod->sect_attrs)
> +		add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
>  
>  	/* Get rid of temporary copy */
>  	vfree(hdr);
> 

-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/atbrowser
