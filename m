Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZE0O1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZE0O1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761388AbZE0O1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:27:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:7592 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598AbZE0O13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1243408083.13460.14.camel@debian-nb>
References: <1243408083.13460.14.camel@debian-nb>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 08:27:10 -0600
Message-ID: <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Janboe Ye <yuan-bo.ye@motorola.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, paulus@samba.org, rmk@arm.linux.org.uk,
       devicetree-discuss <devicetree-discuss@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 1:08 AM, Janboe Ye <yuan-bo.ye@motorola.com> wrote:
> Hi, All
>
> Currently, ARM linux uses mach-type to figure out platform. But mach-type could not handle variants well and it doesn't tell the kernel about info about attached peripherals.
>
> The device-tree used by powerpc and sparc could simplifiy board ports, less platform specific code and simplify device driver code.
>
> Please reference to Grant Likely and Josh Boyer's paper, A Symphony of Flavours: Using the device tree to describe embedded hardware , for the detail of device tree.
>
> www.kernel.org/doc/ols/2008/ols2008v2-pages-27-38.pdf
>
> Signed-off-by: janboe <yuan-bo.ye@motorola.com>

Heeheehe, This is Fantastic.  I'm actually working on this too.  Would
you like to join our efforts?

>  arch/arm/include/asm/of_device.h   |   32 +++
>  arch/arm/include/asm/of_platform.h |   39 ++++
>  arch/arm/include/asm/prom.h        |  367 ++++++++++++++++++++++++++++++++
>  arch/arm/include/asm/setup.h       |    8 +
>  arch/arm/kernel/Makefile           |    1 +
>  arch/arm/kernel/prom.c             |  414 ++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c            |    2 +

Right now we've got 3 platforms in mainline using the OF
infrastructure (sparc, powerpc & microblaze), and 2 using the
Flattened Device Tree (powerpc & microblaze).  Unfortunately, all of
the FDT stuff is duplicated between the 2 ports, along with some OF
support functions which could be common.  I don't want to see it
duplicated yet again.  First thing to do is to factor out the common
code and then make that buildable on ARM.

Another thing that needs to be done is to make the OF code endian
safe.  The FDT format is all in network-byte-order, but since the
current users are all big endian, not enough care has been taken to
use the appropriate nto*() functions when reading data out of the
tree.

> +/* process flat device tree for hardware configuration */
> +static int __init parse_tag_flat_dev_tree_address(const struct tag *tag)
> +{
> +    phys_flat_dev_tree_address =
> +                       tag->u.flat_dev_tree_address.flat_dev_tree_address;
> +    phys_flat_dev_tree_size = tag->u.flat_dev_tree_address.flat_dev_tree_size;
> +
> +    have_of = 1;
> +    if (phys_flat_dev_tree_size)
> +       initial_boot_params = phys_to_virt(phys_flat_dev_tree_address);
> +
> +    printk(KERN_INFO
> +       "%s: flat_dev_tree_address=0x%08x, flat_dev_tree_size == 0x%08X\n",
> +       __func__,
> +       phys_flat_dev_tree_address,
> +       phys_flat_dev_tree_size);
> +
> +    return 0;
> +}
> +
> +__tagtable(ATAG_FLAT_DEV_TREE_ADDRESS, parse_tag_flat_dev_tree_address);

I like this approach.  By using an ATAG, it doesn't force the ARM
kernel to use the FDT.  Of a platform provides one, then great, the
board port can use it.  If not, then it doesn't break existing board
ports.

An unanswered question is how platforms will make use of the FDT data.
 One idea is to define a new machine number for "FDT described
platform", and then probe what board-specific setup code to use from
data in the tree.  Another is if an FDT blob is provided on an
existing board which already has a machine number, then the board code
can be modified to extract device descriptions out of the tree.

I've found that even when firmware does not provide FDT support, it is
still useful to use the FDT data structure and to link it into the
kernel image itself.  There isn't the advantage of building a
multiplatform image in this case, but I find that it tends to result
in more common code between board ports using the same SoC or even
same core.  ie.  Most of the PowerPC eval boards using one of the 440
core variants can be supported by the file
arch/powerpc/platforms/440/ppc44x_simple.c, which is less than 100
lines long.

One thing I'd like to stress is that in powerpc land we make a lot of
mistakes on device tree usage conventions and bindings.  There is a
broad history of experience in the old OpenFirmware documents.  I
often found problems I was trying to solve with FDT already had been
solved by the OpenFirmware folks years ago.  General agreement now is
that all new bindings *must* be documented and reviewed before a
driver using them are merged (the documentation and driver can be
reviewed at the same time).  Right now the documentation is held in
Documentation/powerpc/fdt-bindings/, but that can be moved to a more
common location.  The mailing list for device tree review is
devicetree-discuss@ozlabs.org.  It's also a good place to go for
questions.

I've been toying with the idea for a while now of splitting the device
tree bindings documentation out of the kernel entirely so that it is
useful for other projects too.  For example, I believe that the
FreeBSD ARM community has expressed some interest in the FDT approach.

g.

> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 68d6494..8b219ec 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -35,6 +35,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cachetype.h>
>  #include <asm/tlbflush.h>
> +#include <asm/prom.h>
>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/irq.h>
> @@ -726,6 +727,7 @@ void __init setup_arch(char **cmdline_p)
>        parse_cmdline(cmdline_p, from);
>        paging_init(mdesc);
>        request_standard_resources(&meminfo, mdesc);
> +       unflatten_device_tree();
>
>  #ifdef CONFIG_SMP
>        smp_init_cpus();
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index f821dbc..c23a6ea 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -1,6 +1,6 @@
>  config OF_DEVICE
>        def_bool y
> -       depends on OF && (SPARC || PPC_OF)
> +       depends on OF && (SPARC || PPC_OF || ARM)
>
>  config OF_GPIO
>        def_bool y
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
