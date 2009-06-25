Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZFYCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZFYCn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZFYCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:43:18 -0400
Received: from mga07.intel.com ([143.182.124.22]:52684 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752094AbZFYCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,287,1243839600"; 
   d="scan'208";a="158255606"
Subject: Re: [GIT pull] futex fixes for 2.6.31
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>
	 <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>
	 <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2009 10:43:46 +0800
Message-Id: <1245897826.2560.421.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 21:48 +0200, Thomas Gleixner wrote:
> Linus,
> 
> Please pull the latest futexes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus
> 
> Thanks,
> 
> 	tglx
> 
> ------------------>
> Thomas Gleixner (1):
>       futex: Fix the write access fault problem for real
> 
> 
>  kernel/futex.c |   45 ++++++++++++++++++++++++---------------------
>  1 files changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 80b5ce7..1c33711 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -284,6 +284,25 @@ void put_futex_key(int fshared, union futex_key *key)
>  	drop_futex_key_refs(key);
>  }
>  
> +/*
> + * fault_in_user_writeable - fault in user address and verify RW access
> + * @uaddr:	pointer to faulting user space address
> + *
> + * Slow path to fixup the fault we just took in the atomic write
> + * access to @uaddr.
> + *
> + * We have no generic implementation of a non destructive write to the
> + * user address. We know that we faulted in the atomic pagefault
> + * disabled section so we can as well avoid the #PF overhead by
> + * calling get_user_pages() right away.
> + */
> +static int fault_in_user_writeable(u32 __user *uaddr)
> +{
> +	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
> +				 sizeof(*uaddr), 1, 0, NULL, NULL);
The 4th parameter of get_user_pages means page number. ﻿sizeof(*uaddr) is equal to
4, so you want 4 pages?

Yanmin


