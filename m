Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYE0BQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYE0BQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYE0BQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:16:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:47158 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754266AbYE0BQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:16:15 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX18KVJkLIPAKIIsVthRgepS9TMrHOHf2egrkzPjnV0
	F/FJ9z67hPmMvk
Message-ID: <483B60DB.7020402@gmx.net>
Date: Tue, 27 May 2008 03:16:11 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <483B2A9B.4050007@krogh.cc> <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.05.2008 23:42, Linus Torvalds wrote:
> On Mon, 26 May 2008, Jesper Krogh wrote:
>   
>> I did get this one (which I didn't on 2.6.25.2)
>>
>> [42949399.810959] ck804xrom ck804xrom_init_one(): Unable to register resource
>> 0x0000000000000000-0x00000000ffffffff - kernel bug?
>>     
>
> Something is trying to register a 4GB resource. That sounds unlikely 
> (possible on a 64-bit PCI setup, but I think it's more likely to be some 
> overflow of 0 in "unsigned int").
>
> In fact, this seems to be due to some driver bug. It looks like we have
>
> 	window->size = 0xffffffffUL - window->phys + 1UL;
>
> and in order for window->size to be 0x100000000, that means that 
> window->phys has to be 0. Which looks impossible, or at least like 
> ent->driver_data is neither DEV_CK804 nor DEV_MCP55. Very odd.
>
> The warning:
>
>   
>> [42949399.979924] WARNING: at arch/x86/mm/ioremap.c:159 __ioremap_caller+0x299/0x330()
>>     
>
> is then just a result of the driver blindly continuing and trying to 
> "ioremap()" the resource even though it's bogus and the resource 
> allocation failed.
>
> In other words, that driver init routine is really bad about error 
> handling. Carl-Daniel? David?
>   

It hurts to look at this:

static struct pci_device_id ck804xrom_pci_tbl[] = {
	{ PCI_VENDOR_ID_NVIDIA, 0x0051, PCI_ANY_ID, PCI_ANY_ID, DEV_CK804 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0360, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0361, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0362, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0363, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0364, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0365, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0366, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ PCI_VENDOR_ID_NVIDIA, 0x0367, PCI_ANY_ID, PCI_ANY_ID, DEV_MCP55 },
	{ 0, }
};

considering how struct pci_device_id looks like:

struct pci_device_id {
	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
	kernel_ulong_t driver_data;	/* Data private to the driver */
};



DEV_CK804 and DEV_MCP55 actually end up in class instead of driver_data.

I'd send a patch, but I'm traveling and my only code access is gitweb.

New code should look like
static struct pci_device_id ck804xrom_pci_tbl[] = {
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0051), .driver_data = DEV_CK804 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0360), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0361), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0362), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0363), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0364), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0365), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0366), .driver_data = DEV_MCP55 },
	{ PCI_DEVICE(PCI_VENDOR_ID_NVIDIA, 0x0367), .driver_data = DEV_MCP55 },
	{ 0, }
};


Regards,
Carl-Daniel

