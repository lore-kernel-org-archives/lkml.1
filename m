Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXHISx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXHISx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbXHISxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:53:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760562AbXHISxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:53:36 -0400
Date: Thu, 9 Aug 2007 11:52:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "shannon.nelson@intel.com" <shannon.nelson@intel.com>,
       Andi Kleen <ak@suse.de>, "Luck, Tony" <tony.luck@intel.com>
Subject: Re: 2.6.23-rc2-mm1 -- drivers/dma/ioat_dca.c:177: error: implicit
 declaration of function =?ISO-8859-1?Q?=5F=5F=5Fcpu=5Fphysical=5Fid?=
 =?ISO-8859-1?Q?=5F=5F=5F?=
Message-Id: <20070809115258.5372f76e.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
References: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007 10:18:15 -0400
"Miles Lane" <miles.lane@gmail.com> wrote:

>   CC      drivers/dma/ioat_dca.o
> drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> drivers/dma/ioat_dca.c:177: error: implicit declaration of function
> 'cpu_physical_id'

Looks like cpu_physical_id() doesn't get implemented if CONFIG_SMP=n.

Either ioat needs to stop using cpu_physical_id() if SMP=n, or the
supported architectures (i386, x86_64, ia64) should provide a non-SMP
version of cpu_physical_id().  Preferably the latter, I'd say.

Something like this, I suppose...


From: Andrew Morton <akpm@linux-foundation.org>

i386, x86_64 and ia64 implement cpu_physical_id() if CONFIG_SMP=y.

Provide a uniprocessor stub so that callers will dtrt.

Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN include/linux/smp.h~implement-cpu_physical_id-on-smp=n include/linux/smp.h
--- a/include/linux/smp.h~implement-cpu_physical_id-on-smp=n
+++ a/include/linux/smp.h
@@ -108,6 +108,11 @@ static inline void smp_send_reschedule(i
 	0;			\
 })
 
+static inline unsigned cpu_physical_id(unsigned cpu)
+{
+	return 0;
+}
+
 #endif /* !SMP */
 
 /*
_

