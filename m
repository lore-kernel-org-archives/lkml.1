Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZKFAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZKFAC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZKFAC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:02:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:62183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbZKFAC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:02:56 -0500
X-ExtLoop1: 1
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
In-Reply-To: <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
	 <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
	 <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
	 <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
	 <1257375875.4716.24.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.0911051415340.9725@eddie.linux-mips.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 05 Nov 2009 16:01:32 -0800
Message-Id: <1257465692.4394.295.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 06:46 -0800, Maciej W. Rozycki wrote:
>  For the record: the original ICH/ICH0 (82801AA/AB) seems to have the 
> version set to 0x11 as well.  Now its datasheet mentions the EOI register, 
> but even if it is not a mistake, 

hmm. what a mess.

I found a kernel log in an archive
(http://www.mail-archive.com/linux-usb-users@lists.sourceforge.net/msg13255.html) for ICH0 which shows that it uses an io-apic of version 0x20. So mostly the version in the datasheet is wrong here aswell :-(

And our IO/chipset architect (Rajesh) also confirmed that ICH0 indeed
has an EOI reg.

So, version 0x20 seems to be pretty safe to use EOI register. And
according to Gary Hade's experiments on IBM platforms having  an io-apic
version 0x11, magic of mask+edge and unmask+level seems to clear
remoteIRR.

So the current logic looks safe to me.

>  Also for the record: the 82489DX is a combined local and I/O APIC chip -- 

Thanks. This is what I learnt internally too yesterday and hence the
documentation update ;)

>  I've checked some docs too and you may want to check whether to qualify 
> the use of the EOI register further with the DT (Delivery Type) bit in the 
> Boot Configuration register.  It affects ICH2 at least

For relatively newer ICH's like ICH5, boot configuration register is
marked as a reserved register (perhaps with the serial bus going away,
so did this register but again with out the io-apic version change).

Anyways, our understanding is that EOI register in ICH2 should work
irrespective of DT bit in the boot config register.

>  Also you may want to see whether the complication in ack_apic_level() 
> that is meant to deal with an APIC erratum really matters for FSB delivery 
> -- I guess not, because if you explicitly ACK an interrupt in the I/O 
> unit, then even if it was incorrectly recorded as edge-triggered in the 
> local unit, the IRR bit will be correctly reset and the next message 
> delivered properly.  Given you introduce a conditional statement anyway, 
> you can place more code within it and there will be no performance hit for 
> the other path and certainly a gain for this one.

I am not sure if I follow. With the recent changes (tip commit
5231a68614b94f60e8f6c56bc6e3d75955b9e75e), we use ipi on a new cpu to
handle a pending level-triggered  interrupt on the cpu that is going
offline. It's just not only in the case of io-apic erratum for 0x11, we
see level triggered interrupt as edge interrupt at the cpu.


>  Additionally it seems to me that code to migrate an IRQ is placed 
> incorrectly -- the erratum workaround should be placed above it as it 
> complements ack_APIC_irq() -- the IRR bit will not have been reset before 
> the workaround has been executed if the erratum was hit.  Will you care 
> about this problem?

Yes. I see this issue and agree with your assesment. The result is that
we missed an irq migration attempt and delay it to the next arrival.

I will post a different fix and also update some of the code comments
around this to reflect new changes in the code.

> > Maciej, can I have your ack for the appended patch?
> 
>  Certainly, it looks good to me.
> 
> Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

Thanks. Ingo, Can you please queue this patch too? I am planning to do
couple of more cleanups on top of this. I will post them shortly.

thanks,
suresh

