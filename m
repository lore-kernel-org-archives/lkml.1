Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbZELWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbZELWSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZELWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:18:26 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35579 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZELWS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:18:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18953.62894.217593.865445@cargo.ozlabs.ibm.com>
Date: Wed, 13 May 2009 08:18:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <4A09A09A.7030009@linux.vnet.ibm.com>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
	<18951.32643.749495.538351@drongo.ozlabs.ibm.com>
	<4A086A89.6030905@linux.vnet.ibm.com>
	<18952.36878.942836.803265@cargo.ozlabs.ibm.com>
	<4A08A8C6.1090302@linux.vnet.ibm.com>
	<18953.5194.205862.75538@drongo.ozlabs.ibm.com>
	<4A09A09A.7030009@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> Another hypothesis is that the old PAPI code would open, mmap, close, 
> then reopen, and mmap again.  I wonder if because I wasn't munmap'ing 
> before the close, that I got some strange behavior from the kernel. 

In general an mmap will keep a reference to the file it is mapping,
which means that if you do an mmap on a fd and then close the fd, the
file stays open until the region is munmapped.  So your old PAPI code
would have ended up with more counters active than you expected, if
you thought closing the fd would have destroyed the counter.

That is, you don't have to munmap before close, but you do have to do
both close and munmap to destroy the counter.

Paul.
