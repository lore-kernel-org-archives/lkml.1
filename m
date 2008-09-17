Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYIQTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYIQTXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIQTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:23:21 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1984 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYIQTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:23:20 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: 2.6.27-rc5-mm1
From: "Benjamin Li" <benli@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080916190144.46f534b4@bree.surriel.com>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
 <20080915180130.10995b90@cuia.bos.redhat.com>
 <1221519658.11021.13.camel@HP1>
 <20080916140917.105adc2a@bree.surriel.com>
 <20080916190144.46f534b4@bree.surriel.com>
Date: Wed, 17 Sep 2008 12:23:11 -0700
Message-ID: <1221679391.4028.22.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1
X-WSS-ID: 64CF86AA4E0151085277-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the repost... attaching the patch to the proper thread.

Hi Rik van Riel,

Please try the enclosed patch to see if it will solve your problem.

I have tested on my Dell 2900, and the 5708 LOM is operational again on
my test machine.

Thanks again.

-Ben

>From c455b36005a9b1b6a2b0036b7947d3f4bebb9f2d Mon Sep 17 00:00:00 2001
From: Benjamin Li <benli@broadcom.com>
Date: Tue, 16 Sep 2008 17:20:11 -0700
Subject: [PATCH] bnx2: Promote vector field in bnx2_irq structure from u16 to unsigned int

The bnx2 driver stores/uses the irq value from the pci_dev internally.
But when it stores the irq value, it has been performing an
integer demotion.  Because of the recent changes made to
arch/x86/kernel/io_apic.c, the new method in creating the irq value
(using build_irq_for_pci_dev()) has exposed this bug on x86 systems.

Because of this demotion when calling request_irq() from
bnx2_request_irq(), the driver would get a return code of -EINVAL.
This is because the kernel could not find the requested irq descriptor.
By storing the irq value properly, the kernel can find the correct
irq descriptor and the bnx2 driver can operate normally.

Signed-off-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>

---
 drivers/net/bnx2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index c3c579f..dfacd31 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -6597,7 +6597,7 @@ struct flash_spec {
 
 struct bnx2_irq {
 	irq_handler_t	handler;
-	u16		vector;
+	unsigned int	vector;
 	u8		requested;
 	char		name[16];
 };
-- 
1.5.5.1



On Tue, 2008-09-16 at 16:01 -0700, Rik van Riel wrote:
> On Tue, 16 Sep 2008 14:09:17 -0400
> Rik van Riel <riel@redhat.com> wrote:
> > On Mon, 15 Sep 2008 16:00:58 -0700
> > "Michael Chan" <mchan@broadcom.com> wrote:
> >
> > > > 05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > > > 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > >
> > > Does dmesg show anything when you run ifup?
> >
> > The linux-next tree fails in the same way.  Here is the dmesg output
> > from the broadcom driver:
> 
> OK, with pci=nomsi the system boots up fine and the bnx2 driver
> works.
> 
> Looks like the MSI code in linux-next is broken on the Dell PE 1950.
> 
> --
> All rights reversed.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


