Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZDRUMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZDRUMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbZDRUMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:12:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZDRUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:12:31 -0400
Date: Sat, 18 Apr 2009 22:11:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] driver: dont update dev_name if it is not changed
Message-ID: <20090418201114.GA27903@elte.hu>
References: <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <49EA3176.4010901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EA3176.4010901@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> notice one system /proc/iomem some entries missed the name for pci_devices
> 
> it turns that dev->dev.kobj name is changed after device_add.
> 
> [Impact: fix corrupted names in /proc/iomem ]
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  lib/kobject.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/lib/kobject.c
> ===================================================================
> --- linux-2.6.orig/lib/kobject.c
> +++ linux-2.6/lib/kobject.c
> @@ -216,12 +216,21 @@ int kobject_set_name_vargs(struct kobjec
>  				  va_list vargs)
>  {
>  	const char *old_name = kobj->name;
> +	char *new_name;
>  	char *s;
>  
> -	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
> -	if (!kobj->name)
> +	new_name = kvasprintf(GFP_KERNEL, fmt, vargs);
> +	if (!new_name)
>  		return -ENOMEM;
>  
> +	/* different ? */
> +	if (!strcmp(new_name, old_name)) {
> +		kfree(new_name);
> +		return 0;
> +	}
> +
> +	kobj->name = new_name;
> +
>  	/* ewww... some of these buggers have '/' in the name ... */
>  	while ((s = strchr(kobj->name, '/')))
>  		s[0] = '!';

So we used the old name in the resource code, and the kfree() here 
corrupted the /proc/iomem output?

This still looks fragile to me ...

	Ingo
