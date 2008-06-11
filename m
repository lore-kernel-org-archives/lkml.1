Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYFKWiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYFKWiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYFKWh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:37:56 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44752 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbYFKWhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:37:55 -0400
Date: Wed, 11 Jun 2008 15:31:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
Message-Id: <20080611153118.3fd203a3.randy.dunlap@oracle.com>
In-Reply-To: <1211898963.4132.8.camel@localhost.localdomain>
References: <1211555145.16195.18.camel@new-host>
	<20080523163027.50021215.randy.dunlap@oracle.com>
	<1211898963.4132.8.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 10:36:03 -0400 Mimi Zohar wrote:

> Index: linux-2.6.26-rc3-git2/security/integrity/ima/ima_api.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.26-rc3-git2/security/integrity/ima/ima_api.c
> @@ -0,0 +1,365 @@
> +/*
> + * Copyright (C) 2008 IBM Corporation
> + *
> + * Authors:
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + * File: ima_api.c
> + *            - implements the LIM API
> + */
> +#include <linux/module.h>
> +#include <linux/integrity.h>
> +#include <linux/magic.h>
> +#include <linux/writeback.h>
> +#include <linux/string.h>
> +#include <linux/list.h>
> +#include <linux/audit.h>
> +#include <linux/ima.h>
> +
> +#include "ima.h"
> +
> +struct template_operations ima_template_ops = {
> +	.must_measure = ima_must_measure,
> +	.collect_measurement = ima_collect_measurement,
> +	.store_measurement = ima_store_measurement,
> +	.display_template = ima_template_show
> +};
> +
> +#ifdef CONFIG_IMA_BOOTPARAM
> +static int ima_enabled = CONFIG_IMA_BOOTPARAM_VALUE;
> +
> +static int __init ima_enabled_setup(char *str)
> +{
> +
> +	ima_enabled = simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +
> +__setup("ima=", ima_enabled_setup);
> +#else
> +static int ima_enabled = 1;
> +#endif
> +
> +/**
> + * mode_setup - for compatability with non-template IMA versions
> + * @str - is pointer to a string
> + */
> +int ima_template_mode = 1;
> +static int __init mode_setup(char *str)
> +{
> +	if (strncmp(str, "ima", 3) == 0)
> +		ima_template_mode = 0;
> +	if (strncmp(str, "template", 7) == 0)
> +		ima_template_mode = 1;
> +	printk(KERN_INFO "%s: template_mode %s \n", __func__,
> +	       ima_template_mode ? "template" : "ima");
> +	return 1;
> +}
> +
> +__setup("ima_mode=", mode_setup);
> +
> +/**
> + * ima_digest_cpy - copy the hash in the IMA template structure to a digest
> + * @template_name: string containing the name of the template (i.e. "ima")
> + * @template - pointer to template structure

 * @template:

> + * @digest - pointer to the digest

 * @digest:

> + *
> + * Returns 0 on success, error code otherwise
> + */
> +static int ima_digest_cpy(char *template_name, void *template, u8 *digest)
> +{
> +	int rc, result = 0;
> +	struct ima_inode_measure_entry *inode_template =
> +	    (struct ima_inode_measure_entry *)template;
> +
> +	rc = strcmp(template_name, "ima");
> +	if (rc == 0)
> +		memcpy(digest, inode_template->digest,
> +		       sizeof inode_template->digest);
> +	else
> +		result = -ENODATA;
> +	return result;
> +}


Thanks.
---
~Randy
