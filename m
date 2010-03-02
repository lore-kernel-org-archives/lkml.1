Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0CBGUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:20:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55663
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab0CBGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:20:19 -0500
Date: Mon, 01 Mar 2010 22:20:37 -0800 (PST)
Message-Id: <20100301.222037.82133333.davem@davemloft.net>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       robert.richter@amd.com, eranian@gmail.com
Subject: Re: [PATCH] perf_events: add sampling period randomization support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267510029-19750-1-git-send-email-eranian@google.com>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eranian@google.com
Date: Mon,  1 Mar 2010 22:07:09 -0800

> This patch adds support for randomizing the sampling period.
> Randomization is very useful to mitigate the bias that exists
> with sampling. The random number generator does not need to
> be sophisticated. This patch uses the builtin random32()
> generator.
> 
> The user activates randomization by setting the perf_event_attr.random
> field to 1 and by passing a bitmask to control the range of variation
> above the base period. Period will vary from period to period & mask.
> Note that randomization is not available when a target interrupt rate
> (freq) is enabled.
> 
> The last used period can be collected using the PERF_SAMPLE_PERIOD flag
> in sample_type.
> 
> The patch has been tested on X86. There is also code for PowerPC but
> I could not test it.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>

Please add this, which adds the feature to sparc too.

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 9f2b2ba..3e28225 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1214,6 +1214,9 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 		if (val & (1ULL << 31))
 			continue;
 
+		if (event->attr.random)
+			perf_randomize_event_period(event);
+
 		data.period = event->hw.last_period;
 		if (!sparc_perf_event_set_period(event, hwc, idx))
 			continue;
