Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbXKWAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbXKWAtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXKWAtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:49:04 -0500
Received: from nmta.jpl.nasa.gov ([137.78.160.214]:41246 "EHLO
	nmta1.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWAtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:49:00 -0500
Message-ID: <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
Date: Thu, 22 Nov 2007 16:48:53 -0800
From: niessner@jpl.nasa.gov
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where is the interrupt going?
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov>
	<20071122022004.GB9265@fattire.cabal.ca>
In-Reply-To: <20071122022004.GB9265@fattire.cabal.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_1s3ygnmwbcl"
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
X-Source-IP: webmail1.jpl.nasa.gov [137.78.160.101]
X-Source-Sender: niessner@jpl.nasa.gov
X-AUTH: Authorized
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format.

--=_1s3ygnmwbcl
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


I tried the hammer and the problem persists.
observer@bbb:~$ cat /proc/cmdline
root=3DUUID=3D8b3c3666-22c3-4c04-b399-ece266f2ef30 ro noapic quiet splash

However, I reserve the right to try the hammer again in the future. =20
When I look at /proc/interrupts without the APIC:
observer@bbb:~$ cat /proc/interrupts
            CPU0
   0:        144    XT-PIC-XT        timer
   1:         10    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   5:     100000    XT-PIC-XT        ohci_hcd:usb5, mxser
   6:          5    XT-PIC-XT        floppy
   7:          1    XT-PIC-XT        parport0
   8:          3    XT-PIC-XT        rtc
   9:          1    XT-PIC-XT        acpi, uhci_hcd:usb2
  10:     100000    XT-PIC-XT        ohci_hcd:usb4, ehci_hcd:usb6, =20
r128@pci:0000:01:00.0
  11:       2231    XT-PIC-XT        uhci_hcd:usb1, ohci_hcd:usb3, eth0
  12:        130    XT-PIC-XT        i8042
  14:       4362    XT-PIC-XT        libata
  15:      15315    XT-PIC-XT        libata
NMI:          0
LOC:     130125
ERR:          0
MIS:          0

I do not even see the device that I registered unless it is that =20
r128... line. However the code printed out in /var/log/messages:
Nov 22 16:05:27 bbb kernel: [  104.712473] apc8620: VID =3D 0x10B5
Nov 22 16:05:27 bbb kernel: [  104.712486] apc8620: mapped addr =3D e0bd4000
Nov 22 16:05:27 bbb kernel: [  104.713022] apc8620: registered carrier 0
Nov 22 16:05:27 bbb kernel: [  104.713028] apc8620: interrupt data =20
(0xe1083e40) on irq (10) and status (0x10)

which indicates it successfully registered without being shared. When =20
I have more time, I will changed the code to be a shared IRQ and try =20
the noapic again.

However, without the noapic /proc/interrupts looks like:
observer@bbb:~$ cat /proc/interrupts
            CPU0
   0:        154   IO-APIC-edge      timer
   1:         10   IO-APIC-edge      i8042
   6:          5   IO-APIC-edge      floppy
   7:          0   IO-APIC-edge      parport0
   8:          3   IO-APIC-edge      rtc
   9:          1   IO-APIC-fasteoi   acpi
  10:          0   IO-APIC-edge      apc8620
  12:        130   IO-APIC-edge      i8042
  14:       2861   IO-APIC-edge      libata
  15:       1049   IO-APIC-edge      libata
  16:     100001   IO-APIC-fasteoi   ohci_hcd:usb5, mxser
  17:          0   IO-APIC-fasteoi   uhci_hcd:usb1, ohci_hcd:usb3
  18:          0   IO-APIC-fasteoi   uhci_hcd:usb2
  19:        187   IO-APIC-fasteoi   eth0
  20:          0   IO-APIC-fasteoi   ohci_hcd:usb4, r128@pci:0000:01:00.0
  21:          0   IO-APIC-fasteoi   ehci_hcd:usb6
NMI:          0
LOC:       8820
ERR:          0
MIS:          0


I have attached the kernel module. The apc8620 is an IndustryPack =20
carrier card. I can therefore open up N (in this specific case 5) sub =20
memory windows in the memory mapped PCI address. The kernel module =20
keeps track of the slot offsets from the memory mapped address so that =20
the user can simply use read and write instead of a zillion ugly ioctl =20
calls. Because the kernel module tracks the slot offsets, I place acp =20
state into the private data of the file pointer. There can also be =20
multiple carriers on the bus. So, the array in the kernel module keeps =20
track of the card specific details with the file pointer the slot =20
specific information. Both are the same structure (bad on my part I =20
know but I never intended to show my dirty underwear). To get data =20
from interrupts (asynchronous IO) I was using readv. Now I am using =20
aio_read and had to make some minor changes that you will see comments =20
about to accomidate the change.

Just noticed that r128 is not the carrier card...

Thanks for all of the help so far and I hope this information is helpful.

I almost forgot. I also attached the dmesg output and will try the =20
irqpoll as it suggests. It is just the IRQ 16 is not the one I am =20
looking for, but is probably related to my mxser problems that I will =20
get to later.

Quoting Kyle McMartin <kyle@mcmartin.ca>, on Wed 21 Nov 2007 06:20:04 PM PST=
:

> On Wed, Nov 21, 2007 at 05:08:30PM -0800, Al Niessner wrote:
>> On with the detailed technical information. I developed a kernel module
>> for an PCI card back in 2.4, moved it to 2.6.3, then 2.6.11 or so and
>> now I am trying to move it to 2.6.22. When I began the to move to
>> 2.6.22, I changed all of the deprecated calls for finding the card on
>> the PCI bus, modified the interrupt handler prototype, and changed my
>> readvv/writev to aio_read/aio_write following
>> http://lwn.net/Articles/202449/. So initialization looks like this:
>>
>
> Hi Al,
>
> From the sounds of it, you might have an interrupt routing problem. Can
> you describe the machine you have this plugged into? Possibly attaching
> a copy of "dmesg" and "/proc/interrupts"?
>
> Feel free to attach the driver source to your email if the size is
> reasonable (which it sounds like it is.)
>
> As a "big hammer" in case it is an APIC problem, please try booting the
> kernel with the "noapic" parameter.
>
> cheers,
> =09Kyle
>



--=_1s3ygnmwbcl
Content-Type: text/plain;
	charset=UTF-8;
	name="apc8620.h"
Content-Disposition: attachment;
	filename="apc8620.h"
Content-Transfer-Encoding: quoted-printable

/*
{+D}
    SYSTEM:         APC8620.h

    FILENAME:=09    APC8620.h

    MODULE NAME:    Functions common to the APC8620 example software.

    VERSION:=09    A

    CREATION DATE:  06/06/01

    DESIGNED BY:    FJM

    CODED BY:=09    FJM

    ABSTRACT:       This file contains the definitions, structures
                    and prototypes for APC8620.

    CALLING
=09SEQUENCE:

    MODULE TYPE:

    I/O RESOURCES:

    SYSTEM
=09RESOURCES:

    MODULES
=09CALLED:

    REVISIONS:

  DATE=09  BY=09    PURPOSE
-------  ----=09------------------------------------------------


{-D}
*/


/*
    MODULES FUNCTIONAL DETAILS:

=09This file contains the definitions, structures and prototypes for APC8620=
.
*/

#ifndef __KERNEL__
#   include <ctype.h>
#   include <fcntl.h>
#   include <stdio.h>
#   include <stdlib.h>
#   include <sys/ioctl.h>
#   include <sys/types.h>
#   include <unistd.h>
#endif /* __KERNEL__ */

typedef int BOOL;
typedef unsigned long ULONG;
typedef unsigned char byte;=09/* custom made byte data type */
typedef unsigned short word;    /* custom made word data type */
typedef int cstatus_t;            /* Custom made cstatus_t data type, used a=
s
                                   return value from the carrier functions. =
*/

#define TRUE=091=09/* Boolean value for true */
#define FALSE=090=09/* Boolean value for false */

#define SLOT_A =090x41=09/* Value for slot A */
#define SLOT_B=090x42=09/* Value for slot B */
#define SLOT_C =090x43=09/* Value for slot C */
#define SLOT_D=090x44=09/* Value for slot D */
#define SLOT_E=090x45=09/* Value for slot E */

#define SLOT_A_IO_OFFSET 0x0180=09/*  Slot A IO space addr. offset from carr=
ier base addr. */
#define SLOT_A_ID_OFFSET 0x0040=09/*  Slot A ID space addr. offset from carr=
ier base addr. */
#define SLOT_B_IO_OFFSET 0x0200=09/*  Slot B IO space addr. offset from carr=
ier base addr. */
#define SLOT_B_ID_OFFSET 0x0080=09/*  Slot B ID space addr. offset from carr=
ier base addr. */
#define SLOT_C_IO_OFFSET 0x0280=09/*  Slot C IO space addr. offset from carr=
ier base addr. */
#define SLOT_C_ID_OFFSET 0x00C0=09/*  Slot C ID space addr. offset from carr=
ier base addr. */
#define SLOT_D_IO_OFFSET 0x0300=09/*  Slot D IO space addr. offset from carr=
ier base addr. */
#define SLOT_D_ID_OFFSET 0x0100=09/*  Slot D ID space addr. offset from carr=
ier base addr. */
#define SLOT_E_IO_OFFSET 0x0380=09/*  Slot E IO space addr. offset from carr=
ier base addr. */
#define SLOT_E_ID_OFFSET 0x0140=09/*  Slot E ID space addr. offset from carr=
ier base addr. */

#define NUMBER_OF_SLOTS  5
#define MAX_CARRIERS 5=09/* maximum number of carriers */

#define SOFTWARE_RESET 0x8000=09/*  Value to OR with control register to res=
et carrier */
#define TIME_OUT_INT_ENABLE 0x0008=09/* IP access time out interrupt enable =
*/
#define APC_INT_ENABLE=090x0004=09=09/* IP module interrupt enable */
#define APC_INT_PENDING_CLEAR 0x0020=09/* IP Module interrupt pending bit, c=
lear interrupts */

#define IPA_INT0_PENDING 0x0001=09=09/* IP A Int 0 Interrupt Pending bit */
#define IPA_INT1_PENDING 0x0002=09=09/* IP A Int 1 Interrupt Pending bit */
#define IPB_INT0_PENDING 0x0004=09=09/* IP B Int 0 Interrupt Pending bit */
#define IPB_INT1_PENDING 0x0008=09=09/* IP B Int 1 Interrupt Pending bit */
#define IPC_INT0_PENDING 0x0010=09=09/* IP C Int 0 Interrupt Pending bit */
#define IPC_INT1_PENDING 0x0020=09=09/* IP C Int 1 Interrupt Pending bit */
#define IPD_INT0_PENDING 0x0040=09=09/* IP D Int 0 Interrupt Pending bit */
#define IPD_INT1_PENDING 0x0080=09=09/* IP D Int 1 Interrupt Pending bit */
#define IPE_INT0_PENDING 0x0100=09=09/* IP E Int 0 Interrupt Pending bit */
#define IPE_INT1_PENDING 0x0200=09=09/* IP E Int 1 Interrupt Pending bit */
#define TIME_OUT_PENDING 0x0400=09=09/* Time out interrupt pending */


/*=20
=09cstatus_t return values
=09Errors will have most significant bit set and are preceded with an E_.
=09Success values will be succeeded with an S_.
*/
#define ERROR 0x8000 /* general */
#define E_OUT_OF_MEMORY =090x8001=09/*  Out of memory status value */
#define E_OUT_OF_CARRIERS=090x8002=09/*  All carrier spots have been taken *=
/
#define E_INVALID_HANDLE=090x8003=09/*  no carrier exists for this handle */
#define E_INVALID_SLOT=09=090x8004=09/*  no slot available with this number =
*/
#define E_NOT_INITIALIZED=090x8006=09/*  carrier not initialized */
#define E_NOT_IMPLEMENTED   0x8007;=09/*  Function is not implemented */
#define E_NO_INTERRUPTS =090x8008;=09/*  Carrier will be unable to handle in=
terrupts */
#define S_OK=09=09=09    0x0000=09/*  Everything worked successfully */



/*
 *=09APC8620=09PCI Carrier information
 */
#define APC8620_VENDOR_ID 0x10b5=09/* PLX vendor ID */
#define APC8620_DEVICE_ID 0x1024=09/* Acromag's device ID */

/*=20
 *=09PCI Carrier data structure
 */
typedef struct
{
=09word controlReg;=09/*  Status/Control Register */
=09word intPending;=09/*  Interrupt Pending Register */
=09word slotAInt0;=09=09/*  Slot A interrupt 0 select space */
=09word slotAInt1;=09=09/*  Slot A interrupt 1 select space */
=09word slotBInt0;=09=09/*  Slot B interrupt 0 select space */
=09word slotBInt1;=09=09/*  Slot B interrupt 1 select space */
=09word slotCInt0;=09=09/*  Slot C interrupt 0 select space */
=09word slotCInt1;=09=09/*  Slot C interrupt 1 select space */
=09word slotDInt0;=09=09/*  Slot D interrupt 0 select space */
=09word slotDInt1;=09=09/*  Slot D interrupt 1 select space */
=09word slotEInt0;=09=09/*  Slot E interrupt 0 select space */
=09word slotEInt1;=09=09/*  Slot E interrupt 1 select space */
} PCI_BOARD_MEMORY_MAP;

#define IOCTL_INTERRUPT_COUNT 7
#define IOCTL_INTERRUPT_REGISTER 4

typedef enum { NONE,
               IP330,
               IP340,
               IP480,
               IP1K110_Camera,
               LAST_MODULE_T_ENUM } module_t;

--=_1s3ygnmwbcl
Content-Type: text/plain;
	charset=UTF-8;
	name="apc8620.c"
Content-Disposition: attachment;
	filename="apc8620.c"
Content-Transfer-Encoding: quoted-printable


/*
  SYSTEM:          Acromag PCI carrier
  MODULE NAME:     apc8620.c
  VERSION:         A
  CREATION DATE:   14/05/04
  CODED BY:        AFN
  ABSTRACT:        8620 carrier device.
  CALLING
  SEQUENCE:
  MODULE TYPE:
  I/O RESOURCES:
  SYSTEM
  RESOURCES:
  MODULES
  CALLED:
  REVISIONS:

  DATE      BY       PURPOSE
  -------- ----  ------------------------------------------------

*/


/* APC8620 device */

#include <asm/io.h>           /* for read{b,w,l} and write{b,w,l} */
#include <asm/system.h>
#include <asm/uaccess.h>      /* for copy_to/from_user */
#include <linux/autoconf.h>
#include <linux/delay.h>
#include <linux/errno.h>      /* for error numbers */
#include <linux/fs.h>
#include <linux/init.h>       /* for __init and __exit */
#include <linux/interrupt.h>  /* for request_irq and free_irq */
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/pci.h>
#include <linux/slab.h>       /* for kmalloc and kfree */
#include <linux/types.h>
#include <linux/version.h>    /* KERNEL_VERSION(a,b,c) */

#include "apc8620.h"
#include "isr330.h"
#include "isr340.h"
#include "isr480.h"
#include "isr1k110Camera.h"

#define DEVICE_NAME       "apc8620"
#define MAJOR_NUM         46

MODULE_LICENSE("GPL and additional rights");

/* funtion prototypes */
static ssize_t aio_read (struct kiocb *iocb,
                         const struct iovec *vec,
                         unsigned long count,
                         loff_t offset);
static ssize_t aio_write (struct kiocb *iocb,
                          const struct iovec *vec,
                          unsigned long count,
                          loff_t offset);
static int ioctl (struct inode *inode,
                  struct file *fp,
                  unsigned int cmd,
                  unsigned long arg);
static int open (struct inode *inode, struct file *fp);
static ssize_t read (struct file *fp,
                     char *buf,
                     size_t length,
                     loff_t *offset);
static int release (struct inode *inode, struct file *fp);
static ssize_t write (struct file *fp,
                      const char *buf,
                      size_t length,
                      loff_t *offset);


/* internal types */
struct apc_stateInformation
{
  atomic_t interruptCount[NUMBER_OF_SLOTS];
  int board_irq;
  int carrier;
  int isModule;
  int ret_val;
  int slot;
  unsigned long moduleOffset_IO;
  unsigned long moduleOffset_ID;
  unsigned long physicalAddress;
  void(*isr[NUMBER_OF_SLOTS])(void*);

  /*=20
   * Changes in fs.h struct file  caused this pointer to be moved here.
   * Namely, file_operations (f_op*) was made const.
   */
  ssize_t(*readv)(struct file *fp,
                  const struct iovec *vec,
                  unsigned long count,
                  loff_t *offset);
  ssize_t(*writev)(struct file *fp,
                   const struct iovec *vec,
                   unsigned long count,
                   loff_t *offset); =20
};


/* declaration of available isr table */
/* these functions MUST be FULLY reentrant */
static void(*isrtable[LAST_MODULE_T_ENUM])(void*);
static ssize_t(*readvTable[LAST_MODULE_T_ENUM])(struct file *fp,
                                                const struct iovec *vec,
                                                unsigned long count,
                                                loff_t *offset);
static ssize_t(*writevTable[LAST_MODULE_T_ENUM])(struct file *fp,
                                                 const struct iovec *vec,
                                                 unsigned long count,
                                                 loff_t *offset);

/* declaration of state information */
static spinlock_t stateInformationSync =3D SPIN_LOCK_UNLOCKED;
static struct apc_stateInformation apcsi[MAX_CARRIERS];
static struct file_operations apc8620_ops =3D
  {
    owner:     THIS_MODULE,
    aio_read:  aio_read,
    aio_write: aio_write,
    read:      read,
    write:     write,
    ioctl:     ioctl,
    open:      open,
    release:   release,
  };


/* elaboration of function prototypes */
#define GET_SI(fp,si) if (!extractStateInformation (fp, &si)) return -EBADF;

static int extractStateInformation (struct file *fp,
                                    struct apc_stateInformation *to)
{
  int result =3D 0 =3D=3D 1;
  struct apc_stateInformation *from;

  spin_lock (&stateInformationSync);
  {
    if (fp->private_data !=3D NULL)
      {
        from =3D (struct apc_stateInformation*)fp->private_data;
        memcpy (to, from, sizeof(struct apc_stateInformation));
        result =3D 0 =3D=3D 0;
      }
    else
    result =3D 0 =3D=3D 1;
  }
  spin_unlock (&stateInformationSync);

  return result;
}

static int open (struct inode *inode, struct file *fp)
{
  const int minor   =3D MINOR(inode->i_rdev);
  const int carrier =3D minor & 0x0f;
  const int slot    =3D (minor & 0xf0) >> 4;
  struct apc_stateInformation *module =3D NULL;

  /* Check to make sure the request is valid */
  if (carrier > (MAX_CARRIERS - 1)) return -ENODEV;
  if (slot > NUMBER_OF_SLOTS) return -ENODEV;
  if (apcsi[carrier].physicalAddress =3D=3D 0) return -ENODEV;

  if (slot > 0)
    {
      module =3D kmalloc (sizeof(struct apc_stateInformation), GFP_KERNEL);
      module->board_irq       =3D apcsi[carrier].board_irq;
      module->carrier         =3D carrier;
      module->isModule        =3D 0 =3D=3D 0;
      module->ret_val         =3D apcsi[carrier].ret_val;
      module->slot            =3D slot - 1;
      module->moduleOffset_ID =3D SLOT_A_ID_OFFSET + (module->slot * 0x40);
      module->moduleOffset_IO =3D SLOT_A_IO_OFFSET + (module->slot * 0x80);
      module->physicalAddress =3D apcsi[carrier].physicalAddress;
      module->readv =3D NULL;
      module->writev =3D NULL;
      fp->private_data =3D module;
    }
  else
    fp->private_data =3D &apcsi[carrier];

  return 0;
}=20


static int release (struct inode *inode, struct file *fp)
{
  int result =3D 0;
  struct apc_stateInformation *si;

  spin_lock (&stateInformationSync);
  {
    if (fp->private_data =3D=3D NULL) result =3D -EBADF;
    else
      {
        si =3D (struct apc_stateInformation*)fp->private_data;
        fp->private_data =3D NULL;
        if (si->isModule) kfree (si);
      }
  }
  spin_unlock (&stateInformationSync);

  return result;
}


static ssize_t read (struct file *fp, char *buf, size_t length, loff_t *offs=
et)
{=20
  const int    size =3D length & 0x3;
  const size_t len  =3D length >> 2;
  size_t i;
  struct apc_stateInformation si;
  unsigned char theData[(size=3D=3D0?1:(size=3D=3D3?4:size))*len];
  unsigned long adata;

  GET_SI(fp, si); /* make sure file descriptor is valid. */

  adata =3D si.physicalAddress +
    (size =3D=3D 0 ? si.moduleOffset_ID : si.moduleOffset_IO) + *offset;

  /*
  printk(KERN_NOTICE "apc8620: reading from offset %lld\n", *offset);
  printk(KERN_NOTICE "apc8620: module space is 0x%lx\n",
         (size =3D=3D 0 ? si.moduleOffset_ID : si.moduleOffset_IO));
  printk(KERN_NOTICE "apc8620: reading %d items at %d bytes each from device=
...\n", len, size);
  */

  switch (size)
    {
    case 0:     /* 8 bit read but index output array as 16 bits */
      for (i =3D 0 ; i < len ; i++, adata+=3D2) theData[i] =3D readb((char *=
)adata);
      break;
    case 1:=09/* 8 bit */
      for (i =3D 0 ; i < len ; i++, adata++) theData[i] =3D readb((char *)ad=
ata);
      break;
    case 2:=09/* 16 bit */
      {
        unsigned short *data =3D (unsigned short*)theData;
        for (i =3D 0 ; i < len ; i++, adata+=3D2) data[i] =3D readw((short *=
)adata);
      }
      break;
    case 3:=09/* 32 bit */
      {
        unsigned long *data =3D (unsigned long*)theData;
        for (i =3D 0 ; i < len ; i++, adata+=3D4) data[i] =3D readl((long *)=
adata);
      }
      break;
    default:
      return (-EINVAL);
      break;
    }

  copy_to_user (buf, theData, sizeof(theData));

  /*printk(KERN_NOTICE "apc8620: successfully read device...\n");*/
  return (len);
}


static ssize_t write (struct file *fp,
                      const char *buf,
                      size_t length,
                      loff_t *offset)
{=20
  const int    size =3D length & 0x3;
  const size_t len  =3D length >> 2;
  size_t i;
  struct apc_stateInformation si;
  unsigned char theData[(size=3D=3D0?1:(size=3D=3D3?4:size))*len];
  unsigned long adata;

  GET_SI(fp, si); /* make sure file descriptor is valid. */

  adata =3D si.physicalAddress + si.moduleOffset_IO + *offset;
  copy_from_user (theData, buf, sizeof(theData));

  /*
  printk(KERN_NOTICE "apc8620: writing %d items at %d bytes each from device=
...\n", len, size);
  printk(KERN_NOTICE "apc8620:    physical address 0x%lx\n", si.physicalAddr=
ess);
  printk(KERN_NOTICE "apc8620:    module offset 0x%lx\n", si.moduleOffset_IO=
);
  printk(KERN_NOTICE "apc8620:    requested offset 0x%llx\n", *offset);
  printk(KERN_NOTICE "apc8620:    computed result 0x%lx\n", adata);
  */
  switch (size)
    {
    case 0:=09/* 8 bit write but index input array as 16 bits */
      for (i =3D 0 ; i < len ; i++, adata+=3D2) writeb(theData[i], (char *)a=
data);
      break;
    case 1:=09/* 8 bit */
      for (i =3D 0 ; i < len ; i++, adata++) writeb(theData[i], (char *)adat=
a);
      break;
    case 2:=09/* 16 bit */
      {
        unsigned short *data =3D (unsigned short*)theData;
        for (i =3D 0 ; i < len ; i++, adata+=3D2) writew(data[i], (short *)a=
data);
      }
      break;
    case 3:=09/* 32 bit */
      {
        unsigned long *data =3D (unsigned long*)theData;
        for (i =3D 0 ; i < len ; i++, adata+=3D4) writel(data[i], (long *)ad=
ata);
      }
      break;
    default:
      return (-EINVAL);
      break;
    }

  /*printk(KERN_NOTICE "apc8620: successfully write device...\n");*/
  return (len);
}


static int ioctl (struct inode *inode,
                  struct file *fp,
                  unsigned int cmd,
                  unsigned long arg)
{
  int i;
  module_t ip;
  struct apc_stateInformation si;
  unsigned int interruptCount[NUMBER_OF_SLOTS];

  GET_SI(fp, si); /* make sure file descriptor is valid. */

  /*printk(KERN_NOTICE "apc8620: ioctl device with %u...\n", cmd);*/
  switch (cmd)
    {
    case 0:
    case 1:
    case 2:
    case 3:
    case 4: /* register or degister ISRs for a slot */
      if (arg < LAST_MODULE_T_ENUM && si.isModule)
        {
          int result =3D 0;
          unsigned short int_pending, status;

         =20
          ip =3D (module_t)arg;
          status =3D readw ((void*)(apcsi[si.carrier].physicalAddress));
          int_pending =3D readw ((void*)(apcsi[si.carrier].physicalAddress +=
 2));
          printk (KERN_NOTICE "apc8620: hardware status (0x%hx) with pending=
 interrupts (0x%hx).\n",
                  status, int_pending);
          /* printk (KERN_NOTICE "apc8620: Registering an interrupt for slot=
 %d and IP module %d\n", si.slot, ip); */
          spin_lock (&stateInformationSync);
          {
             apcsi[si.carrier].isr[si.slot] =3D isrtable[ip];
             if (fp->private_data =3D=3D NULL) result =3D -EBADF;
             else
             {
                struct apc_stateInformation* real =3D (struct apc_stateInfor=
mation*)fp->private_data;
                real->readv  =3D readvTable[ip];
                real->writev =3D writevTable[ip];
             }
          }
          spin_unlock (&stateInformationSync);
         =20
          if (result < 0)
          {
            printk (KERN_NOTICE "apc8620: Failure to insert ISR 0x%x.\n", -r=
esult);
            apcsi[si.carrier].isr[si.slot] =3D NULL;
            return result;
          }
        }
      else return -EINVAL;
      break;

    case 7: /* get the interrupt count for some slot */
      if (!si.isModule)
        {
          for (i =3D 0 ; i < NUMBER_OF_SLOTS ; i++)
            {
              interruptCount[i] =3D
                atomic_read (&si.interruptCount[i]);
              /*printk(KERN_NOTICE "apc8620: interrupt count for %c is %u.\n=
",
                (char)(i+0x41), interruptCount[i]);*/
            }
          copy_to_user ((void*)arg,
                        (void*)interruptCount,
                        sizeof(interruptCount));
        }
      else return -EINVAL;
      break;
     =20
    default:
      return -EINVAL;
    }
  /*printk(KERN_NOTICE "apc8620: successfully ioctl device...\n");*/

  return (cmd);
}

static ssize_t aio_read (struct kiocb *iocb,
                         const struct iovec *vec,
                         unsigned long count,
                         loff_t offset)
{
  ssize_t result =3D -EBADF;
  struct apc_stateInformation si;

  GET_SI(iocb->ki_filp, si); /* make sure file descriptor is valid. */

  if (si.readv !=3D NULL)
    result =3D si.readv (iocb->ki_filp, vec, count, &offset);

  return result;
}

static ssize_t aio_write (struct kiocb *iocb,
                          const struct iovec *vec,
                          unsigned long count,
                          loff_t offset)
{
  ssize_t result =3D -EBADF;
  struct apc_stateInformation si;

  GET_SI(iocb->ki_filp, si); /* make sure file descriptor is valid. */

  if (si.writev !=3D NULL)
    result =3D si.writev (iocb->ki_filp, vec, count, &offset);
  return result;
}

static irqreturn_t apc8620_handler (int irq,
                                    void *did)
{
  struct apc_stateInformation *si =3D (struct apc_stateInformation*)did;
  int slot, ip_int0_pending =3D 0x01, ip_int1_pending =3D 0x2;
  int ip_io_offset =3D SLOT_A_IO_OFFSET;
  unsigned short dummyWord, nValue, *slotAddr;
  PCI_BOARD_MEMORY_MAP* pPCICard;

  printk (KERN_NOTICE "apc8620: did (0x%lx)\n", (unsigned long)did);
  pPCICard =3D (PCI_BOARD_MEMORY_MAP*)si->physicalAddress;
  nValue =3D readw ((unsigned short*)&pPCICard->intPending);
  slotAddr =3D &pPCICard->slotAInt0;

  for (slot =3D 0 ; slot < NUMBER_OF_SLOTS ; slot++)
    {
      if (nValue & ip_int0_pending || nValue & ip_int1_pending)
        {
          printk (KERN_NOTICE "apc8620: interrupt on slot %d.\n", slot);
          atomic_inc (&si->interruptCount[slot]);
          if (si->isr[slot] !=3D NULL)
            si->isr[slot] ((void*)si->physicalAddress + ip_io_offset);
          else printk (KERN_NOTICE "apc8620: interrupt handler for slot %d i=
s missing.\n", slot);

          /* read IP A Interrupt Select Space */
          dummyWord =3D readw (slotAddr);
          dummyWord =3D readw (slotAddr+1);
        }
      ip_int0_pending *=3D 4;
      ip_int1_pending *=3D 4;
      slotAddr +=3D 2;
      ip_io_offset +=3D 0x0080;
    }

  return IRQ_HANDLED;
}


static int __init init_apc8620_module (void)=20
{=20
  module_t mt;
  int i, j, done =3D 0 =3D=3D 1, status;
  struct pci_dev *p8620 =3D NULL;

  /* build the interrupt table */
  for (mt =3D NONE ; mt <=3D LAST_MODULE_T_ENUM ; mt++)
    {
      isrtable[mt] =3D NULL;
      readvTable[mt] =3D NULL;
      writevTable[mt] =3D NULL;
    }

  // override the IP 330 calls
  isrtable[IP330] =3D isr330;
  readvTable[IP330] =3D readv330;
  writevTable[IP330] =3D writev330;
  ip330isr_init();

  // override the IP 340 calls
  isrtable[IP340] =3D isr340;
  readvTable[IP340] =3D readv340;
  writevTable[IP340] =3D writev340;
  ip340isr_init();

  // override the IP 340 calls
  isrtable[IP480] =3D isr480;
  readvTable[IP480] =3D readv480;
  writevTable[IP480] =3D writev480;
  ip480isr_init();

  // override the IP 1K110
  isrtable[IP1K110_Camera] =3D isr1K110Camera;
  readvTable[IP1K110_Camera] =3D readv1K110Camera;
  writevTable[IP1K110_Camera] =3D writev1K110Camera;
  ip1K110Cameraisr_init();

  /* initialize the private or instance data */
  for (i =3D 0 ; i < MAX_CARRIERS ; i++)
    {
      for (j =3D 0 ; j < NUMBER_OF_SLOTS ; j++)
        {
          atomic_set (&apcsi[i].interruptCount[j], 0);
          apcsi[i].isr[j] =3D NULL;
        }
      apcsi[i].board_irq =3D 0;
      apcsi[i].carrier =3D i;
      apcsi[i].isModule =3D 0 =3D=3D 1;
      apcsi[i].ret_val =3D 0;
      apcsi[i].slot =3D 0;
      apcsi[i].moduleOffset_IO =3D 0;
      apcsi[i].moduleOffset_ID =3D 0;
      apcsi[i].physicalAddress =3D 0;
      apcsi[i].readv =3D NULL;
      apcsi[i].writev =3D NULL;

      if (!done) p8620 =3D pci_get_device (APC8620_VENDOR_ID, APC8620_DEVICE=
_ID, p8620);
      if (p8620)
        {=20
          apcsi[i].physicalAddress =3D (unsigned long)p8620->resource[2].sta=
rt;
          printk(KERN_NOTICE "apc8620: VID =3D 0x10B5\napc8620: DID =3D 0x10=
24\napc8620: physical addr =3D %lx\n",
                 apcsi[i].physicalAddress);
          apcsi[i].physicalAddress =3D
            (unsigned long)ioremap_nocache (apcsi[i].physicalAddress, 4096);

          if (apcsi[i].physicalAddress =3D=3D 0) return (-ENODEV);
          else printk(KERN_NOTICE "apc8620: mapped addr =3D %lx\n",
                      apcsi[i].physicalAddress);

          writew (0x0100, (void*)apcsi[i].physicalAddress); /* reset the har=
dware */
          apcsi[i].ret_val =3D register_chrdev (MAJOR_NUM,
                                              DEVICE_NAME,
                                              &apc8620_ops);
          if (apcsi[i].ret_val < 0) printk(KERN_ERR
                                           "apc8620: Failed to register erro=
r =3D %d\n",
                                           apcsi[i].ret_val);
          else
            {
              printk(KERN_NOTICE "apc8620: registered carrier %d\n", i);
              apcsi[i].board_irq =3D p8620->irq;
              status =3D request_irq (apcsi[i].board_irq,
                                    apc8620_handler,
                                    IRQF_DISABLED,
                                    DEVICE_NAME,
                                    (void*)&apcsi[i]);
              printk(KERN_NOTICE "apc8620: interrupt data (0x%lx) on irq (%d=
) and "
                     "status (0x%x)\n",
                     (unsigned long)&apcsi[i], apcsi[i].board_irq, -status);
              writew (0x0004, (void*)apcsi[i].physicalAddress);/* enable int=
errupts */
            }
        }
      else done =3D 1 =3D=3D 1;
    }
  return (0);
}


static void __exit cleanup_apc8620_module(void)=20
{
  int i;
  for (i =3D 0 ; i < MAX_CARRIERS ; i++)
    {
      if (apcsi[i].ret_val >=3D 0 )
        {
          unregister_chrdev (MAJOR_NUM, DEVICE_NAME);
          free_irq (apcsi[i].board_irq, (void *)&apcsi[i]);
          iounmap ((void *)apcsi[i].physicalAddress);
        }
    }
}

module_init (init_apc8620_module);
module_exit (cleanup_apc8620_module);

--=_1s3ygnmwbcl
Content-Type: text/plain;
	charset=UTF-8;
	name="dmesg.out"
Content-Disposition: attachment;
	filename="dmesg.out"
Content-Transfer-Encoding: quoted-printable

observer@bbb:~$ dmesg
[    0.000000] Linux version 2.6.22-14-generic (buildd@palmer) (gcc version =
4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun Oct 14 23:0=
5:12 GMT 2007 (Ubuntu 2.6.22-14.46-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f4df0
[    0.000000] Entering add_active_range(0, 0, 131056) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   131056
[    0.000000]   HighMem    131056 ->   131056
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   131056
[    0.000000] On node 0 totalpages: 131056
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 991 pages used for memmap
[    0.000000]   Normal zone: 125969 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP signature @ 0xC00F6820 checksum 0
[    0.000000] ACPI: RSDP 000F6820, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 1FFF3000, 002C (r1 IntelR AWRDACPI 42302E31 AWRD  =
      0)
[    0.000000] ACPI: FACP 1FFF3040, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD  =
      0)
[    0.000000] ACPI: DSDT 1FFF30C0, 388A (r1 INTELR AWRDACPI     1000 MSFT  =
100000D)
[    0.000000] ACPI: FACS 1FFF0000, 0040
[    0.000000] ACPI: APIC 1FFF6980, 0054 (r1 IntelR AWRDACPI 42302E31 AWRD  =
      0)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:2 APIC version 20
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-2=
3
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:=
dec00000)
[    0.000000] Built 1 zonelists.  Total pages: 130033
[    0.000000] Kernel command line: root=3DUUID=3D8b3c3666-22c3-4c04-b399-ec=
e266f2ef30 ro quiet splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 2392.529 MHz processor.
[   14.271187] Console: colour VGA+ 80x25
[   14.271703] Dentry cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[   14.272141] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes=
)
[   14.284509] Memory: 507404k/524224k available (2015k kernel code, 16184k =
reserved, 916k data, 364k init, 0k highmem)
[   14.284521] virtual kernel memory layout:
[   14.284522]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   14.284523]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   14.284524]     vmalloc : 0xe0800000 - 0xff7fe000   ( 495 MB)
[   14.284526]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
[   14.284528]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   14.284530]       .data : 0xc02f7d26 - 0xc03dce84   ( 916 kB)
[   14.284531]       .text : 0xc0100000 - 0xc02f7d26   (2015 kB)
[   14.284534] Checking if this processor honours the WP bit even in supervi=
sor mode... Ok.
[   14.284578] SLUB: Genslabs=3D22, HWalign=3D64, Order=3D0-1, MinObjects=3D=
4, CPUs=3D1, Nodes=3D1
[   14.364416] Calibrating delay using timer specific routine.. 4788.91 Bogo=
MIPS (lpj=3D9577836)
[   14.364445] Security Framework v1.0.0 initialized
[   14.364454] SELinux:  Disabled at boot.
[   14.364468] Mount-cache hash table entries: 512
[   14.364630] CPU: After generic identify, caps: bfebfbff 00000000 00000000=
 00000000 00000000 00000000 00000000
