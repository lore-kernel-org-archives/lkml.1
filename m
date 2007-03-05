Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXCEVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXCEVRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbXCEVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:17:19 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:2260 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933300AbXCEVRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:17:18 -0500
Date: Mon, 5 Mar 2007 22:16:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070305221635.8b20eab5.khali@linux-fr.org>
In-Reply-To: <45EB01E8.5080003@assembler.cz>
References: <20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302151055.d2665d66.khali@linux-fr.org>
	<20070302141840.GA3441@srcf.ucam.org>
	<20070302220454.a0c66d04.khali@linux-fr.org>
	<20070302211251.GA10035@srcf.ucam.org>
	<20070303105316.d51e032d.khali@linux-fr.org>
	<4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>
	<20070303155048.GA22755@srcf.ucam.org>
	<45E9AB8B.1070804@assembler.cz>
	<45EB01E8.5080003@assembler.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rudolf,

On Sun, 04 Mar 2007 18:29:12 +0100, Rudolf Marek wrote:
> I produced some code which I proposed in mail above. The patch is not for review
> it is just a PoC to better show what I'm trying to do. It is a test case for my
> motherboard which has W83627EHF chip and ACPI thermal method and w83627ehf
> compete the device.
> 
> When no driver is loaded, acpi is doing its own raw access to device. However
> when the w83627ehf driver is loaded, the ACPI access to ports (0x295/0x296) is
> forwarded to the w83627ehf driver.
> 
> How it works? I added one pointer to the struct resource which will contain a
> pointer to the structure with callback functions. I know this is not an ideal
> solution, but for a test it works fine. Everytime ACPI wants do IO it will ask
> via ____request_resource(conflict, &res) if some driver claimed the resource,
> if so, it iterates the resource structure to the last entry, if the callback
> structure exists it is called (and device driver context is passed too), if not,
> raw hw access is performed.
> 
> The routines in EHF driver partly emulates the chip, the address of which next
> acpi access will want to read or write is saved in the data->reg_pointer.
> 
> The actual access to the chip is done only when the data port of the chip is
> accessed, and driver generic io function is called. Bank register writes are
> faked to the data->reg_bank. All access to the chip which is done in these
> routines respects the "virtual" bank register which was previously set by ACPI.
> (current emulation is not 100% perfect, but this could be easily fixed)
> If something was written to the chip, driver's register cache is invalidated.
> 
> This approach does not need any external locking because the actual device
> access is done by one function of driver (which already locks).
> 
> As from ACPI point of view the device behaves same way as real HW, the big plus
> is that the driver actually KNOWs what is ACPI trying to do to the chip. Of
> course if the HW access is done in SMM some other countermeasures must be
> invented like GBL lock or the "take ownership" stuff.
> 
> Maybe this forwarder may be used by other drivers, which may want to know what
> is ACPI doing to hardware during suspend/resume methods...
> 
> As I wrote earlier the SMBus access could be also virtualized same way, there
> will be only more virtual registers, real transaction will start when the ACPI
> sets the "begin transaction" bits ;).
> 
> Maybe the pointer to driver context could be removed, and container_of could be
> used instead to reach it. I will need some advise how to implement this
> randevouz between ACPI and one Linux driver... Exploiting the resource structure
>   is nice but pehaps not acceptable??? Some class maybe? We have only 1:1
> relation...

I like your implementation, it's nice. Thanks for coming up with this
idea. The only change I would propose is to make the last parameter of
the read_io and write_io callback functions a device * instead of a
void *. This would let the compiler check the types and avoid improper
casts.

One bug in your code:

> +acpi_status acpi_os_read_port(acpi_io_address port, u32 * value, u32 width)
> +{
> +	acpi_status ret = AE_OK;
> +	struct resource *conflict, res;
> +	u32 dummy;
> +	int retval;
> +
> +	if (!value)
> +		value = &dummy;
> +
> +	printk("%s: Port %x\n", __FUNCTION__ , (int) port);
> +	res.flags = 0;
> +	res.name = "ACPI Access";
> +	res.start = port;
> +	res.end = port + width/8 - 1;
> +	
> +	conflict = ____request_resource(&ioport_resource, &res);
> +
> +	while ((conflict) && (conflict->child))
> +		conflict = ____request_resource(conflict, &res);
> +
> +	if ((conflict) && (conflict->res_ops) && (conflict->res_ops->write_io)) {

You want to check that conflict->res_ops->read_io exists, not write_io.

> +		printk("Redir called\n");
> +		retval = conflict->res_ops->read_io(width, port, value, conflict->res_ops->priv_data);
> +
> +		//this needs coding fix
> +		if (retval < 0) {
> +			ret = acpi_os_read_port_raw(port, value, width);
> +		} else {
> +			ret = AE_OK;
> +		}
> +	} else {
> +		printk("Ordinary job\n");
> +		ret = acpi_os_read_port_raw(port, value, width);
> +		if (conflict == NULL)
> +			release_resource(&res);
> +	}
> +
> +	return ret;
> +}

This port forwarding approach is interesting, maybe even beyond the
ACPI case we are trying to solve here. However, it has some drawbacks:

1* It requires that we modify each driver individually. It's quite a
shame that we have to update drivers all around the kernel tree with
specific code to workaround a problem which is originally located in a
single place (the ACPI subsystem.) That being said this isn't a blocker
point, if this is the only way, we'll do it. But that's a rather great
amount of work.

2* It seems to incur a signficant performance penalty.
____request_resource isn't cheap as far as I know. And in the
absence of conflict, you are even allocating and releasing the resource
on _each_ I/O operation, which certainly isn't cheap either. Again, it
is not a blocker point, after all this is a workaround for an improper
behavior of the acpi subsystem, this performance penalty is the price to
pay. But there is also a performance penalty for legitimate I/O access,
which worries me more.

3* What about concurrent accesses from ACPI itself? Unless we have a
guarantee that only one kernel thread can run AML code at a given
moment, I can imagine a conflict happening, as your code protects us
well against ACPI and driver concurrent accesses, but not against two
concurrent ACPI accesses. But I'm not familiar with ACPI - maybe we do
have this guarantee? OTOH, if this ever happens, well, it would happen
even without your code.

So for now I tend to think that the idea of a global AML lock proposed
by Pavel Machek and Bodo Eggert would be more efficient. And it
wouldn't need any driver-specific code, so it would be much more simple
to implement. The drawback being that we serialize more than we really
need to (e.g. the hardware monitoring driver will not be allowed to
access the chip when _any_ AML code is running, not just when the AML
code accesses the hardware monitoring chip, and if two drivers want to
check the AML lock, they'll exclude each other as well.) But I wonder
if this is a problem in practice. Maybe we'll have to make some
profiling on both solutions and compare.

Thanks,
-- 
Jean Delvare
