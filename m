Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZKFIZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZKFIZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 03:25:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZKFIZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 03:25:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:40628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZKFIZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 03:25:01 -0500
Message-ID: <4AF3DD30.8050200@kernel.org>
Date: Fri, 06 Nov 2009 17:24:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       Peter Zijlstra <peterz@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: irq lock inversion
References: <86802c440911041008q4969b9bdk15b4598c40bb84bd@mail.gmail.com> <4AF25FC7.4000502@kernel.org> <20091105082102.GA2870@elte.hu> <4AF28D7A.6020209@kernel.org> <alpine.LSU.2.00.0911051502060.9988@wotan.suse.de> <4AF3B9BD.9050300@kernel.org> <20091106071711.GA20946@elte.hu> <4AF3D428.8000804@kernel.org> <20091106075820.GA28227@elte.hu>
In-Reply-To: <20091106075820.GA28227@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> I havent looked deeply but at first sight i'm not 100% sure that even 
> the lock dance hack is safe - doesnt vfree() do TLB flushes, which must 
> be done with irqs enabled in general? If yes, then the whole notion of 
> using the allocator from irqs-off sections is wrong and the flags 
> save/restore is misguided (or at least incomplete).

The only place where any v*() call is nested under pcpu_lock is in the
alloc path, specifically pcpu_extend_area_map() ends up calling
vfree().  pcpu_free() path which can be called from irq context never
calls any vmalloc function directly.  The reclaiming is deferred to a
work.  Breaking the single nesting completely decouples the two locks
and nobody would be calling vfree() with irq disabled, so I don't
think there will be any problem.

Thanks.

-- 
tejun
