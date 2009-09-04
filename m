Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbZIDRdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbZIDRdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbZIDRc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:32:59 -0400
Received: from eng.riverbed.com ([208.70.196.45]:16395 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbZIDRc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:32:56 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 13:32:56 EDT
Date: Fri, 4 Sep 2009 10:23:16 -0700
From: Chaitanya Lala <clala@riverbed.com>
To: tj@kernel.org
Cc: clala@riverbed.com, rbecker@riverbed.com, linux-kernel@vger.kernel.org
Subject: Disk failure behavior
Message-ID: <20090904172316.GA6076@clala-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using a back-port of libata from ~ 2.6.20 on a 2.6.9
Red Hat kernel. I have SATA disks (using AHCI) in the 
system which are hot-pluggable. The problem I am facing
is that, certain disk failures bring the system into a
weird state. The system tries to reset the disk but fails.
Finally it prints a message "reset failed, giving up."

At this point the port is left in a frozen state and
the interrupts from the port are masked. If now, this disk is
pulled out and a healthy disk is inserted, the new disk's
insertion does not raise any event/notification/interrupt.
In fact, the only way at this point to get the disk to work is
to reboot.

Below is a snippet of the code, I am referring to, from v2.6.20.
File - drivers/ata/libata-eh.c & function-name -  ata_eh_recover
 
	/* reset */
	if (ehc->i.action & ATA_EH_RESET_MASK) {
		ata_eh_freeze_port(ap);

		rc = ata_eh_reset(ap, ata_port_nr_vacant(ap), prereset,
				  softreset, hardreset, postreset);
		if (rc) {
			ata_port_printk(ap, KERN_ERR,
					"reset failed, giving up\n");
			goto out; 
		}    

		ata_eh_thaw_port(ap);
	} 

A possible work-around is to thaw the port before going to "out".
That would enable the interrupts again before going to "out".
I understand that would enable future interrupts from the old disk as well,
but I am willing to live with that, if it helps to detect the new device.

	/* reset */
	if (ehc->i.action & ATA_EH_RESET_MASK) {
		ata_eh_freeze_port(ap);

		rc = ata_eh_reset(ap, ata_port_nr_vacant(ap), prereset,
				  softreset, hardreset, postreset);
		if (rc) {
			ata_port_printk(ap, KERN_ERR,
					"reset failed, giving up\n");
+			ata_eh_thaw_port(ap);
			goto out; 
		}    

		ata_eh_thaw_port(ap);
	} 

I have tested this successfully. But I would like to ask you if this would
possibly "break" some other functionality ? I am new to the kernel ata stuff
and want to be sure before I use this.

Thanks,
Chaitanya

