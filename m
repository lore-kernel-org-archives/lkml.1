Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYCaM7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYCaM7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 08:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYCaM7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 08:59:25 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34471 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYCaM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 08:59:24 -0400
Message-ID: <47F0E00E.30200@s5r6.in-berlin.de>
Date: Mon, 31 Mar 2008 14:58:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Michlmayr <tbm@cyrius.com>, Jarod Wilson <jwilson@redhat.com>,
       linux1394-devel@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
References: <20080321153952.GA26354@deprecation.cyrius.com> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <200803302106.42624.jwilson@redhat.com> <alpine.LFD.1.10.0803311217550.3219@apollo.tec.linutronix.de> <20080331102852.GJ28821@deprecation.cyrius.com>
In-Reply-To: <20080331102852.GJ28821@deprecation.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Thomas Gleixner <tglx@linutronix.de> [2008-03-31 12:19]:
>> > >      Board: PM965/GM965/GL960 based
>> > >      The R5C832 is known to work with ohci1394 according to
>> > >      http://hardware4linux.info/component/14348/ and other reports.
>> > 
>> > Its also known to work with the juju firewire stack -- that's the controller 
>> > in my own laptop, as well as a few other folks here in the office, all 
>> > running the new stack.
>> 
>> Hmm, can you please check whether you can reproduce the problem with
>> the original stack ?
> 
> I get virtually the same message with the old and new stack.

I can confirm that what Martin previously posted in this thread shows
that firewire-ohci + firewire-core and ohci1394 + ieee1394 fail in the
same way:
  - All MMIO reads and writes leading up to chip initialization works,
  - first "self ID complete" interrupt and corresponding MMIO reads and
    DMAs work and lead up to recognition of the local node by the
    firewire/1394 mid layer,
  - a while later the IRQ is disabled with "nobody cared".
IRQ handlers are drivers/firewire/fw-ohci.c::irq_handler() and
drivers/ieee1394/ohci1394.c::ohci_irq_handler().  Both return IRQ_NONE
if readl() on the register which contains the interrupt event type
returns 0 or ~0, which both are impossible values _if_ the chip
generated the interrupt _and_ MMIO reads work.
-- 
Stefan Richter
-=====-==--- --== =====
http://arcgraph.de/sr/
