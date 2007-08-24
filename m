Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbXHXF5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbXHXF5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 01:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXHXF5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 01:57:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36556 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbXHXF5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 01:57:35 -0400
Date: Thu, 23 Aug 2007 22:55:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Shannon Nelson <shannon.nelson@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH v2 -mm 6/7] DCA: Add Direct Cache Access driver
Message-Id: <20070823225545.743ee1bf.randy.dunlap@oracle.com>
In-Reply-To: <20070824001522.16997.57613.stgit@localhost.localdomain>
References: <20070824001335.16997.79665.stgit@localhost.localdomain>
	<20070824001522.16997.57613.stgit@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 17:15:22 -0700 Shannon Nelson wrote:

> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Acked-by: David S. Miller <davem@davemloft.net>
> ---
> 
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    1 
>  drivers/dca/Kconfig     |   11 +++
>  drivers/dca/Makefile    |    2 +
>  drivers/dca/dca-core.c  |  168 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dca/dca-sysfs.c |   88 +++++++++++++++++++++++++
>  include/linux/dca.h     |   47 +++++++++++++
>  7 files changed, 319 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dca/Kconfig b/drivers/dca/Kconfig
> new file mode 100644
> index 0000000..d901615
> --- /dev/null
> +++ b/drivers/dca/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# DCA server configuration
> +#
> +
> +config DCA
> +	tristate "DCA support for clients and providers"
> +	---help---
> +          This is a server to help modules that want to use Direct Cache
> +	  Access to find DCA providers that will supply correct CPU tags.
> +	default m

We conventionally put help text last in each config entry.
& Help text should be indented by 1 tab + 2 spaces.

> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
> new file mode 100644
> index 0000000..c0ff9bd
> --- /dev/null
> +++ b/drivers/dca/dca-core.c
> @@ -0,0 +1,168 @@
> +/*
> + * Copyright(c) 2007 Intel Corporation. All rights reserved.
> + *
> +/*
> + * This driver supports an interface for DCA clients and providers to meet.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/notifier.h>
> +#include <linux/device.h>
> +#include <linux/dca.h>
> +
> +MODULE_LICENSE("GPL");
> +
> +/* For now we're assuming a single, global, DCA provider for the system. */
> +
> +static DEFINE_SPINLOCK(dca_lock);
> +
> +struct dca_provider *global_dca = NULL;

Can global_dca be static, or is it used in other source files?

It would be good to have all of these global/exported interfaces
documented somewhere.  Did I miss it in another file?
If not, you could use kernel-doc to add inline function docs.
See Documentation/kernel-doc-nano-HOWTO.txt.

> +u8 dca_get_tag(int cpu)
> +{
> +	if (!global_dca)
> +		return -ENODEV;
> +	return global_dca->ops->get_tag(global_dca, cpu);
> +}
> +EXPORT_SYMBOL(dca_get_tag);
> +

> +
> +static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
> +
> +
> +static int __init dca_init(void)
> +{
> +	int err;
> +
> +	err = dca_sysfs_init();
> +	if (err)
> +		return err;
> +	return 0;

or just (in all cases):

	return err;

> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
