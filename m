Return-Path: <linux-kernel-owner+w=401wt.eu-S936934AbZAOXDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936934AbZAOXDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936398AbZAOW4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:56:24 -0500
Received: from mga05.intel.com ([192.55.52.89]:24993 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936371AbZAOW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:56:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,272,1231142400"; 
   d="scan'208";a="422784462"
Message-ID: <496FBF2B.4010809@linux.intel.com>
Date: Thu, 15 Jan 2009 23:56:43 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Tim Hockin <thockin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       ying.huang@intel.com, Aaron Durbin <adurbin@gmail.com>,
       priyankag@google.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu>	 <49594411.60000@linux.intel.com> <20090113174522.GA26965@elte.hu>	 <b3ece790901131057w4c76a428p4308b494675d69aa@mail.gmail.com>	 <496DB067.6060402@linux.intel.com>	 <b3ece790901140818i183bc30n2de01b5edaa6a2c7@mail.gmail.com>	 <496E297B.6010100@linux.intel.com> <b3ece790901141132u28ba2482h2e7af7bd51224f2a@mail.gmail.com>
In-Reply-To: <b3ece790901141132u28ba2482h2e7af7bd51224f2a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Hockin wrote:
> Yeah, no offense, but that's horrible :)

I'm not sure it's worse than the XML like format proposals that seem to
get thrown around. That is I am the only one who mentioned the
X word yet, but the structured ASCII records that have been hinted
at would be exactly like that.

> 
> Ideally, I'd rather see a more generic conduit for all sorts of
> events.  Polled and exception MCEs.  Thermal interrupts.  MCE
> threshold interrupts. 

Actually I think now MCE threshold interrupts should have never been
separate events. That was a design mistake in the AMD implementation
(together with all the sysfs complications)

An MCE threshold interrupt is just a slightly different internal
notification mechanism and it should only trigger the events it reads
from the MCE banks. Nothing more.
My upcoming CMCI code works exactly this way.

> PCI-express errors. 

Yes we need some mechanism for those. Fortunately that's easier
because it doesn't need to handle NMIs.

> SATA
> disk timeouts.

Now that's a different issue. Generalized driver error reporting for everyone.

There was a lot of discussion some years ago from a IBM proposal to do
in general structured error reporting. But that was quite unpopular
and no-one really liked it.

What came out of it was the dev_printk() stuff that allows
to match error messages to devices. So you already have some
baby steps in this direction.

I suspect doing this fully generalized would be quite difficult
because there would be so many people you have to convince.



> Now I know there are different conduits for some events - netlink
> tells me about netif link up/down events I think.  I would settle for
> a small number of interfaces.  What I don't want is what we have today
> - EVERYTHING has a different interface.  Some are poll()-able.  Some
> have to be actively polled.  Some have to have a daemon listening or
> else messages are dropped.  

Well the kernel will always have limited buffers, so the someone
needs to listen problem will be always there.

There are not __that__ many I think.

Also whatever code handles this has to have special code for
all of these anyways, so having a variety of interfaces for them
doesn't seem like the end of the world to me.

> 
> Put it this way:  Given a thousand machines, I want to gather,
> collate, and correlate all these events.  I want to be able to produce
> a "life story" of sorts for a machine and for a data center.  Once I
> can do that, I can start to make predictive diagnoses more accurately,
> and I can know how much these things actually COST us.

Sure sounds nice. But frankly I don't see it happening. It would
be just too radical a change of too much code.

-Andi

