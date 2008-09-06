Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYIFMHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYIFMHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 08:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYIFMHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 08:07:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYIFMHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 08:07:42 -0400
Date: Sat, 6 Sep 2008 14:07:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
Message-ID: <20080906120720.GB30964@elte.hu>
References: <200809052219.44093.arvidjaar@newmail.ru> <200809061240.25925.arvidjaar@newmail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809061240.25925.arvidjaar@newmail.ru>
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


* Andrey Borzenkov <arvidjaar@newmail.ru> wrote:

> On Friday 05 September 2008, Andrey Borzenkov wrote:
> > This is regression but old enough. Apparently I had for whatever reasons
> > EDD turned off till recently. This is 2.6.27-rc5 just in case.
> > 
> > In 2006 I fixed ghost devices due to buggy BIOS:
> > 
> > http://marc.info/?l=linux-kernel&m=114087765422490&w=2
> > 
> > Later edd.S has been rewritten in C, and apparently this patch has been
> > lost:
> > 
> > {pts/1}% ls /sys/firmware/edd
> > int13_dev80/  int13_dev84/  int13_dev88/  int13_dev8c/
> > int13_dev81/  int13_dev85/  int13_dev89/  int13_dev8d/
> > int13_dev82/  int13_dev86/  int13_dev8a/  int13_dev8e/
> > int13_dev83/  int13_dev87/  int13_dev8b/  int13_dev8f/
> > 
> > But I have just a single disk. This is the same system BTW.
> > 
> > Unfortunately I do not speak asm language of C; if somebody could provide
> > equivalent fix for current edd.c, I am more than ready to test it.
> 
> Was it really that simple?
> 
> Subject: [PATCH] Fix ghost devices under /sys/firmware/edd
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> Some BIOSes do not always set CF on error before return from int13.
> The patch adds additional check for status being zero (AH == 0).
> 
> This was fixed for edd.S in
> http://marc.info/?l=linux-kernel&m=114087765422490&w=2, but lost
> again when edd.S was rewritten in C.
> 
> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> ---
> 
>  arch/x86/boot/edd.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
> index d93cbc6..bf4ae6f 100644
> --- a/arch/x86/boot/edd.c
> +++ b/arch/x86/boot/edd.c
> @@ -32,7 +32,9 @@ static int read_mbr(u8 devno, void *buf)
>  		     : "+a" (ax), "+c" (cx), "+d" (dx), "+b" (bx)
>  		     : : "esi", "edi", "memory");
>  
> -	return -(u8)ax;		/* 0 or -1 */
> +	/* Some BIOSes do not set carry flag on error but still return
> +	 * error in AH. The condition below is expected to catch both */
> +	return -!!ax;		/* 0 or -1 */
>  }
>  
>  static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)

looks good to me - applied it to tip/x86/urgent. Thanks Andrey!

	Ingo
