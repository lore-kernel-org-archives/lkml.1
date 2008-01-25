Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYAYNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYAYNSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYAYNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:18:13 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:34059 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbYAYNSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:18:11 -0500
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 25 Jan 2008 13:17:32 +0000
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Andi Kleen <ak@suse.de>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C3BF91EC.1B6D5%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH UPDATE] x86: ignore spurious faults
Thread-Index: AchfVKRk4uDAKMtHEdygEQAX8io7RQ==
In-Reply-To: <200801251119.52798.ak@suse.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/1/08 10:19, "Andi Kleen" <ak@suse.de> wrote:

>> Whether this a problem in light of Xen spurious faults depends on whether
>> NMI handlers touch dynamically-allocated data.
> 
> How do you define dynamically-allocated data?

Anything that could have been a read-only pte or ldt page in a previous life
with no intervening TLB flush. So get_free_page(), kmalloc(), vmalloc(), ...

Actually I think we are fine, now I think about it some more, because we
only clear the software NMI-in-flight flag if the guest executes IRET via
the hypervisor. Most Xen Linux guests only do IRET via the hypervisor when
the current context is an NMI handler (additionally x86_64 also does so when
returning to ring 3). Most importantly for this case, we will *not* IRET via
the hypervisor when returning from a #PF context nested in an NMI context.
Hence the NMI-in-flight flag will not be cleared, and guest virtual NMIs
will not nest. So that's a relief!

 -- Keir


