Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbZE0RBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbZE0RBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZE0RBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:01:30 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:34329 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789AbZE0RB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:01:29 -0400
Date: Wed, 27 May 2009 19:01:18 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lkml@morethan.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: LOCK prefix on uni processor has its use (was Re: [BUG FIX] Make
	x86_32 uni-processor Atomic ops, Atomic)
Message-ID: <20090527170118.GC4024@prithivi.gnumonks.org>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A188A48.5000208@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa and others,

On Sat, May 23, 2009 at 04:44:08PM -0700, H. Peter Anvin wrote:
 
> It looks like there might be a problem with the C7-M ... Michael reports
> that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> necessary for a uniprocessor.

It seems, they are neccessary.

Here are some statements from the CPU logic guys at VIA/Centaur:

* A read-modify-write sequence cannot be interupted.
* All X86 instructions except rep-strings are atomic wrt interrupts.
* The lock prefix has uses on a UP processor: It keeps DMA devices from
  interfering with a read-modify-write sequence

Furthermore, they have done some experimentation in the past, making the
CPU simply ignore the LOCK prefix on uni-processor (running a certain popular
proprietary operating system): It doesn't work, presumably of the abovementioned
DMA related conflict.

Also, the engineers believe that it is only a matter of time until different
CPU/chipset combination would expose the same bug.  Since the in-order
single-retire C7-M is more vulnerable than out-of-order, multiple-retire CPU's,
they are not surprised that the issue shows first on the C7-M.

The recommendation from the CPU engineers, unsurprisingly, thus is to put the
LOCK prefixes back where they were.

Hope this helps you.

Now if I understand the issues correctly, it would mean that there is some
driver code that modifies a certain chunk of memory, while DMA of some
peripheral is also accessing that memory.  I suppose it would not have to be
the same actual address, but probably being within the same cache line is
already sufficient.

Now the question is: Is this a valid operation of a driver?  Should the driver
do such things, or is such a driver broken?  When would that occur?  I'm trying
to come up with a case, but typically you e.g. allocate some DMA buffer and
then don't touch it until the hardware has processed it.

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
