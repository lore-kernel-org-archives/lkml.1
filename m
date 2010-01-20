Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379Ab0ATK51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0ATK51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872Ab0ATK5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:57:25 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:56759
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750962Ab0ATK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:57:23 -0500
X-SpamScore: -6
X-BigFish: VPS-6(z1039ozab9bh1432R98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWJL2A-02-0UO-02
X-M-MSG: 
Date: Wed, 20 Jan 2010 11:56:34 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: monstr@monstr.eu
CC: linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       linux-arch@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] asm-generic: dma: Add BUG_ON for uninitialized dma_ops
Message-ID: <20100120105634.GC8665@amd.com>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
 <1263982111-24123-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1263982111-24123-2-git-send-email-monstr@monstr.eu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jan 2010 10:56:34.0965 (UTC) FILETIME=[3B81DC50:01CA99BF]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 11:08:31AM +0100, monstr@monstr.eu wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> Check that dma_ops are initialized correctly. Without this
> checking you get kernel fault and you don't know where the problem is.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  include/asm-generic/dma-mapping-common.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
> index e694263..ca8bc25 100644
> --- a/include/asm-generic/dma-mapping-common.h
> +++ b/include/asm-generic/dma-mapping-common.h
> @@ -15,6 +15,7 @@ static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
>  	dma_addr_t addr;
>  
>  	kmemcheck_mark_initialized(ptr, size);
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	addr = ops->map_page(dev, virt_to_page(ptr),
>  			     (unsigned long)ptr & ~PAGE_MASK, size,

[...]

> @@ -169,6 +178,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
>  {
>  	struct dma_map_ops *ops = get_dma_ops(dev);
>  
> +	BUG_ON(!ops);
>  	BUG_ON(!valid_dma_direction(dir));
>  	if (ops->sync_sg_for_device)
>  		ops->sync_sg_for_device(dev, sg, nelems, dir);

The more logical place for all these checks would be in get_dma_ops. But
I also question the value of the check. Every dma_ops implementation
that has survived a boot test shouldn't have this bug. So I see no point
in adding extra cycles to every dma-api call.

	Joerg