[   14.364645] CPU: Trace cache: 12K uops, L1 D cache: 8K
[   14.364649] CPU: L2 cache: 512K
[   14.364652] CPU: Hyper-Threading is disabled
[   14.364654] CPU: After all inits, caps: bfebfbff 00000000 00000000 0000b0=
80 00000000 00000000 00000000
[   14.364667] Compat vDSO mapped to ffffe000.
[   14.364682] Checking 'hlt' instruction... OK.
[   14.380503] SMP alternatives: switching to UP code
[   14.380737] Freeing SMP alternatives: 11k freed
[   14.381079] Early unpacking initramfs... done
[   14.745725] ACPI: Core revision 20070126
[   14.745797] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml =
not found.
[   14.748840] CPU0: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 07
[   14.748889] Total of 1 processors activated (4788.91 BogoMIPS).
[   14.749036] ENABLING IO-APIC IRQs
[   14.749252] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-=
1
[   14.895206] Brought up 1 CPUs
[   14.895351] Booting paravirtualized kernel on bare hardware
[   14.895457] Time:  0:31:30  Date: 10/23/107
[   14.895488] NET: Registered protocol family 16
[   14.895609] EISA bus registered
[   14.895634] ACPI: bus type pci registered
[   14.919814] PCI: PCI BIOS revision 2.10 entry at 0xfb370, last bus=3D3
[   14.919817] PCI: Using configuration type 1
[   14.919819] Setting up standard PCI resources
[   14.921448] ACPI: EC: Look up EC in DSDT
[   14.925101] ACPI: Interpreter enabled
[   14.925105] ACPI: (supports S0 S1 S5)
[   14.925126] ACPI: Using IOAPIC for interrupt routing
[   14.930313] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   14.930321] PCI: Probing PCI hardware (bus 00)
[   14.930557] PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
[   14.930562] PCI quirk: region 0480-04bf claimed by ICH4 GPIO
[   14.930988] PCI: Firmware left 0000:02:05.0 e100 interrupts enabled, disa=
bling
[   14.931117] PCI: Transparent bridge - 0000:00:1e.0
[   14.931698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   14.931840] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   14.944154] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12 14 =
15)
[   14.944277] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12 14 =
15)
[   14.944397] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 =
15)
[   14.944517] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 =
15)
[   14.944636] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 1=
5) *0, disabled.
[   14.944757] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 1=
5) *0, disabled.
[   14.944878] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 *11 12 14 =
15)
[   14.944999] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 =
15)
[   14.945119] Linux Plug and Play Support v0.97 (c) Adam Belay
[   14.945133] pnp: PnP ACPI init
[   14.945146] ACPI: bus type pnp registered
[   14.948478] pnp: PnP ACPI: found 15 devices
[   14.948482] ACPI: ACPI bus type pnp unregistered
[   14.948488] PnPBIOS: Disabled by ACPI PNP
[   14.948552] PCI: Using ACPI for IRQ routing
[   14.948556] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it h=
elps, post a report
[   14.976016] NET: Registered protocol family 8
[   14.976019] NET: Registered protocol family 20
[   14.976113] pnp: 00:00: iomem range 0xca000-0xcbfff has been reserved
[   14.976116] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
[   14.976119] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[   14.976122] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
[   14.976131] pnp: 00:03: ioport range 0x400-0x4bf could not be reserved
[   14.978964] Time: tsc clocksource has been installed.
[   15.006467] PCI: Bridge: 0000:00:01.0
[   15.006470]   IO window: c000-cfff
[   15.006476]   MEM window: f8000000-f9ffffff
[   15.006480]   PREFETCH window: f4000000-f7ffffff
[   15.006486] PCI: Bridge: 0000:02:0c.0
[   15.006489]   IO window: a000-afff
[   15.006495]   MEM window: fb000000-fcffffff
[   15.006499]   PREFETCH window: disabled.
[   15.006505] PCI: Bridge: 0000:00:1e.0
[   15.006508]   IO window: a000-bfff
[   15.006514]   MEM window: fa000000-fdffffff
[   15.006518]   PREFETCH window: 30000000-300fffff
[   15.006538] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   15.006571] NET: Registered protocol family 2
[   15.042878] IP route cache hash table entries: 4096 (order: 2, 16384 byte=
s)
[   15.042948] TCP established hash table entries: 16384 (order: 5, 196608 b=
ytes)
[   15.043132] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[   15.043256] TCP: Hash tables configured (established 16384 bind 16384)
[   15.043259] TCP reno registered
[   15.054951] checking if image is initramfs... it is
[   15.505709] Switched to high resolution mode on CPU 0
[   15.774974] Freeing initrd memory: 7815k freed
[   15.775479] audit: initializing netlink socket (disabled)
[   15.775502] audit(1195777890.092:1): initialized
[   15.778005] VFS: Disk quotas dquot_6.5.1
[   15.778080] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   15.778208] io scheduler noop registered
[   15.778211] io scheduler anticipatory registered
[   15.778213] io scheduler deadline registered
[   15.778232] io scheduler cfq registered (default)
[   15.778285] Boot video device is 0000:01:00.0
[   15.778542] isapnp: Scanning for PnP cards...
[   16.132108] isapnp: No Plug & Play device found
[   16.164344] Real Time Clock Driver v1.12ac
[   16.164459] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ shar=
ing enabled
[   16.164563] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   16.164810] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[   16.165629] 00:0a: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   16.166001] 00:0b: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[   16.166289] ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 17 (level, low) ->=
 IRQ 16
