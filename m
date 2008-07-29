Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYG2Xmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYG2Xmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYG2XmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:42:24 -0400
Received: from gw.goop.org ([64.81.55.164]:42589 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYG2XmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:42:24 -0400
Message-ID: <488FAAD9.4090907@goop.org>
Date: Tue, 29 Jul 2008 16:42:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
References: <20080729160939.GA4484@linux.vnet.ibm.com>	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com> <m1bq0g8euy.fsf@frodo.ebiederm.org>
In-Reply-To: <m1bq0g8euy.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
>
>   
>> I didn't follow this from the start but one reason why NR_IRQS based on
>> NR_CPUS is a bad idea, is the huge (nearly 300Mb) increase in memory usage
>> (that's mostly wasted.)  I believe there's another patch coming real soon
>> now to make irq allocations dynamic.  (I had also hoped to look closer at
>> your irq abstraction patch you sent a while back.  Does that also address
>> this issue?)
>>     
>
> The patch I sent out earlier is one of the key patches needed for killing
> NR_IRQS usage in generic code.  Which is part of what we need to make this
> dynamic.
>
> In systems where the I/O is well balanced with the compute the typical
> usage is usually within 16 irqs per core, and at worst 32.  That is an old
> rule of thumb observation and that makes for reasonable allocations.
>
> I don't have a problem at all with your code that updated the heuristic to
> be based on the NR_IOAPICS.
>
> My problem is with Thomas's patch that totally threw out all of our tuned
> heuristics and made NR_IRQS=256.  Which is ludicrous.  Even on 32bit systems
> there are cases where 1024 irq sources needed to be supported.
>
> Which is what NR_IRQ_VECTORS is.  I goofed slightly in my comments.
> irq_vector only needs to be NR_IRQS in size.  I think ACPI still needs
> NR_IRQ_VECTORS to know how many GSI the kernel can support.  The fact they
> are not mapped 1-1 right now in the 32bit kernel is unfortunate.
>   

I'm still interested in making Xen's event channel-based interrupts fit 
better into the rest of the interrupt handling scheme.  In particular, 
event channels map very closely to the x86-64 notion of a vector.  
There's 1024 of them per domain, and each is bound to a cpu.  At the 
moment, I map them to irqs, which means that I need to allocate around 
5-6 irqs per cpu, which makes everything very cluttered.  I'd like to 
map event channels to vectors, and then map vectors to (irq,cpu) tuples.

 From what I've seen this is exactly how x86-64 currently has things set 
up, and I'm interested in making sure that 32-bit does the same thing. 

I'm also interested in having vectors being sourced from multiple 
interrupt controllers.  So, some vectors would be sourced from APICs, 
and other are sourced from event channels.  This would be useful for Xen 
domains which have direct access to hardware (ie, the dom0 control 
domain in the short term, and disaggregated driver domains later on), 
and fully emulated domains which have paravirtual drivers.

I haven't studied the current code to see if this notion already exists 
or not.

While the APIC interrupt model is the most architecturally important for 
the x86 platform, I'd like to make sure we don't build in the assumption 
that it's the *only* interrupt model.

    J
