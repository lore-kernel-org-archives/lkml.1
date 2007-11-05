Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbXKEEIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbXKEEIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 23:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXKEEH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 23:07:59 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:37775 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXKEEH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 23:07:58 -0500
Date: Sun, 4 Nov 2007 23:06:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, buytenh@wantstofly.org
Subject: Re: [PATCH 1/6] ARM: fix memset size error
In-Reply-To: <472E7CB4.5020301@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0711042302580.31550@localhost.localdomain>
References: <472E7CB4.5020301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Li Zefan wrote:

> The size passing to memset is wrong. And here we can replace
> kmalloc with kzalloc.
>
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
>
> ---
>  arch/arm/common/uengine.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/common/uengine.c b/arch/arm/common/uengine.c
> index 95c8508..117cab3 100644
> --- a/arch/arm/common/uengine.c
> +++ b/arch/arm/common/uengine.c
> @@ -374,8 +374,8 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
>  	u8 *ucode;
>  	int i;
>
> -	gpr_a = kmalloc(128 * sizeof(u32), GFP_KERNEL);
> -	gpr_b = kmalloc(128 * sizeof(u32), GFP_KERNEL);
> +	gpr_a = kzalloc(128 * sizeof(u32), GFP_KERNEL);
> +	gpr_b = kzalloc(128 * sizeof(u32), GFP_KERNEL);
>  	ucode = kmalloc(513 * 5, GFP_KERNEL);
>  	if (gpr_a == NULL || gpr_b == NULL || ucode == NULL) {
>  		kfree(ucode);
> @@ -388,8 +388,6 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
>  	if (c->uengine_parameters & IXP2000_UENGINE_4_CONTEXTS)
>  		per_ctx_regs = 32;
>
> -	memset(gpr_a, 0, sizeof(gpr_a));
> -	memset(gpr_b, 0, sizeof(gpr_b));
>  	for (i = 0; i < 256; i++) {
>  		struct ixp2000_reg_value *r = c->initial_reg_values + i;
>  		u32 *bank;
>
  it's unlikely that patch will cause any trouble whatsoever, but
notice that it *is* changing the underlying logic.  those original
memsets should probably have been written initially as
"sizeof(*gpr_a)" so they would previously have zeroed only memory the
        ^
size of a pointer, no?

  now, i'm guessing the logic is correct but i figured it's worth
noting what the code *used* to do.  unless i'm misreading something
horribly.



rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