[   16.166298] ACPI: PCI interrupt for device 0000:03:05.0 disabled
[   16.167003] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 =
blocksize
[   16.167296] input: Macintosh mouse button emulation as /class/input/input=
0
[   16.167402] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[   16.170545] serio: i8042 KBD port at 0x60,0x64 irq 1
[   16.170555] serio: i8042 AUX port at 0x60,0x64 irq 12
[   16.170810] mice: PS/2 mouse device common for all mice
[   16.170956] EISA: Probing bus 0 at eisa.0
[   16.170999] EISA: Detected 0 cards.
[   16.171130] TCP cubic registered
[   16.171145] NET: Registered protocol family 1
[   16.171175] Using IPI No-Shortcut mode
[   16.171375]   Magic number: 15:233:507
[   16.172194] Freeing unused kernel memory: 364k freed
[   16.208105] input: AT Translated Set 2 keyboard as /class/input/input1
[   17.409515] AppArmor: AppArmor initialized<5>audit(1195777891.592:2):  ty=
pe=3D1505 info=3D"AppArmor initialized" pid=3D1185
[   17.419527] fuse init (API version 7.8)
[   17.426779] Failure registering capabilities with primary security module=
.
[   17.438422] ACPI: Fan [FAN] (on)
[   17.444836] ACPI: Processor [CPU0] (supports 2 throttling states)
[   17.446643] ACPI: Thermal Zone [THRM] (36 C)
[   17.463536] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: =
dm-devel@redhat.com
[   17.483493] md: linear personality registered for level -1
[   17.489218] md: multipath personality registered for level -4
[   17.494652] md: raid0 personality registered for level 0
[   17.500746] md: raid1 personality registered for level 1
[   17.506004] raid5: automatically using best checksumming function: pIII_s=
se
[   17.524858]    pIII_sse  :  3068.000 MB/sec
[   17.524861] raid5: using function: pIII_sse (3068.000 MB/sec)
[   17.592770] raid6: int32x1    672 MB/s
[   17.660616] raid6: int32x2    658 MB/s
[   17.728457] raid6: int32x4    654 MB/s
[   17.796219] raid6: int32x8    462 MB/s
[   17.864072] raid6: mmxx1     1924 MB/s
[   17.931894] raid6: mmxx2     2467 MB/s
[   17.999725] raid6: sse1x1    1150 MB/s
[   18.067567] raid6: sse1x2    2167 MB/s
[   18.135411] raid6: sse2x1    1948 MB/s
[   18.203239] raid6: sse2x2    2691 MB/s
[   18.203242] raid6: using algorithm sse2x2 (2691 MB/s)
[   18.203246] md: raid6 personality registered for level 6
[   18.203248] md: raid5 personality registered for level 5
[   18.203250] md: raid4 personality registered for level 4
[   18.231003] md: raid10 personality registered for level 10
[   18.904221] SCSI subsystem initialized
[   18.910522] libata version 2.21 loaded.
[   18.914988] ata_piix 0000:00:1f.1: version 2.11
[   18.915071] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   18.915180] scsi0 : ata_piix
[   18.915234] scsi1 : ata_piix
[   18.915360] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0=
x0001f000 irq 14
[   18.915363] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0=
x0001f008 irq 15
[   18.943819] usbcore: registered new interface driver usbfs
[   18.943852] usbcore: registered new interface driver hub
[   18.943881] usbcore: registered new device driver usb
[   18.945026] USB Universal Host Controller Interface driver v3.0
[   18.990850] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
[   18.990854] e100: Copyright(c) 1999-2006 Intel Corporation
[   19.075378] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI=
) Driver
[   19.077615] ata1.00: ATA-5: MAXTOR 6L080J4, A93.0500, max UDMA/133
[   19.077620] ata1.00: 156355584 sectors, multi 16: LBA=20
[   19.093551] ata1.00: configured for UDMA/100
[   19.194136] Floppy drive(s): fd0 is 1.44M
[   19.230962] FDC 0 is a post-1991 82077
[   19.404705] ata2.00: ATAPI: TSSTcorpDVD-ROM TS-H352A, TS04, max UDMA/33
[   19.568315] ata2.00: configured for UDMA/33
[   19.568475] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR 6L080J4   A93=
. PQ: 0 ANSI: 5
[   19.569077] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD-ROM TS-H352A TS0=
4 PQ: 0 ANSI: 5
[   19.569302] ACPI: PCI Interrupt 0000:00:1f.2[D] -> GSI 19 (level, low) ->=
 IRQ 17
