Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbXEQIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbXEQIoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 04:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXEQIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 04:44:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbXEQIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 04:44:11 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: Dongjun Shin <djshin90@gmail.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
In-Reply-To: <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
	 <1179330596.2859.248.camel@shinybook.infradead.org>
	 <20070516164158.GB8113@lazybastard.org>
	 <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
	 <1179383117.2859.416.camel@shinybook.infradead.org>
	 <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 17 May 2007 16:43:59 +0800
Message-Id: <1179391440.2859.447.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 17:20 +0900, Dongjun Shin wrote:
> There are, of course, cases where direct access are better.
> However, as the demand for capacity, reliability and high performance
> for the flash storage increases, the use of FTL with embedded controller
> would be inevitable.
> 
> - The complexity/cost of host-side SW (like JFFS2/MTD) will increase due to
> the use of multiple flash in parallel and the use of high degree ECC algorithm.
> There are other things like bad block handling and wear-leveling issues
> which has been recently touched by UBI with added SW complexity.

You don't get rid of that complexity by offloading it to a µcontroller. 

The only thing you achieve that way is making sure it's quite likely to
be done badly, and making it impossible to debug.

> - In contrast to the embedded environment where CPU and flash is directly
> connected, the I/O path between CPU and flash in PC environment is longer.
> The latency for SW handshaking between CPU and flash will also be longer,
> which would make the performance optimization harder.

Do it the naïve way with a single byte push/pull and waggling the
control lines separately, and what you say is true -- but you can have
flash controllers which assist with data transfer but still give you
essentially 'raw' access to the chip.

With the CAFÉ controller designed for the OLPC machine, we can spew data
across the PCI bus just as fast as we can suck it off the flash chip.

> As I mentioned, some techniques like log-structured filesystem could
> perform generally better on any kind of flash-based storage with FTL.
> Although there are many kinds of FTL, it is commonly true that
> it performs well under workload where sequential write is dominant.

Yes, it's certainly possible that we _could_ write a file system which
is specifically targeted at FTL -- I was just wondering why anyone would
_bother_ :)

I've seen an interesting file system which does have a kind of FTL
internally as its lowest layer, and which build on that using 'virtual'
sectors for file extents. Now that _does_ have its advantages -- but it
doesn't go as far as pretending to be a 'normal' block device; it's its
own special thing for internal use within that file system.
 
> I also expect that FTL for PC environment will have better quality spec
> than the disposable storage.

There really is no reason why FTL has to be done badly; just as there's
no _reason_ why hardware vendors have to give us crappy bsVendorCode.
Nevertheless, that's the way the world tends to be. So good luck
shipping with that :)

-- 
dwmw2

