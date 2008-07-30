Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYG3AvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYG3AvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYG3Au7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:50:59 -0400
Received: from gw.goop.org ([64.81.55.164]:49084 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbYG3Au7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:50:59 -0400
Message-ID: <488FBAEC.5000306@goop.org>
Date: Tue, 29 Jul 2008 17:50:52 -0700
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
References: <20080729160939.GA4484@linux.vnet.ibm.com>	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>	<m1bq0g8euy.fsf@frodo.ebiederm.org> <488FAAD9.4090907@goop.org> <m1vdyo44v4.fsf@frodo.ebiederm.org>
In-Reply-To: <m1vdyo44v4.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I'm still interested in making Xen's event channel-based interrupts fit better
>> into the rest of the interrupt handling scheme.  In particular, event channels
>> map very closely to the x86-64 notion of a vector.  There's 1024 of them per
>> domain, and each is bound to a cpu.  At the moment, I map them to irqs, which
>> means that I need to allocate around 5-6 irqs per cpu, which makes everything
>> very cluttered.  I'd like to map event channels to vectors, and then map vectors
>> to (irq,cpu) tuples.
>>     
>
> Uh....  I'm not certain this applies.
>   

No, but, hey, it's a hook.

>> From what I've seen this is exactly how x86-64 currently has things set up, and
>> I'm interested in making sure that 32-bit does the same thing.
>>     
>
> Yes. x86_32 needs work to get cleaned up.
>
> The architecture on x86_64 is as follows.
>
> We have interrupt sources:  GSIs in the case of acpi.
> We have linux interupts:  something with an irq number.
>
> Vectors are an internal implementation detail.
>
> I don't know if your event channels more closely resemble interrupt sources or internal
> implementation details.  If they are an implementation detail that interrupt sources
> just flow through we should hide them like we do vectors.  If event channels actually are
> the sources of interrupts we should do something different.
>   

They're an interrupt source, I guess.  They need to be behind some layer 
of indirection because they can be reassigned at arbitrary times (like 
suspend/resume, or if the backend driver just decided to disconnect 
itself), and so they need to get rebound to at least the same irq.

>> I'm also interested in having vectors being sourced from multiple interrupt
>> controllers.  So, some vectors would be sourced from APICs, and other are
>> sourced from event channels.  This would be useful for Xen domains which have
>> direct access to hardware (ie, the dom0 control domain in the short term, and
>> disaggregated driver domains later on), and fully emulated domains which have
>> paravirtual drivers.
>>     
>
> Generally easy except for the disparate methods of catching interrupts.
>   

Catching in what sense?  I assume the interrupt gets raised in some 
source-specific way, and then passed into a generic layer where it 
eventually gets matched with an appropriate handler.  I'm sure there's 
some subtlety I'm missing.

>> I haven't studied the current code to see if this notion already exists or not.
>>
>> While the APIC interrupt model is the most architecturally important for the x86
>> platform, I'd like to make sure we don't build in the assumption that it's the
>> *only* interrupt model.
>>     
>
> Well with iommus starting to show up in our irq paths it looks we are going to get
> a lot of diversity.
>
> Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