[   19.569316] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   19.569320] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[   19.569537] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus n=
umber 1
[   19.569570] uhci_hcd 0000:00:1f.2: irq 17, io base 0x0000d000
[   19.569725] usb usb1: configuration #1 chosen from 1 choice
[   19.569758] hub 1-0:1.0: USB hub found
[   19.569771] hub 1-0:1.0: 2 ports detected
[   19.591472] sd 0:0:0:0: [sda] 156355584 512-byte hardware sectors (80054 =
MB)
[   19.591540] sd 0:0:0:0: [sda] Write Protect is off
[   19.591544] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   19.591572] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[   19.591655] sd 0:0:0:0: [sda] 156355584 512-byte hardware sectors (80054 =
MB)
[   19.591667] sd 0:0:0:0: [sda] Write Protect is off
[   19.591670] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   19.591689] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[   19.591697]  sda: sda1 sda2 sda3
[   19.611659] sd 0:0:0:0: [sda] Attached SCSI disk
[   19.617475] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.617648] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   19.647843] sr0: scsi3-mmc drive: 1x/48x cd/rw xa/form2 cdda tray
[   19.647851] Uniform CD-ROM driver Revision: 3.20
[   19.648183] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   19.671907] ACPI: PCI Interrupt 0000:00:1f.4[C] -> GSI 23 (level, low) ->=
 IRQ 18
