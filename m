Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbXLRRJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbXLRRJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 12:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760976AbXLRRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 12:08:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:11968 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762099AbXLRRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 12:08:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=kmyS8pHMZe/lW5OZA5yBF+5QXxPwgJkLpaPAXKNUTtdSBuDjqq7zWx3oyo7WgyakTYpHkySEcS+GbApb1u3LE7sRHs7lS+L0zrdRM6qavEA0OUrZlTWf036XUOFy7ciWxe4h/3g46Iife+UvQ8QzOglcwSbk/JxAsbhtBGYTUZQ=
Date: Tue, 18 Dec 2007 18:09:03 +0100
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-pcmcia@lists.infradead.org,
       linux-main <linux-kernel@vger.kernel.org>
Subject: (RESEND) [HP6XX] - Still issues with pcmcia driver (HD64461)
Message-Id: <20071218180903.8cf814c3.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__18_Dec_2007_18_09_03_+0100_erpQM3NPncR8WIzd"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__18_Dec_2007_18_09_03_+0100_erpQM3NPncR8WIzd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Unable to get any respons from the linux-pcmcia list so putting this in main. Must be some pcmcia guru out there.

Greetings,

I'm getting nowhere with this.

IRQ 78 using IRQF_SHARED to handle both socket and inserted pcmcia card. I've set so socket interrupt returns IRQ_NONE when it sees that it belongs to PCMCIA_CARD_IRQ. This should mean that the interrupt should dropped from socket interrupt and be taken up by the card interrupt handler.
For whatever reason the pcmcia subsystem hasn't setup any PCMCIA_CARD_IRQ handler and I get a kernel panic "irq 78: nobody cared (try booting with the "irqpoll" option)".

In /sys/devices/platform/hd64461-pcmcia/ I see :
driver, modalias, power, pcmcia_socket, subsystem, uevent. And I know that pcmcia_register_socket is successfull.

If I remove the IRQ_NONE return but still only handle the SOCKET_IRQ requests it detects insertion / removal properly but obviously non-working.

In short, I need to make sure the PCMCIA_CARD_IRQ is properly setup by the pcmcia_subsystem (or manually request it in driver).

Best wishes
Kristoffer Ericson


/*
 * drivers/pcmcia/hd64461_ss.c
 *
 * PCMCIA platform driver for Hitachi HD64461 companion chip
 * Copyright (C) 2006-2007 Kristoffer Ericson <kristoffer.ericson@gmail.com>
 *
 * This driver is based on hd64461_ss.c that was maintained in LinuxSH cvs before merger with mainline
 * by
 * COPYRIGHT (C) 2002-2005 Andriy Skulysh <askulysh@image.kiev.ua>
 * COPYRIGHT (C) ?  Greg Banks <gbanks@pocketpenguins.com>
 * COPYRIGHT (C) 2000 YAEGASHI Takeshi
 *
 * Please note that although the hd64461 chipset supports two sockets (0 & 1) this driver only
 * supports the PCMCIA one. The CF slot cannot handle anything other than memory cards, so its
 * better to leave support for that on libata.
 *
 */
#include <linux/autoconf.h>
#include <linux/types.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/string.h>
#include <linux/kernel.h>
#include <linux/ioport.h>
#include <linux/mm.h>
#include <linux/vmalloc.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/platform_device.h>

#include <pcmcia/cs_types.h>
#include <pcmcia/cs.h>
#include <pcmcia/ss.h>
#include <pcmcia/bulkmem.h>
#include <pcmcia/cistpl.h>

#include "cs_internal.h"

#include <asm/io.h>
#include <asm/hd64461.h>
#include <asm/hp6xx.h>

#define MODNAME "HD64461_ss"

/*
 *
 * Our socket implementation
 **************************************/
typedef struct hd64461_socket_t {
	u8			cscier;
	unsigned int		irq;
	unsigned long		mem_base;
	socket_state_t		state;
	pccard_mem_map		mem_maps[MAX_WIN];
	unsigned char		IC_memory;
	struct pcmcia_socket	socket;
} hd64461_socket_t;

/* socket declaration */
static hd64461_socket_t hd64461_sockets[CONFIG_HD64461_PCMCIA_SOCKETS];

/*
 * hd64461_set_voltage(int Vcc, int Vpp)
 *
 * returns : %1 on success (no error checking!)
 */
static int hd64461_set_voltage(int Vcc, int Vpp)
{
	u8 gcr, scr;
	u16 stbcr;
	u32 gcr_reg = HD64461_PCC0GCR;
	u32 scr_reg = HD64461_PCC0SCR;
	
	gcr = inb(gcr_reg);
	scr = inb(scr_reg);

	/* Handling voltage control pins */
	switch (Vcc) {
	case 0:
		gcr |= HD64461_PCCGCR_VCC0;
		scr |= HD64461_PCCSCR_VCC1;
		break;
	case 33:
		gcr |= HD64461_PCCGCR_VCC0; 
		scr &= ~HD64461_PCCSCR_VCC1;
		break;
	case 50:
		gcr &= ~HD64461_PCCGCR_VCC0;
		scr &= ~HD64461_PCCSCR_VCC1;
		break;
	}

	outb(gcr, gcr_reg);
	outb(scr, scr_reg);

	stbcr = inw(HD64461_STBCR);

	if (Vcc > 0) {
		stbcr &= ~HD64461_STBCR_SPC0ST;
	} else {
		stbcr |= HD64461_STBCR_SPC0ST;
	}

	outw(stbcr, HD64461_STBCR);

	return 1;
}

static int hd64461_init(struct pcmcia_socket *s)
{
	u16 gpadr;
	hd64461_socket_t *sp = container_of(s, struct hd64461_socket_t, socket);

	printk(KERN_INFO "hd64461_ss: entering hd64461_init from pcmcia_register_socket\n");

	sp->state.Vcc = 0;
	sp->state.Vpp = 0;
	hd64461_set_voltage(0, 0);

	gpadr = inw(HD64461_GPADR);
	gpadr &= ~HD64461_GPADR_PCMCIA0;
	outw(gpadr, HD64461_GPADR);

	return 0;
}

static int hd64461_suspend(struct pcmcia_socket *s)
{
	u16 gpadr;
	u8 gcr;
	u32 gcr_reg = HD64461_PCC0GCR;

	gcr = inb(gcr_reg);
	gcr &= ~HD64461_PCCGCR_DRVE;
	outb(gcr, gcr_reg);
	hd64461_set_voltage(0, 0);

	gpadr = inw(HD64461_GPADR);
	gpadr |= HD64461_GPADR_PCMCIA0;
	outw(gpadr, HD64461_GPADR);
	
	return 0;
}

/*
 * hd64461_get_status(struct pcmcia_socket *s, u32 * value)
 *
 * 
 */
static int hd64461_get_status(struct pcmcia_socket *s, u32 *value)
{
	u8 isr;
	u32 status = 0;
	hd64461_socket_t *sp = container_of(s, struct hd64461_socket_t, socket);

	/* get status of pcmcia socket */
	isr = inb(HD64461_PCC0ISR);
	printk(KERN_INFO "hd64461_get_status: reading HD64461_PCC0ISR status %d\n", isr);

	/* is card inserted and powerd? */
	if ((isr & HD64461_PCCISR_PCD_MASK) == 0) {
//	if (isr & HD64461_PCCISR_PCD_MASK) {
		status |= SS_DETECT;

		/* If its an memory card, lets find out the voltage */
		if (sp->IC_memory) {
			switch (isr & HD64461_PCCISR_BVD_MASK) {
			case HD64461_PCCISR_BVD_BATGOOD:
				break;
			case HD64461_PCCISR_BVD_BATWARN:
				status |= SS_BATWARN;
				break;
			default:
				status |= SS_BATDEAD;
				break;
			}

			if (isr & HD64461_PCCISR_READY)
				status |= SS_READY;
			if (isr & HD64461_PCCISR_MWP)
				status |= SS_WRPROT;
		} else {
			if (isr & HD64461_PCCISR_BVD1)
			printk(KERN_INFO "get_status: status has changed! \n");
		    	status |= SS_STSCHG;
		}

		switch (isr & (HD64461_PCCISR_VS2 | HD64461_PCCISR_VS1)) {
		case HD64461_PCCISR_VS1:
			printk(KERN_INFO MODNAME
			       ": cannot handle X.XV card, ignored\n");
			status = 0;
			break;
		case 0:
		case HD64461_PCCISR_VS2:
			status |= SS_3VCARD;
			break;
		case HD64461_PCCISR_VS2 | HD64461_PCCISR_VS1:
			break;
		}

		if ((sp->state.Vcc != 0) || (sp->state.Vpp != 0))
			status |= SS_POWERON;
	}

	printk(KERN_INFO "get_status: returning status = %d\n", status);
	*value = status;
	return 0;
}

