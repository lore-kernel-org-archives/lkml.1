Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXLKO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXLKO1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbXLKO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:27:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:32782 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbXLKO1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:27:15 -0500
To: dor.laor@qumranet.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Performance overhead of get_cycles_sync
From: Andi Kleen <andi@firstfloor.org>
References: <475E8C8B.7070308@qumranet.com>
Date: Tue, 11 Dec 2007 15:27:14 +0100
In-Reply-To: <475E8C8B.7070308@qumranet.com> (Dor Laor's message of "Tue\, 11 Dec 2007 15\:11\:39 +0200")
Message-ID: <p73lk81nw71.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[headers rewritten because of gmane crosspost breakage]

> In the latest kernel (2.6.24-rc3) I noticed a drastic performance 
> decrease for KVM networking.

That should not have changed for quite some time.

Also it depends on the CPU of course.

> The reason is many vmexit (exit reason is cpuid instruction) caused by
> calls to gettimeofday that uses tsc sourceclock.
> read_tsc calls get_cycles_sync which might call cpuid in order to 
> serialize the cpu.
>
> Can you explain why the cpu needs to be serialized for every gettime call?

Otherwise RDTSC can be speculated around and happen outside the protection
of the seqlock and that can sometimes lead to non monotonic time reporting.

Anyways after a lot of discussions it turns out there are ways to archive
this without CPUID and there is a solution implemented for this in ff
tree which I will submit for .25. It's a little complicated though
and not a quick fix.

> Do we need to be that accurate? (It will also slightly improve physical 
> hosts).
> I believe you have a reason and the answer is yes. In that case can you 
> replace the serializing instruction
> with an instruction that does not trigger vmexit? Maybe use 'ltr' for 
> example?

ltr doesn't synchronize RDTSC.

-Andi
