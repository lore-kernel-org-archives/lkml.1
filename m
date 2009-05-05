Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZEESnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZEESnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbZEESnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:43:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:41801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZEESnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:43:03 -0400
Subject: Re: [PATCH 3/7] perf_counter: ioctl(PERF_COUNTER_IOC_RESET)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A0085FC.2060200@linux.vnet.ibm.com>
References: <20090505155020.309162852@chello.nl>
	 <20090505155437.022272933@chello.nl>  <4A0085FC.2060200@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 20:42:56 +0200
Message-Id: <1241548976.8100.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 11:31 -0700, Corey Ashford wrote:
> Hi Peter,
> 
> Peter Zijlstra wrote:
> 
> > +static void perf_counter_reset(struct perf_counter *counter)
> > +{
> > +	atomic_set(&counter->count, 0);
> > +}
> > +
> 
> 
> Thanks for posting a patch for this issue.
> 
> As Ingo said, I think the hardware counter needs to be reset as well as 
> the value saved in the perf_counter struct.
> 

I don't think that's needed, we calculate a delta between prev_count and
the current read and use that to increment counter->count. Therefore
when we reset counter->count we should not need to touch the hardware
counter.

However, I do think we need the below, first read the hardware counter
to ensure that delta spoken of above is as close to zero as possible
when we reset.

And update the user-page bits.

---
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1299,7 +1299,9 @@ static unsigned int perf_poll(struct fil
 
 static void perf_counter_reset(struct perf_counter *counter)
 {
+	(void)perf_counter_read(counter);
 	atomic_set(&counter->count, 0);
+	perf_counter_update_userpage(counter);
 }
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)


