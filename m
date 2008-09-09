Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYIINOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYIINOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbYIINO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:14:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:62598 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYIINO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:14:27 -0400
Message-ID: <48C676AB.2070101@windriver.com>
Date: Tue, 09 Sep 2008 08:14:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Atsuo Igarashi <atsuo_igarashi@tripeaks.co.jp>
CC: linux-kernel@vger.kernel.org, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Tom Rini <trini@kernel.crashing.org>
Subject: Re: [PATCH] kgdb: could not write to the last of valid memory with
 kgdb.
References: <48C5BDA0.90105@tripeaks.co.jp>
In-Reply-To: <48C5BDA0.90105@tripeaks.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2008 13:14:20.0007 (UTC) FILETIME=[F823AF70:01C9127D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atsuo Igarashi wrote:
> Hi,
>
> I'm using i.MX31 ARM11 board which has 104Mbyte valid memory.  When
> I'd invoked a print command to write the last of valid memory from
> gdb, there was no response from kgdb.
> It seems that the following line causes this problem.
>
> kernel/kgdb.c: write_mem_msg()
> ...
>  491             flush_icache_range(addr, addr + length + 1);
>
> If the last byte of valid memory is specified, the last cache line
> and the next cache line will be flushed by the ARM11 V6's function
> from flush_icache_range().  I'm not sure why the 2nd parameter has
> +1, I assume this +1 is unnecessary for ARM11 V6's cache.  I send a
> patch to remove this +1, does anyone know necessity for other
> architectures?

I had to go digging through the archives to find out where the "+1"
came from, as it pre-dates my involvement with kgdb.  It turns out
this actually appeared in the initial version of the 'X' 'M' gdb
serial packet write.

You can see historical first version if you scroll to line 973 at:

http://kgdb.cvs.sourceforge.net/kgdb/kgdb-2/core-lite.patch?annotate=1.40

That means we have carried this for 3 years, 10 months with no one
noticing it. :-)

The flush_icache_range() is a "start" to "end" address so there should
be no need for the +1, as it is already computed by adding the length.
I will queue this patch for some testing and pushing into the
mainline.

Thanks,
Jason.


