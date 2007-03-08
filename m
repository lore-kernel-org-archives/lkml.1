Return-Path: <linux-kernel-owner+w=401wt.eu-S1161093AbXCHXQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093AbXCHXQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161068AbXCHXQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:16:55 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12993 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbXCHXQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:16:53 -0500
Date: Thu, 8 Mar 2007 15:08:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-Id: <20070308150839.7c191323.randy.dunlap@oracle.com>
In-Reply-To: <1173394696.5981.12.camel@localhost.localdomain>
References: <1173394696.5981.12.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2007 17:58:16 -0500 Mimi Zohar wrote:

> This is a request for comments for a new Integrity Based Access
> Control(IBAC) LSM module which bases access control decisions
> on the new integrity framework services. 
> 
> (Hopefully this will help clarify the interaction between an LSM 
> module and LIM module.)
> 
> Index: linux-2.6.21-rc3-mm2/security/ibac/Kconfig
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3-mm2/security/ibac/Kconfig
> @@ -0,0 +1,36 @@
> +config SECURITY_IBAC
> +	boolean "IBAC support"
> +	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
> +	help
> +	  Integrity Based Access Control(IBAC) implements integrity
> +	  based access control.

Please make the help text do more than repeat the words I B A C...
Put a short explanation or say something like:
	  See Documentation/security/foobar.txt for more information.
(and add that file)


> +config SECURITY_IBAC_BOOTPARAM
> +	bool "IBAC boot parameter"
> +	depends on SECURITY_IBAC
> +	default y
> +	help
> +	  This option adds a kernel parameter 'ibac', which allows IBAC
> +	  to be disabled at boot.  If this option is selected, IBAC
> +	  functionality can be disabled with ibac=0 on the kernel
> +	  command line.  The purpose of this option is to allow a
> +	  single kernel image to be distributed with IBAC built in,
> +	  but not necessarily enabled.
> +
> +	  If you are unsure how to answer this question, answer N.

What's the downside to having this always builtin instead of
yet another config option?

> +config SECURITY_IBAC_BOOTPARAM_VALUE
> +	int "IBAC boot parameter default value"
> +	depends on SECURITY_IBAC_BOOTPARAM
> +	range 0 1
> +	default 0
> +	help
> +	  This option sets the default value for the kernel parameter
> +	  'ibac', which allows IBAC to be disabled at boot.  If this
> +	  option is set to 0 (zero), the IBAC kernel parameter will
> +	  default to 0, disabling IBAC at bootup.  If this option is
> +	  set to 1 (one), the IBAC kernel parameter will default to 1,
> +	  enabling IBAC at bootup.
> +
> +	  If you are unsure how to answer this question, answer 0.
> +

> Index: linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> @@ -0,0 +1,126 @@
> +/*
> + * Integrity Based Access Control (IBAC)
> + *
> + * Copyright (C) 2007 IBM Corporation
> + * Author: Mimi Zohar <zohar@us.ibm.com>
> + *
> + *      This program is free software; you can redistribute it and/or modify
> + *      it under the terms of the GNU General Public License as published by
> + *      the Free Software Foundation, version 2 of the License.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/kernel.h>
> +#include <linux/security.h>
> +#include <linux/integrity.h>
> +
> +#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
> +int ibac_enabled = CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;

static int ?

> +static int __init ibac_enabled_setup(char *str)
> +{
> +	ibac_enabled = simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +
> +__setup("ibac=", ibac_enabled_setup);
> +#else
> +int ibac_enabled = 0;

static int ?

> +#endif
> +
> +static unsigned int integrity_enforce = 0;

Don't init to 0 (not needed, consumes some binary file space).

> +static int __init integrity_enforce_setup(char *str)
> +{
> +	integrity_enforce = simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +
> +__setup("ibac_enforce=", integrity_enforce_setup);
> +
> +#define XATTR_NAME "security.evm.hash"
> +
> +static inline int is_kernel_thread(struct task_struct *tsk)
> +{
> +	return (!tsk->mm) ? 1 : 0;
> +}
> +
> +static int ibac_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	struct dentry *dentry = bprm->file->f_dentry;
> +	int xattr_len;
> +	char *xattr_value = NULL;
> +	int rc, status;
> +
> +	rc = integrity_verify_metadata(dentry, XATTR_NAME,
> +				       &xattr_value, &xattr_len, &status);
> +	if (rc < 0 && rc == -EOPNOTSUPP) {

just	if (rc == -EOPNOTSUPP)
?

> +		kfree(xattr_value);
> +		return 0;
> +	}
> +
> +	if (rc < 0) {
> +		printk(KERN_INFO "verify_metadata %s failed "
> +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);

How about adding "ibac: " to the beginning of each printk string,
so that someone will know the general source of these messages?


> +		if (!integrity_enforce)
> +			rc = 0;
> +		goto out;
> +	}
> +	if (status != INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
> +		if (!is_kernel_thread(current)) {
> +			printk(KERN_INFO "verify_metadata %s "
> +			       "(Integrity status: FAIL)\n", bprm->filename);
> +			if (integrity_enforce) {
> +				rc = -EACCES;
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	rc = integrity_verify_data(dentry, &status);
> +	if (rc < 0) {
> +		printk(KERN_INFO "%s verify_data failed "
> +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
> +		if (!integrity_enforce)
> +			rc = 0;
> +		goto out;
> +	}
> +	if (status != INTEGRITY_PASS) {
> +		if (!is_kernel_thread(current)) {
> +			printk(KERN_INFO "verify_data %s "
> +			       "(Integrity status: FAIL)\n", bprm->filename);
> +			if (integrity_enforce) {
> +				rc = -EACCES;
> +				goto out;
> +			}
> +		}
> +	}
> +
> +	kfree(xattr_value);
> +
> +	/* measure all integrity level executables */
> +	integrity_measure(dentry, bprm->filename, MAY_EXEC);
> +	return 0;
> +      out:

Don't "hide" labels by indenting them so much.  You don't need to
indent them at all, or maybe 1 character/column.

> +	kfree(xattr_value);
> +	return rc;
> +}
> +
> +static struct security_operations ibac_security_ops = {
> +	.bprm_check_security = ibac_bprm_check_security
> +};
> +
> +static int __init init_ibac(void)
> +{
> +	int rc;
> +
> +	if (!ibac_enabled)
> +		return 0;
> +
> +	rc = register_security(&ibac_security_ops);
> +	if (rc != 0)
> +		panic("IBAC: Unable to register with kernel\n");

Normally we would not want to see a panic() from a register_xyz()
failure, but I guess you are arguing that an ibac register_security()
failure needs to halt everything??

> +	return rc;
> +}
> +
> +security_initcall(init_ibac);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
