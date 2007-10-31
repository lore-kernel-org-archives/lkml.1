Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXJaAXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXJaAXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXJaAXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:23:43 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31264 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbXJaAXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:23:42 -0400
Date: Tue, 30 Oct 2007 18:23:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-reply-to: <alpine.LFD.0.999.0710301653330.30120@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <4727CB1A.7040607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org>
 <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org>
 <20071027024140.GC29039@kroah.com> <47267232.3020506@shaw.ca>
 <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
 <4727C126.8070000@shaw.ca>
 <alpine.LFD.0.999.0710301653330.30120@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 30 Oct 2007, Robert Hancock wrote:
>>> You have to, anyway. Even now the MMCONFIG stuff uses CONF1 cycles for
>>> startup.
>> If it does, it's not by necessity. As soon as you read the table location out
>> of the ACPI tables you can start using it, and that shouldn't require any
>> config space accesses.
> 
> Don't be silly. Exactly _BECAUSE_ we cannot trust the firmware, we have to 
> use conf1 (which we can trust) to verify it and/or fix things up.

My point was, it's not inherently necessary in order to use MMCONFIG. 
I'm not saying the checks (unreachable_devices and 
pci_mmcfg_check_hostbridge) aren't useful or needed with many real 
machines. However, in the event that type1 access isn't available we 
just skip all those checks because we have no other option. It would 
indeed be a pretty broken spec if there was no way to bootstrap with it 
even under ideal conditions..

> 
> Also, there are several devices that don't show up in the MMCFG things, or 
> just otherwise get it wrong.
> 
> So just take a look at arch/x86/pci/mmconfig-shared.c and look for 
> "conf1".
> 
> Really. Damn, I'm nervous taking any MMCFG patches that has you as an 
> author, if you aren't even aware of these kinds of fundamnetal issues. You 
> probably read the standards about how things are "supposed" to work, and 
> then just believed them?
> 
> Rule #1 in kernel programming: don't *ever* think that things actually 
> work the way they are documented to work. The documentation is a starting 
> point, nothing else. 
> 
> And please be defensive in programming. We *know* conf1 cycles work. The 
> hardware has been extensively tested, and there are no firmware 
> interactions. There is *zero* reasons to use MMCONF cycles for normal 
> devices. Ergo: switching over to MMCONF when not needed is stupid and 
> fragile.

I can't really disagree that MMCONFIG doesn't have great advantages for 
most devices (though it likely is faster on a lot of platforms, which 
may be significant if the device does lots of config space accesses). So 
for the moment, avoiding using it except where necessary will likely 
work out (except if some system does indeed puke on mixing type1 and 
MMCONFIG).

However, what Microsoft is doing with Vista may eventually make a 
difference in the future. Many hardware vendors seem to use the testing 
strategy of "test with latest Windows version. Works OK? Ship it." If 
Vista decides that MMCONFIG is good to use all the time, then type1 
access support is likely going to a) end up less tested and b) probably 
deleted entirely in time. We've seen it before - it used to be that not 
using ACPI was the safe option on most hardware with Linux. Now you 
pretty much have to use it because the manufacturers only test with it 
enabled. I've seen at least one board where the interrupt routing was 
completely broken with ACPI off, because they obviously only tested in 
Windows..

