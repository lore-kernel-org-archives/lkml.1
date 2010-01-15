Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470Ab0AOAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0AOAk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166Ab0AOAk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:40:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:56035 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab0AOAk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:40:27 -0500
Message-ID: <4B4FB931.7020301@kernel.org>
Date: Thu, 14 Jan 2010 16:39:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jeff Garrett <jeff@jgarrett.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] x86/pci: intel ioh need to subtract mmconf range
References: <20100113053736.GA6720@jgarrett.org> <201001141609.19290.bjorn.helgaas@hp.com> <4B4FAAE0.7080608@kernel.org> <201001141649.08554.bjorn.helgaas@hp.com>
In-Reply-To: <201001141649.08554.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 03:49 PM, Bjorn Helgaas wrote:
> On Thursday 14 January 2010 04:38:08 pm Yinghai Lu wrote:
>> On 01/14/2010 03:09 PM, Bjorn Helgaas wrote:
>>> On Thursday 14 January 2010 03:46:35 pm Yinghai Lu wrote:
>>>>
>>>> Bjorn pointed out we need to remove mmconf range
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> ---
>>>>  arch/x86/pci/intel_bus.c |   29 +++++++++++++++++++++++++++--
>>>>  1 file changed, 27 insertions(+), 2 deletions(-)
>>>>
>>>> Index: linux-2.6/arch/x86/pci/intel_bus.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/pci/intel_bus.c
>>>> +++ linux-2.6/arch/x86/pci/intel_bus.c
>>>> @@ -46,6 +46,20 @@ static inline void print_ioh_resources(s
>>>>  
>>>>  #define RANGE_NUM 16
>>>>  
>>>> +static void __devinit subtract_mmconf(struct range *range, int nr)
>>>> +{
>>>> +#ifdef CONFIG_PCI_MMCONFIG
>>>> +	struct pci_mmcfg_region *cfg;
>>>> +
>>>> +	if (list_empty(&pci_mmcfg_list))
>>>> +		return;
>>>> +
>>>> +        list_for_each_entry(cfg, &pci_mmcfg_list, list)
>>>> +		subtract_range(range, nr, cfg->res.start,
>>>> +			 cfg->res.end + 1);
>>>> +#endif
>>>
>>> This can't be right, can it?  Let's say the kernel was built with
>>> CONFIG_PCI_MMCONFIG turned off, or the user used "pci=nommconf",
>>> or the kernel decides not to use MMCONFIG for some other reason.
>>>
>>> In that case, the hardware may still be configured to support
>>> MMCONFIG, but the pci_mmcfg_list will be empty, so your code will
>>> leave the window alone.  We might assign some of that MMCONFIG
>>> space to a device, but the hardware will route it to MMCONFIG,
>>> not to the device.
>>
>> so if there is mmconf specified, we just skip the whole function?
> 
> No, I'm saying that intel-bus.c must ALWAYS remove the MMCONFIG region
> from the host bridge apertures, even if Linux isn't using MMCONFIG.
> 
> That means intel-bus.c has to be smart enough to figure out on its
> own what the MMCONFIG area is.  It can't depend on mmconfig-shared.c
> to do it, because mmconfig-shared.c might not be there.

that seems go too far away...

Subject: [PATCH -v2] x86/pci: intel ioh need to subtrac mmconf range

Bjorn pointed out we need to remove mmconf range

-v2: if mmconf is not there, get out early.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/Makefile    |    3 ++-
 arch/x86/pci/intel_bus.c |   30 ++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -46,6 +46,18 @@ static inline void print_ioh_resources(s
 
 #define RANGE_NUM 16
 
+static void __devinit subtract_mmconf(struct range *range, int nr)
+{
+	struct pci_mmcfg_region *cfg;
+
+	if (list_empty(&pci_mmcfg_list))
+		return;
+
+        list_for_each_entry(cfg, &pci_mmcfg_list, list)
+		subtract_range(range, nr, cfg->res.start,
+			 cfg->res.end + 1);
+}
+
 static void __devinit pci_root_bus_res(struct pci_dev *dev)
 {
 	u16 word;
@@ -58,6 +70,9 @@ static void __devinit pci_root_bus_res(s
 	struct range range[RANGE_NUM];
 	int i;
 
+	if (list_empty(&pci_mmcfg_list))
+		return;
+
 	/* some sys doesn't get mmconf enabled */
 	if (dev->cfg_size < 0x200)
 		return;
@@ -96,6 +111,7 @@ static void __devinit pci_root_bus_res(s
 
 		subtract_range(range, RANGE_NUM, vt_base, vt_end + 1);
 	}
+	subtract_mmconf(range, RANGE_NUM);
 	for (i = 0; i < RANGE_NUM; i++) {
 		if (!range[i].end)
 			continue;
@@ -112,8 +128,18 @@ static void __devinit pci_root_bus_res(s
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
-			 IORESOURCE_MEM, 0);
+	memset(range, 0, sizeof(range));
+	add_range(range, RANGE_NUM, 0, mmioh_base, mmioh_end + 1);
+	/* mmconf could be above 4g */
+	subtract_mmconf(range, RANGE_NUM);
+	for (i = 0; i < RANGE_NUM; i++) {
+		if (!range[i].end)
+			continue;
+
+		update_res(info, cap_resource(range[i].start),
+			   cap_resource(range[i].end - 1),
+			   IORESOURCE_MEM, 0);
+	}
 
 	print_ioh_resources(info);
 }
Index: linux-2.6/arch/x86/pci/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile
+++ linux-2.6/arch/x86/pci/Makefile
@@ -14,7 +14,8 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o bus_numa.o intel_bus.o
+obj-y				+= amd_bus.o bus_numa.o
+obj-$(CONFIG_PCI_MMCONFIG)	+= intel_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
