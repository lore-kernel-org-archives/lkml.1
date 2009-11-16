Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbZKPF1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbZKPF1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZKPF1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:27:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:45246 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751091AbZKPF1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:27:47 -0500
X-Authenticated: #3373616
X-Provags-ID: V01U2FsdGVkX1+zfOF4lyqzGAfO2iccjs2cXz28HdyVmHsnKGJFPJ
	1an7/Bhyhp/I39
Message-ID: <4B00E261.6080701@gmx.de>
Date: Mon, 16 Nov 2009 15:25:53 +1000
From: =?ISO-8859-1?Q?Simon_K=E4mpflein?= <s.kaempflein@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       bfweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: perf counters: problem with perf record
References: <4AFEE55B.3000906@gmx.de> <1258227980.30187.512.camel@laptop> <4AFFD2B8.5060400@gmx.de> <20091115103459.GC24931@elte.hu>
In-Reply-To: <20091115103459.GC24931@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote
>> Maybe it's a good idea to add another comment making it clear that the
>> performance counters are not fully working in this case. Or detect this
>> case in "perf-record" and output a message relating to that.
> 
> Ok. Mind sending a patch that changes the message so that it explains it 
> all to you more clearly?

Here's a patch for this:

More accurate error message when "perf record" fails because there is no
APIC support:
---
 tools/perf/builtin-record.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 04f335e..77b21f1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -303,6 +303,10 @@ try_again:
                printf("\n");
                error("perfcounter syscall returned with %d (%s)\n",
                        fd[nr_cpu][counter], strerror(err));
+
+               if (attr->type == PERF_TYPE_HARDWARE && err == EOPNOTSUPP)
+                        die("No hardware sampling interrupt available.
No APIC? Boot the kernel with the \"lapic\" boot parameter to
force-enable it.\n");
+
                die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
                exit(-1);
        }
--
1.5.4.3


> 
>>> And does booting with the suggested lapic parameter cure your problems?
>>>
>> Yes, thank you!
> 
> Great.
> 
> You might want to send another patch that allows the .config enabling of 
> that lapic boot parameter. It sucks to carry around boot parameters.
> 

I'm not sure if this is a good idea. Some systems may crash if you
force-enable it:
http://lkml.indiana.edu/hypermail/linux/kernel/0307.3/1635.html

And I'm also not familiar with the kernel internals on that topic ;)

Simon

