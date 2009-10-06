Return-Path: <linux-kernel-owner+w=401wt.eu-S932146AbZJFKq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbZJFKq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZJFKq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:46:27 -0400
Received: from smtp.nokia.com ([192.100.105.134]:36804 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbZJFKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:46:27 -0400
Subject: Re: [BISECTED] "conservative" cpufreq governor broken
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: ext Steven Noonan <steven@uplinklabs.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
References: <alpine.LNX.2.00.0910050923280.2419@alcarin.uplinklabs.net>
	 <1254814298.31336.63.camel@eenurkka-desktop>
	 <f488382f0910060322y12e2e7dbm9a1372e481c9013f@mail.gmail.com>
Content-Type: text/plain
Organization: Nokia
Date: Tue, 06 Oct 2009 13:43:15 +0300
Message-Id: <1254825795.31336.204.camel@eenurkka-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2009 10:44:22.0918 (UTC) FILETIME=[F762DA60:01CA4671]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 12:22 +0200, ext Steven Noonan wrote:
> 
> I would suspect you have to have CONFIG_NO_HZ enabled to be able to
> reproduce the issue (considering the title of the bisected commit and
> my own config). Do you have it enabled?
> 

Yes, it's enabled.

> > And another round:
> >
> > cpufreq stats: OP1:16,78%, OP2:0,24%, OP3:5,14%, OP4:77,83%  (72)
> >
> > Just once more after doing nothing:
> > OP1:7,41%, OP2:0,11%, OP3:2,38%, OP4:90,10%  (82)
> >
> > So I can't agree it's broken. The patch you bisected, actually filtered
> > out such phenomenon, in which an IRQ made the cpufreq framework
> > occasionally think we were idling, although we were not. So you got
> > "bonus" idle time that shouldn't been there in the first place. Now that
> > the "bonus" idle time is not there, your system load may indeed be so
> > high that the system never spends 80% or more time in idle? Could that
> > be the case? Of course, even though I can't agree it's broken, doesn't
> > mean it isn't somehow broken ;) It'd be nice to get info on other
> > systems as well...
> 
> Interestingly, "ondemand" (the governor fixed by the bisected commit)
> works fine. "conservative" is the only broken one.
> 

If you took timestamps in /arch/x86/kernel/process_**.c:
(let's assume process_64.c) in cpu_idle()
around enter_idle(); and __exit_idle(), took the diff,
added the diffs up, and compared it to system uptime, you could see how
much time you spend in idle()? I think it's possible that
even if the cpu load is near 0%, the system may idle only for a bare
moment (that translates to a buggy pm_idle()), and time is spent
elsewhere (less than 80% in idle). 

If I had similar findings like you, I'd be worried; but traces here and
there will point out where things go wrong ;)

- Eero

