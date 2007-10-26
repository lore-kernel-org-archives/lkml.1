Return-Path: <linux-kernel-owner+w=401wt.eu-S1764316AbXJZSTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764316AbXJZSTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXJZSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:19:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbXJZSTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:19:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] Fix CONFIG_SMP=n build break
Date: Fri, 26 Oct 2007 20:19:10 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Olof Johansson <olof@lixom.net>, paulus@samba.org,
       linux-kernel@vger.kernel.org
References: <20071026165510.GA2323@lixom.net>
In-Reply-To: <20071026165510.GA2323@lixom.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710262019.12094.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19a9FXDJKg0hCTvKtUcoexYHR1Ny+lUsZ3tVyz
 h9UNoyW6eVasFC3VejXwmJ/+FQ+HAd+NITmSVXyg4v3XNO/sOW
 Kh4pzMIrSoFE7xiBcR8Jg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007, Olof Johansson wrote:
> Fix two build errors on powerpc allyesconfig + CONFIG_SMP=n:
>
> arch/powerpc/platforms/built-in.o: In function `cpu_affinity_set':
> arch/powerpc/platforms/cell/spu_priv1_mmio.c:78: undefined reference to
> `.iic_get_target_id' arch/powerpc/platforms/built-in.o: In function
> `iic_init_IRQ':
> arch/powerpc/platforms/cell/interrupt.c:397: undefined reference to
> `.iic_setup_cpu'

Thanks for reporting this.

> --- a/arch/powerpc/platforms/cell/spu_priv1_mmio.c
> +++ b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
> @@ -75,9 +75,11 @@ static u64 int_stat_get(struct spu *spu, int class)
>  
>  static void cpu_affinity_set(struct spu *spu, int cpu)
>  {
> +#ifdef CONFIG_SMP
>         u64 target = iic_get_target_id(cpu);
>         u64 route = target << 48 | target << 32 | target << 16;
>         out_be64(&spu->priv1->int_route_RW, route);
> +#endif
>  }

I think here it would be better to move iic_get_target_id out of
CONFIG_SMP as well. We might want to kexec from an SMP kernel into
a UP kernel, and in that case, cpu_affinity_set() should better
reset the routing to CPU 0.

	Arnd <><
