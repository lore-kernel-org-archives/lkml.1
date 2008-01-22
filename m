Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYAVPYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYAVPYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAVPXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:23:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43293 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYAVPXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:23:54 -0500
Date: Tue, 22 Jan 2008 16:23:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Rescheduling interrupts
Message-ID: <20080122152333.GB19590@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr> <20080122105741.GG21149@elte.hu> <200801221455.16814.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801221455.16814.caglar@pardus.org.tr>
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


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> I grabbed the logs two times to make sure to catch needed info. 1st [1] one is generated while "Rescheduling interrupts" wakeups ~200 times and 2nd one generated for ~350 wakeups.
> 
> [1] http://cekirdek.pardus.org.tr/~caglar/dmesg.1st 
> [2] http://cekirdek.pardus.org.tr/~caglar/dmesg.2nd

thanks, these seem to be mostly normal wakeups from standard tasks:

 IPI from task kdm_greet:2118 on CPU#0:
 IPI from task X:2079 on CPU#1:
 IPI from task kdm_greet:2118 on CPU#0:
 IPI from task hald-addon-inpu:2009 on CPU#1:
 IPI from task events/0:7 on CPU#1:
 IPI from task bash:2129 on CPU#0:
 IPI from task kdm_greet:2118 on CPU#0:
 IPI from task events/0:7 on CPU#1:
 IPI from task events/0:7 on CPU#1:
 IPI from task events/0:7 on CPU#1:
 IPI from task bash:3902 on CPU#1:
 IPI from task bash:3902 on CPU#1:
 IPI from task amarokapp:3423 on CPU#1:
 IPI from task amarokapp:3423 on CPU#1:
 IPI from task amarokapp:3423 on CPU#1:
 IPI from task X:2079 on CPU#0:
 IPI from task yakuake:3422 on CPU#0:
 IPI from task X:2079 on CPU#1:
 IPI from task amarokapp:3423 on CPU#1:
 IPI from task amarokapp:3423 on CPU#1:

could you also add a similar IPI printouts (with the same panic_timeout 
logic) to arch/x86/kernel/smp_32.c's smp_reschedule_interrupt() function 
- while still keeping the other printouts too?

Could you also enable PRINTK_TIME timestamps, so that we can see the 
timings? (And do a "dmesg -n 1" so that the printks happen fast and the 
timings are accurate.) I'd suggest to increase CONFIG_LOG_BUF_SHIFT to 
20, so that your dmesg buffer is large enough. Plus try to capture 100 
events, ok?

My theory is that for whatever reason we get "repeat" IPIs: multiple 
reschedule IPIs although the other CPU only initiated one.

	Ingo
