Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYGIGyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYGIGyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 02:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYGIGyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 02:54:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:58576 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYGIGyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 02:54:21 -0400
Subject: Re: AZFS file system proposal
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Maxim Shchetynin <maxim@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Gunnar von Boehn <VONBOEHN@de.ibm.com>, Mark Nelson <markn@au1.ibm.com>
In-Reply-To: <200807081642.19507.arnd@arndb.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	 <200807011659.33413.arnd@arndb.de>
	 <20080707173923.17dc6c05@mercedes-benz.boeblingen.de.ibm.com>
	 <200807081642.19507.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 16:48:06 +1000
Message-Id: <1215586086.8970.348.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cc:'ing some more people that might have more of a clue on this question.
> _memcpy_fromio does a "sync" at the start and an "eieio" at the end.
> IFAICT, neither are needed here because the source is always memory.
> 
> It also handles unaligned memory accesses, which copy_to_user should
> also do correctly, so it *looks* like it should work with just a
> copy_to_user, but it still feels wrong to use an __iomem pointer
> as the source for a copy_to_user.
> 
> Any ideas?

It's a bit nasty yes. The problem is that copy_to/from_user might
do cache tricks which will blow up if the area is non-cacheable.

We have a similar problem with Mark's work on faster copy functions
since things like sys_read() can be called on userspace non-cacheable
memory such as spu local stores.

So I'm not 100% sure what the right approach here. Our copy_tofrom_user
today does dcbt on the source for example, which I hope only turns into
a no-op... The risk is if we start using dcbz.

Cheers,
Ben.


