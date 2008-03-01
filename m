Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbYCALeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbYCALeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYCALdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:33:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58162 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbYCALdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:33:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 12:33:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/4] firewire, ieee1394: bus power lost after resume (PPC
 PMac)
To: benh@kernel.crashing.org
cc: linuxppc-dev@ozlabs.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <47C90E81.7050603@s5r6.in-berlin.de>
Message-ID: <tkrat.bc4ca3408428a60b@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
 <tkrat.7e8e04e66a38dcd6@s5r6.in-berlin.de>
 <1204340392.15052.455.camel@pasglop> <47C90E81.7050603@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Benjamin Herrenschmidt wrote:
> [...]
>>> @@ -2211,6 +2241,16 @@ static int pci_suspend(struct pci_dev *p
>>>  	if (err)
>>>  		fw_error("pci_set_power_state failed with %d\n", err);
>>>  
>>> +/* PowerMac suspend code comes last */
>>> +#ifdef CONFIG_PPC_PMAC
>>> +	if (machine_is(powermac)) {
>>> +		struct device_node *ofn = pci_device_to_OF_node(pdev);
>>> +
>>> +		if (ofn)
>>> +			pmac_call_feature(PMAC_FTR_1394_ENABLE, ofn, 0, 0);
>>> +	}
>>> +#endif /* CONFIG_PPC_PMAC */
>> 
>> I wonder why we don't do the cable power thingy here...
> 
> I don't know.
> 
> I tested with a bus powered device now.  Actually, suspend to RAM 
> switches off cable power nevertheless, but resume does not switch it on 
> anymore...
> 
> Of course the same is true with ohci1394.  Why did nobody ever complain? 
> I suppose the last two users of FireWire + Linux + UniNorth rev01 don't 
> use cable power or don't suspend and resume.

At least this is what the 1st generation PowerBook G4 does.  I don't
know if other PPC_PMAC are affected.

I suggest we explicitly switch cable power on in .resume() but also
explicitly switch cable power off in .suspend(), so that we don't get
any surprises. (Hardware bugs related to these platform features
excepted.)  Patches follow:

 1/4 firewire: fw-ohci: switch on bus power after resume on PPC PMac
 2/4 firewire: fw-ohci: refactor probe, remove, suspend, resume
 3/4 ieee1394: ohci1394: switch on bus power after resume on PPC PMac
 4/4 ieee1394: ohci1394: refactor probe, remove, suspend, resume

 drivers/firewire/fw-ohci.c  |   96 +++++++++++++------------------
 drivers/ieee1394/ohci1394.c |  109 ++++++++++++++++--------------------
 2 files changed, 91 insertions(+), 114 deletions(-)
-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/


