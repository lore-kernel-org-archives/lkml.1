Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZDTBU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZDTBU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZDTBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:20:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZDTBUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:20:48 -0400
Message-ID: <49EBCDC0.1020001@zytor.com>
Date: Sun, 19 Apr 2009 18:20:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Hitoshi Mitake <h.mitake@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu> <adaws9gywkd.fsf@cisco.com>
In-Reply-To: <adaws9gywkd.fsf@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> 
> Notice that it reads from addr+4 *before* it reads from addr, rather
> than after as in your example (and in fact your example depends on
> undefined compiler semantics, since there is no sequence point between
> the two operands of the | operator).  Now, I don't know that hardware,
> so I don't know if it makes a difference, but the niu example I gave in
> my original email shows that given hardware with clear-on-read
> registers, the order does very much matter.
> 

At least for x86, the order should be low-high, because that is the
order that those two transactions would be seen on a 32-bit bus
downstream from the CPU if the CPU issued a 64-bit transaction.

The only sane way to handle this as something other than per-driver
hacks would be something like:

#include <linux/io64.h>		/* Any 64-bit I/O OK */

#include <linux/io64lh.h>	/* Low-high splitting OK */

#include <linux/io64hl.h>	/* High-low splitting OK */

#include <linux/io64atomic.h>	/* 64-bit I/O must be atomic */

... i.e. letting the driver choose what fallback method it will accept.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

