Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZBEX6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZBEX6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZBEX6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:58:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:37840 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbZBEX6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:58:23 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200902051433.23294.jbarnes@virtuousgeek.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
	 <1233867944.4612.104.camel@pasglop>
	 <200902051433.23294.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 10:57:52 +1100
Message-Id: <1233878272.4612.106.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No, sorry, but I just took a look and as long as the various callers can 
> handle it (haven't checked), this patch would work.
> 
> > The second problem is that if I just don't expose the legacy_mem file,
> > then X has no way to know whether the kernel doesn't support the
> > interface or whether the HW doesn't support legacy memory access. So X
> > will fallback to whacking /dev/mem which is even more bogus. At least
> > that's what I remember from last I looked at that part of X code.
> >
> > It should be a trivial fix on X side tho.
> 
> One option there would be to provide the file but just use anonymous memory to 
> back it.  X will happily think it's messing with legacy VGA memory, but it 
> shouldn't matter that it's not actually affecting hw.

That might be the best approach ... I'll have a look.

Ben.

> diff --git a/hw/xfree86/os-support/bus/linuxPci.c 
> b/hw/xfree86/os-support/bus/li
> index 263fd8f..5d2da32 100644
> --- a/hw/xfree86/os-support/bus/linuxPci.c
> +++ b/hw/xfree86/os-support/bus/linuxPci.c
> @@ -484,8 +484,9 @@ xf86MapDomainMemory(int ScreenNum, int Flags, struct 
> pci_dev
>      if (fd >= 0)
>         close(fd);
>      if (addr == NULL || addr == MAP_FAILED) {
> -       perror("mmap failure");
> -       FatalError("xf86MapDomainMem():  mmap() failure\n");
> +       xf86Msg(X_WARNING, "xf86MapDomainMem():  mmap() failure: %s\n",
> +               strerror(errno));
> +       return NULL;
>      }
>      return addr;
>  }
> 
> 

