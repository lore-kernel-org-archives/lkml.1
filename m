Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXENOkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXENOkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXENOkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:40:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:63890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXENOkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:40:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency by changing tlb flush size
Date: Mon, 14 May 2007 16:40:02 +0200
User-Agent: KMail/1.9.6
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
References: <yyi3b1zapqa.wl@toshiba.co.jp> <1179125506.22481.297.camel@localhost.localdomain> <yyitzuf9857.wl@toshiba.co.jp>
In-Reply-To: <yyitzuf9857.wl@toshiba.co.jp>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705141640.02561.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18JXwV/dZrp+7gNJaDSG6WqQlzNvnUpvd6Tb8/
 C3TcoOs1bm9C2Sf0M0aTfMl1A8o+1Cy0ON+9ydbymiz0rHGjq2
 17R3Z46Fq+nZu9VtbSo9g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007, Tsutomu OWA wrote:
> --- linux-2.6.21-rt1/include/asm-powerpc/tlbflush.h     2007-04-26 12:08:32.000000000 +0900
> +++ rt/include/asm-powerpc/tlbflush.h   2007-05-14 16:12:47.000000000 +0900
> @@ -25,7 +25,12 @@ struct mm_struct;
>  #include <linux/percpu.h>
>  #include <asm/page.h>
>  
> +#if defined(CONFIG_PPC_CELLEB) && defined(CONFIG_PREEMPT_RT)
> +/* Since tlb flush takes long time on Celleb, reduce it to 1 when Celleb && RT */
> +#define PPC64_TLB_BATCH_NR 1
> +#else
>  #define PPC64_TLB_BATCH_NR 192
> +#endif /* defined(CONFIG_PPC_CELLEB) && defined(CONFIG_PREEMPT_RT) */

With this code, you get silent side-effects of enabling PPC_CELLEB
along with another platform.

Maybe instead you should change the hpte_need_flush() to always flush
when running on the celleb platform and PREEMPT_RT is enabled.

	Arnd <><
