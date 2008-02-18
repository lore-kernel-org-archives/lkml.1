Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYBRBoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYBRBoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYBRBoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:44:19 -0500
Received: from mga05.intel.com ([192.55.52.89]:10078 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbYBRBoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:44:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,368,1199692800"; 
   d="scan'208";a="520207266"
Subject: Re: tbench regression in 2.6.25-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: herbert@gondor.apana.org.au, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <47B59FFC.4030603@cosmosbay.com>
References: <1203040321.3027.131.camel@ymzhang>
	 <47B52B95.3070607@cosmosbay.com> <1203057044.3027.134.camel@ymzhang>
	 <47B59FFC.4030603@cosmosbay.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 18 Feb 2008 09:39:06 +0800
Message-Id: <1203298746.3027.179.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 15:21 +0100, Eric Dumazet wrote:
> Zhang, Yanmin a écrit :
> > On Fri, 2008-02-15 at 07:05 +0100, Eric Dumazet wrote:
> >   
> >> Zhang, Yanmin a �crit :
> >>     
> >>> Comparing with kernel 2.6.24, tbench result has regression with
> >>> 2.6.25-rc1.
> >>>
> >>> 1) On 2 quad-core processor stoakley: 4%.
> >>> 2) On 4 quad-core processor tigerton: more than 30%.
> >>>
> >>> bisect located below patch.
> >>>
> >>> b4ce92775c2e7ff9cf79cca4e0a19c8c5fd6287b is first bad commit
> >>> commit b4ce92775c2e7ff9cf79cca4e0a19c8c5fd6287b
> >>> Author: Herbert Xu <herbert@gondor.apana.org.au>
> >>> Date:   Tue Nov 13 21:33:32 2007 -0800
> >>>
> >>>     [IPV6]: Move nfheader_len into rt6_info
> >>>     
> >>>     The dst member nfheader_len is only used by IPv6.  It's also currently
> >>>     creating a rather ugly alignment hole in struct dst.  Therefore this patch
> >>>     moves it from there into struct rt6_info.
> >>>
> >>>
> >>> As tbench uses ipv4, so the patch's real impact on ipv4 is it deletes
> >>> nfheader_len in dst_entry. It might change cache line alignment.
> >>>
> >>> To verify my finding, I just added nfheader_len back to dst_entry in 2.6.25-rc1
> >>> and reran tbench on the 2 machines. Performance could be recovered completely.
> >>>
> >>> I started cpu_number*2 tbench processes. On my 16-core tigerton:
> >>> #./tbench_srv &
> >>> #./tbench 32 127.0.0.1
> >>>
> >>> -yanmin
> >>>       
> >> Yup. struct dst is sensitive to alignements, especially for benches.
> >>
> >> In the real world, we need to make sure that next pointer start at a cache 
> >> line bondary (or a litle bit after), so that RT cache lookups use one cache 
> >> line per entry instead of two. This permits better behavior in DDOS attacks.
> >>
> >> (check commit 1e19e02ca0c5e33ea73a25127dbe6c3b8fcaac4b for reference)
> >>
> >> Are you using a 64 or a 32 bit kernel ?
> >>     
> > 64bit x86-64 machine. On another 4-way Madison Itanium machine, tbench has the
> > similiar regression.
> >
> >   
> 
> On linux-2.6.25-rc1 x86_64 :
> 
> offsetof(struct dst_entry, lastuse)=0xb0
> offsetof(struct dst_entry, __refcnt)=0xb8
> offsetof(struct dst_entry, __use)=0xbc
> offsetof(struct dst_entry, next)=0xc0
> 
> So it should be optimal... I dont know why tbench prefers __refcnt being 
> on 0xc0, since in this case lastuse will be on a different cache line...
> 
> Each incoming IP packet will need to change lastuse, __refcnt and __use, 
> so keeping them in the same cache line is a win.
> 
> I suspect then that even this patch could help tbench, since it avoids 
> writing lastuse...
> 
> diff --git a/include/net/dst.h b/include/net/dst.h
> index e3ac7d0..24d3c4e 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -147,7 +147,8 @@ static inline void dst_use(struct dst_entry *dst, 
> unsigned long time)
>  {
>         dst_hold(dst);
>         dst->__use++;
> -       dst->lastuse = time;
> +       if (time != dst->lastuse)
> +               dst->lastuse = time;
>  }
I did a quick test and this patch doesn't help tbench.

Thanks,
-yanmin