static int hd64461_set_socket(struct pcmcia_socket *s, socket_state_t * state)
{
	u32 flags;
	u32 changed;
	u8 gcr, cscier;
	hd64461_socket_t *sp = container_of(s, struct hd64461_socket_t, socket);
	u32 gcr_reg = HD64461_PCC0GCR;
	u32 cscier_reg = HD64461_PCC0CSCIER;

	printk(KERN_INFO "hd64461: entering hd64461_set_socket\n");

	/* no interruptions please */
	local_irq_save(flags);

	/* compair old power status with new */
	if (state->Vpp != sp->state.Vpp || state->Vcc != sp->state.Vcc) {
		if (!hd64461_set_voltage(state->Vcc, state->Vpp)) {
    			local_irq_restore(flags);
			printk(KERN_INFO "hd64461_set_socket: We've produced an EINVAL\n");
			return -EINVAL;
		}
	}

	/* lets only push the changes */
	changed = sp->state.csc_mask ^ state->csc_mask;
	cscier = inb(cscier_reg);

	/* set it so interrupt occurs when values of CD1 and CD2 are changed */
	if (changed & SS_DETECT) {
		if (state->csc_mask & SS_DETECT)
			cscier |= HD64461_PCCCSCIER_CDE;
		else
			cscier &= ~HD64461_PCCCSCIER_CDE;
	}

	/* set so interrupt occurs when pin changes from low -> high */
	if (changed & SS_READY) {
		if (state->csc_mask & SS_READY)
			cscier |= HD64461_PCCCSCIER_RE;
		else
			cscier &= ~HD64461_PCCCSCIER_RE;
	}

	/* set so interrupt occurs when BVD1 & BVD2 are set to bat_dead */
	if (changed & SS_BATDEAD) {
		if (state->csc_mask & SS_BATDEAD)
			cscier |= HD64461_PCCCSCIER_BDE;
		else
			cscier &= ~HD64461_PCCCSCIER_BDE;
	}

	/* set so interrupt occurs when BVD1 & BVD2 are set to bat_warn */
	if (changed & SS_BATWARN) {
		if (state->csc_mask & SS_BATWARN)
			cscier |= HD64461_PCCCSCIER_BWE;
		else
			cscier &= ~HD64461_PCCCSCIER_BWE;
	}

	/* set so "pccard connection" interrupt initializes PCC0SCR and PCC0GCR */
	if (changed & SS_STSCHG) {
		if (state->csc_mask & SS_STSCHG)
			cscier |= HD64461_PCCCSCIER_SCE;
		else
			cscier &= ~HD64461_PCCCSCIER_SCE;
	}

	outb(cscier, cscier_reg);

	changed = sp->state.flags ^ state->flags;

	gcr = inb(gcr_reg);

	if (changed & SS_IOCARD) {
		if (state->flags & SS_IOCARD) {
			if (s->sock == 1) {
				printk(KERN_INFO
				       "socket 1 can be only IC Memory card\n");
			} else {
				/* Reset the card and set as IO card */
				printk(KERN_INFO "hd64461_set_socket: Lets reset and set to IO card \n");
				gcr |= HD64461_PCCGCR_PCCT;
				sp->IC_memory = 0;
			}
		} else {
			/* Reset and set as memory card */
			gcr &= ~HD64461_PCCGCR_PCCT;
			sp->IC_memory = 1;
		}
	}

	/* if bit 3 = 0 while pccard accessed, output 1 on pccreg */
	if (changed & SS_RESET) {
    	    if (state->flags & SS_RESET)
			gcr |= HD64461_PCCGCR_PCCR;
		else
			gcr &= ~HD64461_PCCGCR_PCCR;
	}

	/* Set low level of external buffer */
	if (changed & SS_OUTPUT_ENA) {
		if (state->flags & SS_OUTPUT_ENA)
			gcr |= HD64461_PCCGCR_DRVE;
		else
			gcr &= ~HD64461_PCCGCR_DRVE;
	}

	outb(gcr, gcr_reg);

	sp->state = *state;

	/* enable interruptions */
	local_irq_restore(flags);

	printk(KERN_INFO "hd64461_set_socket: We've passed the routine successfully\n");

	return 0;
}

static int hd64461_set_io_map(struct pcmcia_socket *s, struct pccard_io_map *io)
{
	/* this is not needed due to static mappings */
	return 0;
}

static int hd64461_set_mem_map(struct pcmcia_socket *s,
			       struct pccard_mem_map *mem)
{
	hd64461_socket_t *sp = container_of(s, struct hd64461_socket_t, socket);
	struct pccard_mem_map *smem;
	int map = mem->map;
	unsigned long saddr;

	printk(KERN_INFO "hd64461: entering hd64461_set_mem_map\n");
	
	if (map >= MAX_WIN)
		return -EINVAL;

	/* lets setup pointers to memory */
	smem = &sp->mem_maps[map];
	saddr = sp->mem_base + mem->card_start;

	if (!(mem->flags & MAP_ATTRIB))
		saddr += HD64461_PCC_WINDOW;

	mem->static_start = saddr;
	*smem = *mem;

	return 0;
}

/*
 *
 * functions needed for operations
 **************************************/
static struct pccard_operations hd64461_operations = {
	.init = hd64461_init,
	.suspend = hd64461_suspend,
	.get_status = hd64461_get_status,
	.set_socket = hd64461_set_socket,
	.set_io_map = hd64461_set_io_map,
	.set_mem_map = hd64461_set_mem_map,
};

/* hd64461_interrupt()
 *
 * Here we check what caused the interrupt and
 * pass it on to pcmcia parser
 *
 ***************************************/
static irqreturn_t hd64461_interrupt(int irq, void *dev)
{
	hd64461_socket_t *sp = (hd64461_socket_t *) dev;
	unsigned events = 0;
	unsigned char cscr,cscr2;
	
	//printk(KERN_INFO "HD64461_SS: Interrupt 78\n");
	cscr = inb(HD64461_PCC0CSCR);

	/* If IREQ pin is in low state */
	if (cscr & HD64461_PCCCSCR_IREQ) {
	    if (!(cscr & HD64461_PCCCSCR_SC)) {
		cscr &= ~HD64461_PCCCSCR_IREQ;
		/* silence interrupt source and hand over interrupt */
		outb(cscr, HD64461_PCC0CSCR);
		cscr2 = inb(HD64461_PCC0CSCR);
		if (!(cscr2 & cscr))
		    printk(KERN_INFO "hd64461_interrupt: Pah! we are in bloody level mode!\n");
    		return IRQ_NONE;
	    }
	}

//	printk(KERN_INFO "HD64461_SS: Interrupt caused by Slot 0\n");

	/* if both CD1 and CD2 has changed */
	if (cscr & HD64461_PCCCSCR_CDC) {
		printk(KERN_INFO "HD64461_SS: We are inside the CD1/CD2 changed loop\n");
		/* silence it by writing a 0 to bit 3 */
		cscr &= ~HD64461_PCCCSCR_CDC;
		/* we've detected something being inserted or unplugged */
		events |= SS_DETECT;

		/* if CD1 and CD2 don't both display 1, we need to clean up */
		if (((inb(HD64461_PCC0ISR)) & HD64461_PCCISR_PCD_MASK) != 0) {
			cscr &= ~(HD64461_PCCCSCR_RC | HD64461_PCCCSCR_BW |
				  HD64461_PCCCSCR_BD | HD64461_PCCCSCR_SC);
		}
	}

	/* MEMORY CARD */
	if (sp->IC_memory) {
		if (cscr & HD64461_PCCCSCR_RC) {
			/* ? */
			cscr &= ~HD64461_PCCCSCR_RC;
			events |= SS_READY;
		}

		if (cscr & HD64461_PCCCSCR_BW) {
			/* battery warning */
			cscr &= ~HD64461_PCCCSCR_BW;
			events |= SS_BATWARN;
		}

		if (cscr & HD64461_PCCCSCR_BD) {
			/* battery dead */
			cscr &= ~HD64461_PCCCSCR_BD;
			events |= SS_BATDEAD;
		}
	} else { /* IO CARD */
		if (cscr & HD64461_PCCCSCR_SC) {
			/* status changed */
			cscr &= ~HD64461_PCCCSCR_SC;
			events |= SS_STSCHG;
		}
	}

	outb(cscr, HD64461_PCC0CSCR);

	/* make sure we push these changes into pcmcia events */
	if (events) {
		pcmcia_parse_events(&sp->socket, events);
	        printk(KERN_INFO "hd64461_interrupt: we are pushing changed events! events=%d\n", events);
	}


	return IRQ_HANDLED;
}

/*
 *hd_64461_init_socket()
 *
 * Add values to socket and link it with pcmcia operations
 *********************************************************/
int hd64461_init_socket(int sock, int irq, unsigned long mem_base,unsigned long io_offset)
{
	hd64461_socket_t *sp = &hd64461_sockets[sock];
	unsigned gcr_reg = HD64461_PCC0GCR;
	u8 gcr;
	int i, err;

	outb(0, HD64461_PCC0CSCIER);

	memset(sp, 0, sizeof(*sp));
	sp->IC_memory = 0;
	sp->irq = irq;
	//sp->socket.irq_mask = 0;
	sp->mem_base = mem_base;
	sp->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP | SS_CAP_PAGE_REGS;
	sp->socket.resource_ops = &pccard_static_ops;
	sp->socket.ops = &hd64461_operations;
	sp->socket.map_size = HD64461_PCC_WINDOW;	/* 16MB fixed window size */
	sp->socket.pci_irq = irq;
	sp->socket.io_offset = 0;
	sp->socket.owner = THIS_MODULE;

	for (i = 0; i != MAX_WIN; i++)
		sp->mem_maps[i].map = i;

	if ((request_irq(irq, hd64461_interrupt, IRQF_SHARED, "hd64461_ss-irq", sp)) < 0) {
		printk(KERN_INFO "hd64461_init: request for irq %d: failed\n", sp->irq);
		return -1;
	}
	
	gcr = inb(gcr_reg);
	/* continuous 16MB area mode for both memory and I/O operations */
	gcr |= HD64461_PCCGCR_PMMOD;
	/* ??? */
	gcr &= ~(HD64461_PCCGCR_PA25 | HD64461_PCCGCR_PA24);
	outb(gcr, gcr_reg);

	return 0;
}

