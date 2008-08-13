Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYHMUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYHMUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYHMUhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:37:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49989 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYHMUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:37:14 -0400
Date: Wed, 13 Aug 2008 22:38:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Greg KH <greg@kroah.com>, joachim.deguara@amd.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/01][retry 2] x86: L3 cache index disable for 2.6.26
Message-ID: <20080813203831.GE8861@elf.ucw.cz>
References: <200807181603.52332.mark.langsdorf@amd.com> <20080812215659.GA12911@elf.ucw.cz> <20080812221201.GA3550@kroah.com> <200808131502.42611.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131502.42611.mark.langsdorf@amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> diff -r e683983d4dd0 Documentation/ABI/testing/sysfs-devices-cache_disable
> --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> +++ b/Documentation/ABI/testing/sysfs-devices-cache_disable	Wed Aug 13 09:06:52 2008 -0500
> @@ -0,0 +1,18 @@
> +What:           /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
> +Date:           Augsust 2008
> +KernelVersion:  2.6.27
> +Contact:        osrc-kernel@elbe.amd.com
> +Description:    These files exist in every cpu's cache index directories.
> +		There are currently 2 cache_disable_# files in each 
> +		directory.  Reading from these files on a supported
> +		processor will return that cache disable index value
> +		for that processor and node.  Writing to one of these
> +		files will cause the specificed cache index to be disable.

disabled.

> +#if defined(CONFIG_PCI) && defined(CONFIG_K8_NB)
> +#include <linux/pci.h>
> +#include <asm/k8.h>
> +static struct pci_dev *get_k8_northbridge(int node)
> +{
> +        return k8_northbridges[node];
> +}
> +#else
> +static inline int pci_write_config_dword(struct pci_dev *dev, int where,
> +                                         u32 val)
> +{
> +	return 0;
> +}

Spaces vs. tabs problem visible here. ... 

> +static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
> +		unsigned int index)
> +{
> +        int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +        struct pci_dev *dev = get_k8_northbridge(node);
> +	unsigned int reg = 0;
> +
> +        if (!this_leaf->can_disable) 
> +		return 0;
> +
> +	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
> +        return sprintf(buf, "%x\n", reg);
> +}

...and getting serious here.


> +#define SHOW_CACHE_DISABLE(index)					\
> +static ssize_t                                                          \
> +show_cache_disable_##index(struct _cpuid4_info *this_leaf, char *buf)	\
> +{									\
> +	return show_cache_disable(this_leaf, buf, index);		\
> +}
> +
> +static ssize_t
> +store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
> +		size_t count, unsigned int index)
> +{
> +        int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
> +        struct pci_dev *dev = get_k8_northbridge(node);
> +        ssize_t ret = 0;
> +        unsigned int val;
> +
> +        if (!this_leaf->can_disable)
> +                return 0;

So if someone asks you to disable part of cache you can't disable, you
return success?

> +        if (strlen(buf) > 10)
> +                return -EINVAL;
> +
> +        ret = sscanf(buf, "%x\n", &val);
> +        if (ret != 1)
> +                return -EINVAL;
....
> +        return strlen(buf);

Is this safe to do? What if buf is not null-terminated?

return count?

Actually, the sscanf is problematic, too, right?


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
