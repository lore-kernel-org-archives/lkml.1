Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYKXSni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYKXSni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYKXSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:43:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34677 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbYKXSn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:43:27 -0500
Date: Mon, 24 Nov 2008 18:43:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: petkovbb@gmail.com
Cc: sshtylyov@ru.mvista.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081124184321.GA8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081124155632.GE23190@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 03:56:32PM +0000, Mel Gorman wrote:
> Hi,
> 
> I got caught by commit 20df429dd6671804999493baf2952f82582869fa as I didn't
> immediately guess that "ide_generic." was necessary on the kernel command line
> when compiled in instead of as a module. While it didn't catch me for long,
> my concern is that this is going to trip up other people with old machines
> that need that mask.  This change was introduced in 2.6.28-rc1 but I didn't
> catch it till now as I hadn't used the laptop in a while.
> 

It gets even more screwy. Networking was bust on the machine when
the probe_mask workaround was used. After some investigation, I saw
/proc/interrupts looks like

           CPU0                                                                                                                                                  
  0:      55495    XT-PIC-XT        timer                                                                                                                        
  1:          8    XT-PIC-XT        i8042                                                                                                                        
  2:          0    XT-PIC-XT        cascade                                                                                                                      
  3:          1    XT-PIC-XT                                                                                                                                     
  4:       1763    XT-PIC-XT        serial                                                                                                                       
  6:          5    XT-PIC-XT        floppy                                                                                                                       
  8:          0    XT-PIC-XT        ide4                                                                                                                         
  9:        289    XT-PIC-XT        acpi                                                                                                                         
 10:          0    XT-PIC-XT        ide3                                                                                                                         
 11:          0    XT-PIC-XT        ide2                                                                                                                         
 12:          0    XT-PIC-XT        ide5                                                                                                                         
 14:     473802    XT-PIC-XT        ide0                                                                                                                         
 15:        209    XT-PIC-XT        ide1                                                                                                                         
NMI:          0   Non-maskable interrupts                                                                                                                        
LOC:          0   Local timer interrupts                                                                                                                         
RES:          0   Rescheduling interrupts                                                                                                                        
CAL:          0   function call interrupts                                                                                                                       
TLB:          0   TLB shootdowns                                                                                                                                 
SPU:          0   Spurious interrupts                                                                                                                            
ERR:          0                                                                                                                                                  
MIS:          0                                

Note the number of "ide" devices (2, 3 and 5) even though there are only
really two in the machine for the disk and cdrom. The file in 2.6.27 looked like

           CPU0                                                                                                                                                  
  0:       9881    XT-PIC-XT        timer
  1:          8    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  4:        305    XT-PIC-XT        serial
  6:          5    XT-PIC-XT        floppy
  9:        141    XT-PIC-XT        acpi
 11:        136    XT-PIC-XT        uhci_hcd:usb1, eth0
 12:        149    XT-PIC-XT        i8042
 14:      54276    XT-PIC-XT        ide0
 15:        172    XT-PIC-XT        ide1

Note how interrupt 11 is the ethernet on a working kernel and an ide device
with the suggested probe_mask. Using the old probe_mask of 0x3 instead of
0.3f works as expected so very minimally, could you consider the following
patch please?

====
From: Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] ide_generic: Suggest 0x3 as a probe mask instead of 0x3f

On a machine requiring probing of the legacy ports, the suggested
probe_mask of 0x3f results in other devices being registered as IDE
devices. Suggest to the user they use 0x3 which is the old value of
probe_mask prior to commit 20df429dd6671804999493baf2952f82582869fa.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 drivers/ide/ide-generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 81a5282..7d6bd99 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -144,7 +144,7 @@ static int __init ide_generic_init(void)
 	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
 
 	if (!probe_mask) {
-		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" "
+		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3\" "
 		     "module parameter for probing all legacy ISA IDE ports\n");
 
 		if (primary == 0)
