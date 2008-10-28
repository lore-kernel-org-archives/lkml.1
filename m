Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbYJ1GlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbYJ1GlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 02:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYJ1Gkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 02:40:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:12301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbYJ1Gky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 02:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,497,1220252400"; 
   d="scan'208";a="632329116"
Subject: Re: [2.6.28-rc2] EeePC ACPI errors & exceptions
From: Zhao Yakui <yakui.zhao@intel.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	 <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 14:47:29 +0800
Message-Id: <1225176449.5189.133.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:52 -0700, Darren Salt wrote: 
> EeePC 901, BIOS revision 1603, current Debian lenny; running on AC.
> 
> I've noticed the following errors & exceptions, apparently coinciding with
> the startup of xfce4-sensors-plugin:
Will you please confirm whether the same issue exists on the previous
kernel? For example: 2.6.27 or 2.6.27-rc6

After the following commit is merged, it seems that on the EEEPC laptop
the EC will switch off EC GPE interrupt mode when there is no EC GPE
interrupt confirm for some EC transactions. Then AE_TIME is returned by
the function of ec_poll, which causes that the _BST object of battery
can't be evaluated.
   >commit 7c6db4e050601f359081fde418ca6dc4fc2d0011
   >Author: Alexey Starikovskiy <astarikovskiy@suse.de>
   >Date:   Thu Sep 25 21:00:31 2008 +0400
     >ACPI: EC: do transaction from interrupt context

When there is no EC GPE interrupt confirm in some EC transaction, the
EC will switch off the EC GPE interrupt mode in the function of
acpi_ec_wait. 

But why is AE_TIME returned by the function of ec_poll?
>static int ec_poll(struct acpi_ec *ec)
{
        unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
        msleep(1);
// Maybe the current jiffies is already after the predefined jiffies
after msleep(1). In such case the ETIME will be returned. Of course the
EC transaction can't be finished. If so, IMO this is not reasonable as
this is caused by that OS has no opportunity to issue the following EC
command sequence.
        while (time_before(jiffies, delay)) {
                gpe_transaction(ec, acpi_ec_read_status(ec));
                msleep(1);
                if (ec_transaction_done(ec))
                        return 0;
//Maybe there exists the following cases. EC transaction is not finished
after msleep(1),but the current jiffies is already after predefined
jiffies. So ETIME is returned. In such case, IMO this is also not
reasonable.
        }
        return -ETIME;
}
     At the same time msleep is realized by schedule_timeout. On linux
although one process is waked up by some events, it won't be scheduled
immediately. So maybe the current jiffies is already after the
predefined timeout jiffies  after msleep(1).

     Now some people suggest that msleep is replaced by udelay. Although
the above two cases can be avoided by that msleep is replaced by udelay,
maybe the above two cases still exist if the preempt schedule happens at
the corresponding place.
    At the same time when msleep is replaced by udelay, CPU will do
nothing but loop while executing udelay. If the 100 EC transactions are
done in one second, the CPU will do nothing in about 100*2*100
microseconds. IMO this is not reasonable. 

    IMO the better solution is that the EC transaction is divided into
the different phases. (Not do the EC transaction in one loop).
    For example:
    The EC read transaction can be done in the following sequence:
    a. Issue read command 
    b. wait until the EC input buffer is empty and then write the EC
internal read address
    c. wait until the EC output buffer is ready and read the data from
EC the Data port. Of course it indicates that EC read transaction is
finished.
    
    The EC  write transaction can be done in the following sequence:
    a. issue the write command
    b. wait until the EC input buffer is empty and write the EC internal
write address
    c. wait until the EC input buffer is empty and write the data to the
EC Data port
    d. wait until the EC input buffer is empty. After it becomes empty,
it indicates that the EC write transaction is finished.

Welcome the comments.
   Thanks.
    
    
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST2] (Node f7030d38), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70336f8), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7031c48), AE_TIME
> ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080926]
> 
> Also, this (which, unlike the above, is also present with 2.6.27.*):
> 
> ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> ACPI: Device needs an ACPI driver
> 
> Full dmesg & config are attached.
> 
> (The Elantech touchpad patch from http://arjan.opmeer.net/elantech/ is
> applied to this kernel.)
> 

