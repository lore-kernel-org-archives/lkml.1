Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYIZHMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYIZHMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYIZHMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:12:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYIZHMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:12:21 -0400
Date: Fri, 26 Sep 2008 09:12:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: e1000e NVM corruption issue status
Message-ID: <20080926071205.GA27956@elte.hu>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251857360.1736@jbrandeb-desk.amr.corp.intel.com> <Pine.WNT.4.63.0809251907250.1736@jbrandeb-desk.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.WNT.4.63.0809251907250.1736@jbrandeb-desk.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brandeburg, Jesse <jesse.brandeburg@intel.com> wrote:

> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> Export set_memory_ro() and set_memory_rw() calls. Soon to be used
> by e1000e.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> 
>  arch/x86/mm/pageattr.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 43e2f84..0991e15 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -906,11 +906,13 @@ int set_memory_ro(unsigned long addr, int numpages)
>  {
>  	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
>  }
> +EXPORT_SYMBOL(set_memory_ro);
>  
>  int set_memory_rw(unsigned long addr, int numpages)
>  {
>  	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
>  }
> +EXPORT_SYMBOL(set_memory_rw);

that's fine, as long as you make it kernel-internal EXPORT_SYMBOL_GPL():

  Acked-by: Ingo Molnar <mingo@elte.hu>

feel free to push that bit via the networking tree(s) whenever you think 
you'd like to push it. We can queue it up in the x86 tree too - it's a 
useful debug facility for critical resources.

one other possible angle beyond these current theories of user-space PCI 
BAR corruption (perhaps) and racy in-kernel corruption (less likely) is 
PAT and conflicting caching attributes.

But that too is in the race category IMO (while this corruption seems to 
trigger straight away on the affected boxes) and the CPUs that saw these 
corruptions should triple fault if the OS creates conflicting cache 
attributes.

	Ingo
