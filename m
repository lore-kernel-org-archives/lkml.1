Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZGULZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZGULZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZGULZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:25:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbZGULZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:25:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Gurudatt, Sreenidhi B" <sreenidhi.b.gurudatt@intel.com>
Subject: Re: x86: IPC driver patch for Intel Moorestown platform
Date: Tue, 21 Jul 2009 13:24:26 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>
References: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
In-Reply-To: <98769532B4BB14429434178695419EAE5F3F9541@bgsmsx501.gar.corp.intel.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907211324.26617.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+I/eHNlesrJxhKQ1VrpT9ZCB1NmTLy2bCQpzV
 2ZjW9Y/PnlOE2hMbyGQHyu4717qEBjnqzvVD6YmeaeuF3cUBpH
 bKJH8ow+ZE6IR9W/51h++F20hQdgSFQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009, Gurudatt, Sreenidhi B wrote:
> From c77d58ad07fbedb5de478bff21eb48c62b399cf1 Mon Sep 17 00:00:00 2001
> From: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
> Date: Mon, 20 Jul 2009 15:41:10 +0530
> Subject: [PATCH] x86: IPC driver patch for Intel Moorestown platform.
> 
> The Inter-Processor-Communication driver provides interfaces to host
> drivers in kernel to access various Langwell ICH blocks such as PMIC,
> GPIO and Battery for Intel Moorestown platform.
> The IPC driver for Intel Moorestown platform communicates via SCU
> firmware to access these registers.
> 
> Signed-off-by: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>

The naming is unfortunate, because IPC in our context normally
refers to Inter-Process-Communication, which is very different
from Inter-Processor-Communication. Can you find a meaningful
acronym to use in the code that is less overloaded?

It would be helpful to see the code using the new exported functions
as well, this driver alone doesn't do anything, so it is hard
to tell if your interfaces make sense.

My first impression is that your abstraction is on the wrong
level. Your have functions that are specific to devices like
watchdog and battery in your common code. These should really
be moved into the specific drivers and only communicate
with the IPC driver over device-independent interfaces.

One thing that is notably missing from your driver in integration
in the device model. At the very least, it should provide
a struct platform_device for every device for every device
that is logically connected to IPC. Most likely it gets easier
if you define your own bus_type for these devices.

> +/**
> + * struct mrst_ipc_cmd_type
> + * @u8 cmd - Command type
> + * @u32 data - Command data
> + * @u8 value - Command value
> + * @u8 ioc - IOC/MSI field.;
> + */
> +struct mrst_ipc_cmd_type {
> +       u8 cmd;
> +       u32 data;
> +       u8 value;
> +       u8 ioc;
> +};

This data structure contains a lot of padding,
sizeof (struct mrst_ipc_cmd_type) is 12 bytes for
only 7 bytes of content. If you put data at the
beginning or the end, it will only be 8 bytes.

I don't think wasting space is a problem here,
but the change would make it more aesthetic.

> +/**
> + * struct mrst_ipc_batt_prop_data - Structures defined for
> + * battery PMIC driver This structure is used by IPC_BATT_GET_PROP
> + * @u32 batt_value1 - Battery value.
> + * @u8 batt_value2[5] - battery value for PMIC specific regs.;
> + */
> +struct mrst_ipc_batt_prop_data {
> +       u32 batt_value1;
> +       u8 batt_value2[5];
> +       u32 ipc_cmd_len;
> +       u8 ioc;
> +};

same here

> +
> +/**
> + * struct mrst_ipc_reg_data - PMIC register structure.
> + * @u8 ioc - MSI or IOC bit.
> + * @u32 address - PMIC register address.
> + * @u32 data - PMIC register data.
> +*/
> +struct mrst_ipc_reg_data {
> +       u8 ioc;
> +       u32 address;
> +       u32 data;
> +};
> +
> +/**
> + * struct mrst_ipc_cmd - PMIC IPC command structure.
> + * @u8 cmd - Commmand -  bit.
> + * @u32 data - Command data.
> +*/
> +struct mrst_ipc_cmd {
> +       u8 cmd;
> +       u32 data;
> +};

