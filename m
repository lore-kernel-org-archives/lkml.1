Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbZCTTXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbZCTTXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZCTTXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:23:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33502 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZCTTXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:23:36 -0400
Date: Fri, 20 Mar 2009 20:23:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Bartlett <ajb.stxsl@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix IO APIC resource allocation error message
Message-ID: <20090320192323.GG6224@elte.hu>
References: <200903202012.41344.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903202012.41344.bzolnier@gmail.com>
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


* Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] x86: fix IO APIC resource allocation error message
> 
> Impact: fix incorrect error message
> 
> - IO APIC resource allocation error message contains one too many "be".
> 
> - Print the error message iff there are IO APICs in the system.
> 
> Cc: Alan Bartlett <ajb.stxsl@googlemail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> I've seen this error message for some time on my x86-32 laptop...
> 
>  arch/x86/kernel/io_apic.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/arch/x86/kernel/io_apic.c
> ===================================================================
> --- a/arch/x86/kernel/io_apic.c
> +++ b/arch/x86/kernel/io_apic.c
> @@ -4150,9 +4150,9 @@ static int __init ioapic_insert_resource
>  	int i;
>  	struct resource *r = ioapic_resources;
>  
> -	if (!r) {
> +	if (!r && nr_ioapics > 0) {
>  		printk(KERN_ERR
> -		       "IO APIC resources could be not be allocated.\n");
> +		       "IO APIC resources couldn't be allocated.\n");
>  		return -1;
>  	}

looks good, but there's one weirdness:

so if nr_ioapics == 0 && !r we'll drop into this codepath:

        for (i = 0; i < nr_ioapics; i++) {
                insert_resource(&iomem_resource, r);
                r++;
        }

        return 0;

we survive the loop by luck, and then return 0 - which we'll survive 
too but still it's a bit unexpected and hence fragile.

So i think we should rather add a standalone:

	if (nr_ioapics > 0)
  		printk(KERN_ERR

check to the printk only. That wont affect the remaining code flow.

	Ingo
