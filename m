Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbZDHE1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbZDHE1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 00:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZDHE1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 00:27:37 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53259 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751496AbZDHE1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 00:27:36 -0400
Date: Tue, 7 Apr 2009 23:27:35 -0500
From: Robin Holt <holt@sgi.com>
To: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
Message-ID: <20090408042734.GD10768@sgi.com>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On and ia64 system with a QLA12160 adapter, my boot fails with:

qla1280: QLA12160 found on PCI bus 0, dev 3
qla1280 0001:00:03.0: PCI INT A -> GSI 61 (level, low) -> IRQ 61
scsi(0): Enabling SN2 PCI DMA dual channel lockup workaround
qla1280 0001:00:03.0: firmware: using built-in firmware qlogic/12160.bin
qla1280_mailbox_command: Command failed, mailbox0 = 0x0007, mailbox_out0 = 0x4003, istatus = 0x6000
m0 4003, m1 b141, m2 5555, m3 aa55
m4 55aa, m5 a5a5, m6 5a5a, m7 2525
scsi(0): RISC checksum failed.
scsi(0): initialize: pci probe failed!
qla1x160: Failed to initialize adapter
qla1280 0001:00:03.0: PCI INT A disabled


I did a git-bisect and narrowed it down to:

commit 1bfa11db712cbf4af1ae037cd25fd4f781f0c215
Author: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date:   Thu Apr 2 11:13:17 2009 +0530

    [SCSI] qla1280: use request_firmware

    Firmware blob is little endian looks like this...
            unsigned char  Version1
            unsigned char  Version2
            unsigned char  Version3
            unsigned char  Padding
            unsigned short start_address
    	unsigned short data

    Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>


When I revert that commit from the 2.6.30-rc1 revision, I get a bootable
system.

Thanks,
Robin
