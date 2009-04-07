Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbZDGOzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbZDGOzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZDGOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:54:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758621AbZDGOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:54:31 -0400
Date: Tue, 7 Apr 2009 07:50:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
In-Reply-To: <20090407090229.GA2467@elte.hu>
Message-ID: <alpine.LFD.2.00.0904070743380.4010@localhost.localdomain>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org>
 <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu> <20090407090229.GA2467@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Ingo Molnar wrote:
> 
> Switch it to a braced group statement.

No, the way to do that is to just clean it up (or in the worst case just 
add another set of parenthesis, not a statement expression).

That said, whoever made "if()" a macro should be shot. That 
PROFILE_ALL_BRANCHES thing is crazy, crazy.

Anyway, in this case, I think

>  #define for_each_active_iommu(i, drhd)					\
>  	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
> -		if (i=drhd->iommu, drhd->ignored) {} else
> +		if (({i=drhd->iommu, drhd->ignored;})) {} else

Just do it like

	if ( (i=drhd->iommu, drhd->ignored) ) {} else

is still not pretty, but better than using ({..}) I think. And just a 
single set of parenthesis will protect the macro expansion.

But that '#define if(cond)' for the branch profiling is really the core 
problem there. Wow. I never realized quite _how_ ugly tricks it played.

		Linus
