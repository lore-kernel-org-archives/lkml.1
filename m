Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYGONgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYGONgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYGONg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:36:29 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:50425 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYGONg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:36:29 -0400
Date: Tue, 15 Jul 2008 15:36:27 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Marc Zyngier <maz@misterjones.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH][pcmcia] cisinfo_t removal prevents card detection
Message-ID: <20080715133627.GD27297@roarinelk.homelinux.net>
References: <487CA577.5090602@misterjones.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CA577.5090602@misterjones.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:26:15PM +0200, Marc Zyngier wrote:
> Dominik,
>
> The commit
>
> c5081d5f4775b2a3f858f91151bbf9163e473075 (pcmcia: simplify 
> pccard_validate_cis)
>
> that entered mainline yesterday introduced a bug that prevents card 
> detection
> on my platform (PXA255 based), and possibly others :
>
>   @@ -1490,11 +1491,13 @@ int pccard_validate_cis(struct pcmcia_socket *s, 
> unsigned int function, cisinfo_
>               ((tuple->TupleCode > 0x90) && (tuple->TupleCode < 0xff)))
>               reserved++;
>        }
>   -    if ((info->Chains == MAX_TUPLES) || (reserved > 5) ||
>   -       ((!dev_ok || !ident_ok) && (info->Chains > 10)))
>   -       info->Chains = 0;
>   +    if ((count) || (reserved > 5) ||
>   +       ((!dev_ok || !ident_ok) && (count > 10)))
>   +       count = 0;
>
> Since count starts at 1, condition is now always true, and count then
> reset to 0. Restoring the comparaison to MAX_TUPLES makes everybody
> happy...
>
> 	M.
>
> Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
>
> diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
> index 9fcff0c..65129b5 100644
> --- a/drivers/pcmcia/cistpl.c
> +++ b/drivers/pcmcia/cistpl.c
> @@ -1490,7 +1490,7 @@ int pccard_validate_cis(struct pcmcia_socket *s, 
> unsigned int function, unsigned
>  	    ((tuple->TupleCode > 0x90) && (tuple->TupleCode < 0xff)))
>  	    reserved++;
>      }
> -    if ((count) || (reserved > 5) ||
> +    if ((count == MAX_TUPLES) || (reserved > 5) ||
>  	((!dev_ok || !ident_ok) && (count > 10)))
>  	count = 0;

Confirmed: this fixes CF card detection on my SH and MIPS boards.
Thanks!

-- 
 Manuel Lauss
