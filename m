Return-Path: <linux-kernel-owner+w=401wt.eu-S934269AbZLJMlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269AbZLJMlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbZLJMlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:41:05 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:49903 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757986AbZLJMlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:41:04 -0500
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 07:41:04 EST
Message-ID: <4B20E7B2.1010208@suse.de>
Date: Thu, 10 Dec 2009 15:21:06 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH -V2] acpi: don't cond_resched if irq is disabled
References: <20091210100907.GA2446@ucw.cz> <1260446205-16868-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1260446205-16868-1-git-send-email-dfeng@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xiaotian,

I think, this is another round of "armor vs. bullet" race... It will hold until
might_sleep() logic changes again.

Please consider using preemptible() -- IMHO this is the check we should perform 
in our case of voluntary preemption.

Regards,
Alex.


Xiaotian Feng пишет:
> commit 8bd108d adds preemption point after each opcode parse, then
> a sleeping function called from invalid context bug was founded
> during suspend/resume stage. this was fixed in commit abe1dfa by
> don't cond_resched when irq_disabled. But recent commit 138d156 changes
> the behaviour to don't cond_resched when in_atomic. This makes the
> sleeping function called from invalid context bug happen again, which
> is reported in http://lkml.org/lkml/2009/12/1/371.
> 
> This patch also fixes http://bugzilla.kernel.org/show_bug.cgi?id=14483
> 
> Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-and-bisected-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
> Cc: Pavel Machek <pavel@ucw.cz>
> ---
>  include/acpi/platform/aclinux.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 9d7febd..0946997 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  #include <linux/hardirq.h>
>  #define ACPI_PREEMPTION_POINT() \
>  	do { \
> -		if (!in_atomic_preempt_off()) \
> +		if (!in_atomic_preempt_off() && !irqs_disabled()) \
>  			cond_resched(); \
>  	} while (0)
>  

