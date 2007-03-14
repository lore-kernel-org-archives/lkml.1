Return-Path: <linux-kernel-owner+w=401wt.eu-S1161180AbXCNMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180AbXCNMMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXCNMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:12:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34173 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161180AbXCNMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:12:46 -0400
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Seth Arnold <seth.arnold@suse.de>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070314022713.GI27643@suse.de>
References: <1173394696.5981.12.camel@localhost.localdomain>
	 <20070314022713.GI27643@suse.de>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 07:25:26 -0400
Message-Id: <1173871526.18147.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 19:27 -0700, Seth Arnold wrote:
> On Thu, Mar 08, 2007 at 05:58:16PM -0500, Mimi Zohar wrote:
> > This is a request for comments for a new Integrity Based Access
> > Control(IBAC) LSM module which bases access control decisions
> > on the new integrity framework services. 
> 
> Thanks Mimi, nice to see an example of how the integrity framework ought
> to be used.
> 
> > (Hopefully this will help clarify the interaction between an LSM 
> > module and LIM module.)
> 
> Is this module intended to clarify an interface, or be useful in and of
> itself?

It's a little bit of both. :-) Initially it was written to help me with 
implementing and testing the integrity provider.  But it could definitely stand
on it's own.  As Serge Hallyn commented http://lkml.org/lkml/2007/3/13/220, by 
adding the mmap hook, IBAC could replace the LSM aspect of digsig and a gpg 
based integrity provider, could be written, instead of EVM, which is TPM based.

> > Index: linux-2.6.21-rc3-mm2/security/ibac/Makefile
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.21-rc3-mm2/security/ibac/Makefile
> > @@ -0,0 +1,6 @@
> > +#
> > +# Makefile for building IBAC
> > +#
> > +
> > +obj-$(CONFIG_SECURITY_IBAC) += ibac.o
> > +ibac-y 	:= ibac_main.o
> > Index: linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.21-rc3-mm2/security/ibac/ibac_main.c
> > @@ -0,0 +1,126 @@
> > +/*
> > + * Integrity Based Access Control (IBAC)
> > + *
> > + * Copyright (C) 2007 IBM Corporation
> > + * Author: Mimi Zohar <zohar@us.ibm.com>
> > + *
> > + *      This program is free software; you can redistribute it and/or modify
> > + *      it under the terms of the GNU General Public License as published by
> > + *      the Free Software Foundation, version 2 of the License.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/kernel.h>
> > +#include <linux/security.h>
> > +#include <linux/integrity.h>
> > +
> > +#ifdef CONFIG_SECURITY_IBAC_BOOTPARAM
> > +int ibac_enabled = CONFIG_SECURITY_IBAC_BOOTPARAM_VALUE;
> > +
> > +static int __init ibac_enabled_setup(char *str)
> > +{
> > +	ibac_enabled = simple_strtol(str, NULL, 0);
> > +	return 1;
> > +}
> > +
> > +__setup("ibac=", ibac_enabled_setup);
> > +#else
> > +int ibac_enabled = 0;
> > +#endif
> 
> If the command line option isn't enabled, how will ibac_enabled ever be
> set to '1'? Have I overlooked or forgotten some helper routine elsewhere?

I guess I was a bit over zealous in preventing IBAC from running 
unintentionally.  Will fix in the next IBAC patch release.

> > +static unsigned int integrity_enforce = 0;
> > +static int __init integrity_enforce_setup(char *str)
> > +{
> > +	integrity_enforce = simple_strtol(str, NULL, 0);
> > +	return 1;
> > +}
> > +
> > +__setup("ibac_enforce=", integrity_enforce_setup);
> > +
> > +#define XATTR_NAME "security.evm.hash"
> 
> Is this name unique to this IBAC module? Or should it be kept in sync
> with the integrity framework?

In order to verify the metadata integrity, an xattr needs to be
specified on the integrity_verify_metadata() call.  As IBAC does not
define an xattr of its own, I used this one, which at the time worked. 
But as EVM is only one integrity provider, this probably is not a good 
idea. To resolve this problem, I guess the integrity_verify_metadata()
API call should respond without requiring an actual xattr.

> > +static inline int is_kernel_thread(struct task_struct *tsk)
> > +{
> > +	return (!tsk->mm) ? 1 : 0;
> > +}
> > +
> > +static int ibac_bprm_check_security(struct linux_binprm *bprm)
> > +{
> > +	struct dentry *dentry = bprm->file->f_dentry;
> > +	int xattr_len;
> > +	char *xattr_value = NULL;
> > +	int rc, status;
> > +
> > +	rc = integrity_verify_metadata(dentry, XATTR_NAME,
> > +				       &xattr_value, &xattr_len, &status);
> > +	if (rc < 0 && rc == -EOPNOTSUPP) {
> > +		kfree(xattr_value);
> > +		return 0;
> > +	}
> > +
> > +	if (rc < 0) {
> > +		printk(KERN_INFO "verify_metadata %s failed "
> > +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
> > +		if (!integrity_enforce)
> > +			rc = 0;
> > +		goto out;
> > +	}
> > +	if (status != INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
> > +		if (!is_kernel_thread(current)) {
> 
> Please remind me why kernel threads are exempt?

You really don't want to prevent kernel threads from working. Nasty things
happen.

> > +			printk(KERN_INFO "verify_metadata %s "
> > +			       "(Integrity status: FAIL)\n", bprm->filename);
> 
> Integrity status may be FAIL or NO_LABEL at this point -- would it be
> more useful to report the whole truth?

FAIL here indicates that the integrity of the metadata was bad, while
NOLABEL indicates, in the case of EVM, that there was no HMAC.  I'll
update the error message to differentiate between the two.

> > +			if (integrity_enforce) {
> > +				rc = -EACCES;
> > +				goto out;
> > +			}
> > +		}
> > +	}
> > +
> > +	rc = integrity_verify_data(dentry, &status);
> > +	if (rc < 0) {
> > +		printk(KERN_INFO "%s verify_data failed "
> > +		       "(rc: %d - status: %d)\n", bprm->filename, rc, status);
> > +		if (!integrity_enforce)
> > +			rc = 0;
> > +		goto out;
> > +	}
> > +	if (status != INTEGRITY_PASS) {
> > +		if (!is_kernel_thread(current)) {
> 
> Please remind me why kernel threads are exempt?

Same as above. 
> > +			printk(KERN_INFO "verify_data %s "
> > +			       "(Integrity status: FAIL)\n", bprm->filename);
> 
> Same question about FAIL vs NO_LABEL.. (Would NO_LABEL be caught by a
> failing verify_metadata above?)

For integrity_verify_data(), EVM verifies that the file hash matches the
one stored as an xattr.

> > +			if (integrity_enforce) {
> > +				rc = -EACCES;
> > +				goto out;
> > +			}
> > +		}
> > +	}
> > +
> > +	kfree(xattr_value);
> > +
> > +	/* measure all integrity level executables */
> > +	integrity_measure(dentry, bprm->filename, MAY_EXEC);
> > +	return 0;
> 
> If integrity_measure() fails (can it fail?) is allowing the exec still the
> right approach? (I seem to recall that "measuring integrity" is actually
> something more like "go off an compute the integrity, but don't compare
> it against anything" -- but even if it fails, is continuing correct?)

For integrity_measure(), EVM calls IMA, if enabled, to extend the
measurement list with the hash value it provides. In most cases, EVM
has already calculated the hash value, when it was called to verify the
data. integrity_measure() is not meant to be intrusive, so it is defined
as void.

> Rest elided :) Thanks Mimi

Thank you for your comments.

Mimi Zohar

