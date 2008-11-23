Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYKWX4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYKWX4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKWX4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:56:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKWX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:56:06 -0500
Message-ID: <4929ECB7.8080108@zytor.com>
Date: Sun, 23 Nov 2008 15:52:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
References: <20081105222911.d76e7e1c.mitake@clustcom.com>	<413709.12821.qm@web50106.mail.re2.yahoo.com>	<20081106164641.ed369060.akpm@linux-foundation.org>	<20081107152830.a42766f3.mitake@clustcom.com>	<20081106223122.8a255211.akpm@linux-foundation.org>	<20081107153824.0ec934e6.mitake@clustcom.com>	<20081106231102.aab83cd4.akpm@linux-foundation.org>	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>	<20081109112646.97c594b5.akpm@linux-foundation.org>	<20081118121620.GB8625@linux-mips.org>	<20081118123215.GB30509@flint.arm.linux.org.uk> <20081121011941.26e05a25.h.mitake@gmail.com>
In-Reply-To: <20081121011941.26e05a25.h.mitake@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -57,6 +57,14 @@ build_mmio_write(__writeq, "q", unsigned long, "r", )
>  /* Let people know we have them */
>  #define readq readq
>  #define writeq writeq
> +
> +#else  /* CONFIG_X86_32 */
> +
> +static inline unsigned long readq(const volatile void __iomem *addr)
> +{
> +	return readl(addr) | (((u64)readl(addr + 4)) << 32);
> +}
> +
>  #endif
>  

Let's see:

* undefined ordering of operations (at least on x86, they really should
be performed in LSB first order.)

* Using "unsigned long" for a 64-bit number on a 32-bit architecture.

* Arithmetic on a void pointer.


Try something like:

static inline u64 readq(const volative void __iomem *addr)
{
	volatile u32 __iomem *__p = addr;
	u32 __l, __h;

	__l = readl(p);
	__h = readl(p+1);

	return __l + ((u64)__h << 32);
}

	-hpa
