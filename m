Return-Path: <linux-kernel-owner+w=401wt.eu-S938182AbXHIFIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938182AbXHIFIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXHIFIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:08:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55433
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbXHIFIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:08:37 -0400
Date: Wed, 08 Aug 2007 22:08:38 -0700 (PDT)
Message-Id: <20070808.220838.88002572.davem@davemloft.net>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, Zoltan.Menyhart@bull.net, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte() on ia64 take9 [2/2]
 flush icache at set_pte
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
	<20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 9 Aug 2007 13:57:21 +0900

> Changelog v8 -> v9.
>  - removed sync_icache_dcache().
>  - modified set_pte() rather than adding new complexed macro.
> 
> Old stories
>  - For synching icache and dcache before set_pte(), I added a new macro for
>    ia64, sync_icache_dcache(). I inserted it in proper places.
>    Comments from reviewer was negative becasue ia64 specific codes are
>    scattered over vm codes and it will not be able to be maintained.
>    An advice was hide all in set_pte() because flush_xxx_cache cannot pass
>    enough information to arch.
> 
> Current ia64 kernel flushes icache by lazy_mmu_prot_update() *after*
> set_pte(). This is too late. This patch removes lazy_mmu_prot_update and
> add modfied set_pte() for flushing if necessary.
> 
> This patch flush icache of a page when
> 	new pte has exec bit.
> 	&& new pte has present bit
> 	&& new pte is user's page.
> 	&& (old *ptep is not present 
>             || new pte's pfn is not same to old *ptep's ptn)
> 	&& new pte's page has no Pg_arch_1 bit.
> 	   Pg_arch_1 is set when a page is cache consistent.
> 
> I think this condition checks are much easier to understand than considering
> "Where sync_icache_dcache() should be inserted ?".
> 
> pte_user() for ia64 was removed by http://lkml.org/lkml/2007/6/12/67 as
> clean-up. So, I added it again.
> 
> Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

If this patch works I am very happy with it, since lazy_mmu_prot_update()
is now completely gone as a result.

Acked-by: David S. Miller <davem@davemloft.net>
