Return-Path: <linux-kernel-owner+w=401wt.eu-S1767447AbXCIRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767447AbXCIRqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbXCIRqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:46:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50796 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXCIRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:46:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "No handler for vector" patches don't work on some systems
References: <45F188ED.7030202@redhat.com>
	<m1slce4b8r.fsf@ebiederm.dsl.xmission.com>
	<45F19858.3070604@redhat.com>
Date: Fri, 09 Mar 2007 10:45:52 -0700
In-Reply-To: <45F19858.3070604@redhat.com> (Chuck Ebbert's message of "Fri, 09
	Mar 2007 12:24:40 -0500")
Message-ID: <m1zm6m2tv3.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:

> Eric W. Biederman wrote:
>> Chuck Ebbert <cebbert@redhat.com> writes:
>>>
>>> So far I've tried the simple "survive having no handler
>>> for a vector" patch and the preliminary 3-patch series
>>> that was in -mm for a while, and neither work on the
>>> Dell PowerEdge 29xx and 19xx systems. These servers
>>> have the Intel 5000X chipset with the 6700PXH PCI Hub
>>> with dual independent PCI-X busses, each with its own
>>> I/OxAPIC with 24 interrupts. The fixes do work on
>>> "simple" systems but not on these high-end ones.
>> 
>> 
>> I would very much like to know if what I merged linus's tree helps.
>> It is a little more conservative, than my earlier patches.  I need
>> a way to reproduce this or to work closely with someone who is, because
>> this sounds like it has a different cause and I need to start with
>> that assumption.
>
> Was that merged or is it still in -mm? The last thing I see in
> arch/x86_64/irq.c is:
>
>   	[PATCH] x86-64: survive having no irq mapping for a vector
>
> And we tried that one.

Look in arch/x86_64/io_apic.c. That is where most of the work happened.
If you can extract that patch series for a backport more power to you.

Eric

commit 610142927b5bc149da92b03c7ab08b8b5f205b74
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri Feb 23 04:40:58 2007 -0700

    [PATCH] x86_64 irq: Safely cleanup an irq after moving it.
    
    The problem:  After moving an interrupt when is it safe to teardown
    the data structures for receiving the interrupt at the old location?
    
    With a normal pci device it is possible to issue a read to a device
    to flush all posted writes.  This does not work for the oldest ioapics
    because they are on a 3-wire apic bus which is a completely different
    data path.  For some more modern ioapics when everything is using
    front side bus delivery you can flush interrupts by simply issuing a
    read to the ioapic.  For other modern ioapics emperical testing has
    shown that this does not work.
    
    So it appears the only reliable way to know the last of the irqs from an
    ioapic have been received from before the ioapic was reprogrammed is to
    received the first irq from the ioapic from after it was reprogrammed.
    
    Once we know the last irq message has been received from an ioapic
    into a local apic we then need to know that irq message has been
    processed through the local apics.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

