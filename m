Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZEKOi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZEKOi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZEKOiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:38:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZEKOiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:38:50 -0400
Subject: Re: [PATCH][KVM] Add support for Pause Filtering to AMD SVM
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200905050909.58583.mark.langsdorf@amd.com>
References: <200905050909.58583.mark.langsdorf@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 11 May 2009 16:38:44 +0200
Message-Id: <1242052724.11251.274.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 09:09 -0500, Mark Langsdorf wrote:
> commit 6f15c833f56267baf5abdd0fbc90a81489573053
> Author: Mark Langsdorf <mlangsdo@wshpnow.amd.com>
> Date:   Mon May 4 15:02:38 2009 -0500
> 
>     New AMD processors will support the Pause Filter Feature.
>     This feature creates a new field in the VMCB called Pause
>     Filter Count.  If Pause Filter Count is greater than 0 and
>     ntercepting PAUSEs is enabled, the processor will increment
>     an internal counter when a PAUSE instruction occurs instead
>     of intercepting.  When the internal counter reaches the
>     Pause Filter Count value, a PAUSE intercept will occur.
>     
>     This feature can be used to detect contended spinlocks,
>     especially when the lock holding VCPU is not scheduled.
>     Rescheduling another VCPU prevents the VCPU seeking the
>     lock from wasting its quantum by spinning idly.
>     
>     Experimental results show that most spinlocks are held
>     for less than 1000 PAUSE cycles or more than a few
>     thousand.  Default the Pause Filter Counter to 3000 to
>     detect the contended spinlocks.
>     
>     Processor support for this feature is indicated by a CPUID
>     bit.
>     
>     On a 24 core system running 4 guests each with 16 VCPUs,
>     this patch improved overall performance of each guest's
>     32 job kernbench by approximately 1%.  Further performance
>     improvement may be possible with a more sophisticated
>     yield algorithm.

Isn't a much better solution to the spinlock problem a usable
monitor-wait implementation?

If we implement virt spinlocks using monitor-wait they don't spin but
simply wait in place, the HV could then decide to run someone else.

This is the HV equivalent to futexes.

The only problem with this is that the current hardware has horrid mwait
wakeup latencies. If this were (much) improved you don't need such ugly
yield hacks like this.
