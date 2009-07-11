Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZGKIUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZGKIUG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGKITu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:19:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZGKITs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:19:48 -0400
Date: Sat, 11 Jul 2009 10:19:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sonny Rao <sonnyrao@us.ibm.com>
Cc: tglx@linuxtronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, stable@kernel.org, anton@samba.org,
       rajamony@us.ibm.com, speight@us.ibm.com, mstephen@us.ibm.com,
       grimm@us.ibm.com, mikey@ozlabs.au.ibm.com
Subject: Re: [PATCH] futexs: fix infinite loop in get_futex_key on huge page
Message-ID: <20090711081924.GA10437@elte.hu>
References: <20090710231313.GA23572@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710231313.GA23572@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sonny Rao <sonnyrao@us.ibm.com> wrote:

> get_futex_key() can infinitely loop if it is called on a virtual 
> address that is within a huge page but not aligned to the 
> beginning of that page.  The call to get_user_pages_fast will 
> return the struct page for a sub-page within the huge page and the 
> check for page->mapping will always fail.
> 
> The fix is to call compound_head on the page before checking that 
> it's mapped.
> 
> Signed-off-by: Sonny Rao <sonnyrao@us.ibm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: stable@kernel.org
> 
> Index: linux-2.6.31-rc2/kernel/futex.c
> ===================================================================
> --- linux-2.6.31-rc2.orig/kernel/futex.c	2009-07-10 17:45:46.181084475 -0500
> +++ linux-2.6.31-rc2/kernel/futex.c	2009-07-10 17:46:47.345084062 -0500
> @@ -247,6 +247,7 @@
>  	if (err < 0)
>  		return err;
>  
> +	page = compound_head(page);
>  	lock_page(page);
>  	if (!page->mapping) {
>  		unlock_page(page);

Nice catch! Applied it to tip:core/urgent - Thomas, do you agree 
with the fix?

	Ingo
