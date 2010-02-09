Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab0BIUEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:04:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab0BIUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:04:19 -0500
Date: Tue, 9 Feb 2010 12:03:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 23/35] x86: make 32bit support NO_BOOTMEM
Message-Id: <20100209120334.f3657ee1.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-24-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-24-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:34 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> --- a/arch/x86/kernel/early_res.c
> +++ b/arch/x86/kernel/early_res.c
> @@ -354,6 +354,9 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
>  
>  	/* need to go over early_node_map to find out good range for node */
>  	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
> +#ifdef CONFIG_X86_32
> +	subtract_range(range, count, max_low_pfn, -1UL);
> +#endif
>  	subtract_early_res(range, count);
>  	nr_range = clean_sort_range(range, count);

I'm too lazy to hunt through all the patches to see the surrounding code...

The "-1UL" is worrisome.  If that contant is to be assigned to a u64
then on x86_32 we end up with 0x00000000ffffffff, which is surely
wrong.

Generally I think it's safer and more maintainable (but odd-looking) to
use plain old "-1" when specifying the all-ones contant pattern. 
Because "-1" always works, whatever the size of the target scalar. 
This particularly matters when you're dealing with types which have
different sizes on different architectures, or whose type changes with
config options.