[   19.671923] PCI: Setting latency timer of device 0000:00:1f.4 to 64
[   19.671928] uhci_hcd 0000:00:1f.4: UHCI Host Controller
[   19.671956] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus n=
umber 2
[   19.671986] uhci_hcd 0000:00:1f.4: irq 18, io base 0x0000d800
[   19.672107] usb usb2: configuration #1 chosen from 1 choice
[   19.672147] hub 2-0:1.0: USB hub found
[   19.672157] hub 2-0:1.0: 2 ports detected
[   19.775803] ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 22 (level, low) ->=
 IRQ 19
[   19.799925] e100: eth0: e100_probe: addr 0xfd100000, irq 19, MAC addr 00:=
D0:C9:90:89:1F
[   19.800466] ACPI: PCI Interrupt 0000:03:0a.0[B] -> GSI 19 (level, low) ->=
 IRQ 17
[   19.800486] ohci_hcd 0000:03:0a.0: OHCI Host Controller
[   19.800535] ohci_hcd 0000:03:0a.0: new USB bus registered, assigned bus n=
umber 3
[   19.800555] ohci_hcd 0000:03:0a.0: irq 17, io mem 0xfc002000
[   19.857422] usb usb3: configuration #1 chosen from 1 choice
[   19.857460] hub 3-0:1.0: USB hub found
[   19.857474] hub 3-0:1.0: 2 ports detected
[   19.959225] ACPI: PCI Interrupt 0000:03:0a.1[C] -> GSI 16 (level, low) ->=
 IRQ 20
