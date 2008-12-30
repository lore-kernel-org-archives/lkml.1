Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYL3JNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYL3JNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 04:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYL3JNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 04:13:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:14447 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbYL3JNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 04:13:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,301,1228118400"; 
   d="scan'208";a="477796259"
Message-ID: <4959E63F.3070405@linux.intel.com>
Date: Tue, 30 Dec 2008 10:13:35 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <4959466F.5030205@linux.intel.com> <20081230065008.GC30975@elte.hu>
In-Reply-To: <20081230065008.GC30975@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> this reminds me, i dont particularly like the way you added a 
> self-interrupt:
> 
> +       __send_IPI_shortcut(APIC_DEST_SELF, MCE_SELF_VECTOR, 0);
> 
> IPI self-sends are generally more fragile than task-flag based methods, 
> and they also waste IRQ vector real-estate.

I believe the self IPI method is superior than going through the idle
notifiers using TIF flags as it was done before.

There's no guarantee idle (or other tif checkers like syscall return)
runs anytime soon after the event. They do usually, but it's not guaranteed.
And at least in the tolerant==3 case it's pretty important
to run this code ASAP.

It also is slightly cleaner code IMHO and better expresses the semantics
(execute as soon as the interrupts are on again) the code wants.
Admittedly temporarily it merging slightly harder, but that should
be only a temporary issue.

The original reason I did it this way  was because 32bit didn't have
them (but I think that's obsolete now, 32bit needs them now too
for the idle power management code)

The other rationale was also that with everything moving to per CPU
interrupt spaces vectors are not as precious as they used to be, so
it's ok to use more.

And I'm not aware of a fundamental unreliability of self IPI.
After all the IRQ migration code already relies on it.

-Andi