and these. Actually, you don't seem to use these data structures
at all, so you're probably best of removing them entirely.

If they are going to be used in another driver, they will
fit more logically into the patch adding the code that uses
them.

> +u8 mrst_pmic_ioreadb(u16 addr, bool ioc_notify, int *err);
> +int mrst_pmic_iowriteb(u16 addr, bool ioc_notify, u8 data);
> +int mrst_pmic_iowrite(struct mrst_pmic_reg_data *p_write_reg_data);
> +int mrst_pmic_ioread(struct mrst_pmic_reg_data *p_read_reg_data);
> +int mrst_pmic_ioread_modify(struct mrst_pmic_mod_reg_data
> +                                 *p_read_mod_reg_data);

What does pmic actually stand for? It certainly does not become
clear from the code, and you don't seem to ever call these functions.

It looks like the pmic functionality should be a separate driver,
but that is not clear from the little information I have on it.

> +int mrst_ipc_read32(struct mrst_ipc_reg_data *p_reg_data);
> +int mrst_ipc_write32(struct mrst_ipc_reg_data *p_reg_data);

struct mrst_ipc_reg_data looks pointless, better make this

int mrst_ipc_read32(u8 ioc, u32 address, u32 *data);
int mrst_ipc_write32(u8 ioc, u32 address, u32 data);

> +u32 mrst_ipc_batt_read(u8 ioc, int *err);
> +int mrst_ipc_batt_write(u8 ioc, u32 value);
> +int mrst_ipc_get_batt_properties(struct mrst_ipc_batt_prop_data *prop_data);
> +int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_data);
> +int mrst_ipc_program_io_bus_master(struct mrst_ipc_io_bus_master_regs
> +                       *p_reg_data);
> +int lnw_ipc_single_cmd(u8 cmd_id, u8 sub_id, int size, int msi);

As mentioned, these all don't seem to belong in the base driver.

> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + * Author: Sreenidhi Gurudatt
> + * Contact information: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>
> + */

style: if your corporate guidelines allow this, it would be more
commonly written as

Author: Sreenidhi Gurudatt <sreenidhi.b.gurudatt@intel.com>


> +#include "mrst_ipc.h"

If there is only one file including mrst_ipc.h, you should just
move all of its contents here.

> +/*virtual memory address for IPC base returned by IOREMAP().*/
> +static void __iomem *p_mrst_ipc_base;
> +static void __iomem *p_mrst_i2c_ser_bus;
> +static struct pci_dev *mrst_ipc_pci_dev;
> +static wait_queue_head_t mrst_cmd_wait;
> +static int scu_cmd_completed;
> +static void __iomem *lnw_ipc_virt_address;
> +static unsigned short cmdid_pool = 0xffff;
> +static DEFINE_MUTEX(mrst_ipc_mutex);

Hmm, so your driver can by design only work with a single
instance of the hardware. Normally, the recommendation is
to put all these variables into a structure that you pass
around between all functions.

Are you sure that you can never have a machine with multiple
such interfaces?

