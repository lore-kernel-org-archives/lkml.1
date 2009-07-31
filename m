Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbZGaA1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbZGaA1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZGaA1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:27:12 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:62802 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZGaA1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OULEOCDxaEXvkjeuUtdZp1GrEWChpkZiSB/aWT7bFP1U/e8SwVT3QZNT25XFY2Te8o
         fNUFbRJItLIWiMKRct6DsjtSEz1uiqQX4TlCrTKP8CcXmzfq3czt/h/dWwvhClggDx/U
         LRFj1vG3xYw+C4AVzD8qIgenb27tBOhNFThRE=
MIME-Version: 1.0
In-Reply-To: <20090730214319.GA1889@linux-os.sc.intel.com>
References: <20090730214319.GA1889@linux-os.sc.intel.com>
Date: Fri, 31 Jul 2009 10:27:11 +1000
Message-ID: <21d7e9970907301727m35876890j485d1bf3cf498b52@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix set_memory_wc related corruption
From: Dave Airlie <airlied@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, suresh.b.siddha@intel.com,
       Jerome Glisse <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 7:43 AM, Pallipadi,
Venkatesh<venkatesh.pallipadi@intel.com> wrote:
>
> Changeset 3869c4aa18835c8c61b44bd0f3ace36e9d3b5bd0
> that went in after 2.6.30-rc1 was a seemingly small change to _set_memory_wc()
> to make it complaint with SDM requirements. But, introduced a nasty bug, which
> can result in crash and/or strange corruptions when set_memory_wc is used.
> One such crash reported here
> http://lkml.org/lkml/2009/7/30/94
>
> Actually, that changeset introduced two bugs.
> * change_page_attr_set() takes &addr as first argument and can the addr value
>  might have changed on return, even for single page change_page_attr_set()
>  call. That will make the second change_page_attr_set() in this routine
>  operate on unrelated addr, that can eventually cause strange corruptions
>  and bad page state crash.
> * The second change_page_attr_set() call, before setting _PAGE_CACHE_WC, should
>  clear the earlier _PAGE_CACHE_UC_MINUS, as otherwise cache attribute will not
>  be WC (will be UC instead).
>
> The patch below fixes both these problems. Sending a single patch to fix both
> the problems, as the change is to the same line of code. The change to have a
> addr_copy is not very clean. But, it is simpler than making more changes
> through various routines in pageattr.c.
>
> A huge thanks to Jerome for reporting this problem and providing a simple test
> case that helped us root cause the problem.
>
> Reported-by: Jerome Glisse <glisse@freedesktop.org>
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Acked-by: Dave Airlie <airlied@redhat.com>

please urgent this, so I don't get blamed for radeon KMS not working ;-)

Dave.

> ---
>
> Patch needed for 2.6.30-stable as well
>
>  arch/x86/mm/pageattr.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 1b734d7..895d90e 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -997,12 +997,15 @@ EXPORT_SYMBOL(set_memory_array_uc);
>  int _set_memory_wc(unsigned long addr, int numpages)
>  {
>        int ret;
> +       unsigned long addr_copy = addr;
> +
>        ret = change_page_attr_set(&addr, numpages,
>                                    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
> -
>        if (!ret) {
> -               ret = change_page_attr_set(&addr, numpages,
> -                                   __pgprot(_PAGE_CACHE_WC), 0);
> +               ret = change_page_attr_set_clr(&addr_copy, numpages,
> +                                              __pgprot(_PAGE_CACHE_WC),
> +                                              __pgprot(_PAGE_CACHE_MASK),
> +                                              0, 0, NULL);
>        }
>        return ret;
>  }
> --
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
