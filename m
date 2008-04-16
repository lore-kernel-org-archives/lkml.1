Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYDPKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYDPKWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756809AbYDPKWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:22:34 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:47584 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805AbYDPKWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:22:33 -0400
Message-ID: <4805D338.2000704@s5r6.in-berlin.de>
Date: Wed, 16 Apr 2008 12:21:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: fw-ohci: work around generation bug
 in TI controllers (fix AV/C and more)
References: <tkrat.95472d87fa4e6c81@s5r6.in-berlin.de>	<tkrat.3e4f8089bffc4e81@s5r6.in-berlin.de> <200804141330.22131.jwilson@redhat.com>
In-Reply-To: <200804141330.22131.jwilson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Saturday 12 April 2008 04:31:25 pm Stefan Richter wrote:
>> https://bugzilla.redhat.com/show_bug.cgi?id=243081
...
>> @@ -2360,6 +2369,8 @@ pci_probe(struct pci_dev *dev, const str
>>  	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
>>  			     dev->device == PCI_DEVICE_ID_APPLE_UNI_N_FW;
>>  #endif
>> +	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
>> +
> 
> I have a few cards with PCI_VENDOR_ID_CREATIVE with a TI TSB41AB2 chip on 'em 
> (SoundBlaster Audigy w/FireWire port). I've not had any issues on any of the 
> cards I've got, but do we want to add them to the work-around list just to be 
> safe?

Right now TSB82AA2 is confirmed buggy by two slightly differing reports
(Mladen's and mine) and TSB43AB22 or TSB43AB22A is under suspicion.

Whether TSB41AB2 is affected or not is impossible to say without having
a hardware combination which triggers the bug.  So far it seems the bug
occurs if there are more bus reset events than self ID complete events.
Note, I noticed the bug on my TSB82AA2 only by means of the bus reset
packet generation logging, not because of any subsequent malfunction
(because a bus reset forced by the bus manager code is always saving the
day on my setup).

If you could reproduce these conditions somehow and then check the debug
log for temporary generation mismatches, that would be good.  Note that
the conditions for the bug to occur are almost exclusively influenced by
the PHY layer hardware of all nodes on the bus, while the bug itself is
caused by the link layer controller.

Anyway, if we get confirmation that the proposed patch fixes
TSB43AB22(A) and you don't have the means to prove that TSB41AB2 is not
buggy, then let's add the vendor ID of Creative as well.  As mentioned,
the patch introduces a certain danger of
 1. fw-core missing to send responses to requests which came in
    immediately after bus reset (unlikely border case),
 2. fw-core responding to requests which came in before the last
    bus reset (even less likely border case, because that would only
    happen if the self ID complete event was processed before an older
    AR event, which does not happen according to my observations with
    a bunch of different chips).

1. is to be compensated by the requester by retry.  We have seen that
some simplistic requesters have difficulties with that.  But luckily,
these requesters are AV/C targets and send requests as AV/C transaction
responses.  I think the chances for this to happen are rather low.

2. is to be compensated by the requester by proper matching of
transaction labels and discarding transaction labels at bus reset events.

AFAIU, the ieee1394 stack has always been in danger to trip these border
cases because ohci1394 never looks at the bus reset packet generation.
So this speaks _for_ enabling the bus_reset_packet_quirk if a card is
merely under suspicion of having the bug and we are unable to find
someone who can disprove the suspicion for us.
-- 
Stefan Richter
-=====-==--- -=-- -==-=
http://arcgraph.de/sr/
