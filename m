Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbYBOGFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbYBOGFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 01:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761047AbYBOGFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 01:05:18 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:40055
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759132AbYBOGFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 01:05:16 -0500
Message-ID: <47B52B95.3070607@cosmosbay.com>
Date: Fri, 15 Feb 2008 07:05:09 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: herbert@gondor.apana.org.au, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: tbench regression in 2.6.25-rc1
References: <1203040321.3027.131.camel@ymzhang>
In-Reply-To: <1203040321.3027.131.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Yanmin a écrit :
> Comparing with kernel 2.6.24, tbench result has regression with
> 2.6.25-rc1.
> 
> 1) On 2 quad-core processor stoakley: 4%.
> 2) On 4 quad-core processor tigerton: more than 30%.
> 
> bisect located below patch.
> 
> b4ce92775c2e7ff9cf79cca4e0a19c8c5fd6287b is first bad commit
> commit b4ce92775c2e7ff9cf79cca4e0a19c8c5fd6287b
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Nov 13 21:33:32 2007 -0800
> 
>     [IPV6]: Move nfheader_len into rt6_info
>     
>     The dst member nfheader_len is only used by IPv6.  It's also currently
>     creating a rather ugly alignment hole in struct dst.  Therefore this patch
>     moves it from there into struct rt6_info.
> 
> 
> As tbench uses ipv4, so the patch's real impact on ipv4 is it deletes
> nfheader_len in dst_entry. It might change cache line alignment.
> 
> To verify my finding, I just added nfheader_len back to dst_entry in 2.6.25-rc1
> and reran tbench on the 2 machines. Performance could be recovered completely.
> 
> I started cpu_number*2 tbench processes. On my 16-core tigerton:
> #./tbench_srv &
> #./tbench 32 127.0.0.1
> 
> -yanmin

Yup. struct dst is sensitive to alignements, especially for benches.

In the real world, we need to make sure that next pointer start at a cache 
line bondary (or a litle bit after), so that RT cache lookups use one cache 
line per entry instead of two. This permits better behavior in DDOS attacks.

(check commit 1e19e02ca0c5e33ea73a25127dbe6c3b8fcaac4b for reference)

Are you using a 64 or a 32 bit kernel ?


