Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbYKNQeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbYKNQeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYKNQdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:33:51 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:12871 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNQdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:33:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v+IzTVic+fXOUDtJLBLF1EZQi915nym1f2LpO3uVTOjFsOmYKy4sCn2k7OlmjyBzx5
         ZX1BB7WCKaieS6kuaXL8JcPrP066Ih2EQRtQC6HWxj8g9rOKEnBVNVDv+13IQd5Onv67
         zUzj75FUaRVxvnKQhGDBIVjrtNHRKDieZsKCo=
Subject: Re: [PATCH 10/10] xtensa: use the new byteorder headers - Merged
 with your previous xtensa-next and will remerge shortly.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Piet Delaney <piet.delaney@tensilica.com>
Cc: Chris Zankel <chris@zankel.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Marc Gauthier <marc@tensilica.com>,
       Joe Taylor <joetayloremail@gmail.com>, linux-xtensa@linux-xtensa.org,
       Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <491D3338.80405@tensilica.com>
References: <1225910131.5991.230.camel@brick> <49133094.6070407@zankel.net>
	 <491500C0.90407@tensilica.com> <1226115481.11596.63.camel@brick>
	 <49165F4A.4070905@tensilica.com>  <491D3338.80405@tensilica.com>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 08:33:45 -0800
Message-Id: <1226680425.5483.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 00:13 -0800, Piet Delaney wrote:
> Piet Delaney wrote:
> > Harvey Harrison wrote:
> >> On Fri, 2008-11-07 at 19:00 -0800, Piet Delaney wrote:
> >>> Hi Chris:
> >>>
> >>>    I've merged your recent xtensa-next with our 2.6.24-smp repo.
> >>> It seems to work fine and I'm in the process of cleaning it
> >>> up a bit and adding preliminary XTENSA kgdb support.
> >>
> >> 2.6.24?  In that case you probably don't have include/linux/byteorder.h,
> >> or include/linux/swab.h which would explain your byteorder problems.
> >>
> >> Or is that a typo in the version numbers?
> > 
> > I was on 2.6.24 and didn't have a problem compiling the kernel -O0 other
> > than a minor tweak in slab.c. Now in 2.6.27-rc3 I get a compile problem
> > with rpcb_clnt.c at lines 122, 123, and 129:
> > 
> >    /export/src/xtensa-next/net/sunrpc/rpcb_clnt.c:129: error: (near 
> > initialization for 'rpcb_in6addr_loopback.sin6_port')
> > 
> 
> The problem is fixed by changing htons() to __constant_htons().
> The __constant_*() flavors use a #define and always compile
> to a constant. Ex:
> 
> #define ___constant_swab32(x) \
>          ((__u32)( \
>                  (((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
>                  (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
>                  (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
>                  (((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
> 
> I tried compiling the recent snapshot from Linus's tree and it
> has a new instance of the problem in a common network file.
> 
> In this case the recent change was FROM __constant_htons()
> to htons(). See net/core/dev.c`simple_tx_hash():

I find it strange that the net/core/dev.c bits of this commit were
a problem as they were only changing the use inside the case: statements
which had to be constants in the first place and had better be picked
up by the __builtin_constant_p inside swab32().

I believe you said you were compiling at -O0?  What compiler?

Harvey

