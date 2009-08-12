Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZHLPjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZHLPjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbZHLPjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:39:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61342 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752744AbZHLPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:39:40 -0400
Subject: Re: kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0908120831060.28882@localhost.localdomain>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090802111453.GA24927@elte.hu>
	 <1249919718.10848.55.camel@pc1117.cambridge.arm.com>
	 <20090810184527.GA9601@elte.hu>
	 <1249945003.26205.23.camel@pc1117.cambridge.arm.com>
	 <20090811073205.GA17476@elte.hu>
	 <1249980905.27150.11.camel@pc1117.cambridge.arm.com>
	 <1250079447.20332.27.camel@pc1117.cambridge.arm.com>
	 <alpine.LFD.2.01.0908120831060.28882@localhost.localdomain>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 12 Aug 2009 16:39:17 +0100
Message-Id: <1250091558.20332.63.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Aug 2009 15:39:18.0906 (UTC) FILETIME=[0E4C15A0:01CA1B63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 08:32 -0700, Linus Torvalds wrote:
> 
> On Wed, 12 Aug 2009, Catalin Marinas wrote:
> > 
> > If the object size is bigger than a predefined value (4K in this case),
> > release the object lock during scanning and call cond_resched().
> 
> What guarantees that the object isn't released during this?

There is no guarantee but the while() loop rechecks that object->flags
still has the OBJECT_ALLOCATED bit set after every cond_resched():

+               while (start < end && (object->flags & OBJECT_ALLOCATED)) {
+                       scan_block(start, min(start + MAX_SCAN_SIZE, end),
+                                  object, 0);
+                       start += MAX_SCAN_SIZE;
+
+                       spin_unlock_irqrestore(&object->lock, flags);
+                       cond_resched();
+                       spin_lock_irqsave(&object->lock, flags);
+               }

It seems to be working fine with LTP running in parallel with kmemleak
scanning for nearly a day.

-- 
Catalin

