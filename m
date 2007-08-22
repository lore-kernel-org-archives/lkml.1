Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXHVQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXHVQ6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761894AbXHVQ6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:58:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:9043 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759929AbXHVQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kmOH3D+XL/MyT7j05ykJE6NFfuian1Rq/P8t+6L7h00WK/utqrGiVH192j8bfbIdo2XCFFGB2RIu0Qr33au8YHWM3a/Nz2k7O6ss+H7O1cLrs5d3lDu0FWDa5j1EMyYvbgkolSYuWZ6NuXpNF0JCrE6KhkGMXli12PhbhWNk7Ks=
Message-ID: <46CC6AE7.1070005@googlemail.com>
Date: Wed, 22 Aug 2007 18:57:11 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6112.9030705@googlemail.com> <20070822162802.GJ9163@parisc-linux.org>
In-Reply-To: <20070822162802.GJ9163@parisc-linux.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Aug 22, 2007 at 06:15:14PM +0200, Gabriel C wrote:
>> advansys.c:(.init.text+0x38ea): undefined reference to `isa_register_driver'
>> I guess advansys_{init,exit} is missing some #ifdef's ..
> 
> That's one conclusion.  I prefer to think that the ISA support should
> behave the same as the PCI and EISA support:

Yes right , your patch fixes the problem.

> 
> ----
> 
> When CONFIG_ISA is disabled, the isa_driver support will not be compiled
> in.  Define stubs so that we don't get link-time errors.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/include/linux/isa.h b/include/linux/isa.h
> index 1b85533..b0270e3 100644
> --- a/include/linux/isa.h
> +++ b/include/linux/isa.h
> @@ -22,7 +22,18 @@ struct isa_driver {
>  
>  #define to_isa_driver(x) container_of((x), struct isa_driver, driver)
>  
> +#ifdef CONFIG_ISA
>  int isa_register_driver(struct isa_driver *, unsigned int);
>  void isa_unregister_driver(struct isa_driver *);
> +#else
> +static inline int isa_register_driver(struct isa_driver *d, unsigned int i)
> +{
> +	return 0;
> +}
> +
> +static inline void isa_unregister_driver(struct isa_driver *d)
> +{
> +}
> +#endif
>  
>  #endif /* __LINUX_ISA_H */
> 
