Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZBJWZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZBJWZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZBJWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:24:51 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19602 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZBJWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:24:50 -0500
Date: Tue, 10 Feb 2009 15:24:48 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, djwong@us.ibm.com
Subject: Re: [PATCH 1/3] PCI: Method for removing PCI devices
Message-ID: <20090210222448.GE446@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
	djwong@us.ibm.com
References: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net> <1233226515-4906-1-git-send-email-xyzzy@speakeasy.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233226515-4906-1-git-send-email-xyzzy@speakeasy.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> This patch adds an attribute named "remove" to a PCI device's sysfs
> directory.  Writing a non-zero value to this attribute will remove the PCI
> device and any children of it.
> ---
>  Documentation/filesystems/sysfs-pci.txt |    9 +++++++++
>  drivers/pci/pci-sysfs.c                 |   26 ++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 0 deletions(-)
 
I've fold this almost verbatim into my patch series, changing the
patch title, adding ABI documentation, and protecting the remove
calls with #ifdef CONFIG_HOTPLUG:

Otherwise, it's untouched.

Author: Trent Piepho <xyzzy@speakeasy.org>
Date:   Tue Feb 10 15:02:54 2009 -0700

    PCI: Introduce /sys/bus/pci/devices/.../remove
    
    This patch adds an attribute named "remove" to a PCI device's sysfs
    directory.  Writing a non-zero value to this attribute will remove the PCI
    device and any children of it.
    
    [achiang@hp.com: document in Documentation/ABI]
    [achiang@hp.com: add #ifdef CONFIG_HOTPLUG]
    Cc: djwong@us.ibm.com
    Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
    Signed-off-by: Alex Chiang <achiang@hp.com>

Thanks.

/ac

> diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
> index 68ef488..54e014f 100644
> --- a/Documentation/filesystems/sysfs-pci.txt
> +++ b/Documentation/filesystems/sysfs-pci.txt
> @@ -11,6 +11,7 @@ that support it.  For example, a given bus might look like this:
>       |   |-- device
>       |   |-- irq
>       |   |-- local_cpus
> +     |   |-- remove
>       |   |-- resource
>       |   |-- resource0
>       |   |-- resource1
> @@ -34,6 +35,7 @@ files, each with their own function.
>         device		   PCI device (ascii, ro)
>         irq		   IRQ number (ascii, ro)
>         local_cpus	   nearby CPU mask (cpumask, ro)
> +       remove		   remove device from kernel's list (ascii, wo)
>         resource		   PCI resource host addresses (ascii, ro)
>         resource0..N	   PCI resource N, if present (binary, mmap)
>         resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
> @@ -44,6 +46,7 @@ files, each with their own function.
>  
>    ro - read only file
>    rw - file is readable and writable
> +  wo - write only file
>    mmap - file is mmapable
>    ascii - file contains ascii text
>    binary - file contains binary data
> @@ -62,6 +65,12 @@ ROM file, if available.  It's disabled by default, however, so applications
>  should write the string "1" to the file to enable it before attempting a read
>  call, and disable it following the access by writing "0" to the file.
>  
> +The 'remove' file is used to remove the PCI device, by writing a non-zero
> +integer to the file.  This does not involve any kind of hot-plug functionality,
> +e.g. powering off the device.  The device is removed from the kernel's list of
> +PCI devices, the sysfs directory for it removed, and the device will be removed
> +from any drivers attached to it.
> +
>  Accessing legacy resources through sysfs
>  ----------------------------------------
>  
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 3ddee7f..d422f37 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -219,6 +219,31 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
>  	return count;
>  }
>  
> +static void remove_callback(void *data)
> +{
> +	pci_remove_bus_device((struct pci_dev *)data);
> +}
> +
> +static ssize_t
> +remove_store(struct device *dev, struct device_attribute *dummy,
> +	     const char *buf, size_t count)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	unsigned long val;
> +
> +	if (strict_strtoul(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (val)
> +		sysfs_schedule_callback(&dev->kobj, remove_callback, pdev,
> +		                        THIS_MODULE);
> +
> +	return count;
> +}
> +
>  struct device_attribute pci_dev_attrs[] = {
>  	__ATTR_RO(resource),
>  	__ATTR_RO(vendor),
> @@ -237,6 +262,7 @@ struct device_attribute pci_dev_attrs[] = {
>  	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
>  		broken_parity_status_show,broken_parity_status_store),
>  	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
> +	__ATTR(remove, S_IWUSR, NULL, remove_store),
>  	__ATTR_NULL,
>  };
>  
> -- 
> 1.5.4.3
> 
