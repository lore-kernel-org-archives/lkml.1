Return-Path: <linux-kernel-owner+w=401wt.eu-S1761944AbZATQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761944AbZATQGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZATQGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:06:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294AbZATQGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:06:36 -0500
Date: Tue, 20 Jan 2009 17:06:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090120160613.GA32650@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <20090120125652.GA1457@elte.hu> <1232461380.4895.33.camel@kulgan.wumi.org.au> <20090120142515.GC10224@elte.hu> <1232466686.4895.45.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232466686.4895.45.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> I've uploaded the debug info here:
>   http://disenchant.net/tmp/bug-12465/

one interesting number to watch for is the KVM thread's wait_max in 
/proc/*/sched. The largest one seems to be 11 milliseconds:

se.wait_max                        :             3.175034
se.wait_max                        :             4.029938
se.wait_max                        :             4.217674
se.wait_max                        :             4.957836
se.wait_max                        :            10.339471
se.wait_max                        :            11.603943

which would be about right given your latency settings:

 /proc/sys/kernel/sched_latency_ns:
 60000000

[ 60 msecs ]

but ... i dont specifically see the kvm threads there. Are they not in 
/proc/*? Maybe it's in threads and it needs to be accessed via 
/proc/*/task/*/sched, as via:

$ grep -h wait_max /proc/*/task/*/sched | sort -t: -n -k 2 | tail -10
se.wait_max                        :            77.858092
se.wait_max                        :            78.778409
se.wait_max                        :            79.379026
se.wait_max                        :            85.930963
se.wait_max                        :            87.671842
se.wait_max                        :            88.008602
se.wait_max                        :            95.095744
se.wait_max                        :           157.882573
se.wait_max                        :           268.714775
se.wait_max                        :           393.085252

so the worst-case latency

Btw., there's a few weird stats in your logs:

se.wait_max                        :          -284.864857
se.wait_max                        :          -284.843431
se.wait_max                        :          -284.820204
se.wait_max                        :          -284.345294
se.wait_max                        :          -284.298462
se.wait_max                        :          -284.018644
se.wait_max                        :          -284.018070
se.wait_max                        :          -188.022417
se.wait_max                        :          -188.021659
se.wait_max                        :           -92.030204
se.wait_max                        :           -92.027877

that field is not supposed to be negative. Mike, Peter, any ideas?

	Ingo