void hd64461_exit_socket(int sock)
{
	hd64461_socket_t *sp = &hd64461_sockets[0];
	unsigned cscier_reg = HD64461_PCC0CSCIER;

	printk(KERN_INFO "hd64461_exit_socket: cleaning up irq %d and %d\n", sp->irq, sp->socket.pci_irq);

	outb(0, cscier_reg);
	hd64461_suspend(&sp->socket);

}

static int __devexit hd64461_pcmcia_drv_remove(struct platform_device *dev)
{
	/* Libpata handles CF slot, so we only handle PCMCIA slot */
	pcmcia_unregister_socket(&hd64461_sockets[0].socket);
	hd64461_exit_socket(0);

	return 0;
}

#ifdef CONFIG_PM
static int hd64461_pcmcia_drv_suspend(struct platform_device *dev, pm_message_t state)
{
	int ret = 0;
	int i;

	u32 cscier_reg = HD64461_PCC0CSCIER;
	hd64461_sockets[0].cscier = inb(cscier_reg);
	outb(0, cscier_reg);
	ret = pcmcia_socket_dev_suspend(&dev->dev, state);

 	return ret;
 }

static int hd64461_pcmcia_drv_resume(struct platform_device *dev)
{
	int ret = 0;
	int i;

	u32 cscier_reg = HD64461_PCC0CSCIER;
	outb(hd64461_sockets[0].cscier, cscier_reg);
	ret = pcmcia_socket_dev_resume(&dev->dev);

	return ret;
}
#endif

static struct platform_driver hd64461_pcmcia_driver = {
	.remove = __devexit_p(hd64461_pcmcia_drv_remove),
#ifdef CONFIG_PM
	.suspend = hd64461_pcmcia_drv_suspend,
	.resume = hd64461_pcmcia_drv_resume,
#endif
	.driver		= {
		.name	= "hd64461-pcmcia",
	},
};

static struct platform_device *hd64461_pcmcia_device;

static int __init init_hd64461_ss(void)
{
	int i;

	printk(KERN_INFO "hd64461_ss_init: pcmcia driver for hd64461 chipset started\n");

        if (platform_driver_register(&hd64461_pcmcia_driver))
	    goto failed1;

	i = hd64461_init_socket(0, HD64461_IRQ_PCC0, HD64461_PCC0_BASE, 0x0);
        if (i < 0) 
	    goto failed2;

        
	hd64461_pcmcia_device = platform_device_alloc("hd64461-pcmcia",-1);
	if(!hd64461_pcmcia_device) {
	    printk(KERN_INFO "hd64461_ss_init: Cannot find pcmcia device!\n");
	    return -ENODEV;
	}

	i = platform_device_add(hd64461_pcmcia_device);
	if (i) {
	    platform_device_put(hd64461_pcmcia_device);
	    printk(KERN_INFO "hd64461_ss_init: Cannot add pcmcia device, return value %d\n",i);
	    return -ENODEV;
	}

	/* Lets register the pcmcia socket */
	printk(KERN_INFO "hd64461_ss_init: setting socket device\n");
	hd64461_sockets[0].socket.dev.parent = &hd64461_pcmcia_device->dev;
	
	i = pcmcia_register_socket(&hd64461_sockets[0].socket);
	printk(KERN_INFO "hd64461_ss_init: return value %d from pcmcia_register_socket\n", i);
	
	return 0;

/* Unregister driver nothing else */
failed1:
	printk(KERN_INFO "hd64461_ss_init: Failed registering pcmcia platform driver\n");
	platform_driver_unregister(&hd64461_pcmcia_driver);
	return -EINVAL;

/* Unregister driver nothing else */
failed2:
	printk(KERN_INFO "hd64461_ss_init: Failed to startup socket 0\n");
	platform_driver_unregister(&hd64461_pcmcia_driver);
	return i;
}

static void __exit exit_hd64461_ss(void)
{
	/* Only remove if there's something to remove */
	if (hd64461_pcmcia_device) {
	    platform_device_unregister(hd64461_pcmcia_device);
	    platform_driver_unregister(&hd64461_pcmcia_driver);
	}
}
module_init(init_hd64461_ss);
module_exit(exit_hd64461_ss);

MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
MODULE_DESCRIPTION("PCMCIA driver for Hitachi HD64461 companion chip");
MODULE_LICENSE("GPL");




--Multipart=_Tue__18_Dec_2007_18_09_03_+0100_erpQM3NPncR8WIzd
Content-Type: application/octet-stream;
 name="hd64461_ss.c"
Content-Disposition: attachment;
 filename="hd64461_ss.c"
Content-Transfer-Encoding: base64

