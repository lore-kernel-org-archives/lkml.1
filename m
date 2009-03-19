Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZCSJuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZCSJuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZCSJuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:50:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbZCSJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:50:05 -0400
Date: Thu, 19 Mar 2009 02:43:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-Id: <20090319024334.59e9e9bc.akpm@linux-foundation.org>
In-Reply-To: <20090318224006.887.91805.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
	<20090318224006.887.91805.stgit@bob.kio>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 16:40:06 -0600 Alex Chiang <achiang@hp.com> wrote:

> This patch adds an attribute named "remove" to a PCI device's sysfs
> directory.  Writing a non-zero value to this attribute will remove the PCI
> device and any children of it.
> 
> Trent Piepho wrote the original implementation and documentation.
> 
> Thanks to Vegard Nossum for testing under kmemcheck and finding locking
> issues with the sysfs interface.
> 
> ...
>
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -246,6 +246,47 @@ struct bus_attribute pci_bus_attrs[] = {
>  	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
>  	__ATTR_NULL
>  };
> +
> +static void remove_callback(struct device *dev)
> +{
> +	int bridge = 0;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	mutex_lock(&pci_remove_rescan_mutex);
> +
> +	if (pdev->subordinate)
> +		bridge = 1;
> +
> +	pci_remove_bus_device(pdev);
> +	if (bridge && list_empty(&pdev->bus->devices))
> +		pci_remove_bus(pdev->bus);
> +
> +	mutex_unlock(&pci_remove_rescan_mutex);
> +}
> +
> +static ssize_t
> +remove_store(struct device *dev, struct device_attribute *dummy,
> +	     const char *buf, size_t count)
> +{
> +	int ret = 0;
> +	unsigned long val;
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	if (strict_strtoul(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (pdev->subordinate && pci_is_root_bus(pdev->bus))
> +		return -EBUSY;
> +
> +	if (val)
> +		ret = device_schedule_callback(dev, remove_callback);
> +	if (ret)
> +		count = ret;
> +	return count;
> +}
>  #endif

It is very hard for the reader (this one at least) to work out why
device_schedule_callback() is used here, instead of simply doing the work
directly.

The way to solve that problem is to add a code comment.

Given that we're in a sysfs write() handler where no relevant locks at all
are held, it seems rather weird that we cannot perform this operation
synchronously, but no doubt the comment will explain all of this.

Do we need the CAP_SYS_ADMIN check if the sysfs file permissions are
correct?  (I keep on asking this then forgetting the answer).

The device_schedule_callback() thing exposes us to (I assume) a pile of
races, the most obvious of which is "what locking or refcounting keeps
*dev alive?".  It would be nice to see an analysis/description of the
lifetime issues here.  Perhaps in the changelog, preferably in code
comments.

