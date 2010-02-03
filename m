Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0BCW0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:26:43 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38380 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0BCW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:26:42 -0500
Subject: Re: [PATCH 2/5] pps: capture MONOTONIC_RAW timestamps as well
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       "William S. Brasher" <billb958@door.net>, Reg Clemens <clemens@dwf.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <67507a9818993cfcf0139668c11569a6f3ff1981.1265228858.git.lasaine@lvk.cs.msu.su>
References: <cover.1265228858.git.lasaine@lvk.cs.msu.su>
	 <67507a9818993cfcf0139668c11569a6f3ff1981.1265228858.git.lasaine@lvk.cs.msu.su>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 14:26:16 -0800
Message-Id: <1265235976.3255.67.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 23:56 +0300, Alexander Gordeev wrote:
> MONOTONIC_RAW clock timestamps are ideally suited for frequency
> calculation and also fit well into the original NTP hardpps design. Now
> phase and frequency can be adjusted separately: the former based on
> REALTIME clock and the latter based on MONOTONIC_RAW clock.
> A new function getnstime_raw_and_real is added to timekeeping subsystem
> to capture both timestamps at the same time and atomically.

Hrmm. So while I understand the need for it, the
getnstime_raw_and_real() makes me cringe a little. Part of the issue is
that there are multiple CLOCK_IDs and the current interface allows for
accesses to only one at a time. There's a similar hack in the hrtimer
code to get the CLOCK_REALTIME and CLOCK_MONOTONIC values at the same
time. Next I worry that folks will want a getnstime_mono_and_raw() or a
getnstime_real_mono_and_raw(), then a getnstime_real_and_realcoarse(),
etc.. 

I'm almost thinking the way to handle this would be a better
abstraction, like a get_two_times(CLOCKID, timepsec*, CLOCKID,
timespec*). But that might need some further discussion. Anyone else
have thoughts here?

So yea not opposed to this patch, but maybe try to avoid exporting the
symbol, so modules don't end up using it and we can change it fairly
easily later.

thanks
-john

