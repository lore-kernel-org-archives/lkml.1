Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYGQWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYGQWu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYGQWuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:50:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:33909 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYGQWuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cw8l7PSYclL7RXgekYZ6S/vPT3MCcs9E2nSVpHcHk4A5/jH+CrE83/A7WBg6WUTTFW
         da3Tf5ry2e1GOWxh8HfJ9iCrPxIqe4a2PIY/uXoEn4VowOnRDl4abJJoSYU60ctGh5sF
         tZYLPZBKkTK8L5eMoT9VcqpPoNEBhwPCqJlho=
Message-ID: <86802c440807171550t360a2a76mddb9ae45c7e9f4fb@mail.gmail.com>
Date: Thu, 17 Jul 2008 15:50:14 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH] x86: Move crashkernel reservation before dma32_reserve_bootmem()
Cc: x86@kernel.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, akpm@linux-foundation.org
In-Reply-To: <1216332945-17197-1-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216332945-17197-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 3:15 PM, Bernhard Walle <bwalle@suse.de> wrote:
> On a x86-64 machine (nothing special I could encounter) I had the problem that
> crashkernel reservation with the usual "64M@16M" failed. While debugging that,
> I encountered that dma32_reserve_bootmem() reserves a memory region which is in
> that area.
>
> Because dma32_reserve_bootmem() does not rely on a specific offset but
> crashkernel does, it makes sense to move the crashkernel reservation up a bit.
> I tested that patch and it works without problems. I don't see any negative
> effects of that move, but maybe I oversaw something ...
>
> While we strictly don't need that patch in 2.6.27 because we have the
> automatic, dynamic offset detection, it makes sense to also include it here
> because:
>
>  - it's easier to get it in -stable then,
>  - many people are still used to the 'crashkernel=...@16M' syntax,
>  - not everybody may be using a reloatable kernel.
>
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/setup.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 531b55b..16101c0 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -792,6 +792,12 @@ void __init setup_arch(char **cmdline_p)
>
>        initmem_init(0, max_pfn);
>
> +       /*
> +        * dma32_reserve_bootmem() allocates bootmem which may conflict
> +        * with the crashkernel command line, so do that before
> +        */
> +       reserve_crashkernel();
> +
>  #ifdef CONFIG_X86_64
>        dma32_reserve_bootmem();
>  #endif
> @@ -808,7 +814,6 @@ void __init setup_arch(char **cmdline_p)
>         */
>        find_smp_config();
>  #endif
> -       reserve_crashkernel();
>
>        reserve_ibft_region();
>

Joe Jin already had another one to move dma32_reserve_bootmem later

YH
