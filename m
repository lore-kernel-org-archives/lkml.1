Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZBWIr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZBWIr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZBWIrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:47:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34867 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZBWIrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:47:18 -0500
Date: Mon, 23 Feb 2009 09:47:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeffrey Trull <jetrull@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AGP aperture size detection 32b vs. 64b kernels
Message-ID: <20090223084707.GD9582@elte.hu>
References: <622229.85336.qm@web82407.mail.mud.yahoo.com> <49A257AB.4040200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A257AB.4040200@kernel.org>
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

>  drivers/char/agp/amd64-agp.c |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/char/agp/amd64-agp.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/agp/amd64-agp.c
> +++ linux-2.6/drivers/char/agp/amd64-agp.c
> @@ -271,15 +271,15 @@ static __devinit int fix_northbridge(str
>  	nb_order = (nb_order >> 1) & 7;
>  	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
>  	nb_aper = nb_base << 25;
> -	if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
> -		return 0;
> -	}
>  
>  	/* Northbridge seems to contain crap. Try the AGP bridge. */
>  
>  	pci_read_config_word(agp, cap+0x14, &apsize);
> -	if (apsize == 0xffff)
> +	if (apsize == 0xffff) {
> +		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
> +			return 0;
>  		return -1;
> +	}
>  
>  	apsize &= 0xfff;
>  	/* Some BIOS use weird encodings not in the AGPv3 table. */
> @@ -301,6 +301,11 @@ static __devinit int fix_northbridge(str
>  		order = nb_order;
>  	}
>  
> +	if (nb_order >= order) {
> +		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
> +			return 0;
> +	}
> +

if the fix does the trick then please do some cleanups as well: 
for example the 32MB magic constant should go into a define.

	Ingo
