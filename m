Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYHVGQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYHVGQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYHVGQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:16:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbYHVGQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:16:36 -0400
Date: Thu, 21 Aug 2008 23:15:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Sean MacLennan <smaclennan@pikatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
Message-Id: <20080821231551.b0bafc5f.akpm@linux-foundation.org>
In-Reply-To: <20080821201002.GA6321@joi>
References: <20080820135551.74911cb3@lappy.seanm.ca>
	<20080820190436.GA5388@joi>
	<20080820151531.38fc1071@lappy.seanm.ca>
	<87myj74azn.fsf@skyscraper.fehenstaub.lan>
	<20080821000844.GA10031@joi>
	<873aky4zk7.fsf@skyscraper.fehenstaub.lan>
	<20080821201002.GA6321@joi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 22:10:23 +0200 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] bootmem: don't embed bootmem_data in pglist_data
> 
> Replace direct pointer from struct pglist_data to struct bootmem_data
> with index into bootmem_node_data.
> 
> As bootmem_node_data are discarded after bootup this change allows
> more fine-grained analysis of access to bootmem data - every access
> to bootmem_node_data from non-__init function will now emit section
> mismatch warning.
> 
> This patch fixes following section mismatch warning:
> WARNING: vmlinux.o(.data+0x1f5c0): Section mismatch in reference from the variable contig_page_data to the variable .init.data:bootmem_node_data
> The variable contig_page_data references
> the variable __initdata bootmem_node_data
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Johannes Weiner <hannes@saeurebad.de>
> ---
>  arch/alpha/mm/numa.c             |    5 +++--
>  arch/arm/mm/discontig.c          |   32 ++++++++++++++++----------------
>  arch/arm/plat-omap/fb.c          |    2 +-
>  arch/avr32/mm/init.c             |    5 +++--
>  arch/ia64/mm/discontig.c         |    5 ++---
>  arch/ia64/mm/init.c              |    2 +-
>  arch/m32r/mm/discontig.c         |    6 +++---
>  arch/m32r/mm/init.c              |    4 ++--
>  arch/m68k/mm/init.c              |    2 +-
>  arch/mips/sgi-ip27/ip27-memory.c |    2 +-
>  arch/mn10300/mm/init.c           |    9 ++++-----
>  arch/parisc/mm/init.c            |    2 +-
>  arch/powerpc/mm/numa.c           |    2 +-
>  arch/sh/mm/init.c                |    5 +++--
>  arch/sh/mm/numa.c                |    4 ++--
>  arch/sparc64/mm/init.c           |    2 +-
>  arch/x86/mm/discontig_32.c       |    2 +-
>  arch/x86/mm/numa_64.c            |    2 +-
>  include/linux/mmzone.h           |    4 +++-
>  mm/bootmem.c                     |   30 +++++++++++++++++++-----------
>  mm/page_alloc.c                  |    2 +-
>  21 files changed, 70 insertions(+), 59 deletions(-)

erp.  Can we go with Sean's obviously-safe one-liner for now, fix this
up properly in 2.6.28?


Plus...  replacing a direct pointer with an index which requires a
subscripting operation each time it is used just to fix a section
warning is a bit sad.

