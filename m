Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbYAYJTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbYAYJTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYAYJTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:19:37 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:53260 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbYAYJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:19:35 -0500
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 25 Jan 2008 09:18:21 +0000
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Andi Kleen <ak@novell.com>, Nick Piggin <nickpiggin@yahoo.com.au>
CC: Jan Beulich <jbeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C3BF59DD.1B68F%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH UPDATE] x86: ignore spurious faults
Thread-Index: AchfMzqHeOugRMsmEdygEQAX8io7RQ==
In-Reply-To: <200801251011.36934.ak@novell.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/1/08 09:11, "Andi Kleen" <ak@novell.com> wrote:

>>> Actually, another thought: permitting (and handling) spurious faults for
>>> kernel mappings conflicts with NMI handling, i.e. great care would be
>>> needed to ensure the NMI path cannot touch any such mapping. So
>>> even the present Xen/Linux Dom0 implementation may have some
>>> (perhaps unlikely) problems here, and it would get worse if we added
>>> e.g. a virtual watchdog NMI (something I am considering, which would
>>> then extend the problem to DomU-s).
>> 
>> Can you explain how they conflict?
> 
> NMI is blocked by the hardware until IRET and when a page fault happens inside
> the NMI handler the early IRET unblocks it and then NMIs can nest, which
> will lead to stack corruption.

Whether this a problem in light of Xen spurious faults depends on whether
NMI handlers touch dynamically-allocated data. And if they do, it still
depends on the exact scenario. If it is likely to be a problem, a Xen pv_op
can flush the TLB on NMI entry, or we could have Xen do that implicitly
before invoking the guest NMI handler.

Currently Xen guests do not use NMI for watchdog or oprofile, so that rather
limits the scope for problems.

 -- Keir


