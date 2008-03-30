Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbYC3RlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbYC3RlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYC3RlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 13:41:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35444 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYC3RlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 13:41:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EFD09D.3020906@s5r6.in-berlin.de>
Date: Sun, 30 Mar 2008 19:40:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com>
In-Reply-To: <20080330161339.GC28821@deprecation.cyrius.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> [2008-03-30 13:11]:
>> Martin, please check whether the same happens if you disable firewire-ohci 
>> in the kernel config (or blacklist it in the modprobe config) and use the 
>> ohci1394 driver instead.
> 
> Yes, I get essentially the same message with the ohci1394 driver:
> 
> [  895.455783] irq 19: nobody cared (try booting with the "irqpoll" option)
> [  895.455783] Pid: 0, comm: swapper Not tainted 2.6.25-rc7-amd64 #1
> [  895.455783]
> [  895.455783] Call Trace:
> [  895.455783]  <IRQ>  [<ffffffff88078155>] :ohci1394:ohci_irq_handler+0x4b/0x76e
> [  895.455783]  [<ffffffff8026c883>] __report_bad_irq+0x30/0x72
> [  895.455783]  [<ffffffff8026cac2>] note_interrupt+0x1fd/0x23f
> [  895.455783]  [<ffffffff8026d34f>] handle_fasteoi_irq+0xa5/0xc8
> [  895.455783]  [<ffffffff8020f53c>] do_IRQ+0x6d/0xd9
> [  895.455783]  [<ffffffff8020c46d>] ret_from_intr+0x0/0x19
> [  895.455783]  <EOI>  [<ffffffff803a25a4>] menu_reflect+0x0/0x75
> [  895.455783]  [<ffffffff8800642b>] :processor:acpi_idle_enter_simple+0x18d/0x1fe
> [  895.455783]  [<ffffffff803a1b2b>] cpuidle_idle_call+0x7a/0xb3
> [  895.455783]  [<ffffffff803a1ab1>] cpuidle_idle_call+0x0/0xb3
> [  895.455783]  [<ffffffff8020b06c>] cpu_idle+0xa9/0xd3
> [  895.455783]
> [  895.455783] handlers:
> [  895.455783] [<ffffffff8807810a>] (ohci_irq_handler+0x0/0x76e [ohci1394])
> [  895.455783] Disabling IRQ #19
> 
> dmesg is attached.
> 

Thanks.

I tend to believe it is a problem to be addressed in the x86 platform 
support, not a driver problem.

I Cc'd some random x86 folk...  To rehash the issue:

   - Controller: Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
     Board: PM965/GM965/GL960 based
     The R5C832 is known to work with ohci1394 according to
     http://hardware4linux.info/component/14348/ and other reports.

   - Martin also saw it happen with Linux 2.6.22.

   - firewire-ohci + firewire-core as well as ohci1394 + ieee1394
     appear to initialize the controller on Martin's laptop just fine.
     Among else this means that a number of register reads and writes
     succeed.

   - Some time later, without having actually used the FireWire
     controller, "irq 19: nobody cared"/ "Disabling IRQ #19" occurs.
     AFAIU the code, this is apparently because firewire-ohci's or
     ohci1394's IRQ handler was called repeatedly but got either 0 or ~0
     when reading the chip's interrupt event register.
-- 
Stefan Richter
-=====-==--- --== ====-
http://arcgraph.de/sr/
