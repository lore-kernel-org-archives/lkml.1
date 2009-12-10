Return-Path: <linux-kernel-owner+w=401wt.eu-S933607AbZLJKer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbZLJKer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933514AbZLJKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:34:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbZLJKem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:34:42 -0500
Date: Thu, 10 Dec 2009 11:09:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
	in_atomic
Message-ID: <20091210100907.GA2446@ucw.cz>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-04 12:26:00, Xiaotian Feng wrote:
> commit 8bd108d adds preemption point after each opcode parse, then
> a sleeping function called from invalid context bug was founded
> during suspend/resume stage. this was fixed in commit abe1dfa by
> don't cond_resched when irq_disabled. But recent commit 138d156 changes
> the behaviour to don't cond_resched when in_atomic. This makes the
> sleeping function called from invalid context bug happen again, which
> is reported in http://lkml.org/lkml/2009/12/1/371.
> 
> The fix is to cond_sched() only when preemptible, which means not in
> irq_disabled or in_atomic.
> 
> @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  #include <linux/hardirq.h>
>  #define ACPI_PREEMPTION_POINT() \
>  	do { \
> -		if (!in_atomic_preempt_off()) \
> +		if (preemptible()) \
>  			cond_resched(); \
>  	} while (0)

Note that this is ugly as hell. It means we have two acpi
interpretters in kernel, one for preemptible, one for non-preemptible,
with very different behaviour.

It would be slightly nicer to pass the "preemptible" info explicitely,
as function parameters.

It would be even better not to need that difference.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
