Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbXFTMuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbXFTMuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXFTMuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:50:10 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:40089 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbXFTMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:50:08 -0400
Date: Wed, 20 Jun 2007 05:49:59 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com, akpm@linux-foundation.org
Subject: Re: [perfmon] Re: [PATCH 1/2] Separate the performance counter allocation from the LAPIC NMI watchdog
Message-ID: <20070620124959.GB24906@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070618103214.GA12045@atjola.homenet> <200706201431.44014.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706201431.44014.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Jun 20, 2007 at 02:31:43PM +0200, Andi Kleen wrote:
> On Wednesday 20 June 2007 12:35:56 Björn Steinbrink wrote:
> > The performance counter allocator is tied to the LAPIC NMI watchdog,
> 
> That's not true. It's completely independent. It just happens to be in
> the same file, but it has no direct functional ties to the watchdog.
> 
I agree with you that the allocator is functionally independent of the
watchdog. That is how I'd like to see it and I think we all agree on
that.

Yet in the current implementation, there is a link between the two which
causes the issues I ran into. If you look at:

static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
{
        return wd_ops ? msr - wd_ops->evntsel : 0;
}

int reserve_evntsel_nmi(unsigned int msr)
{
        unsigned int counter;

        counter = nmi_evntsel_msr_to_bit(msr);
        BUG_ON(counter > NMI_MAX_COUNTER_BITS);
	....
}

You see that if the wd_ops (a watchdog structure) is not initialized
then the allocator collapses all MSRs onto one bit.

Once this is fixed (which is what Bjorn did), then I will agree with you.
For this, the allocator needs to be able to probe the CPU and initialize
its own data structures.

-- 
-Stephane