LyoKICogZHJpdmVycy9wY21jaWEvaGQ2NDQ2MV9zcy5jCiAqCiAqIFBDTUNJQSBwbGF0Zm9ybSBk
cml2ZXIgZm9yIEhpdGFjaGkgSEQ2NDQ2MSBjb21wYW5pb24gY2hpcAogKiBDb3B5cmlnaHQgKEMp
IDIwMDYtMjAwNyBLcmlzdG9mZmVyIEVyaWNzb24gPGtyaXN0b2ZmZXIuZXJpY3NvbkBnbWFpbC5j
b20+CiAqCiAqIFRoaXMgZHJpdmVyIGlzIGJhc2VkIG9uIGhkNjQ0NjFfc3MuYyB0aGF0IHdhcyBt
YWludGFpbmVkIGluIExpbnV4U0ggY3ZzIGJlZm9yZSBtZXJnZXIgd2l0aCBtYWlubGluZQogKiBi
eQogKiBDT1BZUklHSFQgKEMpIDIwMDItMjAwNSBBbmRyaXkgU2t1bHlzaCA8YXNrdWx5c2hAaW1h
Z2Uua2lldi51YT4KICogQ09QWVJJR0hUIChDKSA/ICBHcmVnIEJhbmtzIDxnYmFua3NAcG9ja2V0
cGVuZ3VpbnMuY29tPgogKiBDT1BZUklHSFQgKEMpIDIwMDAgWUFFR0FTSEkgVGFrZXNoaQogKgog
KiBQbGVhc2Ugbm90ZSB0aGF0IGFsdGhvdWdoIHRoZSBoZDY0NDYxIGNoaXBzZXQgc3VwcG9ydHMg
dHdvIHNvY2tldHMgKDAgJiAxKSB0aGlzIGRyaXZlciBvbmx5CiAqIHN1cHBvcnRzIHRoZSBQQ01D
SUEgb25lLiBUaGUgQ0Ygc2xvdCBjYW5ub3QgaGFuZGxlIGFueXRoaW5nIG90aGVyIHRoYW4gbWVt
b3J5IGNhcmRzLCBzbyBpdHMKICogYmV0dGVyIHRvIGxlYXZlIHN1cHBvcnQgZm9yIHRoYXQgb24g
bGliYXRhLgogKgogKi8KI2luY2x1ZGUgPGxpbnV4L2F1dG9jb25mLmg+CiNpbmNsdWRlIDxsaW51
eC90eXBlcy5oPgojaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiNpbmNsdWRlIDxsaW51eC9pbml0
Lmg+CiNpbmNsdWRlIDxsaW51eC9zdHJpbmcuaD4KI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgoj
aW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+CiNpbmNsdWRlIDxsaW51eC9tbS5oPgojaW5jbHVkZSA8
bGludXgvdm1hbGxvYy5oPgojaW5jbHVkZSA8bGludXgvaXJxLmg+CiNpbmNsdWRlIDxsaW51eC9p
bnRlcnJ1cHQuaD4KI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgoKI2luY2x1ZGUg
PHBjbWNpYS9jc190eXBlcy5oPgojaW5jbHVkZSA8cGNtY2lhL2NzLmg+CiNpbmNsdWRlIDxwY21j
aWEvc3MuaD4KI2luY2x1ZGUgPHBjbWNpYS9idWxrbWVtLmg+CiNpbmNsdWRlIDxwY21jaWEvY2lz
dHBsLmg+CgojaW5jbHVkZSAiY3NfaW50ZXJuYWwuaCIKCiNpbmNsdWRlIDxhc20vaW8uaD4KI2lu
Y2x1ZGUgPGFzbS9oZDY0NDYxLmg+CiNpbmNsdWRlIDxhc20vaHA2eHguaD4KCiNkZWZpbmUgTU9E
TkFNRSAiSEQ2NDQ2MV9zcyIKCi8qCiAqCiAqIE91ciBzb2NrZXQgaW1wbGVtZW50YXRpb24KICoq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqLwp0eXBlZGVmIHN0cnVjdCBoZDY0
NDYxX3NvY2tldF90IHsKCXU4CQkJY3NjaWVyOwoJdW5zaWduZWQgaW50CQlpcnE7Cgl1bnNpZ25l
ZCBsb25nCQltZW1fYmFzZTsKCXNvY2tldF9zdGF0ZV90CQlzdGF0ZTsKCXBjY2FyZF9tZW1fbWFw
CQltZW1fbWFwc1tNQVhfV0lOXTsKCXVuc2lnbmVkIGNoYXIJCUlDX21lbW9yeTsKCXN0cnVjdCBw
Y21jaWFfc29ja2V0CXNvY2tldDsKfSBoZDY0NDYxX3NvY2tldF90OwoKLyogc29ja2V0IGRlY2xh
cmF0aW9uICovCnN0YXRpYyBoZDY0NDYxX3NvY2tldF90IGhkNjQ0NjFfc29ja2V0c1tDT05GSUdf
SEQ2NDQ2MV9QQ01DSUFfU09DS0VUU107CgovKgogKiBoZDY0NDYxX3NldF92b2x0YWdlKGludCBW
Y2MsIGludCBWcHApCiAqCiAqIHJldHVybnMgOiAlMSBvbiBzdWNjZXNzIChubyBlcnJvciBjaGVj
a2luZyEpCiAqLwpzdGF0aWMgaW50IGhkNjQ0NjFfc2V0X3ZvbHRhZ2UoaW50IFZjYywgaW50IFZw
cCkKewoJdTggZ2NyLCBzY3I7Cgl1MTYgc3RiY3I7Cgl1MzIgZ2NyX3JlZyA9IEhENjQ0NjFfUEND
MEdDUjsKCXUzMiBzY3JfcmVnID0gSEQ2NDQ2MV9QQ0MwU0NSOwoJCglnY3IgPSBpbmIoZ2NyX3Jl
Zyk7CglzY3IgPSBpbmIoc2NyX3JlZyk7CgoJLyogSGFuZGxpbmcgdm9sdGFnZSBjb250cm9sIHBp
bnMgKi8KCXN3aXRjaCAoVmNjKSB7CgljYXNlIDA6CgkJZ2NyIHw9IEhENjQ0NjFfUENDR0NSX1ZD
QzA7CgkJc2NyIHw9IEhENjQ0NjFfUENDU0NSX1ZDQzE7CgkJYnJlYWs7CgljYXNlIDMzOgoJCWdj
ciB8PSBIRDY0NDYxX1BDQ0dDUl9WQ0MwOyAKCQlzY3IgJj0gfkhENjQ0NjFfUENDU0NSX1ZDQzE7
CgkJYnJlYWs7CgljYXNlIDUwOgoJCWdjciAmPSB+SEQ2NDQ2MV9QQ0NHQ1JfVkNDMDsKCQlzY3Ig
Jj0gfkhENjQ0NjFfUENDU0NSX1ZDQzE7CgkJYnJlYWs7Cgl9CgoJb3V0YihnY3IsIGdjcl9yZWcp
OwoJb3V0YihzY3IsIHNjcl9yZWcpOwoKCXN0YmNyID0gaW53KEhENjQ0NjFfU1RCQ1IpOwoKCWlm
IChWY2MgPiAwKSB7CgkJc3RiY3IgJj0gfkhENjQ0NjFfU1RCQ1JfU1BDMFNUOwoJfSBlbHNlIHsK
CQlzdGJjciB8PSBIRDY0NDYxX1NUQkNSX1NQQzBTVDsKCX0KCglvdXR3KHN0YmNyLCBIRDY0NDYx
X1NUQkNSKTsKCglyZXR1cm4gMTsKfQoKc3RhdGljIGludCBoZDY0NDYxX2luaXQoc3RydWN0IHBj
bWNpYV9zb2NrZXQgKnMpCnsKCXUxNiBncGFkcjsKCWhkNjQ0NjFfc29ja2V0X3QgKnNwID0gY29u
dGFpbmVyX29mKHMsIHN0cnVjdCBoZDY0NDYxX3NvY2tldF90LCBzb2NrZXQpOwoKCXByaW50ayhL
RVJOX0lORk8gImhkNjQ0NjFfc3M6IGVudGVyaW5nIGhkNjQ0NjFfaW5pdCBmcm9tIHBjbWNpYV9y
ZWdpc3Rlcl9zb2NrZXRcbiIpOwoKCXNwLT5zdGF0ZS5WY2MgPSAwOwoJc3AtPnN0YXRlLlZwcCA9
IDA7CgloZDY0NDYxX3NldF92b2x0YWdlKDAsIDApOwoKCWdwYWRyID0gaW53KEhENjQ0NjFfR1BB
RFIpOwoJZ3BhZHIgJj0gfkhENjQ0NjFfR1BBRFJfUENNQ0lBMDsKCW91dHcoZ3BhZHIsIEhENjQ0
NjFfR1BBRFIpOwoKCXJldHVybiAwOwp9CgpzdGF0aWMgaW50IGhkNjQ0NjFfc3VzcGVuZChzdHJ1
Y3QgcGNtY2lhX3NvY2tldCAqcykKewoJdTE2IGdwYWRyOwoJdTggZ2NyOwoJdTMyIGdjcl9yZWcg
PSBIRDY0NDYxX1BDQzBHQ1I7CgoJZ2NyID0gaW5iKGdjcl9yZWcpOwoJZ2NyICY9IH5IRDY0NDYx
X1BDQ0dDUl9EUlZFOwoJb3V0YihnY3IsIGdjcl9yZWcpOwoJaGQ2NDQ2MV9zZXRfdm9sdGFnZSgw
LCAwKTsKCglncGFkciA9IGludyhIRDY0NDYxX0dQQURSKTsKCWdwYWRyIHw9IEhENjQ0NjFfR1BB
RFJfUENNQ0lBMDsKCW91dHcoZ3BhZHIsIEhENjQ0NjFfR1BBRFIpOwoJCglyZXR1cm4gMDsKfQoK
LyoKICogaGQ2NDQ2MV9nZXRfc3RhdHVzKHN0cnVjdCBwY21jaWFfc29ja2V0ICpzLCB1MzIgKiB2
YWx1ZSkKICoKICogCiAqLwpzdGF0aWMgaW50IGhkNjQ0NjFfZ2V0X3N0YXR1cyhzdHJ1Y3QgcGNt
Y2lhX3NvY2tldCAqcywgdTMyICp2YWx1ZSkKewoJdTggaXNyOwoJdTMyIHN0YXR1cyA9IDA7Cglo
ZDY0NDYxX3NvY2tldF90ICpzcCA9IGNvbnRhaW5lcl9vZihzLCBzdHJ1Y3QgaGQ2NDQ2MV9zb2Nr
ZXRfdCwgc29ja2V0KTsKCgkvKiBnZXQgc3RhdHVzIG9mIHBjbWNpYSBzb2NrZXQgKi8KCWlzciA9
IGluYihIRDY0NDYxX1BDQzBJU1IpOwoJcHJpbnRrKEtFUk5fSU5GTyAiaGQ2NDQ2MV9nZXRfc3Rh
dHVzOiByZWFkaW5nIEhENjQ0NjFfUENDMElTUiBzdGF0dXMgJWRcbiIsIGlzcik7CgoJLyogaXMg
Y2FyZCBpbnNlcnRlZCBhbmQgcG93ZXJkPyAqLwoJaWYgKChpc3IgJiBIRDY0NDYxX1BDQ0lTUl9Q
Q0RfTUFTSykgPT0gMCkgewovLwlpZiAoaXNyICYgSEQ2NDQ2MV9QQ0NJU1JfUENEX01BU0spIHsK
CQlzdGF0dXMgfD0gU1NfREVURUNUOwoKCQkvKiBJZiBpdHMgYW4gbWVtb3J5IGNhcmQsIGxldHMg
ZmluZCBvdXQgdGhlIHZvbHRhZ2UgKi8KCQlpZiAoc3AtPklDX21lbW9yeSkgewoJCQlzd2l0Y2gg
KGlzciAmIEhENjQ0NjFfUENDSVNSX0JWRF9NQVNLKSB7CgkJCWNhc2UgSEQ2NDQ2MV9QQ0NJU1Jf
QlZEX0JBVEdPT0Q6CgkJCQlicmVhazsKCQkJY2FzZSBIRDY0NDYxX1BDQ0lTUl9CVkRfQkFUV0FS
TjoKCQkJCXN0YXR1cyB8PSBTU19CQVRXQVJOOwoJCQkJYnJlYWs7CgkJCWRlZmF1bHQ6CgkJCQlz
dGF0dXMgfD0gU1NfQkFUREVBRDsKCQkJCWJyZWFrOwoJCQl9CgoJCQlpZiAoaXNyICYgSEQ2NDQ2
MV9QQ0NJU1JfUkVBRFkpCgkJCQlzdGF0dXMgfD0gU1NfUkVBRFk7CgkJCWlmIChpc3IgJiBIRDY0
NDYxX1BDQ0lTUl9NV1ApCgkJCQlzdGF0dXMgfD0gU1NfV1JQUk9UOwoJCX0gZWxzZSB7CgkJCWlm
IChpc3IgJiBIRDY0NDYxX1BDQ0lTUl9CVkQxKQoJCQlwcmludGsoS0VSTl9JTkZPICJnZXRfc3Rh
dHVzOiBzdGF0dXMgaGFzIGNoYW5nZWQhIFxuIik7CgkJICAgIAlzdGF0dXMgfD0gU1NfU1RTQ0hH
OwoJCX0KCgkJc3dpdGNoIChpc3IgJiAoSEQ2NDQ2MV9QQ0NJU1JfVlMyIHwgSEQ2NDQ2MV9QQ0NJ
U1JfVlMxKSkgewoJCWNhc2UgSEQ2NDQ2MV9QQ0NJU1JfVlMxOgoJCQlwcmludGsoS0VSTl9JTkZP
IE1PRE5BTUUKCQkJICAgICAgICI6IGNhbm5vdCBoYW5kbGUgWC5YViBjYXJkLCBpZ25vcmVkXG4i
KTsKCQkJc3RhdHVzID0gMDsKCQkJYnJlYWs7CgkJY2FzZSAwOgoJCWNhc2UgSEQ2NDQ2MV9QQ0NJ
U1JfVlMyOgoJCQlzdGF0dXMgfD0gU1NfM1ZDQVJEOwoJCQlicmVhazsKCQljYXNlIEhENjQ0NjFf
UENDSVNSX1ZTMiB8IEhENjQ0NjFfUENDSVNSX1ZTMToKCQkJYnJlYWs7CgkJfQoKCQlpZiAoKHNw
LT5zdGF0ZS5WY2MgIT0gMCkgfHwgKHNwLT5zdGF0ZS5WcHAgIT0gMCkpCgkJCXN0YXR1cyB8PSBT
U19QT1dFUk9OOwoJfQoKCXByaW50ayhLRVJOX0lORk8gImdldF9zdGF0dXM6IHJldHVybmluZyBz
dGF0dXMgPSAlZFxuIiwgc3RhdHVzKTsKCSp2YWx1ZSA9IHN0YXR1czsKCXJldHVybiAwOwp9Cgpz
dGF0aWMgaW50IGhkNjQ0NjFfc2V0X3NvY2tldChzdHJ1Y3QgcGNtY2lhX3NvY2tldCAqcywgc29j
a2V0X3N0YXRlX3QgKiBzdGF0ZSkKewoJdTMyIGZsYWdzOwoJdTMyIGNoYW5nZWQ7Cgl1OCBnY3Is
IGNzY2llcjsKCWhkNjQ0NjFfc29ja2V0X3QgKnNwID0gY29udGFpbmVyX29mKHMsIHN0cnVjdCBo
ZDY0NDYxX3NvY2tldF90LCBzb2NrZXQpOwoJdTMyIGdjcl9yZWcgPSBIRDY0NDYxX1BDQzBHQ1I7
Cgl1MzIgY3NjaWVyX3JlZyA9IEhENjQ0NjFfUENDMENTQ0lFUjsKCglwcmludGsoS0VSTl9JTkZP
ICJoZDY0NDYxOiBlbnRlcmluZyBoZDY0NDYxX3NldF9zb2NrZXRcbiIpOwoKCS8qIG5vIGludGVy
cnVwdGlvbnMgcGxlYXNlICovCglsb2NhbF9pcnFfc2F2ZShmbGFncyk7CgoJLyogY29tcGFpciBv
bGQgcG93ZXIgc3RhdHVzIHdpdGggbmV3ICovCglpZiAoc3RhdGUtPlZwcCAhPSBzcC0+c3RhdGUu
VnBwIHx8IHN0YXRlLT5WY2MgIT0gc3AtPnN0YXRlLlZjYykgewoJCWlmICghaGQ2NDQ2MV9zZXRf
dm9sdGFnZShzdGF0ZS0+VmNjLCBzdGF0ZS0+VnBwKSkgewogICAgCQkJbG9jYWxfaXJxX3Jlc3Rv
cmUoZmxhZ3MpOwoJCQlwcmludGsoS0VSTl9JTkZPICJoZDY0NDYxX3NldF9zb2NrZXQ6IFdlJ3Zl
IHByb2R1Y2VkIGFuIEVJTlZBTFxuIik7CgkJCXJldHVybiAtRUlOVkFMOwoJCX0KCX0KCgkvKiBs
ZXRzIG9ubHkgcHVzaCB0aGUgY2hhbmdlcyAqLwoJY2hhbmdlZCA9IHNwLT5zdGF0ZS5jc2NfbWFz
ayBeIHN0YXRlLT5jc2NfbWFzazsKCWNzY2llciA9IGluYihjc2NpZXJfcmVnKTsKCgkvKiBzZXQg
aXQgc28gaW50ZXJydXB0IG9jY3VycyB3aGVuIHZhbHVlcyBvZiBDRDEgYW5kIENEMiBhcmUgY2hh
bmdlZCAqLwoJaWYgKGNoYW5nZWQgJiBTU19ERVRFQ1QpIHsKCQlpZiAoc3RhdGUtPmNzY19tYXNr
ICYgU1NfREVURUNUKQoJCQljc2NpZXIgfD0gSEQ2NDQ2MV9QQ0NDU0NJRVJfQ0RFOwoJCWVsc2UK
CQkJY3NjaWVyICY9IH5IRDY0NDYxX1BDQ0NTQ0lFUl9DREU7Cgl9CgoJLyogc2V0IHNvIGludGVy
cnVwdCBvY2N1cnMgd2hlbiBwaW4gY2hhbmdlcyBmcm9tIGxvdyAtPiBoaWdoICovCglpZiAoY2hh
bmdlZCAmIFNTX1JFQURZKSB7CgkJaWYgKHN0YXRlLT5jc2NfbWFzayAmIFNTX1JFQURZKQoJCQlj
c2NpZXIgfD0gSEQ2NDQ2MV9QQ0NDU0NJRVJfUkU7CgkJZWxzZQoJCQljc2NpZXIgJj0gfkhENjQ0
NjFfUENDQ1NDSUVSX1JFOwoJfQoKCS8qIHNldCBzbyBpbnRlcnJ1cHQgb2NjdXJzIHdoZW4gQlZE
MSAmIEJWRDIgYXJlIHNldCB0byBiYXRfZGVhZCAqLwoJaWYgKGNoYW5nZWQgJiBTU19CQVRERUFE
KSB7CgkJaWYgKHN0YXRlLT5jc2NfbWFzayAmIFNTX0JBVERFQUQpCgkJCWNzY2llciB8PSBIRDY0
NDYxX1BDQ0NTQ0lFUl9CREU7CgkJZWxzZQoJCQljc2NpZXIgJj0gfkhENjQ0NjFfUENDQ1NDSUVS
X0JERTsKCX0KCgkvKiBzZXQgc28gaW50ZXJydXB0IG9jY3VycyB3aGVuIEJWRDEgJiBCVkQyIGFy
ZSBzZXQgdG8gYmF0X3dhcm4gKi8KCWlmIChjaGFuZ2VkICYgU1NfQkFUV0FSTikgewoJCWlmIChz
dGF0ZS0+Y3NjX21hc2sgJiBTU19CQVRXQVJOKQoJCQljc2NpZXIgfD0gSEQ2NDQ2MV9QQ0NDU0NJ
RVJfQldFOwoJCWVsc2UKCQkJY3NjaWVyICY9IH5IRDY0NDYxX1BDQ0NTQ0lFUl9CV0U7Cgl9CgoJ
Lyogc2V0IHNvICJwY2NhcmQgY29ubmVjdGlvbiIgaW50ZXJydXB0IGluaXRpYWxpemVzIFBDQzBT
Q1IgYW5kIFBDQzBHQ1IgKi8KCWlmIChjaGFuZ2VkICYgU1NfU1RTQ0hHKSB7CgkJaWYgKHN0YXRl
LT5jc2NfbWFzayAmIFNTX1NUU0NIRykKCQkJY3NjaWVyIHw9IEhENjQ0NjFfUENDQ1NDSUVSX1ND
RTsKCQllbHNlCgkJCWNzY2llciAmPSB+SEQ2NDQ2MV9QQ0NDU0NJRVJfU0NFOwoJfQoKCW91dGIo
Y3NjaWVyLCBjc2NpZXJfcmVnKTsKCgljaGFuZ2VkID0gc3AtPnN0YXRlLmZsYWdzIF4gc3RhdGUt
PmZsYWdzOwoKCWdjciA9IGluYihnY3JfcmVnKTsKCglpZiAoY2hhbmdlZCAmIFNTX0lPQ0FSRCkg
ewoJCWlmIChzdGF0ZS0+ZmxhZ3MgJiBTU19JT0NBUkQpIHsKCQkJaWYgKHMtPnNvY2sgPT0gMSkg
ewoJCQkJcHJpbnRrKEtFUk5fSU5GTwoJCQkJICAgICAgICJzb2NrZXQgMSBjYW4gYmUgb25seSBJ
QyBNZW1vcnkgY2FyZFxuIik7CgkJCX0gZWxzZSB7CgkJCQkvKiBSZXNldCB0aGUgY2FyZCBhbmQg
c2V0IGFzIElPIGNhcmQgKi8KCQkJCXByaW50ayhLRVJOX0lORk8gImhkNjQ0NjFfc2V0X3NvY2tl
dDogTGV0cyByZXNldCBhbmQgc2V0IHRvIElPIGNhcmQgXG4iKTsKCQkJCWdjciB8PSBIRDY0NDYx
X1BDQ0dDUl9QQ0NUOwoJCQkJc3AtPklDX21lbW9yeSA9IDA7CgkJCX0KCQl9IGVsc2UgewoJCQkv
KiBSZXNldCBhbmQgc2V0IGFzIG1lbW9yeSBjYXJkICovCgkJCWdjciAmPSB+SEQ2NDQ2MV9QQ0NH
Q1JfUENDVDsKCQkJc3AtPklDX21lbW9yeSA9IDE7CgkJfQoJfQoKCS8qIGlmIGJpdCAzID0gMCB3
aGlsZSBwY2NhcmQgYWNjZXNzZWQsIG91dHB1dCAxIG9uIHBjY3JlZyAqLwoJaWYgKGNoYW5nZWQg
JiBTU19SRVNFVCkgewogICAgCSAgICBpZiAoc3RhdGUtPmZsYWdzICYgU1NfUkVTRVQpCgkJCWdj
ciB8PSBIRDY0NDYxX1BDQ0dDUl9QQ0NSOwoJCWVsc2UKCQkJZ2NyICY9IH5IRDY0NDYxX1BDQ0dD
Ul9QQ0NSOwoJfQoKCS8qIFNldCBsb3cgbGV2ZWwgb2YgZXh0ZXJuYWwgYnVmZmVyICovCglpZiAo
Y2hhbmdlZCAmIFNTX09VVFBVVF9FTkEpIHsKCQlpZiAoc3RhdGUtPmZsYWdzICYgU1NfT1VUUFVU
X0VOQSkKCQkJZ2NyIHw9IEhENjQ0NjFfUENDR0NSX0RSVkU7CgkJZWxzZQoJCQlnY3IgJj0gfkhE
NjQ0NjFfUENDR0NSX0RSVkU7Cgl9CgoJb3V0YihnY3IsIGdjcl9yZWcpOwoKCXNwLT5zdGF0ZSA9
ICpzdGF0ZTsKCgkvKiBlbmFibGUgaW50ZXJydXB0aW9ucyAqLwoJbG9jYWxfaXJxX3Jlc3RvcmUo
ZmxhZ3MpOwoKCXByaW50ayhLRVJOX0lORk8gImhkNjQ0NjFfc2V0X3NvY2tldDogV2UndmUgcGFz
c2VkIHRoZSByb3V0aW5lIHN1Y2Nlc3NmdWxseVxuIik7CgoJcmV0dXJuIDA7Cn0KCnN0YXRpYyBp
bnQgaGQ2NDQ2MV9zZXRfaW9fbWFwKHN0cnVjdCBwY21jaWFfc29ja2V0ICpzLCBzdHJ1Y3QgcGNj
YXJkX2lvX21hcCAqaW8pCnsKCS8qIHRoaXMgaXMgbm90IG5lZWRlZCBkdWUgdG8gc3RhdGljIG1h
cHBpbmdzICovCglyZXR1cm4gMDsKfQoKc3RhdGljIGludCBoZDY0NDYxX3NldF9tZW1fbWFwKHN0
cnVjdCBwY21jaWFfc29ja2V0ICpzLAoJCQkgICAgICAgc3RydWN0IHBjY2FyZF9tZW1fbWFwICpt
ZW0pCnsKCWhkNjQ0NjFfc29ja2V0X3QgKnNwID0gY29udGFpbmVyX29mKHMsIHN0cnVjdCBoZDY0
NDYxX3NvY2tldF90LCBzb2NrZXQpOwoJc3RydWN0IHBjY2FyZF9tZW1fbWFwICpzbWVtOwoJaW50
IG1hcCA9IG1lbS0+bWFwOwoJdW5zaWduZWQgbG9uZyBzYWRkcjsKCglwcmludGsoS0VSTl9JTkZP
ICJoZDY0NDYxOiBlbnRlcmluZyBoZDY0NDYxX3NldF9tZW1fbWFwXG4iKTsKCQoJaWYgKG1hcCA+
PSBNQVhfV0lOKQoJCXJldHVybiAtRUlOVkFMOwoKCS8qIGxldHMgc2V0dXAgcG9pbnRlcnMgdG8g
bWVtb3J5ICovCglzbWVtID0gJnNwLT5tZW1fbWFwc1ttYXBdOwoJc2FkZHIgPSBzcC0+bWVtX2Jh
c2UgKyBtZW0tPmNhcmRfc3RhcnQ7CgoJaWYgKCEobWVtLT5mbGFncyAmIE1BUF9BVFRSSUIpKQoJ
CXNhZGRyICs9IEhENjQ0NjFfUENDX1dJTkRPVzsKCgltZW0tPnN0YXRpY19zdGFydCA9IHNhZGRy
OwoJKnNtZW0gPSAqbWVtOwoKCXJldHVybiAwOwp9CgovKgogKgogKiBmdW5jdGlvbnMgbmVlZGVk
IGZvciBvcGVyYXRpb25zCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKi8K
c3RhdGljIHN0cnVjdCBwY2NhcmRfb3BlcmF0aW9ucyBoZDY0NDYxX29wZXJhdGlvbnMgPSB7Cgku
aW5pdCA9IGhkNjQ0NjFfaW5pdCwKCS5zdXNwZW5kID0gaGQ2NDQ2MV9zdXNwZW5kLAoJLmdldF9z
dGF0dXMgPSBoZDY0NDYxX2dldF9zdGF0dXMsCgkuc2V0X3NvY2tldCA9IGhkNjQ0NjFfc2V0X3Nv
Y2tldCwKCS5zZXRfaW9fbWFwID0gaGQ2NDQ2MV9zZXRfaW9fbWFwLAoJLnNldF9tZW1fbWFwID0g
aGQ2NDQ2MV9zZXRfbWVtX21hcCwKfTsKCi8qIGhkNjQ0NjFfaW50ZXJydXB0KCkKICoKICogSGVy
ZSB3ZSBjaGVjayB3aGF0IGNhdXNlZCB0aGUgaW50ZXJydXB0IGFuZAogKiBwYXNzIGl0IG9uIHRv
IHBjbWNpYSBwYXJzZXIKICoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Ki8Kc3RhdGljIGlycXJldHVybl90IGhkNjQ0NjFfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRl
dikKewoJaGQ2NDQ2MV9zb2NrZXRfdCAqc3AgPSAoaGQ2NDQ2MV9zb2NrZXRfdCAqKSBkZXY7Cgl1
bnNpZ25lZCBldmVudHMgPSAwOwoJdW5zaWduZWQgY2hhciBjc2NyLGNzY3IyOwoJCgkvL3ByaW50
ayhLRVJOX0lORk8gIkhENjQ0NjFfU1M6IEludGVycnVwdCA3OFxuIik7Cgljc2NyID0gaW5iKEhE
NjQ0NjFfUENDMENTQ1IpOwoKCS8qIElmIElSRVEgcGluIGlzIGluIGxvdyBzdGF0ZSAqLwoJaWYg
KGNzY3IgJiBIRDY0NDYxX1BDQ0NTQ1JfSVJFUSkgewoJICAgIGlmICghKGNzY3IgJiBIRDY0NDYx
X1BDQ0NTQ1JfU0MpKSB7CgkJY3NjciAmPSB+SEQ2NDQ2MV9QQ0NDU0NSX0lSRVE7CgkJLyogc2ls
ZW5jZSBpbnRlcnJ1cHQgc291cmNlIGFuZCBoYW5kIG92ZXIgaW50ZXJydXB0ICovCgkJb3V0Yihj
c2NyLCBIRDY0NDYxX1BDQzBDU0NSKTsKCQljc2NyMiA9IGluYihIRDY0NDYxX1BDQzBDU0NSKTsK
CQlpZiAoIShjc2NyMiAmIGNzY3IpKQoJCSAgICBwcmludGsoS0VSTl9JTkZPICJoZDY0NDYxX2lu
dGVycnVwdDogUGFoISB3ZSBhcmUgaW4gYmxvb2R5IGxldmVsIG1vZGUhXG4iKTsKICAgIAkJcmV0
dXJuIElSUV9OT05FOwoJICAgIH0KCX0KCi8vCXByaW50ayhLRVJOX0lORk8gIkhENjQ0NjFfU1M6
IEludGVycnVwdCBjYXVzZWQgYnkgU2xvdCAwXG4iKTsKCgkvKiBpZiBib3RoIENEMSBhbmQgQ0Qy
IGhhcyBjaGFuZ2VkICovCglpZiAoY3NjciAmIEhENjQ0NjFfUENDQ1NDUl9DREMpIHsKCQlwcmlu
dGsoS0VSTl9JTkZPICJIRDY0NDYxX1NTOiBXZSBhcmUgaW5zaWRlIHRoZSBDRDEvQ0QyIGNoYW5n
ZWQgbG9vcFxuIik7CgkJLyogc2lsZW5jZSBpdCBieSB3cml0aW5nIGEgMCB0byBiaXQgMyAqLwoJ
CWNzY3IgJj0gfkhENjQ0NjFfUENDQ1NDUl9DREM7CgkJLyogd2UndmUgZGV0ZWN0ZWQgc29tZXRo
aW5nIGJlaW5nIGluc2VydGVkIG9yIHVucGx1Z2dlZCAqLwoJCWV2ZW50cyB8PSBTU19ERVRFQ1Q7
CgoJCS8qIGlmIENEMSBhbmQgQ0QyIGRvbid0IGJvdGggZGlzcGxheSAxLCB3ZSBuZWVkIHRvIGNs
ZWFuIHVwICovCgkJaWYgKCgoaW5iKEhENjQ0NjFfUENDMElTUikpICYgSEQ2NDQ2MV9QQ0NJU1Jf
UENEX01BU0spICE9IDApIHsKCQkJY3NjciAmPSB+KEhENjQ0NjFfUENDQ1NDUl9SQyB8IEhENjQ0
NjFfUENDQ1NDUl9CVyB8CgkJCQkgIEhENjQ0NjFfUENDQ1NDUl9CRCB8IEhENjQ0NjFfUENDQ1ND
Ul9TQyk7CgkJfQoJfQoKCS8qIE1FTU9SWSBDQVJEICovCglpZiAoc3AtPklDX21lbW9yeSkgewoJ
CWlmIChjc2NyICYgSEQ2NDQ2MV9QQ0NDU0NSX1JDKSB7CgkJCS8qID8gKi8KCQkJY3NjciAmPSB+
SEQ2NDQ2MV9QQ0NDU0NSX1JDOwoJCQlldmVudHMgfD0gU1NfUkVBRFk7CgkJfQoKCQlpZiAoY3Nj
ciAmIEhENjQ0NjFfUENDQ1NDUl9CVykgewoJCQkvKiBiYXR0ZXJ5IHdhcm5pbmcgKi8KCQkJY3Nj
ciAmPSB+SEQ2NDQ2MV9QQ0NDU0NSX0JXOwoJCQlldmVudHMgfD0gU1NfQkFUV0FSTjsKCQl9CgoJ
CWlmIChjc2NyICYgSEQ2NDQ2MV9QQ0NDU0NSX0JEKSB7CgkJCS8qIGJhdHRlcnkgZGVhZCAqLwoJ
CQljc2NyICY9IH5IRDY0NDYxX1BDQ0NTQ1JfQkQ7CgkJCWV2ZW50cyB8PSBTU19CQVRERUFEOwoJ
CX0KCX0gZWxzZSB7IC8qIElPIENBUkQgKi8KCQlpZiAoY3NjciAmIEhENjQ0NjFfUENDQ1NDUl9T
QykgewoJCQkvKiBzdGF0dXMgY2hhbmdlZCAqLwoJCQljc2NyICY9IH5IRDY0NDYxX1BDQ0NTQ1Jf
U0M7CgkJCWV2ZW50cyB8PSBTU19TVFNDSEc7CgkJfQoJfQoKCW91dGIoY3NjciwgSEQ2NDQ2MV9Q
Q0MwQ1NDUik7CgoJLyogbWFrZSBzdXJlIHdlIHB1c2ggdGhlc2UgY2hhbmdlcyBpbnRvIHBjbWNp
YSBldmVudHMgKi8KCWlmIChldmVudHMpIHsKCQlwY21jaWFfcGFyc2VfZXZlbnRzKCZzcC0+c29j
a2V0LCBldmVudHMpOwoJICAgICAgICBwcmludGsoS0VSTl9JTkZPICJoZDY0NDYxX2ludGVycnVw
dDogd2UgYXJlIHB1c2hpbmcgY2hhbmdlZCBldmVudHMhIGV2ZW50cz0lZFxuIiwgZXZlbnRzKTsK
CX0KCgoJcmV0dXJuIElSUV9IQU5ETEVEOwp9CgovKgogKmhkXzY0NDYxX2luaXRfc29ja2V0KCkK
ICoKICogQWRkIHZhbHVlcyB0byBzb2NrZXQgYW5kIGxpbmsgaXQgd2l0aCBwY21jaWEgb3BlcmF0
aW9ucwogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqLwppbnQgaGQ2NDQ2MV9pbml0X3NvY2tldChpbnQgc29jaywgaW50IGlycSwgdW5zaWdu
ZWQgbG9uZyBtZW1fYmFzZSx1bnNpZ25lZCBsb25nIGlvX29mZnNldCkKewoJaGQ2NDQ2MV9zb2Nr
ZXRfdCAqc3AgPSAmaGQ2NDQ2MV9zb2NrZXRzW3NvY2tdOwoJdW5zaWduZWQgZ2NyX3JlZyA9IEhE
NjQ0NjFfUENDMEdDUjsKCXU4IGdjcjsKCWludCBpLCBlcnI7CgoJb3V0YigwLCBIRDY0NDYxX1BD
QzBDU0NJRVIpOwoKCW1lbXNldChzcCwgMCwgc2l6ZW9mKCpzcCkpOwoJc3AtPklDX21lbW9yeSA9
IDA7CglzcC0+aXJxID0gaXJxOwoJLy9zcC0+c29ja2V0LmlycV9tYXNrID0gMDsKCXNwLT5tZW1f
YmFzZSA9IG1lbV9iYXNlOwoJc3AtPnNvY2tldC5mZWF0dXJlcyA9IFNTX0NBUF9QQ0NBUkQgfCBT
U19DQVBfU1RBVElDX01BUCB8IFNTX0NBUF9QQUdFX1JFR1M7CglzcC0+c29ja2V0LnJlc291cmNl
X29wcyA9ICZwY2NhcmRfc3RhdGljX29wczsKCXNwLT5zb2NrZXQub3BzID0gJmhkNjQ0NjFfb3Bl
cmF0aW9uczsKCXNwLT5zb2NrZXQubWFwX3NpemUgPSBIRDY0NDYxX1BDQ19XSU5ET1c7CS8qIDE2
TUIgZml4ZWQgd2luZG93IHNpemUgKi8KCXNwLT5zb2NrZXQucGNpX2lycSA9IGlycTsKCXNwLT5z
b2NrZXQuaW9fb2Zmc2V0ID0gMDsKCXNwLT5zb2NrZXQub3duZXIgPSBUSElTX01PRFVMRTsKCglm
b3IgKGkgPSAwOyBpICE9IE1BWF9XSU47IGkrKykKCQlzcC0+bWVtX21hcHNbaV0ubWFwID0gaTsK
CglpZiAoKHJlcXVlc3RfaXJxKGlycSwgaGQ2NDQ2MV9pbnRlcnJ1cHQsIElSUUZfU0hBUkVELCAi
aGQ2NDQ2MV9zcy1pcnEiLCBzcCkpIDwgMCkgewoJCXByaW50ayhLRVJOX0lORk8gImhkNjQ0NjFf
aW5pdDogcmVxdWVzdCBmb3IgaXJxICVkOiBmYWlsZWRcbiIsIHNwLT5pcnEpOwoJCXJldHVybiAt
MTsKCX0KCQoJZ2NyID0gaW5iKGdjcl9yZWcpOwoJLyogY29udGludW91cyAxNk1CIGFyZWEgbW9k
ZSBmb3IgYm90aCBtZW1vcnkgYW5kIEkvTyBvcGVyYXRpb25zICovCglnY3IgfD0gSEQ2NDQ2MV9Q
Q0NHQ1JfUE1NT0Q7CgkvKiA/Pz8gKi8KCWdjciAmPSB+KEhENjQ0NjFfUENDR0NSX1BBMjUgfCBI
RDY0NDYxX1BDQ0dDUl9QQTI0KTsKCW91dGIoZ2NyLCBnY3JfcmVnKTsKCglyZXR1cm4gMDsKfQoK
dm9pZCBoZDY0NDYxX2V4aXRfc29ja2V0KGludCBzb2NrKQp7CgloZDY0NDYxX3NvY2tldF90ICpz
cCA9ICZoZDY0NDYxX3NvY2tldHNbMF07Cgl1bnNpZ25lZCBjc2NpZXJfcmVnID0gSEQ2NDQ2MV9Q
Q0MwQ1NDSUVSOwoKCXByaW50ayhLRVJOX0lORk8gImhkNjQ0NjFfZXhpdF9zb2NrZXQ6IGNsZWFu
aW5nIHVwIGlycSAlZCBhbmQgJWRcbiIsIHNwLT5pcnEsIHNwLT5zb2NrZXQucGNpX2lycSk7CgoJ
b3V0YigwLCBjc2NpZXJfcmVnKTsKCWhkNjQ0NjFfc3VzcGVuZCgmc3AtPnNvY2tldCk7Cgp9Cgpz
dGF0aWMgaW50IF9fZGV2ZXhpdCBoZDY0NDYxX3BjbWNpYV9kcnZfcmVtb3ZlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKmRldikKewoJLyogTGlicGF0YSBoYW5kbGVzIENGIHNsb3QsIHNvIHdlIG9u
bHkgaGFuZGxlIFBDTUNJQSBzbG90ICovCglwY21jaWFfdW5yZWdpc3Rlcl9zb2NrZXQoJmhkNjQ0
NjFfc29ja2V0c1swXS5zb2NrZXQpOwoJaGQ2NDQ2MV9leGl0X3NvY2tldCgwKTsKCglyZXR1cm4g
MDsKfQoKI2lmZGVmIENPTkZJR19QTQpzdGF0aWMgaW50IGhkNjQ0NjFfcGNtY2lhX2Rydl9zdXNw
ZW5kKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKmRldiwgcG1fbWVzc2FnZV90IHN0YXRlKQp7Cglp
bnQgcmV0ID0gMDsKCWludCBpOwoKCXUzMiBjc2NpZXJfcmVnID0gSEQ2NDQ2MV9QQ0MwQ1NDSUVS
OwoJaGQ2NDQ2MV9zb2NrZXRzWzBdLmNzY2llciA9IGluYihjc2NpZXJfcmVnKTsKCW91dGIoMCwg
Y3NjaWVyX3JlZyk7CglyZXQgPSBwY21jaWFfc29ja2V0X2Rldl9zdXNwZW5kKCZkZXYtPmRldiwg
c3RhdGUpOwoKIAlyZXR1cm4gcmV0OwogfQoKc3RhdGljIGludCBoZDY0NDYxX3BjbWNpYV9kcnZf
cmVzdW1lKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKmRldikKewoJaW50IHJldCA9IDA7CglpbnQg
aTsKCgl1MzIgY3NjaWVyX3JlZyA9IEhENjQ0NjFfUENDMENTQ0lFUjsKCW91dGIoaGQ2NDQ2MV9z
b2NrZXRzWzBdLmNzY2llciwgY3NjaWVyX3JlZyk7CglyZXQgPSBwY21jaWFfc29ja2V0X2Rldl9y
ZXN1bWUoJmRldi0+ZGV2KTsKCglyZXR1cm4gcmV0Owp9CiNlbmRpZgoKc3RhdGljIHN0cnVjdCBw
bGF0Zm9ybV9kcml2ZXIgaGQ2NDQ2MV9wY21jaWFfZHJpdmVyID0gewoJLnJlbW92ZSA9IF9fZGV2
ZXhpdF9wKGhkNjQ0NjFfcGNtY2lhX2Rydl9yZW1vdmUpLAojaWZkZWYgQ09ORklHX1BNCgkuc3Vz
cGVuZCA9IGhkNjQ0NjFfcGNtY2lhX2Rydl9zdXNwZW5kLAoJLnJlc3VtZSA9IGhkNjQ0NjFfcGNt
Y2lhX2Rydl9yZXN1bWUsCiNlbmRpZgoJLmRyaXZlcgkJPSB7CgkJLm5hbWUJPSAiaGQ2NDQ2MS1w
Y21jaWEiLAoJfSwKfTsKCnN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpoZDY0NDYxX3Bj
bWNpYV9kZXZpY2U7CgpzdGF0aWMgaW50IF9faW5pdCBpbml0X2hkNjQ0NjFfc3Modm9pZCkKewoJ
aW50IGk7CgoJcHJpbnRrKEtFUk5fSU5GTyAiaGQ2NDQ2MV9zc19pbml0OiBwY21jaWEgZHJpdmVy
IGZvciBoZDY0NDYxIGNoaXBzZXQgc3RhcnRlZFxuIik7CgogICAgICAgIGlmIChwbGF0Zm9ybV9k
cml2ZXJfcmVnaXN0ZXIoJmhkNjQ0NjFfcGNtY2lhX2RyaXZlcikpCgkgICAgZ290byBmYWlsZWQx
OwoKCWkgPSBoZDY0NDYxX2luaXRfc29ja2V0KDAsIEhENjQ0NjFfSVJRX1BDQzAsIEhENjQ0NjFf
UENDMF9CQVNFLCAweDApOwogICAgICAgIGlmIChpIDwgMCkgCgkgICAgZ290byBmYWlsZWQyOwoK
ICAgICAgICAKCWhkNjQ0NjFfcGNtY2lhX2RldmljZSA9IHBsYXRmb3JtX2RldmljZV9hbGxvYygi
aGQ2NDQ2MS1wY21jaWEiLC0xKTsKCWlmKCFoZDY0NDYxX3BjbWNpYV9kZXZpY2UpIHsKCSAgICBw
cmludGsoS0VSTl9JTkZPICJoZDY0NDYxX3NzX2luaXQ6IENhbm5vdCBmaW5kIHBjbWNpYSBkZXZp
Y2UhXG4iKTsKCSAgICByZXR1cm4gLUVOT0RFVjsKCX0KCglpID0gcGxhdGZvcm1fZGV2aWNlX2Fk
ZChoZDY0NDYxX3BjbWNpYV9kZXZpY2UpOwoJaWYgKGkpIHsKCSAgICBwbGF0Zm9ybV9kZXZpY2Vf
cHV0KGhkNjQ0NjFfcGNtY2lhX2RldmljZSk7CgkgICAgcHJpbnRrKEtFUk5fSU5GTyAiaGQ2NDQ2
MV9zc19pbml0OiBDYW5ub3QgYWRkIHBjbWNpYSBkZXZpY2UsIHJldHVybiB2YWx1ZSAlZFxuIixp
KTsKCSAgICByZXR1cm4gLUVOT0RFVjsKCX0KCgkvKiBMZXRzIHJlZ2lzdGVyIHRoZSBwY21jaWEg
c29ja2V0ICovCglwcmludGsoS0VSTl9JTkZPICJoZDY0NDYxX3NzX2luaXQ6IHNldHRpbmcgc29j
a2V0IGRldmljZVxuIik7CgloZDY0NDYxX3NvY2tldHNbMF0uc29ja2V0LmRldi5wYXJlbnQgPSAm
aGQ2NDQ2MV9wY21jaWFfZGV2aWNlLT5kZXY7CgkKCWkgPSBwY21jaWFfcmVnaXN0ZXJfc29ja2V0
KCZoZDY0NDYxX3NvY2tldHNbMF0uc29ja2V0KTsKCXByaW50ayhLRVJOX0lORk8gImhkNjQ0NjFf
c3NfaW5pdDogcmV0dXJuIHZhbHVlICVkIGZyb20gcGNtY2lhX3JlZ2lzdGVyX3NvY2tldFxuIiwg
aSk7CgkKCXJldHVybiAwOwoKLyogVW5yZWdpc3RlciBkcml2ZXIgbm90aGluZyBlbHNlICovCmZh
aWxlZDE6CglwcmludGsoS0VSTl9JTkZPICJoZDY0NDYxX3NzX2luaXQ6IEZhaWxlZCByZWdpc3Rl
cmluZyBwY21jaWEgcGxhdGZvcm0gZHJpdmVyXG4iKTsKCXBsYXRmb3JtX2RyaXZlcl91bnJlZ2lz
dGVyKCZoZDY0NDYxX3BjbWNpYV9kcml2ZXIpOwoJcmV0dXJuIC1FSU5WQUw7CgovKiBVbnJlZ2lz
dGVyIGRyaXZlciBub3RoaW5nIGVsc2UgKi8KZmFpbGVkMjoKCXByaW50ayhLRVJOX0lORk8gImhk
NjQ0NjFfc3NfaW5pdDogRmFpbGVkIHRvIHN0YXJ0dXAgc29ja2V0IDBcbiIpOwoJcGxhdGZvcm1f
ZHJpdmVyX3VucmVnaXN0ZXIoJmhkNjQ0NjFfcGNtY2lhX2RyaXZlcik7CglyZXR1cm4gaTsKfQoK
c3RhdGljIHZvaWQgX19leGl0IGV4aXRfaGQ2NDQ2MV9zcyh2b2lkKQp7CgkvKiBPbmx5IHJlbW92
ZSBpZiB0aGVyZSdzIHNvbWV0aGluZyB0byByZW1vdmUgKi8KCWlmIChoZDY0NDYxX3BjbWNpYV9k
ZXZpY2UpIHsKCSAgICBwbGF0Zm9ybV9kZXZpY2VfdW5yZWdpc3RlcihoZDY0NDYxX3BjbWNpYV9k
ZXZpY2UpOwoJICAgIHBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVyKCZoZDY0NDYxX3BjbWNpYV9k
cml2ZXIpOwoJfQp9Cm1vZHVsZV9pbml0KGluaXRfaGQ2NDQ2MV9zcyk7Cm1vZHVsZV9leGl0KGV4
aXRfaGQ2NDQ2MV9zcyk7CgpNT0RVTEVfQVVUSE9SKCJLcmlzdG9mZmVyIEVyaWNzb24gPGtyaXN0
b2ZmZXIuZXJpY3NvbkBnbWFpbC5jb20+Iik7Ck1PRFVMRV9ERVNDUklQVElPTigiUENNQ0lBIGRy
aXZlciBmb3IgSGl0YWNoaSBIRDY0NDYxIGNvbXBhbmlvbiBjaGlwIik7Ck1PRFVMRV9MSUNFTlNF
KCJHUEwiKTsK

--Multipart=_Tue__18_Dec_2007_18_09_03_+0100_erpQM3NPncR8WIzd--
