Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZGHXQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZGHXQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 19:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZGHXQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 19:16:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60050 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754280AbZGHXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 19:16:21 -0400
Date: Thu, 9 Jul 2009 00:17:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com, Mark Allyn <mark.a.allyn@intel.com>
Subject: Re: [PATCH] This is the security processor driver for the Intel mid
 platform
Message-ID: <20090709001716.3dca2032@lxorguk.ukuu.org.uk>
In-Reply-To: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
References: <1247083262-17356-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Jul 2009 13:01:02 -0700
Mark Allyn <mark.a.allyn@intel.com> wrote:

> This is the driver for the Security Processor (SEP) for the Intel MID Platform.
> 
> This device driver is used by userspace applications to use the hardware based
> security processor that is on some Intel Mobile Internet (MID) devices.
> 
> This patch is applied against 2.6.31
> 
> Signed off my Mark Allyn <mark.a.allyn@intel.com>

Something weird seems to have happened to the formatting (at least if it
was tab formatted bits of it aren't any more - nasty accident with MS
Exchange perhaps ?)


> diff --git a/drivers/sep/Kconfig b/drivers/sep/Kconfig
> new file mode 100644
> index 0000000..316b79c
> --- /dev/null
> +++ b/drivers/sep/Kconfig
> @@ -0,0 +1,9 @@
> +config DX_SEP
> +	tristate "SEP driver"

Whats a SEP ? (I know that but I work for Intel ;)). This needs a longer
text and a description that would be useful to more people. The one in
your intro text is probably pretty close.

> diff --git a/drivers/sep/sep_driver_api.h b/drivers/sep/sep_driver_api.h

I'll skip over the API and the API related code for the moment. I think
that perhaps this should land in staging/sep first ? It's new hardware,
new support so would be good to get in soon but it needs lots of cleanup
and once its in staging that can be community and Intel done with a fast
turnaround. It also needs a rather different API I think (plus wiring
into the kernel crypto layer possibly ?)

> +++ b/drivers/sep/sep_driver_config.h

> +	the maximum length of the message - the rest of the message shared
> +	area will be dedicated to the dma lli tables
> +*/

I think we'd assume SIZE_IN_BYTES but if you like typing a lot 8)


> +/* FUNCTIONAL MACROS */
> +
> +/* debug macro without paramaters */

Use the standard dbg_ macros

> +#define SEP_WRITE_REGISTER(address, value)  writel((value), (void *)(address))
> +#define SEP_READ_REGISTER(address, value)  (value) = readl((void *)(address))

All of the I/O registers should be void __iomem *, this allows sparse and
other tools to be used to check for bugs.


> diff --git a/drivers/sep/sep_driver_ext_api.h b/drivers/sep/sep_driver_ext_api.h
> new file mode 100644

> +extern int sepDebug;

stylistically we normally use sep_ etc for globals (the rest have done)

> +extern unsigned long g_sep_reg_base_address;

no g_ by preference (that seems to be an Intel style characteristing but
its not an intel one)


> +++ b/drivers/sep/sep_ext_with_pci_driver.c
> @@ -0,0 +1,630 @@

> +static unsigned long CRYS_SEP_ROM[] = {
> +	#include "SEP_ROM_image.h"
> +};

Firmware interface not compiled in.

> +void *io_memory_start_virtual_address;

Not a good name for a global - and to be honest all of this stuff
including the IRQ would be better as a single "struct sep_device" or
similar that kept all the globals in one struct cleanly. It also saves
your backside if you ever have a future system with a two of them.


> +/* temporary */
> +unsigned long jiffies_future;


????

