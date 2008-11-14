Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYKNQ5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYKNQ5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYKNQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:57:30 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:35940 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYKNQ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:57:29 -0500
Date: Fri, 14 Nov 2008 08:56:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add option to passively listen for PCIE hotplug
 events
Message-Id: <20081114085627.bcfecf31.randy.dunlap@oracle.com>
In-Reply-To: <20081103132606.GA30537@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org>
	<20081101175152.GG13302@colo.lackof.org>
	<20081103132606.GA30537@srcf.ucam.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.491DADC0.0052:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 13:26:06 +0000 Matthew Garrett wrote:

> Various pieces of hardware (such as the Acer Aspire One and Asus EEE)
> use PCIE hotplug to change the state of devices in response to events
> such as the removal of SD cards or disabling the wireless radio.
> However, they do not provide firmware support for this. As a consequence
> pciehp will refuse to load and various things break.
>                                                                               
> The existing workaround has been to use the pciehp_force option. This is
> undesirable as there is little guarantee that manipulating the power
> file in the slot directory will actually result in anything happening,
> leading to potential user confusion and hardware damage. This patch adds
> a new option, pciehp_passive. In this configuration pciehp will listen
> for events and notify the PCI core appropriately. However, it will not
> provide any user controllable sysfs attributes and so the risk of
> confusion or damage is averted. Any system slots that do have firmware
> support will continue to provide full functionality.
>                                                                               
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> Includes a minor code change suggested by Matthew Wilcox to avoid 
> calling pciehp_get_hp_hw_control_from_firmware() twice and documentation 
> updates as suggested Grant Grundler.
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 1bbcaa8..2503ee0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1711,6 +1711,20 @@ and is between 256 and 4096 characters. It is defined in the file
>  		force	Enable ASPM even on devices that claim not to support it.
>  			WARNING: Forcing ASPM on may cause system lockups.
>  
> +	pciehp.pciehp_force= [PCIE] Forcibly enable PCIE hotplug support on a 
> +			     slot even if the firmware provides no support for
> +			     it.
> +
> +	pciehp.pciehp_passive= [PCIE] Forcibly enable listening for PCIE 
> +			       hotplug events on a slot even if the firmware
> +			       provides no support for it. Unlike pciehp.force,
> +			       does not provide user interface for triggering
> +			       hotplug events.
> +
> +	pciehp.pciehp_poll_mode= [PCIE] Poll for PCIE hotplug events
> +
> +	pciehp.pciehp_poll_time= [PCIE] Seconds to wait between polls
> +

Hi,

Is it too late to comment on these parameters?
Please don't make users repeat the "pciehp.pciehp" name.
This can be changed easily in the source code by keeping the variable
names as is but using module_param_named() instead of module_param().
One good example is drivers/video/uvesafb.c.



>  	pcmv=		[HW,PCMCIA] BadgePAD 4
>  
>  	pd.		[PARIDE]

> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 4b23bc3..2bb2f4b 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -41,6 +41,7 @@ int pciehp_debug;
>  int pciehp_poll_mode;
>  int pciehp_poll_time;
>  int pciehp_force;
> +int pciehp_passive;
>  struct workqueue_struct *pciehp_wq;
>  
>  #define DRIVER_VERSION	"0.4"
> @@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
>  module_param(pciehp_poll_mode, bool, 0644);
>  module_param(pciehp_poll_time, int, 0644);
>  module_param(pciehp_force, bool, 0644);
> +module_param(pciehp_passive, bool, 0644);
>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
> +MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");
>  
>  #define PCIE_MODULE_NAME "pciehp"
>  

---
~Randy
