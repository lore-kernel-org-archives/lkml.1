Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZJBNkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZJBNkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZJBNkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:40:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34265 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbZJBNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:40:08 -0400
Date: Fri, 2 Oct 2009 15:39:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091002133954.GA29390@elte.hu>
References: <20090930223956.GE17712@liondog.tnic> <20090930230947.GA9346@elte.hu> <20091001141432.GA11410@aftab> <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain> <20091001144637.GB11410@aftab> <20091001150046.GA21476@elte.hu> <20091001152140.GC11410@aftab> <20091001153250.GA25885@elte.hu> <20091002132101.GA28682@aftab> <20091002133148.GD28682@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002133148.GD28682@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> +static void (*orig_mce_callback)(struct mce *m);
>  
>  void amd_report_gart_errors(bool v)
>  {
> @@ -427,9 +428,25 @@ static int __init mce_amd_init(void)
>  	 * We can decode MCEs for Opteron and later CPUs:
>  	 */
>  	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
> -	    (boot_cpu_data.x86 >= 0xf))
> +	    (boot_cpu_data.x86 >= 0xf)) {
> +		/* safe the default decode mce callback */
> +		orig_mce_callback = x86_mce_decode_callback;
> +
>  		x86_mce_decode_callback = amd_decode_mce;
> +	}
>  
>  	return 0;
>  }
>  early_initcall(mce_amd_init);
> +
> +#ifdef MODULE
> +static void __exit mce_amd_exit(void)
> +{
> +	x86_mce_decode_callback = orig_mce_callback;
> +}

I suspect this is fine currently because no two EDAC modules should be 
active at the same time. A followup cleanup patch would be nice 
nevertheless that uses a notifier chain here with proper 
register/unregister locking.

	Ingo
