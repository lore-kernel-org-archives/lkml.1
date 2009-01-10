Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZAJJt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZAJJt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZAJJtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:49:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54133 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZAJJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:49:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49686F0C.7030807@s5r6.in-berlin.de>
Date: Sat, 10 Jan 2009 10:49:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Enrik Berkhan <Enrik.Berkhan@ge.com>
CC: David Vrabel <david.vrabel@csr.com>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: Reference counting of MMC host driver modules
References: <49678443.8040909@ge.com> <49679570.3070403@csr.com> <20090109200024.GA14754@ngeserver2.localdomain>
In-Reply-To: <20090109200024.GA14754@ngeserver2.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enrik Berkhan wrote:
> On Fri, Jan 09, 2009 at 06:20:32PM +0000, David Vrabel wrote:
>> Enrik Berkhan wrote:
>>> I've noticed recently that the MMC/SD block driver does not reference 
>>> count the MMC/SD host driver module that it uses via the MMC/SD core 
>>> layer. Thus, I can rmmod my host driver module while, for example, a 
>>> partition on a SD card is mounted.
>> This is same as removing the card while it's in use.
> 
> I don't think so.
> 
> Being able to remove the card while it is in use is a bug of the
> mechanical interface. Can't be fixed easily.
> 
> Being able to remove the module while it is in use is a bug of the
> software. Can be fixed.

Here is my implementation experience with the issue, concerning the two
FireWire driver stacks which I maintain:

In case of firewire (new FireWire stack), module removal of the
controller driver will trigger removal of all child and grandchild
devices, e.g. sd_shutdown of FireWire HDDs.

This will have the same effect as if the cable of the HDD was pulled.
I don't see a need to prevent this because whoever runs
# modprobe -r firewire-ohci
is supposed to know what he is doing.

But in case of ieee1394 (old FireWire stack), the sbp2 storage driver
calls try_module_get() on the host driver whenever it starts using a
device, and of course module_put() when it is done.  I.e. modprobe -r
ohci1394 is blocked as long as the sbp2 driver is in touch with a
FireWire drive.

I added this at some point because of unclean layering of the ieee1394
stack:  The high-level drivers video1394 and dv1394 do not only depend
on the ieee1394 core driver, but also directly on the ohci1394 low-level
driver.  Now, if somebody runs
# modprobe -r video1394
it would also remove ohci1394 if sbp2 hadn't artificially increased
ohci1394's reference count.

*However*, note that try_module_get() and module_put() don't actually do
what you asked for:  They do _not_ guarantee that the host driver gets
unbound from the MMC (or FireWire...) controller:
You can still do
# echo -n ${ID} > /sys/module/${MODULE}/drivers/${DRIVER}/unbind

So, if somebody asked me to copy my ieee1394/sbp2 safeguard into
firewire/fw-sbp2, I would reject that on the grounds that killing the
connection to the FireWire disk is the *expected result* of
# modprobe -r firewire-ohci
-- 
Stefan Richter
-=====-==--= ---= -=-=-
http://arcgraph.de/sr/
