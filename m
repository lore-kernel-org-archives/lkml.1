Return-Path: <linux-kernel-owner+w=401wt.eu-S934713AbZIEAbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbZIEAbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbZIEAbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:31:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611AbZIEAbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:31:38 -0400
Message-ID: <4AA1B16A.4080002@kernel.org>
Date: Sat, 05 Sep 2009 09:31:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Chaitanya Lala <clala@riverbed.com>
CC: rbecker@riverbed.com, linux-kernel@vger.kernel.org
Subject: Re: Disk failure behavior
References: <20090904172316.GA6076@clala-laptop>
In-Reply-To: <20090904172316.GA6076@clala-laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 05 Sep 2009 00:31:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Chaitanya Lala wrote:
> I am using a back-port of libata from ~ 2.6.20 on a 2.6.9
> Red Hat kernel. I have SATA disks (using AHCI) in the 
> system which are hot-pluggable. The problem I am facing
> is that, certain disk failures bring the system into a
> weird state. The system tries to reset the disk but fails.
> Finally it prints a message "reset failed, giving up."
> 
> At this point the port is left in a frozen state and
> the interrupts from the port are masked. If now, this disk is
> pulled out and a healthy disk is inserted, the new disk's
> insertion does not raise any event/notification/interrupt.
> In fact, the only way at this point to get the disk to work is
> to reboot.

# echo - - - /sys/class/scsi_host/hostX/scan

should revive it too.

> Below is a snippet of the code, I am referring to, from v2.6.20.
> File - drivers/ata/libata-eh.c & function-name -  ata_eh_recover
>  
> 	/* reset */
> 	if (ehc->i.action & ATA_EH_RESET_MASK) {
> 		ata_eh_freeze_port(ap);
> 
> 		rc = ata_eh_reset(ap, ata_port_nr_vacant(ap), prereset,
> 				  softreset, hardreset, postreset);
> 		if (rc) {
> 			ata_port_printk(ap, KERN_ERR,
> 					"reset failed, giving up\n");
> 			goto out; 
> 		}    
> 
> 		ata_eh_thaw_port(ap);
> 	} 
> 
> A possible work-around is to thaw the port before going to "out".
> That would enable the interrupts again before going to "out".
> I understand that would enable future interrupts from the old disk as well,
> but I am willing to live with that, if it helps to detect the new device.
> 
> 	/* reset */
> 	if (ehc->i.action & ATA_EH_RESET_MASK) {
> 		ata_eh_freeze_port(ap);
> 
> 		rc = ata_eh_reset(ap, ata_port_nr_vacant(ap), prereset,
> 				  softreset, hardreset, postreset);
> 		if (rc) {
> 			ata_port_printk(ap, KERN_ERR,
> 					"reset failed, giving up\n");
> +			ata_eh_thaw_port(ap);
> 			goto out; 
> 		}    
> 
> 		ata_eh_thaw_port(ap);
> 	} 
> 
> I have tested this successfully. But I would like to ask you if this would
> possibly "break" some other functionality ? I am new to the kernel ata stuff
> and want to be sure before I use this.

Unless your controller causes IRQ storm bringing down the controller,
the above change shouldn't be dangerous.

-- 
tejun
