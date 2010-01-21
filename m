Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274Ab0AUPux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab0AUPux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955Ab0AUPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:50:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab0AUPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:50:51 -0500
Date: Thu, 21 Jan 2010 07:49:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 04/36] x86/pci: add cap_resource
In-Reply-To: <1264055303-15123-5-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1001210745330.13231@localhost.localdomain>
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-5-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jan 2010, Yinghai Lu wrote:
> 
> -v2: hpa said we should compare with (resource_size_t)~0

Hmm. Some of these look dubious.

> diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
> index f939d60..b267919 100644
> --- a/arch/x86/pci/bus_numa.c
> +++ b/arch/x86/pci/bus_numa.c
> @@ -60,6 +60,9 @@ void __devinit update_res(struct pci_root_info *info, size_t start,
>  	if (start > end)
>  		return;
>  
> +	if (start == (resource_size_t)~0)
> +		return;

Here, 'start' isn't a resource_size_t. It's a regular size_t. And if 
resource_size_t is u64, and size_t is u32, this test can never be true.

Maybe that is intentional, but if looks odd/wrong. Needs a comment if 
right, needs fixing if wrong.

> +static inline resource_size_t cap_resource(u64 val)
> +{
> +	if (val > (resource_size_t)~0)
> +		return (resource_size_t)~0;
> +	else
> +		return val;
> +}
>  #endif

And this just looks odd. I'd suggest just doing

	#define MAX_RESOURCE ((resource_size_t)~0)

	static inline resource_size_t cap_resource(u64 val)
	{
		if (val > MAX_RESOURCE)
			val = MAX_RESOURCE;
		return val;
	}

instead, which looks a whole lot more natural. No?

			Linus
