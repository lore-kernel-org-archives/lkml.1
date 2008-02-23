Return-Path: <linux-kernel-owner+w=401wt.eu-S1763150AbYBWMNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763150AbYBWMNe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 07:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbYBWMNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 07:13:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55956 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYBWMNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 07:13:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C00DB0.20605@s5r6.in-berlin.de>
Date: Sat, 23 Feb 2008 13:12:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Kristian Hoegsberg <krh@bitplanet.net>,
       Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 1/2] firewire: endianess fix
References: <20080220220326.GA22328@uranus.ravnborg.org> <1203545913.25307.47.camel@brick> <tkrat.e2bfb30f2c0ae70a@s5r6.in-berlin.de> <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
In-Reply-To: <tkrat.9e19fa31951506af@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> This needs to be tested on different big endian PCs, if possible with
> the Apple Uninorth FireWire controller and other types of controllers.
> One test which involves ohci->request_generation is simply with an SBP-2
> device (harddisk, CD-ROM...).  Does SBP-2 login etc. work?

Hmm, no, tests with SBP-2 devices won't trigger that problem at all.
All of the requests from the device will be:
   - read requests to the host's config ROM, handled by the controller's
     physical response unit instead of the driver stack's response
     handlers,
   - read requests to ORBs and read and write requests to SCSI data
     buffers which are DMA-mapped at bus addresses below 4G, hence be
     handled by the physical response unit as well,
   - write requests to firewire-sbp2's status FIFO which is mapped into
     a FireWire address range for which PCI write posting is enabled,
     hence no response subaction will be generated (unified transaction)
     and therefore ohci->request_generation remain unused.

Alas I have no idea how to create a simple test setup which really 
triggers the questionable code.  Or wait, it should be triggered by 
replacing
	&fw_high_memory_region
by
	&fw_private_region
in drivers/firewire/fw-sbp2.c and testing with any SBP-2 device which is 
_not_ based on the PL3507 bridge chip.  This moves the status FIFO into 
an area outside of PCI write posting and forces the driver stack to 
generate response packets.  (Some PL-3507 only accept unified 
transactions, hence this test needs to be performed with other bridge 
chips.)
-- 
Stefan Richter
-=====-==--- --=- =-===
http://arcgraph.de/sr/
