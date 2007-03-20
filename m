Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbXCTUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbXCTUFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbXCTUFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:05:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59098 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbXCTUFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:05:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Daniel Yeisley <dan.yeisley@unisys.com>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] I/O space boot parameter
References: <1174407505.23830.14.camel@localhost.localdomain>
	<20070320180020.GB21470@suse.de>
Date: Tue, 20 Mar 2007 14:05:15 -0600
In-Reply-To: <20070320180020.GB21470@suse.de> (Greg KH's message of "Tue, 20
	Mar 2007 11:00:20 -0700")
Message-ID: <m1vegv1y10.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Mar 20, 2007 at 12:18:24PM -0400, Daniel Yeisley wrote:
>> It has been mentioned before that large systems with a lot of PCI buses
>> have issues with the 64k I/O space limit.  The ES7000 has a BIOS option
>> to either assign I/O space to all adapters, or only to those that need
>> it.  A list of supported adapters that don't need it is kept in the
>> BIOS.  When this option is used, the kernel sees the BARs on the
>> adapters and still tries to assign I/O space (until it runs out).  I've
>> written a patch to implement a boot parameter that tells the kernel not
>> to assign I/O space if the BIOS hasn't.  
>
> How prelevant are machines like this?  And why are the BARs on these
> devices wrong?

It is a machine scaling issue, and largely caused because we have
only one PCI-IO space on x86.  Since devices are increasingly moving
to mmaped I/O it becomes less of an issue but there are still legacy
bits and pieces.

The bridges should be able to correctly have a no pci io region,
by setting base > than limit.  Having bridges that can map pci io
but don't have anything behind them is common.

The concept of having devices that have I/O bars that we should not
assign I/O space to I find a little weird.  I guess we can detect
this case by simply looking to see if the bridge maps the address
assigned to the bar.

Ideally the way to handle this case is to not that the BAR is not
valid (but it could be) and not attempt to fix this until the driver
tries to use the BAR.

The approach where we don't allocate a bar if the BIOS doesn't sounds
like a hack, and we still need code in the kernel to detect that the
BAR has an invalid value and that we can't use it.

I have seen so many different api's for mapping the region behind a
bar that I'm a little fuzzy.  Is my recollection correct that we
have enough flexibility in the current API that we can detect an
invalid address and allocate a valid one if needed?

I do know we have a semi common case that is related to this where
the BIOS does not allocate a resource because it knows we don't
need it, and the kernel being more generic decides to allocate it
just in case.  At which point the kernel reprograms the hardware
to allocate the resource and then we have problems because the
kernel didn't have enough knowledge to reprogram the root complex
(northbridge) correctly.

So if we can delay our fixups to when we really need them the changes
of linux working on a machine where peculiar things are happening
are greater.

Eric
