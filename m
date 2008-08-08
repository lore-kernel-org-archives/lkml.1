Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYHHDiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYHHDiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYHHDih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:38:37 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:22504 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYHHDig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=i2jvDdShS2TxySdYdX4G0pazVICI+eas/3dvhrLAESlYdNSCae/K4jC+Hnbytx4oiK
         4/Wf/6Ebp7hxv/ShRe6d2bF3nCRY0vFB9V+yP+zS+o4im+isTLTtvH+PR1OUNs3quB4o
         LmnGKu/I9EHxAM29wvSvd5bGoQqkYnkVvokHE=
Message-ID: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com>
Date: Thu, 7 Aug 2008 20:38:35 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Austin Zhang" <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
       davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1218000211.4231.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218000211.4231.23.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 10:23 PM, Austin Zhang
<austin_zhang@linux.intel.com> wrote:
> +#ifdef CONFIG_X86_64
> +#define REX_PRE "0x48, "
> +#define SCALE_F 8
> +#else
> +#define REX_PRE
> +#define SCALE_F 4
> +#endif
[...]
> +static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len)
> +{
> +       unsigned int iquotient = len / SCALE_F;
> +       unsigned int iremainder = len % SCALE_F;
> +       unsigned long *ptmp = (unsigned long *)p;
> +
> +       while (iquotient--) {
> +               __asm__ __volatile__(
> +                       ".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
> +                       :"=S"(crc)
> +                       :"0"(crc), "c"(*ptmp)
> +               );
> +               ptmp++;

I think you want to use

  #define SCALE_F sizeof(unsigned long)

Since the loop iteration count etc depends on

   ptmp++

which depends on the type being unsigned long.
