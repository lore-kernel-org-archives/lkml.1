Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbZE0XwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbZE0XwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZE0XwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755545AbZE0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:51:59 -0400
Date: Wed, 27 May 2009 16:51:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: dwmw2@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Time out for possible dead loops during queued
 invalidation wait
Message-Id: <20090527165117.8b768d00.akpm@linux-foundation.org>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8AF933281@orsmsx505.amr.corp.intel.com>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<1240135508.3589.75.camel@macbook.infradead.org>
	<A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	<20090520174259.GA10646@linux-os.sc.intel.com>
	<20090526225146.2faeeb05.akpm@linux-foundation.org>
	<A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
	<20090527154816.23541b2a.akpm@linux-foundation.org>
	<A6AD88C3F2289247BE726C37303E1EB8AF933281@orsmsx505.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 16:25:52 -0700
"Yu, Fenghua" <fenghua.yu@intel.com> wrote:

> >> Which error code is better? Is EAGAIN ok?
> >
> >That depends on driver details - probably EIO would be suitable, dunno.
> >
> >But all the callers of qi_submit_sync() seem to just drop the error
> >code on the floor:
> >
> >	/* should never fail */
> >	qi_submit_sync(&desc, iommu);
> >
> >and may well cause a kernel crash as a result.
> 
> Should the code go to kernel panic after timeout in qi_submit_sync() loops? When timeout (10 seconds) in the loops, something in hardware could be wrong.
> 

The most important thing to do when an error is detected is to protect
the user's data, perhaps by reliably halting the kernel.

The second most important thing is to report what happened, so people
can fix things.

The third most important thing is to attempt to recover from the error
so that the kernel continues to function.  This third requirement often
makes the second one more successful: a still-running kernel can report
things which a crashed kernel cannot.

In this particualr case I'd suggest that the driver be converted to
correctly recognise errors, clean things up and propagate the errors
back in an orderly fashion, as usual.


otoh...  How likely is it that this timeout actually occurs?  If it's
only conceivable that this can happen when the hardware is busted then
I'd suggest that we not patch the kernel at all - the kernel really has
little chance of surviving broken silicon so why bother adding a little
bit of code here to handle a tiny subset of it?

If the chip is indeed busted then afacit the kernel will get stuck in
an infinite loop.  That's OK, we can still diagnose those with NMI
watchdogs, sysrq-p handlers, etc.

