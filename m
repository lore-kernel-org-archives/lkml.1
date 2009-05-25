Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZEYWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZEYWvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZEYWvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:51:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbZEYWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:51:47 -0400
Date: Mon, 25 May 2009 15:50:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
In-Reply-To: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org>
Message-ID: <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 May 2009, H. Peter Anvin wrote:
>
> +static void wbinvd_local(void *unused)
> +{
> +	wbinvd();
> +}
> +
>  static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>  			    int in_flags, struct page **pages)
>  {
> @@ -218,8 +223,9 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
>  
>  	/* 4M threshold */
>  	if (numpages >= 1024) {
> -		if (boot_cpu_data.x86_model >= 4)
> -			wbinvd();
> +		if (boot_cpu_data.x86 >= 4)
> +			on_each_cpu(wbinvd_local, NULL, 1);
> +

This looks a bit wrong.

Just above this, we've done

	on_each_cpu(__cpa_flush_range, NULL, 1);

and quite frankly, it seems to be that what we _should_ have done is to 
instead change that to

	long do_wbinvd = cache && numpages >= 1024;

	on_each_cpu(__cpa_flush_all, (void *)do_wbinvd, 1);
	if (!cache || do_wbinvd)
		return;

	.. do the cflush dance .. 

instead.

Now you made it do two different "on_each_cpu" things. Maybe it doesn't 
matter, but it just seems wrong.

		Linus
