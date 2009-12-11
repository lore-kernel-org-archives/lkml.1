Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZLKGAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZLKGAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZLKGAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:00:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:37494 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZLKGAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:00:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,379,1257148800"; 
   d="scan'208";a="521900046"
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
From: Lin Ming <ming.m.lin@intel.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Xiaotian Feng <dfeng@redhat.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <4B20E7B2.1010208@suse.de>
References: <20091210100907.GA2446@ucw.cz>
	 <1260446205-16868-1-git-send-email-dfeng@redhat.com>
	 <4B20E7B2.1010208@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 13:46:13 +0800
Message-Id: <1260510373.10543.17.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 20:21 +0800, Alexey Starikovskiy wrote:
> Hi Xiaotian,
> 
> I think, this is another round of "armor vs. bullet" race... It will hold until
> might_sleep() logic changes again.
> 
> Please consider using preemptible() -- IMHO this is the check we should perform 
> in our case of voluntary preemption.

preemptible() may not work here because it always returns 0 for
non-preemptible kernel.

#ifdef CONFIG_PREEMPT
# define preemptible()  (preempt_count() == 0 && !irqs_disabled())
# define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
#else
# define preemptible()  0
# define IRQ_EXIT_OFFSET HARDIRQ_OFFSET
#endif

Lin Ming

> 
> Regards,
> Alex.
> 
> 
> Xiaotian Feng пишет:
> > commit 8bd108d adds preemption point after each opcode parse, then
> > a sleeping function called from invalid context bug was founded
> > during suspend/resume stage. this was fixed in commit abe1dfa by
> > don't cond_resched when irq_disabled. But recent commit 138d156 changes
> > the behaviour to don't cond_resched when in_atomic. This makes the
> > sleeping function called from invalid context bug happen again, which
> > is reported in http://lkml.org/lkml/2009/12/1/371.
> > 
> > This patch also fixes http://bugzilla.kernel.org/show_bug.cgi?id=14483
> > 
> > Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Reported-and-bisected-by: Justin P. Mattock <justinmattock@gmail.com>
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: Bob Moore <robert.moore@intel.com>
> > Cc: Lin Ming <ming.m.lin@intel.com>
> > Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > ---
> >  include/acpi/platform/aclinux.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> > index 9d7febd..0946997 100644
> > --- a/include/acpi/platform/aclinux.h
> > +++ b/include/acpi/platform/aclinux.h
> > @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
> >  #include <linux/hardirq.h>
> >  #define ACPI_PREEMPTION_POINT() \
> >  	do { \
> > -		if (!in_atomic_preempt_off()) \
> > +		if (!in_atomic_preempt_off() && !irqs_disabled()) \
> >  			cond_resched(); \
> >  	} while (0)
> >  
> 

