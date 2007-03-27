Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXC0NXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXC0NXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXC0NXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:23:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54734 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbXC0NXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:23:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Mitch Williams <mitch.a.williams@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <1174951102.22190.15.camel@strongmad>
	<20070327000951.GA11555@kroah.com>
Date: Tue, 27 Mar 2007 07:23:16 -0600
In-Reply-To: <20070327000951.GA11555@kroah.com> (Greg KH's message of "Mon, 26
	Mar 2007 17:09:51 -0700")
Message-ID: <m14po6zupn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Mon, Mar 26, 2007 at 04:18:22PM -0700, Mitch Williams wrote:
>> This patch fixes a kernel bug which is triggered when using the
>> irqbalance daemon with MSI-X hardware.
>> 
>> Because both MSI-X interrupt messages and MSI-X table writes are posted,
>> it's possible for them to cross while in-flight.  This results in
>> interrupts being received long after the kernel thinks they're disabled,
>> and in interrupts being sent to stale vectors after rebalancing.
>> 
>> This patch performs a read flush after writes to the MSI-X table for
>> enable/disable and rebalancing operations.  Because this is an expensive
>> operation, we do not perform the read flush after mask/unmask
>> operations.  Hardware which supports MSI-X typically also supports some
>> sort of interrupt moderation, so a read-flush is not necessary for
>> mask/unmask operations.
>> 
>> This patch has been validated with (unreleased) network hardware which
>> uses MSI-X.
>
> How well does this play with the MSI core changes that Michael Ellerman
> has proposed on the linux-pci mailing list?

I guess I should add that I'm not certain that the code is exactly correct
there are weird differences between enable/disable and mask.  Where generally
the mask/unmask methods do the work and enable/disable do some weird software
thing.  Having them different and enable/disable not doing some software
thing concerns me a little.  I think mask/unmask may been overoptimized
in this case.

So I expect someone will wind up refactor this code at some point.

However the code is clearly better than what we have now, and it can't
affect anything else.

Eric