[   19.959248] ohci_hcd 0000:03:0a.1: OHCI Host Controller
[   19.959279] ohci_hcd 0000:03:0a.1: new USB bus registered, assigned bus n=
umber 4
[   19.959300] ohci_hcd 0000:03:0a.1: irq 20, io mem 0xfc003000
[   19.991551] Attempting manual resume
[   19.991556] swsusp: Resume From Partition 8:2
[   19.991558] PM: Checking swsusp image.
[   19.996416] PM: Resume from disk failed.
[   20.009496] SGI XFS with ACLs, security attributes, realtime, large block=
 numbers, no debug enabled
[   20.017079] usb usb4: configuration #1 chosen from 1 choice
[   20.017116] hub 4-0:1.0: USB hub found
[   20.017134] hub 4-0:1.0: 2 ports detected
[   20.019298] SGI XFS Quota Management subsystem
[   20.033379] XFS mounting filesystem sda3
[   20.117538] Ending clean XFS mount for filesystem: sda3
[   20.118850] ACPI: PCI Interrupt 0000:03:0a.2[D] -> GSI 17 (level, low) ->=
 IRQ 16
[   20.118872] ohci_hcd 0000:03:0a.2: OHCI Host Controller
[   20.118904] ohci_hcd 0000:03:0a.2: new USB bus registered, assigned bus n=
umber 5
[   20.118926] ohci_hcd 0000:03:0a.2: irq 16, io mem 0xfc004000
[   20.176665] usb usb5: configuration #1 chosen from 1 choice
[   20.176701] hub 5-0:1.0: USB hub found
[   20.176717] hub 5-0:1.0: 2 ports detected
[   20.278634] ACPI: PCI Interrupt 0000:03:0a.3[A] -> GSI 18 (level, low) ->=
 IRQ 21
