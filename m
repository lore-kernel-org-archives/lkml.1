Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZBGDFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZBGDFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZBGDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:05:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:47520 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZBGDFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:05:25 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200902061445.11379.jbarnes@virtuousgeek.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <200902060849.45851.jbarnes@virtuousgeek.org>
	 <Pine.LNX.4.64.0902062205540.5710@blonde.anvils>
	 <200902061445.11379.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 14:05:10 +1100
Message-Id: <1233975910.31963.56.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 14:45 -0800, Jesse Barnes wrote:
> +    if (Base <= 1024*1024) {
> +        /* Try legacy_mem (may not be available or implemented) */
> +        if ((fd = linuxOpenLegacy(dev, "legacy_mem")) < 0) {
> +            addr = mmap(NULL, Size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, Base);
> +            close(fd);
> +            if (addr && addr != MAP_FAILED)
> +                return addr;
> +        }
>      }
> -    return addr;
> +
> +    /* Fall back to old method if legacy_mem fails or Base >= 1M */
> +    return linuxMapPci(ScreenNum, Flags, dev, Base, Size, PCIIOC_MMAP_IS_MEM);
>  }

I don't like the fallback if legacy_mem exists and returns an error,
that's an indication that legacy memory is -not- available and thus
whatever 'fallback' X will try (supposedly using /dev/mem) will be
horribly broken and will probably end up scribbling all over system
memory :-)

Ben.


