Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbXHXQn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbXHXQn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXHXQnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:43:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:33950 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXHXQns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="283439456"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 -mm 6/7] DCA: Add Direct Cache Access driver
Date: Fri, 24 Aug 2007 09:43:46 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02EB51D3@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070823225545.743ee1bf.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 -mm 6/7] DCA: Add Direct Cache Access driver
thread-index: AcfmE6XQbVtbUzLKQf+48uXswNQNRgAWavzw
References: <20070824001335.16997.79665.stgit@localhost.localdomain><20070824001522.16997.57613.stgit@localhost.localdomain> <20070823225545.743ee1bf.randy.dunlap@oracle.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>
X-OriginalArrivalTime: 24 Aug 2007 16:43:47.0002 (UTC) FILETIME=[F0DA71A0:01C7E66D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>
>On Thu, 23 Aug 2007 17:15:22 -0700 Shannon Nelson wrote:
>
>> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> ---
>> 
>>  drivers/Kconfig         |    2 +
>>  drivers/Makefile        |    1 
>>  drivers/dca/Kconfig     |   11 +++
>>  drivers/dca/Makefile    |    2 +
>>  drivers/dca/dca-core.c  |  168 
>+++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/dca/dca-sysfs.c |   88 +++++++++++++++++++++++++
>>  include/linux/dca.h     |   47 +++++++++++++
>>  7 files changed, 319 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/dca/Kconfig b/drivers/dca/Kconfig
>> new file mode 100644
>> index 0000000..d901615
>> --- /dev/null
>> +++ b/drivers/dca/Kconfig
>> @@ -0,0 +1,11 @@
>> +#
>> +# DCA server configuration
>> +#
>> +
>> +config DCA
>> +	tristate "DCA support for clients and providers"
>> +	---help---
>> +          This is a server to help modules that want to use 
>Direct Cache
>> +	  Access to find DCA providers that will supply correct 
>CPU tags.
>> +	default m
>
>We conventionally put help text last in each config entry.
>& Help text should be indented by 1 tab + 2 spaces.
>
>> diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
>> new file mode 100644
>> index 0000000..c0ff9bd
>> --- /dev/null
>> +++ b/drivers/dca/dca-core.c
>> @@ -0,0 +1,168 @@
>> +/*
>> + * Copyright(c) 2007 Intel Corporation. All rights reserved.
>> + *
>> +/*
>> + * This driver supports an interface for DCA clients and 
>providers to meet.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/notifier.h>
>> +#include <linux/device.h>
>> +#include <linux/dca.h>
>> +
>> +MODULE_LICENSE("GPL");
>> +
>> +/* For now we're assuming a single, global, DCA provider 
>for the system. */
>> +
>> +static DEFINE_SPINLOCK(dca_lock);
>> +
>> +struct dca_provider *global_dca = NULL;
>
>Can global_dca be static, or is it used in other source files?

Yes, this should be static.  I'll fix this.

>
>It would be good to have all of these global/exported interfaces
>documented somewhere.  Did I miss it in another file?
>If not, you could use kernel-doc to add inline function docs.
>See Documentation/kernel-doc-nano-HOWTO.txt.

I'll add the block comments.

>
>> +u8 dca_get_tag(int cpu)
>> +{
>> +	if (!global_dca)
>> +		return -ENODEV;
>> +	return global_dca->ops->get_tag(global_dca, cpu);
>> +}
>> +EXPORT_SYMBOL(dca_get_tag);
>> +
>
>> +
>> +static BLOCKING_NOTIFIER_HEAD(dca_provider_chain);
>> +
>> +
>> +static int __init dca_init(void)
>> +{
>> +	int err;
>> +
>> +	err = dca_sysfs_init();
>> +	if (err)
>> +		return err;
>> +	return 0;
>
>or just (in all cases):
>
>	return err;
>
>> +}

Yep, will do.

Thanks for the comments,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