[   20.278652] ehci_hcd 0000:03:0a.3: EHCI Host Controller
[   20.278689] ehci_hcd 0000:03:0a.3: new USB bus registered, assigned bus n=
umber 6
[   20.278732] ehci_hcd 0000:03:0a.3: debug port 1
[   20.278740] PCI: cache line size of 128 is not supported by device 0000:0=
3:0a.3
[   20.302224] ehci_hcd 0000:03:0a.3: irq 21, io mem 0xfc005000
[   20.302237] ehci_hcd 0000:03:0a.3: USB 2.0 started, EHCI 1.00, driver 10 =
Dec 2004
[   20.302375] usb usb6: configuration #1 chosen from 1 choice
[   20.302409] hub 6-0:1.0: USB hub found
[   20.302419] hub 6-0:1.0: 6 ports detected
[   27.078188] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[   27.977197] NET: Registered protocol family 10
[   27.977306] lo: Disabled Privacy Extensions
[   28.812956] Linux agpgart interface v0.102 (c) Dave Jones
[   28.861554] agpgart: Detected an Intel 845G Chipset.
[   28.865395] agpgart: AGP aperture is 64M @ 0xf0000000
[   28.888183] iTCO_vendor_support: vendor-support=3D0
[   28.897534] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   28.897664] iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by =
hardware
[   28.897674] iTCO_wdt: No card detected
[   29.008865] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   29.019142] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   29.305581] intel_rng: FWH not detected
[   30.031895] input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
[   30.068569] MOXA Smartio/Industio family driver version 1.11
[   30.117801] Found MOXA C168H/PCI series board(BusNo=3D3,DevNo=3D5)
[   30.117820] ACPI: PCI Interrupt 0000:03:05.0[A] -> GSI 17 (level, low) ->=
 IRQ 16