> +static struct pci_device_id sep_pci_id_tbl[] = {
> +	{ PCI_DEVICE(VENDOR_ID, 0x080c) },

PCI_VENDOR_ID_INTEL,

> +	{ 0 }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
> +
> +static unsigned long    rar_region_addr;
> +
> +
> +/* field for registering driver to PCI device */
> +static struct pci_driver sep_pci_driver = {
> +	.name = "sep_sec_driver",
> +	.id_table = sep_pci_id_tbl,
> +	.probe = sep_probe
> +};
> +
> +/* pointer to pci dev received during probe */
> +struct pci_dev *sep_pci_dev_ptr;

More global that will get you later.

> +/*
> +  This functions copies the cache and resident from their source location into
> +  destination memory, which is external to Linux VM and is given as
> +   physical address
> +*/

Kerneldoc format

/**
 *	sep_copy_cache_etc		-	does stuff 1 line
 *	@each arg: what it is
 *
 *  Text
 *  Text
 */

That way the tools we have can automatically extract documentation

> +int sep_copy_cache_resident_to_area(unsigned long   src_cache_addr,
> +				unsigned long   cache_size_in_bytes,
> +				unsigned long   src_resident_addr,
> +				unsigned long   resident_size_in_bytes,
> +				unsigned long *dst_new_cache_addr_ptr,
> +				unsigned long *dst_new_resident_addr_ptr)
> +{

> +	memcpy((void *)cache_virtual_address, (void *)fw->data, fw->size);

If this is ioremap space as it seems then  memcpy_to_io(void __iomem
*), ..)

> +	memcpy((void *)resident_virtual_address, (void *)fw->data, fw->size);

ditto

> +	/* physical addresses */
> +	*dst_new_cache_addr_ptr = cache_physical_address;
> +	*dst_new_resident_addr_ptr = resident_physical_address;

and would also be cleaned up by using a struct to hold all your context
and passing it around


> +int sep_map_and_alloc_shared_area(unsigned long shared_area_size,
> +				unsigned long *kernel_shared_area_addr_ptr,
> +				unsigned long *phys_shared_area_addr_ptr)
> +{
> +	// shared_virtual_address = ioremap_nocache(0xda00000,shared_area_size);

No C++ comments. 

> +	shared_virtual_address = kmalloc(shared_area_size, GFP_KERNEL);
> +	if (!shared_virtual_address) {
> +		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
> +		  "sep_driver:shared memory kmalloc failed\n");
> +		return -1;
> +	}
> +
> +	shared_physical_address = __pa(shared_virtual_address);

Ugly.. not sure what the best way to handle that is, but probably to use
the dma_ APIs to allocate a coherent region not use kmalloc


> +/*
> +  function that is activaed on the succesfull probe of the SEP device

Its called when one is found - not neccessarily on "successful" (one l)

> +*/
> +static int __devinit sep_probe(struct pci_dev *pdev,
> +			const struct pci_device_id *ent)
> +{

> +	/* set the pci dev pointer */
> +	sep_pci_dev_ptr = pdev;
> +
> +	/* get the io memory start address */
> +	io_memory_start_physical_address = pci_resource_start(pdev, 0);

This demonstrates part of why we don't want globals. A typical Linux
driver looks something like

	x = kzalloc(sizeof(struct foo), GFP_KERNEL);
	x->phys_addr = pci_resource_start(pdev, 0);

> +	io_memory_size = io_memory_end_physical_address -
> +	  io_memory_start_physical_address + 1;

	pci_resource_len()

> +	io_memory_start_virtual_address =
> +	  ioremap_nocache(io_memory_start_physical_address,
> +	  io_memory_size);

	pci_ioremap_bar()

> +	g_sep_reg_base_address = (unsigned long)io_memory_start_virtual_address;

More globals we don't need

> +	/* set up system base address and shared memory location */
> +
> +	rar_virtual_address = kmalloc(2 * SEP_RAR_IO_MEM_REGION_SIZE,
> +	  GFP_KERNEL);
> +
> +	if (!rar_virtual_address) {
> +		DEBUG_PRINT_0(SEP_DEBUG_LEVEL_EXTENDED,
> +		  "SEP Driver:cant kmalloc rar\n");
> +		goto end_function;
> +		}
> +
> +	rar_physical_address = __pa(rar_virtual_address);

	pci_alloc_coherent

> +#if !SEP_DRIVER_POLLING_MODE

Should probably be a separate routine, and any reason why polling mode is
compile not runtime selected ?

> +end_function:

Various things goto this but don't free the resources they allocated
before failing

> +void sep_load_rom_code()

void sep_load_rom_code(void)


> +{
> +#if SEP_DRIVER_ARM_DEBUG_MODE

Probably this lot doesn't belong in the upstream driver


> diff --git a/drivers/sep/sep_main_mod.c b/drivers/sep/sep_main_mod.c

> +/* address of the shared memory allocated during init for SEP driver */
> +static unsigned long			g_sep_shared_area_addr;
> +
> +/* the physical address of the shared area */
> +static unsigned long			g_sep_phys_shared_area_addr;
> +
> +/* Message Shared Area start address - will be allocated during init */
> +static unsigned long			g_message_shared_area_addr;
> +
> +/* major and minor device numbers */
> +static dev_t					g_sep_device_number;
> +
> +/* the files operations structure of the driver */
> +static struct file_operations  g_sep_fops;
> +
> +/* cdev struct of the driver */
> +static struct cdev			g_sep_cdev;

All stuff that belongs in the per device struct


> +  this function locks SEP by locking the semaphore
> +*/
> +int sep_lock()
> +{
> +  mutex_lock(&sep_mutex);

Except its a mutex, and it doesn't need wrapping

> +static int sep_open(struct inode *inode_ptr, struct file *file_ptr)
> +{
> +  /* return value */
> +  int			error;
> +
> +  /*-----------------
> +	CODE
> +  ---------------------*/
> +
> +  DEBUG_PRINT_0(SEP_DEBUG_LEVEL_BASIC, "SEP Driver:--------> open start\n");
> +
> +  error = 0;
> +
> +  /* check the blocking mode */
> +  if (g_sep_block_mode_flag)
> +	/* lock mutex */
> +	mutex_lock(&sep_mutex);
> +  else
> +	error = mutex_trylock(&sep_mutex);

Blocking mode comes from filp->f_flags O_NDELAY flag.

Also don't use mutexes across returns to user space, it makes life far
too interesting for real time people.

I'm not even clear what the goal here is for the mutex ?

> +/*---------------------------------------------------------------
> +  map function - this functions maps the message shared area
> +-----------------------------------------------------------------*/
> +static int sep_mmap(struct file  *filp, struct vm_area_struct  *vma)
> +{

> +  /* get physical address */
> +  phys_addr  = g_sep_phys_shared_area_addr;

All of this global stuff needs to go away. Create a single instance of a
struct holding the general stuff (which could become an array of pointers
in future). Assign the filp->private_data pointer to it in the _open
method and it'll begin to look like usual Linux code.


> +	*((unsigned long *)(g_sep_shared_area_addr +
> +	SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES + count)));

If that is from the ioremap external memory (its hard to tell as you
don't use __iomem anywhere consistently) this needs to be using readl and
friends, but I can't tell

> +	for (count = 0; count < 10 * 4; count += 4)
> +	DEBUG_PRINT_2(SEP_DEBUG_LEVEL_EXTENDED,
> +	"Debug Data Word %lu of the message is %lu\n",
> +	count,
> +	*((unsigned long *)(g_sep_shared_area_addr + 0x1800 + count)));

What locks poll v write v read v other poll etc ?

>
> +/*
> +  this function registers the driver to the file system
> +*/
> +static int  sep_register_driver_to_fs(void)
> +{
> +  /* return value */
> +  int			ret_val;
> +
> +  /*---------------------
> +	CODE
> +  -----------------------*/
> +
> +  ret_val = alloc_chrdev_region(&g_sep_device_number, 0, 1, "sep_sec_driver");
> +  if (ret_val) {
> +	DEBUG_PRINT_1(SEP_DEBUG_LEVEL_EXTENDED,
> +	"sep_driver:major number allocation failed, retval is %d\n", ret_val);
> +	goto end_function;
> +  }
> +
> +  /* set the files operations structure */
> +  g_sep_fops.owner = THIS_MODULE;
> +  g_sep_fops.ioctl = sep_ioctl;
> +  g_sep_fops.poll = sep_poll;
> +  g_sep_fops.open = sep_open;
> +  g_sep_fops.release = sep_release;
> +  g_sep_fops.mmap = sep_mmap;

Could be a static structure which is how must folks do it.


> +  iounmap((void *)g_sep_reg_base_address);

again void __iomem *, but if you kept it void __iomem * you could dump
all the casting

> +  /* calculate the total size for de-allocation */
> +  size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
> +		SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES +
> +		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
> +		SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES +
> +		SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
> +		SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;

Why isn't the total size a define ?

> +  interrupt handler function
> +*/
> +irqreturn_t sep_inthandler(int irq, void *dev_id)
> +{
> +  /* int error */

> +	if (reg_val & (0x1 << 13)) {
> +		/* update the counter of reply messages */
> +		sep_sep_to_host_reply_counter++;

What locks this v other users callers etc ?

