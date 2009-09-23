Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZIWWrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZIWWrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZIWWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:47:08 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29691 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZIWWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:47:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMlCukqrR7PE/2dsb2JhbAC+bYhPAY93BYQbgV0
X-IronPort-AV: E=Sophos;i="4.44,440,1249257600"; 
   d="scan'208";a="394793989"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Reduce verbosity of "PAT enabled" kernel message
References: <adavdj92sso.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 23 Sep 2009 15:47:10 -0700
In-Reply-To: <adavdj92sso.fsf@cisco.com> (Roland Dreier's message of "Wed, 23
	Sep 2009 15:35:35 -0700")
Message-ID: <adar5tx2s9d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Sep 2009 22:47:11.0031 (UTC) FILETIME=[C96CFC70:01CA3C9F]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, there is further work to be done in this direction... these
were the easy ones (that save me 127 lines of dmesg :).

The philosophy should probably be things that we would want to see to
debug crashes at boot should go into the kernel log -- that makes it
easy for users to grab the output and send it on for debugging.  If we
can move other stuff somewhere that users can grab easily after boot,
then that's probably worth it.

I think the next things to look at are:

* secondary CPU booting:

     Calibrating delay using timer specific routine.. xxxx BogoMIPS (lpj=xxxx)
     CPU: Physical Processor ID: 2
     CPU: Processor Core ID: 0
     CPU: L1 I cache: xxxx, L1 D cache: xxxx
     CPU: L2 cache: xxxx
     CPU: L3 cache: xxxx
     CPU 1/0x40 -> Node 0
     mce: CPU supports xxxx MCE banks
     CPU1: Thermal monitoring enabled (TM1)
     CPU 1 MCA banks ....

  where all 64 CPUs are exactly the same -- I guess checking for
  non-homogenous systems might be kind of complicated but we really
  shouldn't print all this for every CPU when they all match the boot
  CPU precisely.

* scheduler domain stuff:

     CPU0 attaching sched-domain:
      domain 0: span 0,32 level SIBLING
       groups: 0 (cpu_power = xxxx) 32 (cpu_power = xxxx)
       domain 1: span 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60 level MC
        groups: 0,32 (cpu_power = xxxx) 4,36 (cpu_power = xxxx) 8,40 (cpu_power = xxxx) 12,44 (cpu_power = xxxx) 16,48 (cpu_power = xxxx) 20,52 (cpu_power = xxxx) 24,56 (cpu_power = xxxx) 28,60 (cpu_power = xxxx)
        domain 2: span 0-63 level CPU
         groups: 0,4,8,12,16,20,24,28,32,36,40,44,48,52,56,60 (cpu_power = xxxx) 1,5,9,13,17,21,25,29,33,37,41,45,49,53,57,61 (cpu_power = xxxx) 2,6,10,14,18,22,26,30,34,38,42,46,50,54,58,62 (cpu_power = xxxx) 3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63 (cpu_power = xxxx)

  not sure what the best way to present this is but 64 copies of this
  output do consume a lot of log buffer space!

* misc stuff, where we get 64 copies of a single message, eg

     Switched to high resolution mode on CPU 0

     ACPI: Processor [CPU0] (supports 8 throttling states)
     processor LNXCPU:01: registered as cooling_device1
