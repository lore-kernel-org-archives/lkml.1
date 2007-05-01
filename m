Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXEAWpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXEAWpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbXEAWpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:45:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:61930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbXEAWpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:45:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="82242202"
Message-ID: <4637C313.8040002@intel.com>
Date: Tue, 01 May 2007 15:45:39 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Michel Lespinasse <walken@zoy.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <4637C227.5040108@redhat.com>
In-Reply-To: <4637C227.5040108@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2007 22:45:40.0072 (UTC) FILETIME=[7158BE80:01C78C42]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Kok, Auke wrote:
>> Michel Lespinasse wrote:
>>> (I've added the E1000 maintainers to the thread as I found the issue
>>> seems to go away after I compile out that driver. For reference, I was
>>> trying to figure out why I lose exactly 24 ticks about every two
>>> seconds, as shown with report_lost_ticks. This is with a DQ965GF
>>> motherboard with onboard E1000).
>> that's perfectly likely. The main issue is that we read the hardware
>> stats every two seconds and that can consume quite some time. It's
>> strange that you are losing that many ticks IMHO, but losing one or two
>> might very well be.
>>
>> We've been playing with all sorts of solutions to this problem and
>> haven't come up with a way to reduce the load of the system reading HW
>> stats, and it remains the most likely culprit, allthough I don't rule
>> out clean routines just yet. This could very well be exaggerated at
>> 100mbit speeds as well, I never looked at that.
>>
>> I've had good results with 2.6.21.1 (even running tickless :)) on these
>> NICs. Have you tried that yet?
> 
> Maybe this could fix it in 2.6.20? (went into 2.6.21)

well, that hasn't got anything to do with stats, but is part of the clean_tx/rx 
codepath. I personally don't get any lost_ticks so I can't reproduce, but that 
was why I was hinting that you can try it for us ;)

codewise, the patch below makes our cleanup routine spend _more_ time, instead 
of less, which is why I think it's not the cause nor fix.

Auke

> 
> --------------------------------------------------------------------------
> 
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=46fcc86dd71d70211e965102fb69414c90381880
> Commit:     46fcc86dd71d70211e965102fb69414c90381880
> Parent:     2b858bd02ffca71391161f5709588fc70da79531
> Author:     Linus Torvalds <torvalds@woody.linux-foundation.org>
> AuthorDate: Thu Apr 19 18:21:01 2007 -0700
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Thu Apr 19 18:21:01 2007 -0700
> 
>     Revert "e1000: fix NAPI performance on 4-port adapters"
>     
>     This reverts commit 60cba200f11b6f90f35634c5cd608773ae3721b7.  It's been
>     linked to lockups of the e1000 hardware, see for example
>     
>     	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229603
>     
>     but it's likely that the commit itself is not really introducing the
>     bug, but just allowing an unrelated problem to rear its ugly head (ie
>     one current working theory is that the code exposes us to a hardware
>     race condition by decreasing the amount of time we spend in each NAPI
>     poll cycle).
>     
>     We'll revert it until root cause is known.  Intel has a repeatable
>     reproduction on two different machines and bus traces of the hardware
>     doing something bad.
>     
