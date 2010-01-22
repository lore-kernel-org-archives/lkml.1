Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221Ab0AVHxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0AVHxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 02:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167Ab0AVHxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 02:53:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51945 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab0AVHxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 02:53:14 -0500
Message-ID: <4B595904.4000202@zytor.com>
Date: Thu, 21 Jan 2010 23:51:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       linux-mips@linux-mips.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       shaohui.zheng@intel.com
Subject: Re: [PATCH 1/3] resources: introduce generic page_is_ram()
References: <20100122032102.137106635@intel.com> <20100122033004.193166010@intel.com>
In-Reply-To: <20100122033004.193166010@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 07:21 PM, Wu Fengguang wrote:
> --- linux-mm.orig/kernel/resource.c	2010-01-22 11:20:34.000000000 +0800
> +++ linux-mm/kernel/resource.c	2010-01-22 11:20:35.000000000 +0800
> @@ -327,6 +327,17 @@ int walk_system_ram_range(unsigned long 
>  
>  #endif
>  
> +#define PAGE_IS_RAM	24
> +static int __is_ram(unsigned long pfn, unsigned long nr_pages, void *arg)
> +{
> +	return PAGE_IS_RAM;
> +}
> +int __attribute__((weak)) page_is_ram(unsigned long pfn)
> +{
> +	return PAGE_IS_RAM == walk_system_ram_range(pfn, 1, NULL, __is_ram);
> +}
> +#undef PAGE_IS_RAM
> +

Stylistic nitpick:

The use of the magic number "24" here is pretty ugly; it seems to imply
that there is something peculiar with this number and that it is trying
to avoid an overlap, whereas in fact any number but 0 and -1 would do.

I would rather see just returning 1 and do:

	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;

(walk_system_ram_range() returning -1 on error, and 0 means continue.)

Note also that we don't write "constant == expression"; although some
schools teach it as a way to avoid the "=" versus "==" beginner C
mistake, it makes the code less intuitive to read.

Other than that, the patchset looks good; if Ingo doesn't beat me to it
I'll put it in tomorrow (need sleep right now.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
