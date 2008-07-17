Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbYGQUD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbYGQUD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbYGQUDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:03:46 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:54386 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYGQUDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V3O+ztdgIyTOxbL3xGkxcXV/DcmPQMBLRKSQDtgZZIi7l2hzFomLS7WNHcfVan3eVM
         tx7MUS2fmjZUM0A0KX9Z/CChXf8hJ6aCBjKD7d5I5parsnbmfuEJankh4D+vnDZSKALu
         BSRvcx0dFiEJ3Oj5IyPVjKW8UIGQkVK+hsMfI=
Message-ID: <9b06e8d20807171303n4c207baas461706159bcbbdfb@mail.gmail.com>
Date: Thu, 17 Jul 2008 22:03:44 +0200
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: "Mikael Pettersson" <mikpe@it.uu.se>
Subject: Re: Typecast problems in SKFP driver
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <18559.37282.156032.998661@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080717173149.GA5040@cognac.dyndns.org>
	 <18559.37282.156032.998661@harpo.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/17 Mikael Pettersson <mikpe@it.uu.se>:
> Loic Grenie writes:
>  >     I've just compiled the 2.6.26-git5 kernel and the SKFP driver
>  >     compilation produces complaints about typecasts. These complaints
>  >     disappear with the following patch.
>
> NAK, this needs to be done by someone with better understanding of C.

     or, better, by someone with a better understanding of the driver.

>  >
>  >       Thanks,
>  >
>  >           Loïc Grenié
>  > diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
>  > index 889f987..d3a8afc 100644
>  > --- a/drivers/net/skfp/ess.c
>  > +++ b/drivers/net/skfp/ess.c
>  > @@ -510,7 +510,7 @@ static void ess_send_response(struct s_smc *smc, struct smt_header *sm,
>  >      chg->path.para.p_type = SMT_P320B ;
>  >      chg->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
>  >      chg->path.mib_index = SBAPATHINDEX ;
>  > -    chg->path.path_pad = (u_short)NULL ;
>  > +    chg->path.path_pad = (u_short)(long)NULL ;
>  >      chg->path.path_index = PRIMARY_RING ;
>
> Putting NULL (a pointer type) in an u_short field is utterly
> and completely broken. My guess is that the code really wants:
>
>        chg->path.path_pad = 0;

    Indeed. I do not even understand why it was done that way in the
  first place.

>  >      /* set P320F */
>  > @@ -606,7 +606,7 @@ static void ess_send_alc_req(struct s_smc *smc)
>  >      req->path.para.p_type = SMT_P320B ;
>  >      req->path.para.p_len = sizeof(struct smt_p_320b) - PARA_LEN ;
>  >      req->path.mib_index = SBAPATHINDEX ;
>  > -    req->path.path_pad = (u_short)NULL ;
>  > +    req->path.path_pad = (u_short)(long)NULL ;
>  >      req->path.path_index = PRIMARY_RING ;
>
> ditto
>
>  >
>  >      /* set P0017 */
>  > @@ -636,7 +636,7 @@ static void ess_send_alc_req(struct s_smc *smc)
>  >      /* set P19 */
>  >      req->a_addr.para.p_type = SMT_P0019 ;
>  >      req->a_addr.para.p_len = sizeof(struct smt_p_0019) - PARA_LEN ;
>  > -    req->a_addr.sba_pad = (u_short)NULL ;
>  > +    req->a_addr.sba_pad = (u_short)(long)NULL ;
>  >      req->a_addr.alloc_addr = null_addr ;
>
> ditto
>
>  >
>  >      /* set P1A */
>  > diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
>  > index ea85de9..5798be4 100644
>  > --- a/drivers/net/skfp/pmf.c
>  > +++ b/drivers/net/skfp/pmf.c
>  > @@ -44,17 +44,17 @@ static SMbuf *smt_build_pmf_response(struct s_smc *smc, struct smt_header *req,
>  >                                   int set, int local);
>  >  static int port_to_mib(struct s_smc *smc, int p);
>  >
>  > -#define MOFFSS(e)   ((int)&(((struct fddi_mib *)0)->e))
>  > -#define MOFFSA(e)   ((int) (((struct fddi_mib *)0)->e))
>  > +#define MOFFSS(e)   ((long)&(((struct fddi_mib *)0)->e))
>  > +#define MOFFSA(e)   ((long) (((struct fddi_mib *)0)->e))
>
> NAK, use offsetof().
>
> How is the MOFFSA() used? As written it makes no sense at all
> as evaluating it as an r-value will oops.

     I think it is used when e is an array (unchecked).

>  >
>  > -#define MOFFMS(e)   ((int)&(((struct fddi_mib_m *)0)->e))
>  > -#define MOFFMA(e)   ((int) (((struct fddi_mib_m *)0)->e))
>  > +#define MOFFMS(e)   ((long)&(((struct fddi_mib_m *)0)->e))
>  > +#define MOFFMA(e)   ((long) (((struct fddi_mib_m *)0)->e))
>
> ditto
>
>  >
>  > -#define MOFFAS(e)   ((int)&(((struct fddi_mib_a *)0)->e))
>  > -#define MOFFAA(e)   ((int) (((struct fddi_mib_a *)0)->e))
>  > +#define MOFFAS(e)   ((long)&(((struct fddi_mib_a *)0)->e))
>  > +#define MOFFAA(e)   ((long) (((struct fddi_mib_a *)0)->e))
>
> ditto
>
>  >
>  > -#define MOFFPS(e)   ((int)&(((struct fddi_mib_p *)0)->e))
>  > -#define MOFFPA(e)   ((int) (((struct fddi_mib_p *)0)->e))
>  > +#define MOFFPS(e)   ((long)&(((struct fddi_mib_p *)0)->e))
>  > +#define MOFFPA(e)   ((long) (((struct fddi_mib_p *)0)->e))
>
> ditto
>
> To be fair, the original code is crap, but your changes don't
> make it any better.
>

     I agree... Maybe someone with stronger guts than mine will have
  read about it and will correct it for some next release.

      Thanks once again,

          Loïc
