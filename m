Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbZC0Jow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbZC0Jow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZC0Jok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:44:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36046 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbZC0Joj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:44:39 -0400
Message-ID: <49CC9FEC.6090300@jp.fujitsu.com>
Date: Fri, 27 Mar 2009 18:44:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
 cmci
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com>
In-Reply-To: <49CB4677.9010403@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> This patch adds a kernel parameter "mce_threshold=n" to enable us
>> to change the default threshold for CMCI(Corrected Machine Check
>> Interrupt) that recent Intel processor supports.
> 
> I intentionally didn't implement this because it seemed not needed.

I know your intention since you have mentioned it at description of
previous patch that implements CMCI support.

> Any threshold in the actual error reporting should be implemented
> in the user space processing backend, but not in the CPU, because
> they typically need to be more fine grained than just per bank,
> and the CPU cannot do that.

I believe that one of reasons why there is thresholding in CPU is
because it can be help for user space.  Not all backend in the user
space requires such fine graining.  More coarse grain also should be
supported.
i.e. It would be useful if the backend accounts 5 errors as 1 grain.

> The only potential reason for implementing this threshold at the
> CPU level is if someone is concerned about CPU consumption during error storms.
> But then the threshold should be dynamically adjusted based on the
> current rate, otherwise it doesn't help.

So sysfs is required for such usage, right?
I already have an another patch to have sysfs interface.
I'll post it next time if it helps.

> But I didn't do this so far because I didn't want to overengineer
> and in general if you have a error storm you're likely soon dead
> anyways.

Always it is said that corrected errors (and CE storm) will be soon
lead an uncorrected error.  But AFAIK there is no statistics about
that the "soon" is how much long.

Assume that if a component starts to assert CEs, you'll not stop
system but just schedule next maintenance by the weekend, by the
end of the month or so.  Nothing wrong with that.
I suppose we can have something to support the few days until the
maintenance.

> Also even if this was implemented a boot option would seem
> like the wrong interface compared to sysfs.

CMCI is enabled before sysfs creation, isn't it?
If someone like to disable CMCI at all, it seems sysfs is not enough.

> Can you please describe your rationale for this more clearly?

At first I've been asked about the default threshold of CMCI, and
noticed there is no way to know the default value, some kind of
"factory default."  So my concern is the "1", default value of current
implementation, is really appropriate value or not.

I told it to querier and had some responses that:
1) It is heard that already there are some customer complaining about
  error reporting for "every" CE.  So thresholding is nice solution
  for such cases.  Is it adjustable?
2) Usually reporting corrected error never have high priority so even
  it is too higher than reference high threshold would be preferred
  than low one.
3) The reference value might varies in every bank.  So it would be best
  if we can have per-bank adjusters, but it will be simple and still
  acceptable if we only have a global adjuster for all banks because of
  logic in 2).

And additionally that:
4) It is also heard that some have no interest in correctable errors
  at all!  In such case, kernel message "Machine check events logged"
  for CE (it is leveled KERN_INFO and already rate-limited) can be a
  "noise" in syslog.  Can we disable CE related stuff at all?
5) Our BIOS provides good log enough to identify faulty component,
  so OS log is rarely used in maintenance phase.  Comparing these log
  will be cause of confusion, in case if they use different threshold
  and if one reports error while another does not.  It depends on
  the platform which log is better, but I suppose disabling OS feature
  might be a good option for platforms where BIOS wins.
6) In past, EDAC driver troubled us by conflicting with BIOS since it
  clears error information in memory controller.  It would not happen
  in recent platforms that have processors integrated memory controller.
  However it would be a nice workaround to have switch to disable error
  monitoring by OS in advance, just in case there are something nasty
  conflict in BIOS or hardware.  Update or quirk for such issue will
  take time and rarely be in time.

So in summary, the conclusion is that it is better to have a threshold
adjuster as an option (at least global one) and also add some switch to
disable CE features just in case of troubles.


Thanks,
H.Seto

