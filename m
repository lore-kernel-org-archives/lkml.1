Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZG3UF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZG3UF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZG3UFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:05:55 -0400
Received: from nox.protox.org ([88.191.38.29]:39193 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZG3UFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:05:55 -0400
Subject: Re: PAT wc & vmap mapping count issue ?
From: Jerome Glisse <glisse@freedesktop.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com
In-Reply-To: <20090730191757.GA16239@linux-os.sc.intel.com>
References: <1248952269.2462.33.camel@localhost>
	 <1248973593.2462.35.camel@localhost>
	 <20090730191757.GA16239@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 22:04:33 +0200
Message-Id: <1248984273.2462.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 12:17 -0700, Pallipadi, Venkatesh wrote:
> This seems to be a regression from changeset
> 3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
> 
> Below test patch should fix the problem. Can you please try it and let use know.
> We can then send a cleaner patch with changelog etc to upstream+stable kernels.
> 
> Thanks,
> Venki
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/mm/pageattr.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 1b734d7..895d90e 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -997,12 +997,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
>  int _set_memory_wc(unsigned long addr, int numpages)
>  {
>  	int ret;
> +	unsigned long addr_copy = addr;
> +
>  	ret = change_page_attr_set(&addr, numpages,
>  				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
> -
>  	if (!ret) {
> -		ret = change_page_attr_set(&addr, numpages,
> -				    __pgprot(_PAGE_CACHE_WC), 0);
> +		ret = change_page_attr_set_clr(&addr_copy, numpages,
> +					       __pgprot(_PAGE_CACHE_WC),
> +					       __pgprot(_PAGE_CACHE_MASK),
> +					       0, 0, NULL);
>  	}
>  	return ret;
>  }

Yes it fixes the issue for me (at least it seems, so far after bunch of
minutes no corruption despite massive set_wc/set_wb/free_page calls).
Thanks a lot for tracking this down.

Cheers,
Jerome Glisse

