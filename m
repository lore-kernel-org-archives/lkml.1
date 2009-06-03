Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZFCGix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZFCGix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFCGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:38:46 -0400
Received: from claw.goop.org ([74.207.240.146]:45293 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZFCGiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:38:46 -0400
Message-ID: <4A261A72.5040700@goop.org>
Date: Wed, 03 Jun 2009 16:38:42 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 01/17] xen/dom0: handle acpi lapic parsing in Xen dom0
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-2-git-send-email-jeremy@goop.org> <alpine.LFD.2.00.0906021826430.3419@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906021826430.3419@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 27 May 2009, Jeremy Fitzhardinge wrote:
>
>   
>> When running in Xen dom0, we still want to parse the ACPI tables to
>> find out about local and IO apics, but we don't want to actually use
>> the lapics.
>>     
>
> Hmm, we parse the tables and discard the information. What's the point
> of this exercise ? Some nice dmesg lines ?
>   

No, it was to make some highly convoluted logic work.  I'm planning on 
revisting all this to make it so that clearing the APIC cpuid feature 
flag works (ie, the local apics are skipped, but IO-APIC discovery still 
works).

I don't remember the specific problems I encountered, but it was 
something to do with the fact that CPU discovery is tied up with local 
APIC discovery and some entanglement with how ACPI table parsing works, 
all coupled through some global variables with unclear semantics.

> I hate these "if (xen_...)" extra cases even more than the paravirt
> misery. They stick Xen dependencies into random places and enforce the
> people who want to modify that code to find out why the heck this
> needs to be there.
>   

I agree.  The if (xen) stuff was there to avoid sugar-coating the 
situation.  I could have prettily hidden things in abstraction layers, 
but if there were no current or even likely non-Xen users, I thought it 
was more honest and direct to just make the situation obvious to the reader.

> That's the fundamental design problem with the Dom0 model that you
> want just certain parts of Linux and those parts which are in your way
> are just hacked out. But this is designed to be a nightmare for
> maintainence and development. Are you going to stick more and more of
> those "if (xen..)" constructs into places which provide functionality
> which is only partially useful to Xen ?
>   

No.

My current plan for this apic stuff is to 1) clean up the local apic 
discovery so we can just clear the APIC cpuid flag and have the right 
thing happen (since that's the truth of the situation: there are no 
local apics available to the kernel), and 2) implement the ioapic driver 
layer so that we can just plug our Xen stuff into that.  That should 
avoid all the explicit if (xen) bits in this part of the code.

    J
