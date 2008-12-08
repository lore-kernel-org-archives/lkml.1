Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYLHPAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYLHPAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYLHPA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:00:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43760 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYLHPA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:00:26 -0500
Subject: Re: [PATCH 2/2] virtio: do not statically allocate root device
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>
In-Reply-To: <493D3276.5040506@us.ibm.com>
References: <20081205184603.GC13133@suse.de>
	 <1228736980-19539-1-git-send-email-markmc@redhat.com>
	 <1228736980-19539-2-git-send-email-markmc@redhat.com>
	 <493D3276.5040506@us.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 14:58:53 +0000
Message-Id: <1228748333.3609.47.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 08:43 -0600, Anthony Liguori wrote:
> Mark McLoughlin wrote:
> > Apparently we shouldn't be statically allocating the root device
> > object, so dynamically allocate it instead.
> >
> > Also add a release() function to avoid this warning:
> >
> >   Device 'virtio-pci' does not have a release() function, it is broken and must be fixed
> >   
> 
> Is it really better to dynamically allocate the root device than 
> statically allocate it?  Is the advice that we shouldn't statically 
> allocate a device really a suggestion that if you're doing that, you're 
> using struct device wrong?

There are other statically allocated devices in tree[1]. It seems this
is actively discouraged, though.

AFAICT, the platform_bus device is there for a similar reason to ours -
i.e. to group devices together in sysfs.

> If so, this conversion should be equally wrong.  Have you chosen to keep 
> this device so that your initrd work-around continues to work as-is?  

I choose to keep it because:

  a) I'm trying to fix the warning spew from 'rmmod virtio_pci' without 
     breaking anything else

  b) The grouping under /sys/devices/{virtio-pci,lguest,kvm_s390} is
     useful IMHO and there are precedents (e.g. /sys/devices/platform)

  c) It's better to not gratuitously move stuff around where we know it 
     will break something

> What exactly is the work around and is there a less hackish way we could 
> support it?

Being discussed elsewhere in the thread.

Cheers,
Mark.

[1] - git-grep 'struct device .* = {' next-20081204
next-20081204:arch/cris/arch-v32/drivers/iop_fw_load.c:static struct device iop_spu_device[2] = {
next-20081204:arch/cris/arch-v32/drivers/iop_fw_load.c:static struct device iop_mpu_device = {
next-20081204:arch/ia64/kernel/pci-dma.c:struct device fallback_dev = {
next-20081204:arch/parisc/kernel/drivers.c:static struct device root = {
next-20081204:arch/powerpc/kernel/ibmebus.c:static struct device ibmebus_bus_device = { /* fake "parent" device */
next-20081204:arch/powerpc/platforms/ps3/system-bus.c:static struct device ps3_system_bus = {
next-20081204:arch/x86/kernel/pci-dma.c:struct device x86_dma_fallback_dev = {
next-20081204:drivers/base/isa.c:static struct device isa_bus = {
next-20081204:drivers/base/platform.c:struct device platform_bus = {
next-20081204:drivers/idle/i7300_idle.c:static struct device dummy_dma_dev = {
next-20081204:drivers/ieee1394/nodemgr.c:static struct device nodemgr_dev_template_ud = {
next-20081204:drivers/ieee1394/nodemgr.c:static struct device nodemgr_dev_template_ne = {
next-20081204:drivers/ieee1394/nodemgr.c:struct device nodemgr_dev_template_host = {
next-20081204:drivers/lguest/lguest_device.c:static struct device lguest_root = {
next-20081204:drivers/misc/sgi-gru/grumain.c:static struct device gru_device = {
next-20081204:drivers/misc/sgi-xp/xp_main.c:struct device xp_dbg_subname = {
next-20081204:drivers/misc/sgi-xp/xpc_main.c:struct device xpc_part_dbg_subname = {
next-20081204:drivers/misc/sgi-xp/xpc_main.c:struct device xpc_chan_dbg_subname = {
next-20081204:drivers/misc/sgi-xp/xpnet.c:struct device xpnet_dbg_subname = {
...
next-20081204:drivers/rapidio/rio-driver.c:static struct device rio_bus = {
next-20081204:drivers/scsi/scsi_debug.c:static struct device pseudo_primary = {
next-20081204:drivers/sh/maple/maple.c:static struct device maple_bus = {
next-20081204:drivers/sh/superhyway/superhyway.c:static struct device superhyway_bus_device = {
next-20081204:drivers/virtio/virtio_pci.c:static struct device virtio_pci_root = {
next-20081204:drivers/w1/w1.c:struct device w1_master_device = {
next-20081204:drivers/w1/w1.c:struct device w1_slave_device = {
next-20081204:samples/firmware_class/firmware_sample_driver.c:static struct device ghost_device = {
next-20081204:samples/firmware_class/firmware_sample_firmware_class.c:static struct device my_device = {