[   30.117852]         ttyM0 - ttyM7  max. baud rate =3D 921600 bps.
[   30.161967] input: PC Speaker as /class/input/input3
[   30.196428] parport_pc 00:0c: reported by Plug and Play ACPI
[   30.196529] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRIS=
TATE,COMPAT,EPP,ECP,DMA]
[   31.624526] lp0: using parport0 (interrupt-driven).
[   31.686801] Adding 499960k swap on /dev/sda2.  Priority:-1 extents:1 acro=
ss:499960k
[   32.400711] kjournald starting.  Commit interval 5 seconds
[   32.405440] EXT3 FS on sda1, internal journal
[   32.405445] EXT3-fs: mounted filesystem with ordered data mode.
[   35.132896] No dock devices found.
[   35.215961] input: Power Button (FF) as /class/input/input4
[   35.221366] ACPI: Power Button (FF) [PWRF]
[   35.265194] input: Power Button (CM) as /class/input/input5
[   35.270607] ACPI: Power Button (CM) [PWRB]
[   37.533273] ppdev: user-space parallel port driver
[   37.761296] audit(1195777912.954:3):  type=3D1503 operation=3D"inode_perm=
ission" requested_mask=3D"a" denied_mask=3D"a" name=3D"/dev/tty" pid=3D4985 =
profile=3D"/usr/sbin/cupsd"
[   37.866030] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   37.866037] apm: overridden by ACPI.
[   38.175378] eth0: no IPv6 routers present
[   98.828402] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   98.906439] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recove=
ry directory
[   98.915268] NFSD: starting 90-second grace period
[   99.242128] Failure registering capabilities with primary security module=
.
[   99.451268] Bluetooth: Core ver 2.11
[   99.451425] NET: Registered protocol family 31
[   99.451428] Bluetooth: HCI device and connection manager initialized
[   99.451433] Bluetooth: HCI socket layer initialized
[   99.467573] Bluetooth: L2CAP ver 2.8
[   99.467580] Bluetooth: L2CAP socket layer initialized
[   99.544904] Bluetooth: RFCOMM socket layer initialized
[   99.545029] Bluetooth: RFCOMM TTY layer initialized
[   99.545032] Bluetooth: RFCOMM ver 1.8
[  102.487355] [drm] Initialized drm 1.1.0 20060810
[  102.497734] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) ->=
 IRQ 20
[  102.501113] [drm] Initialized r128 2.5.0 20030725 on minor 0
[  102.501993] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[  102.502248] agpgart: Putting AGP V2 device at 0000:00:00.0 into 1x mode
[  102.502427] agpgart: Putting AGP V2 device at 0000:01:00.0 into 1x mode
[  103.227878] apc8620: VID =3D 0x10B5
[  103.227881] apc8620: DID =3D 0x1024
[  103.227882] apc8620: physical addr =3D fc000000
[  103.227900] apc8620: mapped addr =3D e0bc8000
[  103.229842] apc8620: registered carrier 0
[  103.229871] apc8620: interrupt data (0xe1083e40) on irq (10) and status (=
0x0)
[  103.239200] irq 16: nobody cared (try booting with the "irqpoll" option)
[  103.239239]  [<c015b594>] __report_bad_irq+0x24/0x80
[  103.239260]  [<c015b852>] note_interrupt+0x262/0x2a0
[  103.239280]  [<c015aab0>] handle_IRQ_event+0x30/0x60
[  103.239293]  [<c015c23b>] handle_fasteoi_irq+0xbb/0xf0
[  103.239306]  [<c0106b1b>] do_IRQ+0x3b/0x70
[  103.239327]  [<c0105223>] common_interrupt+0x23/0x30
[  103.239371]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
[  103.239373] handlers:
[  103.239375] [<e09606a0>] (usb_hcd_irq+0x0/0x60 [usbcore])
[  103.239398] [<e0adaaf0>] (mxser_interrupt+0x0/0x260 [mxser])
[  103.239408] Disabling IRQ #16
[  103.351490] Registering ccd_driver is a success
[  103.351497] The major ccd device number is 253.

--=_1s3ygnmwbcl--
