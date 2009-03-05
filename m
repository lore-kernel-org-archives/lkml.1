Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZCEHhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZCEHhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZCEHhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:37:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:45517 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCEHhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:37:38 -0500
Subject: Re: [Bug #12809] iozone regression with 2.6.29-rc6
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236219189.2567.123.camel@ymzhang>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.9MB.pUarJB@chimera> <20090305010920.GB11575@localhost>
	 <1236218012.2567.115.camel@ymzhang>  <20090305020408.GA26425@localhost>
	 <1236219189.2567.123.camel@ymzhang>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 08:37:29 +0100
Message-Id: <1236238649.5330.10132.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(list restored)

On Thu, 2009-03-05 at 10:13 +0800, Zhang, Yanmin wrote:

> My idea:
> 1) When the main thread traps into kernel and find need to write back pages; it just starts
> write back, but it needn't change timestamp (???or something like that) on writeback; and start
> pdflush;
> 2) Later on pdflush could pick up the file to write back for other pages on the same file;
> 3) The target is to let pdflush to writeback pages and main testing thread continues on its own
> work, so we can benefit from SMP.

No!

This is not about parallelism, this is about making sure there is a
limited number of dirty pages, that means the tasks generating dirty
pages will _have_ to wait. You simply cannot delegate that.

Furthermore, the task throttling explicitly wants to throttle the task
that generates all those dirty pages more than other tasks. So pushing
the throttle out to pdflush will destroy the whole scheme.

The reason we want to make the heavy dirtier throttle sooner is that
other tasks, who only occasionally dirty a page, don't get caught in the
massive throttle latency.

