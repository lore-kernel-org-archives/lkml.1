Return-Path: <linux-kernel-owner+w=401wt.eu-S1760621AbYGQSil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbYGQSil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbYGQSid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:38:33 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43459 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbYGQSic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:38:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18559.37282.156032.998661@harpo.it.uu.se>
Date: Thu, 17 Jul 2008 20:38:26 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Loic Grenie <loic.grenie@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Typecast problems in SKFP driver
In-Reply-To: <20080717173149.GA5040@cognac.dyndns.org>
References: <20080717173149.GA5040@cognac.dyndns.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Grenie writes:
 >     I've just compiled the 2.6.26-git5 kernel and the SKFP driver
 >     compilation produces complaints about typecasts. These complaints
 >     disappear with the following patch.

NAK, this needs to be done by someone with better understanding of C.

 > 
 >       Thanks,
 > 
 >           Loïc Grenié
 > diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
 > index 889f987..d3a8afc 100644
 > --- a/drivers/net/skfp/ess.c
 > +++ b/drivers/net/skfp/ess.c
 > @@ -510,7 +510,7 @@ static void ess_send_response(struct s_smc *smc, struct smt_header *sm,
 >  	chg->path.para.p_type = SMT_P320B ;
 >  	chg->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 >  	chg->path.mib_index = SBAPATHINDEX ;
 > -	chg->path.path_pad = (u_short)NULL ;
 > +	chg->path.path_pad = (u_short)(long)NULL ;
 >  	chg->path.path_index = PRIMARY_RING ;

Putting NULL (a pointer type) in an u_short field is utterly
and completely broken. My guess is that the code really wants:

	chg->path.path_pad = 0;

 >  	/* set P320F */
 > @@ -606,7 +606,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 >  	req->path.para.p_type = SMT_P320B ;
 >  	req->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
 >  	req->path.mib_index = SBAPATHINDEX ;
 > -	req->path.path_pad = (u_short)NULL ;
 > +	req->path.path_pad = (u_short)(long)NULL ;
 >  	req->path.path_index = PRIMARY_RING ;

ditto

 >  
 >  	/* set P0017 */
 > @@ -636,7 +636,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 >  	/* set P19 */
 >  	req->a_addr.para.p_type = SMT_P0019 ;
 >  	req->a_addr.para.p_len = sizeof(struct smt_p_0019) - PARA_LEN ;
 > -	req->a_addr.sba_pad = (u_short)NULL ;
 > +	req->a_addr.sba_pad = (u_short)(long)NULL ;
 >  	req->a_addr.alloc_addr = null_addr ;

ditto

 >  
 >  	/* set P1A */
 > diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
 > index ea85de9..5798be4 100644
 > --- a/drivers/net/skfp/pmf.c
 > +++ b/drivers/net/skfp/pmf.c
 > @@ -44,17 +44,17 @@ static SMbuf *smt_build_pmf_response(struct s_smc *smc, struct smt_header *req,
 >  				     int set, int local);
 >  static int port_to_mib(struct s_smc *smc, int p);
 >  
 > -#define MOFFSS(e)	((int)&(((struct fddi_mib *)0)->e))
 > -#define MOFFSA(e)	((int) (((struct fddi_mib *)0)->e))
 > +#define MOFFSS(e)	((long)&(((struct fddi_mib *)0)->e))
 > +#define MOFFSA(e)	((long) (((struct fddi_mib *)0)->e))

NAK, use offsetof().

How is the MOFFSA() used? As written it makes no sense at all
as evaluating it as an r-value will oops.

 >  
 > -#define MOFFMS(e)	((int)&(((struct fddi_mib_m *)0)->e))
 > -#define MOFFMA(e)	((int) (((struct fddi_mib_m *)0)->e))
 > +#define MOFFMS(e)	((long)&(((struct fddi_mib_m *)0)->e))
 > +#define MOFFMA(e)	((long) (((struct fddi_mib_m *)0)->e))

ditto

 >  
 > -#define MOFFAS(e)	((int)&(((struct fddi_mib_a *)0)->e))
 > -#define MOFFAA(e)	((int) (((struct fddi_mib_a *)0)->e))
 > +#define MOFFAS(e)	((long)&(((struct fddi_mib_a *)0)->e))
 > +#define MOFFAA(e)	((long) (((struct fddi_mib_a *)0)->e))

ditto

 >  
 > -#define MOFFPS(e)	((int)&(((struct fddi_mib_p *)0)->e))
 > -#define MOFFPA(e)	((int) (((struct fddi_mib_p *)0)->e))
 > +#define MOFFPS(e)	((long)&(((struct fddi_mib_p *)0)->e))
 > +#define MOFFPA(e)	((long) (((struct fddi_mib_p *)0)->e))

ditto

To be fair, the original code is crap, but your changes don't
make it any better.
