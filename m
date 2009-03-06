Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZCFO0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZCFO0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCFO0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:26:38 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38976 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751001AbZCFO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:26:37 -0500
Date: Fri, 6 Mar 2009 15:26:34 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jim Paris <jim@jtan.com>, Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing video
     RAM as block device
In-Reply-To: <20090306125832.GX11787@kernel.dk>
Message-ID: <alpine.LRH.2.00.0903061525340.16809@vixen.sonytel.be>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <20090305083701.GQ11787@kernel.dk> <alpine.LRH.2.00.0903051146440.2618@vixen.sonytel.be> <20090305110940.GY11787@kernel.dk> <alpine.LRH.2.00.0903051325450.2618@vixen.sonytel.be>
 <20090306074639.GN11787@kernel.dk> <alpine.LRH.2.00.0903061347360.16809@vixen.sonytel.be> <20090306125832.GX11787@kernel.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009, Jens Axboe wrote:
> On Fri, Mar 06 2009, Geert Uytterhoeven wrote:
> > On Fri, 6 Mar 2009, Jens Axboe wrote:
> > > On Thu, Mar 05 2009, Geert Uytterhoeven wrote:
> > > > But then I noticed ps3vram_make_request() may be called concurrently,
> > > > so I had to add a mutex to avoid data corruption. This slows the
> > > > driver down, and in the end, the version with a thread turns out to be
> > > > ca. 1% faster. The version without a thread is about 50 lines less
> > > > code, though.
> > >
> > > That is correct, ->make_request_fn may get reentered. I'm not surprised
> > > that performance dropped if you just shoved everything under a mutex.
> > > You could be a little more smart and queue concurrent bio's for
> > > processing when the current one is complete though, there are several
> > > approaches there that be a lot faster than going all the way through the
> > > IO stack and scheduler just to avoid concurrency.
> > 
> > Yes, using a spinlock and queueing requests on a list if the driver is
> > busy can be done after 2.6.29...
> 
> Certainly. Even just replacing your current mutex with a spinlock during
> the memcpy() would surely be a lot faster. Or even just grabbing the
> mutex before calling into the write for the duration of the bio. The way
> you do it is certain context switch death :-)

It's not just the memcpy(). ps3vram_{up,down}load() call msleep(), so I cannot
use a spinlock.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
