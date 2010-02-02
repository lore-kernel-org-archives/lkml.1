Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0BBEyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:54:09 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37055 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0BBEyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:54:05 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
	<4B679042.2010008@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Feb 2010 20:53:55 -0800
In-Reply-To: <4B679042.2010008@kernel.org> (Tejun Heo's message of "Tue\, 02 Feb 2010 11\:38\:58 +0900")
Message-ID: <m1r5p4grvg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Torsten.
>
> On 01/31/2010 10:02 PM, Torsten Kaiser wrote:
>> I'm still trying to get the MSI support for sata_sil24, that was added
>> in 2.6.33-rc1, to work. But even with -rc6 it still shows the same
>> errors.
>> 
>> The current best guess is, that there is something fishy going on in
>> the IRQ system, as the only error messages before the libata timeouts
>> start are:
>> 
>> [   86.463814] do_IRQ: 0.165 No irq handler for vector (irq -1)
>> [   86.463832] do_IRQ: 3.165 No irq handler for vector (irq -1)
>> [   86.463848] do_IRQ: 1.165 No irq handler for vector (irq -1)
>> [   86.463867] do_IRQ: 2.165 No irq handler for vector (irq -1)
>> 
>> (Thats why I added CCs for get_maintainer.pl -f arch/x86/kernel/apic/io_apic.c)

Fascinating I think get_maintainer.pl missed the maintainers.

>> To get these errors I only boot with sata_sil24.msi=1 and then do: dd
>> if=1GB-file-on-ro-mounted-xfs-fs of=/dev/null bs=1k
>> 
>> Writing with enabled MSI also fails with timeouts, but in this case
>> there is no error from do_IRQ.
>
> It might be that the silicon implements MSI incorrectly and ends up
> sending out invalid MSI packets under certain circumstances.  The
> silicon hasn't changed for quite some time now and back when it came
> out MSI wasn't too popular and I don't think SIMG's proprietary
> drivers use it, so it's quite possible that the feature simply is
> broken.  Is there any specific reason why you want to enable MSI
> support?  It's not like MSI brings any actual benefit when the
> compatibility hardware is already there.

It also seems possible that some of the recent irq handling changes
missed something.

Usually the message "No irq handler for vector (irq -1)" means that the irq
was delivered to a cpu that was not ready for it.  I see that vector 165
is being delivered on all of the different cpus with vector 165,
and that you are getting interrupts delivered most of the time.

This smells like the initialization problems I was seeing in another
thread.  Suresh?

Eric
