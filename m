Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYDWOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYDWOrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYDWOrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:47:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbYDWOrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:47:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KLbNKYpbHQ5nG41tGCCYgjigsKIJuLR9Ib2ISnB6VEe6VRCsx3CB0HBHAxkQsmrz7
	pU8bwUIwmdCGSsexOdO/w==
Message-ID: <da824cf30804230746o74e8de0bxbcb31d4b13e98b6@mail.gmail.com>
Date: Wed, 23 Apr 2008 07:46:49 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Marin Mitov" <mitov@issp.bas.bg>
Subject: Re: [PATCH] pci_try_set_mwi() in sata_promise
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jgarzik@pobox.com>, linux-ide@vger.kernel.org
In-Reply-To: <200804231633.24603.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804222126.56321.mitov@issp.bas.bg>
	 <18446.60365.156326.246875@harpo.it.uu.se>
	 <200804231633.24603.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 6:33 AM, Marin Mitov <mitov@issp.bas.bg> wrote:
...
>  > 2. What improvement does that pci_try_set_mwi() cause? Speed? Fewer errors?
>
>  May be speed, but practically hardly observable.

I expect the difference to be in available memory BW.
MWI (Memory Write Invalidate) allows the IO controller to write
partial cachlines without having to do a read/modify/write sequence.
R/W/M means the cacheline has to cross the memory bus twice.
The difference in performance will depend on how often the
Promise SATA controller was doing partial cachline
transactions with the wrong cacheline size.

This should be measurable if you run a memory test at the same time
as you stress the SATA controller with fio. Re-read the same 128KB block
repeatedly from the Promise controller (I'm expecting that to be cached)
and measure the available memory BW (e.g. see lmbench for a memtest).
Repeat with MWI enabled.


>  > 3. Why call pci_try_set_mwi()? Can't you set the cache line size directly?
>
>  pci_set_cacheline_size() is NOT exported, while pci_try_set_mwi() IS and
> sets (as a side effect) the cache line size.

Setting the cachline size only makes sense if MWI is enabled.
Drivers should not longer directly set the cacheline size since it might
not be what they think it is.

hth,
grant
