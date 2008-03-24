Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYCXQF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYCXQF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYCXQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:05:16 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:50812 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbYCXQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fGXWZ1siSXWR2jiTxSmBYYZ3hBm/vagwnLj3EeWkCODm5xLIzmdcPh6A0zpg0C36Q7zXV+mTvjS6lI/QD2j9qxOHC+14nPpIUzhnjGJt6g6A0mqkTPTaeJhqmocYwVqr9bmOCYfl0BnQNEevAYs6KlDfo/AElsSwh4nRSfRQ1q0=
Message-ID: <87a5b0800803240905g705a8ea3p11c415ad37fc3cbb@mail.gmail.com>
Date: Mon, 24 Mar 2008 16:05:12 +0000
From: "Will Newton" <will.newton@gmail.com>
To: nitingupta910@gmail.com
Subject: Re: [PATCH 2/6] compcache: block device - internal defs
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <200803242033.30782.nitingupta910@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242033.30782.nitingupta910@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 3:03 PM, Nitin Gupta <nitingupta910@gmail.com> wrote:

Hi Nitin,

> This contains header to be used internally by block device code.
>  It contains flags to enable/disable debugging, stats collection and also
>  defines default disk size (25% of total RAM).
>
>  Signed-off-by: Nitin Gupta <nitingupta910 at gmail dot com>
>  ---
>   drivers/block/compcache.h |  147 +++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 147 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/block/compcache.h b/drivers/block/compcache.h
>  new file mode 100644
>  index 0000000..b84b5d3
>  --- /dev/null
>  +++ b/drivers/block/compcache.h
>  @@ -0,0 +1,147 @@
>  +/*
>  + * Compressed RAM based swap device
>  + *
>  + * (C) Nitin Gupta
>  + *
>  + * This RAM based block device acts as swap disk.
>  + * Pages swapped to this device are compressed and
>  + * stored in memory.
>  + *
>  + * Project home: http://code.google.com/p/compcache
>  + */
>  +
>  +#ifndef _COMPCACHE_H_
>  +#define _COMPCACHE_H_
>  +
>  +#define K(x)   ((x) >> 10)
>  +#define KB(x)  ((x) << 10)
>  +
>  +#define SECTOR_SHIFT           9
>  +#define SECTOR_SIZE            (1 << SECTOR_SHIFT)
>  +#define SECTORS_PER_PAGE_SHIFT (PAGE_SHIFT - SECTOR_SHIFT)
>  +#define SECTORS_PER_PAGE       (1 << SECTORS_PER_PAGE_SHIFT)
>  +
>  +/*-- Configurable parameters */
>  +/* Default compcache size: 25% of total RAM */
>  +#define DEFAULT_COMPCACHE_PERCENT      25
>  +#define INIT_SIZE                      KB(16)
>  +#define GROW_SIZE                      INIT_SIZE

Maybe these could be renamed to INIT_SIZE_BYTES/GROW_SIZE_BYTES to
make the units clearer?

>  +/*-- */
>  +
>  +/* Message prefix */
>  +#define C "compcache: "
>  +
>  +/* Debugging and Stats */
>  +#define NOP    do { } while(0)
>  +
>  +#if (1 || defined(CONFIG_DEBUG_COMPCACHE))
>  +#define DEBUG  1
>  +#define STATS  1
>  +#else
>  +#define DEBUG  0
>  +#define STATS  0
>  +#endif

If DEBUG is defined unconditionally what is the point of CONFIG_DEBUG_COMPCACHE?

>  +
>  +/* Create /proc/compcache? */
>  +/* If STATS is disabled, this will give minimal compcache info */
>  +#define CONFIG_COMPCACHE_PROC
>  +
>  +#if DEBUG
>  +#define CC_DEBUG(fmt,arg...) \
>  +       printk(KERN_DEBUG C fmt,##arg)
>  +#else
>  +#define CC_DEBUG(fmt,arg...) NOP
>  +#endif

Have you thought about using pr_debug() for this? It looks like it
would simplify this file at the cost of a little flexibility.

>  +
>  +/*
>  + * Verbose debugging:
>  + * Enable basic debugging + verbose messages spread all over code
>  + */
>  +#define DEBUG2 0
>  +
>  +#if DEBUG2
>  +#define DEBUG  1
>  +#define STATS  1
>  +#define CONFIG_COMPCACHE_PROC  1
>  +#define CC_DEBUG2((fmt,arg...) \
>  +       printk(KERN_DEBUG C fmt,##arg)
>  +#else /* DEBUG2 */
>  +#define CC_DEBUG2(fmt,arg...) NOP
>  +#endif
>  +
>  +/* Its useless to collect stats if there is no way to export it */
>  +#if (STATS && !defined(CONFIG_COMPCACHE_PROC))
>  +#error "compcache stats is enabled but not /proc/compcache."
>  +#endif

So it appears that if we want DEBUG we also get STATS, which requires
/proc support enabled, so it is impossible to have just DEBUG and no
STATS or /proc support?