> +static inline int lnw_ipc_set_mapping(struct pci_dev *dev)
> +{
> +       unsigned long cadr;
> +
> +       cadr = pci_resource_start(dev, 0);
> +       if (!cadr) {
> +               dev_info(&dev->dev, "No PCI resource for IPC\n");
> +               return -ENODEV;
> +       }
> +       lnw_ipc_virt_address = ioremap_nocache(cadr, 0x1000);
> +       if (lnw_ipc_virt_address != NULL) {
> +               dev_info(&dev->dev, "lnw ipc base found 0x%lup: 0x%p\n",
> +                        cadr, lnw_ipc_virt_address);
> +               return 0;
> +       }

This could use pci_iomap.

> +static inline void lnw_ipc_clear_mapping(void)
> +{
> +       iounmap(lnw_ipc_virt_address);
> +       lnw_ipc_virt_address = NULL;
> +}
> +
> +static u32 lnw_ipc_readl(u32 a)
> +{
> +       return readl(lnw_ipc_virt_address + a);
> +}
> +
> +static inline void lnw_ipc_writel(u32 d, u32 a)
> +{
> +       writel(d, lnw_ipc_virt_address + a);
> +}

These abstractions don't seem to gain much, you could
just as well call them inline.

> +static const struct mrst_ipc_driver ipc_mrst_driver = {
> +       .name = "MRST IPC Controller",
> +       /*
> +        * generic hardware linkage
> +        */
> +       .irq = mrst_ipc_irq,
> +       .flags = 0,
> +};

This really confused me for some time until I realized that
it is not based on a 'struct device_driver' at all. Once
more, you confuse driver and instance.

> +int init_mrst_ipc_driver(void)
> +{
> +       mutex_lock(&mrst_ipc_mutex);
> +       init_waitqueue_head(&mrst_cmd_wait);
> +
> +       /* Map the memory of ipc1 PMIC reg base */
> +       p_mrst_ipc_base = ioremap_nocache(IPC_BASE_ADDRESS, IPC_MAX_ADDRESS);
> +       if (p_mrst_ipc_base == NULL) {
> +               dev_err(&mrst_ipc_pci_dev->dev, "ERR:IPC Address Map Failed\n");
> +               mutex_unlock(&mrst_ipc_mutex);
> +               return -ENOMEM;
> +       }
> +
> +       p_mrst_i2c_ser_bus = ioremap_nocache(I2C_SER_BUS, I2C_MAX_ADDRESS);
> +       if (p_mrst_i2c_ser_bus == NULL) {
> +               iounmap(p_mrst_ipc_base);
> +               dev_err(&mrst_ipc_pci_dev->dev, "ERR:IPC Address Map Failed\n");
> +               mutex_unlock(&mrst_ipc_mutex);
> +               return -ENOMEM;
> +       }
> +
> +       mutex_unlock(&mrst_ipc_mutex);
> +
> +       return 0;
> +}

This function looks really strange, it is not called anywhere in your
driver, is not exported for modules and does not make sense as a
library interface. The lock does not appear to protect anything
either.

You really should not hardcode I/O addresses like IPC_BASE_ADDRESS
and I2C_SER_BUS. These normally come from some kind of bus probing
or from a firmware table. Again, like for the PCI stuff, the virtual
addresses should be part of some device, not just global variables
so that you are prepared for multiple instances.

Regarding error handling with mutexes, the recommended style is
using

{
	mutex_lock(&foo_lock);

	if (something_goes_wrong)
		goto out;

	do_something_else();

out:
	mutex_unlock(&foo_lock);
}

This pattern can be applied to many places in your code. The
reason is that if every if() clause handling errors needs
to unwind all the locks and resources manually, it gets
very easy to forget a case when you change something.

> + * u8 mrst_pmic_ioreadb() - This function reads the data from PMIC
> + * registers and fills the user specified buffer with data.
> + * @u16 addr: 16 Bit PMIC register offset address.
> + * @bool ioc_notify: boolean_value to speicify Interrupt On Completion bit.
> + * @int *err: negative if an error occurred
> + *
> + * This function reads 1byte of data data from specified PMIC register offset.
> + * It returns 8 bits of PMIC register data
> + */
> +u8 mrst_pmic_ioreadb(u16 addr, bool ioc_notify, int *err)
> +{
> +       struct mrst_pmic_reg_data r_data;
> +       int ret_val;
> +
> +       r_data.ioc = ioc_notify;
> +       r_data.num_entries = 1;
> +       r_data.pmic_reg_data[0].register_address = addr;
> +
> +       ret_val = mrst_pmic_ioread(&r_data);
> +       *err = ret_val;
> +       if (ret_val) {
> +               printk(KERN_ERR "mrst_pmic_ioreadb: ioreadb failed! \n");
> +               return 0xFF;
> +       }
> +       return r_data.pmic_reg_data[0].value;
> +}
> +EXPORT_SYMBOL(mrst_pmic_ioreadb);

It seems like the calling conventions for mrst_pmic_ioread are
unnecessarily complicated. r_data.num_entries is always 1, so
why pass a variable-length array?

> +/**
> + * int mrst_ipc_set_watchdog() - Function provides interface to set kernel watch
> + * dog timer using the SCU firmware command.
> + * @struct watchdog_reg_data *p_watchdog_reg_data: Pointer to data user
> + * defined data structure.
> + *
> + * This function provides and interface to to set kernel watch-dog
> + * timer using the SCU firmware command.
> + */
> +int mrst_ipc_set_watchdog(struct watchdog_reg_data *p_watchdog_reg_data)
> +{
> +       union mrst_ipc_fw_cmd ipc_cmd;
> +       u32 *ipc_wbuf;
> +       u8 cbuf[16] = { '\0' };
> +       u32 rbuf_offset = 2;
> +
> +       ipc_wbuf = (u32 *)&cbuf;
> +
> +       if (p_watchdog_reg_data == NULL) {
> +               printk(KERN_ERR "mrst_ipc_set_watchdog: reg_data is NULL\n");
> +               WARN_ON(1);
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&mrst_ipc_mutex);
> +
> +       mrst_set_ipc_cmd_fields(&ipc_cmd, p_watchdog_reg_data->ioc, 2, 0x0);
> +       /*Override this function specific fields*/
> +       ipc_cmd.cmd_parts.cmd = IPC_SET_WATCHDOG_TIMER;
> +
> +       /*MRST SCU Busy-Bit check*/
> +       if (is_mrst_scu_busy()) {
> +               mutex_unlock(&mrst_ipc_mutex);
> +               return -EBUSY;
> +       }
> +       ipc_wbuf[0] = p_watchdog_reg_data->payload1;
> +       writel(ipc_wbuf[0], p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
> +
> +       ipc_wbuf[1] = p_watchdog_reg_data->payload2;
> +       writel(ipc_wbuf[1], p_mrst_ipc_base + IPC_WBUF + rbuf_offset);
> +
> +       /*execute the command by writing to IPC_CMD registers*/
> +       mrst_ipc_send_cmd(ipc_cmd.cmd_data);

I think you need a more generic command facility that you can pass the
watchdog data to, without the function knowing anything about the
watchdog.

> +
> +#ifdef LNW_IPC_DEBUG
> +
> +#define lnw_ipc_dbg(fmt, args...) \
> +       do { printk(KERN_INFO fmt, ## args); } while (0)
> +#else
> +#define lnw_ipc_dbg(fmt, args...) do { } while (0)
> +#endif

This is basically the same as pr_debug(), so use that instead
of defining your own macros.

> +#define LNW_IPC1_BASE          0xff11c000
> +#define LNW_IPC1_MMAP_SIZE     1024

As mentioned before, don't hardcode but read from
an appropriate interface.

> +/*********************************************
> + * Define IPC_Base_Address and offsets
> + ********************************************/
> +#define IPC_BASE_ADDRESS       0xFF11C000
> +#define I2C_SER_BUS            0xFF12B000
> +#define DFU_LOAD_ADDR          0xFFFC0000

same here.

> +int init_mrst_ipc_driver(void);
> +static inline int is_mrst_scu_busy(void);
> +static inline int mrst_set_ipc_cmd_fields(union mrst_ipc_fw_cmd *ipc_cmd,
> +                                       u8 ioc, u32 size, u8 cmd_id);
> +static int do_mrst_ipc_battery(u32 cmd, u8 ioc, u32 *data);
> +static void mrst_ipc_send_cmd(u32 cmd_data);
> +static inline int wait_for_scu_cmd_completion(u8 mrst_ipc_ioc_bit);
> +static inline int is_mrst_scu_error(void);
> +static int de_init_mrst_ipc_driver(void);

Never declare static functions in a header file. Static functions
should be defined in the order in which they are called so you
don't need any forward declarations at all.

	Arnd <><
