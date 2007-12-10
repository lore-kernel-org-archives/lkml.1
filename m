Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbXLJUVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbXLJUVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 15:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXLJUVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 15:21:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbXLJUVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 15:21:22 -0500
Date: Mon, 10 Dec 2007 21:20:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markut.t.metzger@intel.com,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       roland@redhat.com, akpm@linux-foundation.org, mtk.manpages@gmail.com,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: x86, ptrace: support for branch trace store(BTS)
Message-ID: <20071210202052.GA26002@elte.hu>
References: <20071210123809.A14251@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210123809.A14251@sedona.ch.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Cc:-ed Alan Stern a'ka kwatch fame - Alan might be interested in this 
  too. ]

hi Markus,

finally had time to take a closer look at the design of your 
Branch-Trace-Support-via-ptrace-on-x86 patchset. I think we'll need to 
work some more on general API issues.

here's the current proposed API:

+       case PTRACE_BTS_MAX_BUFFER_SIZE:
+       case PTRACE_BTS_ALLOCATE_BUFFER:
+       case PTRACE_BTS_GET_BUFFER_SIZE:
+       case PTRACE_BTS_READ_RECORD:
+       case PTRACE_BTS_CONFIG:
+       case PTRACE_BTS_STATUS:

i can see a couple of open questions:

1) PTRACE_BTS_MAX_BUFFER_SIZE

why is a trace buffer size limit visible to user-space? It's 4000 
entries right now:

     #define PTRACE_BTS_BUFFER_MAX 4000

it would be more flexible if user-space could offer arbitrary sized 
buffers, which the kernel would attempt to mlock(). Then those pages 
could be fed to the BTS MSR. I.e. there should be no hard limit in the 
API, other than a natural resource limit.

2) struct bts_struct

the structure of it is hardwired:

the basic unit is an array of bts_struct:

 +struct bts_struct {
 +       enum bts_qualifier qualifier;
 +       union {
 +               /* BTS_BRANCH */
 +               struct {
 +                       long from_ip;
 +                       long to_ip;
 +               } lbr;
 +               /* BTS_TASK_ARRIVES or
 +                  BTS_TASK_DEPARTS */
 +               unsigned long long timestamp;
 +       } variant;
 +};

while other CPUs (on other architectures, etc.) might have a different 
raw format for the trace entries. So it would be better to implement BTS 
support in kernel/ptrace.c with a general trace format, and to provide a 
cross-arch API (only implemented by arch/x86 in the beginning) to 
translate the 'raw' trace entries into the general format.

3)

it would certainly be useful for some applications to have a large 
"virtual" trace buffer and a small "real" trace buffer. The kernel would 
use BTS high-watermark interrupts to feed the real trace buffer into the 
larger "virtual" trace buffer. This way we wouldnt even have to use 
mlock() to pin down the trace buffer.

	Ingo
