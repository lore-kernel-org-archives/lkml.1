Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933Ab0AGW2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab0AGW2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510Ab0AGW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:28:50 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:38568 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0AGW2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:28:49 -0500
To: mgross@linux.intel.com
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
	<87ocl550x7.fsf@deeprootsystems.com>
	<20100107205227.GA5703@linux.intel.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 07 Jan 2010 14:28:46 -0800
In-Reply-To: <20100107205227.GA5703@linux.intel.com> (mark gross's message of "Thu\, 7 Jan 2010 12\:52\:27 -0800")
Message-ID: <87d41lv9b5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mark gross <mgross@linux.intel.com> writes:

> On Thu, Jan 07, 2010 at 08:34:28AM -0800, Kevin Hilman wrote:
>> Daniel Walker <dwalker@codeaurora.org> writes:
>> 
>> > From: Praveen Chidambaram <pchidamb@quicinc.com>
>> >
>> > In some systems, the system bus speed can be varied, usually
>> > based on the current CPU frequency.  However, various device
>> > drivers and/or applications may need a faster system bus for I/O
>> > even though the CPU itself may be idle.
>> >
>> > Signed-off-by: Praveen Chidambaram <pchidamb@quicinc.com>
>> > Signed-off-by: David Brown <davidb@quicinc.com>
>> > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
>> 
>> I think some type of bus parameter is a good idea and something we
>> would use on TI OMAP as well.  However, I also have two concerns with
>> this approach.
>> 
>> 1) The constraint should be in throughput, not in frequency
>> 2) It doesn't handle multiple busses (as Mark Gross pointed out)
>> 
>> For (1), I don't like the idea of forcing drivers to know about the
>> underlying bus frequency.  The same driver could be in use across a
>> family of SoCs (or even different SoCs), each having different bus
>> frequencies.  For this driver to be portable, the driver should
>> express its constraints in terms of throughput, not underlying bus
>> frequency.
>
> This makes sense, as throttling constraints should be based on things
> that are invariant to bus width.
>
>> 
>> For (2), I'm not sure what the best way to handle this in PM QoS is.
>> Lately, I've been thinking that PM QoS is not the right place for
>> this.  My idea (currenly only in my head) is the that busses in the
>> LDM (platform_bus, etc.)  should have constraints associated with
>> them.  That way, constraints can be set using a 'struct device' and
>> the bus they are attatched to will inherit the constraints directly.
>> This automatically solves the problem of multiple busses and allows
>> the possibility for different bus types to handle the constraints
>> differently.
>
> Sounds a bit like the range timers implementation.  One question, what
> would a throttling constraint changes API look like if not pm_qos?

Hmm, good question.  I haven't gotten far enough to think of an API. :(

I've been thinking of (and using) PM QoS as an API for system-wide
constraints, and it is fine for this. 

However, when it comes to device specific constraints, I don't think
it fits.  IMHO, constraints should be something that becomes part of
the driver model, rather than a separate API.  Most likely by evolving
the current runtime PM code.

Basically if a device has a constraint, it should register that
constraint with the LDM (API TBD) and it should be associated with the
device and associated bus etc.  That way, the PM core code (including
runtime PM layer) can examine device and bus specific constraints and
make localized decisions rather than querying some central repository.

This approach also allows the platform-specific runtime PM
implementations to handle constraints in platform-specific ways, but the
constraints are still tightly coupled to devices and/or busses.

> I think adding a bandwidth throttling constraint to struct device may be
> a good thing, but I'm not sure if there isn't a place for the PM_QOS
> interface yet.  i.e. perhaps if this happens, then we should look at
> evolving the pm_qos api to handle multiple constraint's per class and
> multiple buses, multiple nic's etc...

That's one option.  But my preferred option would be to see the LDM grow
some notion of per-device and/or per-bus constraints.

We're currenly experimenting with this on ARM/OMAP where we have have
a 'struct omap_device' which is a 'struct device' plus some
arch-specific extentions including constraints.  I am working on
runtime PM for OMAP currently, and when something is working there, we
may have some proposals for generalizing this in LDM-generic way.

Kevin
