Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZGBOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZGBOOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZGBOOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 10:14:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:16134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZGBOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 10:14:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,334,1243839600"; 
   d="scan'208";a="529692387"
From: "Shi, Alex" <alex.shi@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
CC: "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
Date: Thu, 2 Jul 2009 22:12:09 +0800
Subject: RE: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
Thread-Topic: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
Thread-Index: Acn68lp4gNRHtLyNThysNat7/+Gd6QALJVog
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6502C8404B2A@PDSMSX501.ccr.corp.intel.com>
References: <bug-13690-10286@http.bugzilla.kernel.org/>
	 <20090701183452.8660c8a9.akpm@linux-foundation.org>
	 <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp>
 <4A4C74D8.30809@kernel.org>
In-Reply-To: <4A4C74D8.30809@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n62EEPoU012989

Yes, the patch fixes this bug! 

Alex 

>-----Original Message-----
>From: Yinghai Lu [mailto:yinghai@kernel.org]
>Sent: 2009Äê7ÔÂ2ÈÕ 16:51
>To: Shi, Alex; Andrew Morton; Ingo Molnar
>Cc: bugzilla-daemon@bugzilla.kernel.org; bugme-daemon@bugzilla.kernel.org;
>Christoph Lameter; Mel Gorman; linux-kernel@vger.kernel.org; Zhang, Yanmin;
>Chen, Tim C
>Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage unusable
>on non-NUMA machine
>
>Alex Shi wrote:
>> The new patch works for my stoakley i386 machine. But for x86_64 machine
>> the specjbb2005 still can not run with hugepage. The specjbb2005 use the
>> same java setting as i386 system. After apply your patch, the iomem of
>> x86_64 is:
>
>please check
>
>[PATCH] x86: don't clear nodes_states[N_NORMAL_MEMORY] when numa is not
>compiled in
>
>Alex found:
>for x86_64 machine the specjbb2005 still can not run with hugepage
>
>only happens when numa is not compiled in
>
>the root cause: node_set_state will not set it back for us in that case
>
>so don't clear that when numa is not select in config
>
>Reported-by: Alex Shi <alex.shi@intel.com>
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
>---
> arch/x86/mm/init_64.c |    8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>Index: linux-2.6/arch/x86/mm/init_64.c
>===================================================================
>--- linux-2.6.orig/arch/x86/mm/init_64.c
>+++ linux-2.6/arch/x86/mm/init_64.c
>@@ -598,8 +598,14 @@ void __init paging_init(void)
>
> 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
> 	sparse_init();
>-	/* clear the default setting with node 0 */
>+#if MAX_NUMNODES > 1
>+	/*
>+	 * clear the default setting with node 0
>+	 * note: don't clear it, node_set_state will do nothing
>+	 *	 (aka set it back) when numa support is not compiled in
>+	 */
> 	nodes_clear(node_states[N_NORMAL_MEMORY]);
>+#endif
> 	free_area_init_nodes(max_zone_pfns);
> }
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
