Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYFTOXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYFTOXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbYFTOWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:22:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57856 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYFTOWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:22:51 -0400
Date: Fri, 20 Jun 2008 16:22:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Message-ID: <20080620142224.GF8135@elte.hu>
References: <20080620095247.GA24557@elte.hu> <20080620135639.GA5073@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620135639.GA5073@damson.getinternet.no>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi Ingo,
> 
> Can you see if this patch solves your problem? There might be other 
> functions that needs this guard as well, though. I wonder if maybe 
> this test should just be included at the top of every driver that uses 
> ACPI in some way. But I'm pretty sure that this lack of initialization 
> is the root of your problem in any case :-)

applied this to tip/out-of-tree for more testing, thanks Vegard.

> (By the way, I don't know why this problem popped up at this time, 
> maybe it was just bad timing/bad luck... How far back do your 
> AE_BAD_PARAMETER in the logs go?)

i have hit this warning for the first time in January 2008:

 [    0.000000] Linux version 2.6.24-rc8 (mingo@dione) (gcc version 4.2.2)
                #452 SMP Sun Jan 20 23:36:28 CET 2008

and it says:

[    0.000000] Calling initcall 0xc050758a: acpi_rtc_init+0x0/0xb8()
[    0.000000] ACPI Exception (utmutex-0263): AE_BAD_PARAMETER,
               Thread F7C22000 could not acquire Mutex [3] [20070126]
[    0.000000] initcall 0xc050758a: acpi_rtc_init+0x0/0xb8() returned 0.

the logs of my auto-tests on this box start at more than a year ago:

 Linux version 2.6.21-rc6 (mingo@dione) (gcc version 4.0.2)
               #331 SMP Fri Apr 13 10:14:12 CEST 2007

the size of the logs is 16.2 GB, covering the bootup of 58605 uniquely 
built kernels performing 67065 bootups - so it's a fairly exhaustive 
history.

that's why WARN_ON()s are so important - there's no way my automated 
tools (or even i, when taking a casual look at the logs) could have 
picked up that new ACPI Exception - if each subsystem has different 
warnings (which change frequently) then it's sheer impossible to 
automate the answer to the "does that log show any anomaly" question. 

( Even delta analysis would be of little use, due to timing related
  noise, random data variances and the impact of randconfig booting. )

The only reason i noticed it because this problem escallated into a lock 
corruption which triggered a WARN_ON().

	Ingo
