Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZLDFiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZLDFiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZLDFiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:38:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:25304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZLDFiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:38:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218721771"
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
 in_atomic
From: Zhang Rui <rui.zhang@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>, "Lin, Ming M" <ming.m.lin@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <1259905017.27069.98.camel@rzhang1-desktop>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
	 <1259905017.27069.98.camel@rzhang1-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:38:43 +0800
Message-ID: <1259905123.27069.99.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 13:36 +0800, Zhang Rui wrote:
> CC Alexey.
> 
> And this is also the fix for
> http://bugzilla.kernel.org/show_bug.cgi?id=14483
> 
> thanks,
> rui
> 
> On Fri, 2009-12-04 at 12:26 +0800, Xiaotian Feng wrote:
> > commit 8bd108d adds preemption point after each opcode parse, then
> > a sleeping function called from invalid context bug was founded
> > during suspend/resume stage. this was fixed in commit abe1dfa by
> > don't cond_resched when irq_disabled. But recent commit 138d156 changes
> > the behaviour to don't cond_resched when in_atomic. This makes the
> > sleeping function called from invalid context bug happen again, which
> > is reported in http://lkml.org/lkml/2009/12/1/371.
> > 
> > The fix is to cond_sched() only when preemptible, which means not in
> > irq_disabled or in_atomic.
> > 
> > Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > ---
> >  include/acpi/platform/aclinux.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> > index 9d7febd..5b415ee 100644
> > --- a/include/acpi/platform/aclinux.h
> > +++ b/include/acpi/platform/aclinux.h
> > @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
> >  #include <linux/hardirq.h>
> >  #define ACPI_PREEMPTION_POINT() \
> >  	do { \
> > -		if (!in_atomic_preempt_off()) \
> > +		if (preemptible()) \
> >  			cond_resched(); \
> >  	} while (0)
> >  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


