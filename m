Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbZIDOrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbZIDOrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZIDOrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:47:03 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41624 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756920AbZIDOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:47:02 -0400
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack
	allocation
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090904065745.GE29829@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
	 <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
	 <20090829132954.GB24123@elte.hu>
	 <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
	 <20090831084546.GE15619@elte.hu>
	 <1251797114.10349.28.camel@pc1117.cambridge.arm.com>
	 <20090904065745.GE29829@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 04 Sep 2009 15:45:49 +0100
Message-Id: <1252075549.26413.71.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2009 14:45:50.0224 (UTC) FILETIME=[65465100:01CA2D6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 08:57 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > I tried to move to an inline function and linux/gfp.h is needed for
> > __get_free_pages() and GFP_* macros. This leads to some complicated
> > circular dependencies like below:
> > 
> >   CC      arch/x86/kernel/asm-offsets.s
> > In file included from /work/Linux/2.6/linux-2.6-arm/include/linux/mmzone.h:9,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/gfp.h:4,
> >                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/include/asm/thread_info.h:22,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/thread_info.h:56,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/preempt.h:9,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/spinlock.h:50,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/seqlock.h:29,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/time.h:8,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/stat.h:60,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/module.h:10,
> >                  from /work/Linux/2.6/linux-2.6-arm/include/linux/crypto.h:21,
> >                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets_32.c:7,
> >                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets.c:2:
> > include/linux/wait.h|51| error: expected specifier-qualifier-list before ???spinlock_t???
> > 
> > The linux/mmzone.h file normally includes linux/spinlock.h but the 
> > reverse is also true when the latter includes the former via 
> > thread_info.h and gfp.h. Because of the (correct) guards in the 
> > header files, the spinlock_t definition is no longer available in 
> > mmzone.h.
> 
> mmzone.h probably should not include spinlock.h (which is heavy) - 
> it should include spinlock_types.h (which is lighter). It only needs 
> the type definitions and none of the API definitions.

It fixes this particular case but I get plenty of other similar error in
timex.h, jiffies.h, ktime.h, rcutree.h, kmem.h etc.

I'll drop this patch for now and look for alternatives.

-- 
Catalin

