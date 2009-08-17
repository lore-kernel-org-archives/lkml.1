Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbZHQJSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbZHQJSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbZHQJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:18:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34351 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553AbZHQJSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:18:40 -0400
Date: Mon, 17 Aug 2009 11:18:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       ak@linux.intel.com, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine
	check code on 32bit
Message-ID: <20090817091800.GA21269@elte.hu>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A891E17.1090901@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> >> Could you try boot your laptop with mce=nobootlog?
> > 
> > Hm, why should that make any difference? mce=nobootlog only 
> > influences whether we pass records into the mcelog buffer but 
> > does not affect whether we touch the hardware.
> 
> Old mce codes doesn't take bootlog.

I understand what you mean, and i know that we have a number of BIOS 
workarounds in the code - but i think some of those workarounds are 
wrong and they dont actually solve anything.

The thing is, mce=nobootlog does _not_ keep us from touching MCE 
related hardware registers during bootup.

It only inhibits us from doing an mce_log() call:

                if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
                        mce_log(&m);
                        add_taint(TAINT_MACHINE_CHECK);
                }

but an mce_log() call itself only passes on the data we already read 
from hardware registers, into the MCE ring-buffer (which is a pure 
software construct).

> One possibility is: if the BIOS doesn't clear status in banks,
> new mce codes will try to log such junks.
>
> If the junk is totally junk but can be decoded as a valid log with 
> MISCV or ADDRV bit, and if the cpu try to access register which is 
> not implemented (e.g. IA32_MCi_MISC/ADDR), then such access might 
> cause a general protection exception. (ref. ASDM 3A 15.3.2.3)
> 
> I'm just guessing...

My point is that mce=nobootlog will only affect whether we call 
mce_log(). It does not keep us from touching all the MSRs that 
relate to MCEs.

mce=off does that, and the box boots up fine with that specified 
(and as expected).

	Ingo
