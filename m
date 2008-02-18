Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYBRHhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYBRHhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYBRHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:37:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34316 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYBRHh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:37:28 -0500
Date: Sun, 17 Feb 2008 23:40:56 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #5.1)
Message-ID: <20080218074056.GA19915@kroah.com>
References: <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B92FF5.1080301@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:12:53PM +0900, Kohei KaiGai wrote:
> Greg KH wrote:
> > On Fri, Feb 15, 2008 at 12:38:02PM -0600, Serge E. Hallyn wrote:
> >>> --------
> >>> This patch enables to export code/name of capabilities supported
> >>> on the running kernel.
> >>>
> >>> A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
> >>> at 2.6.25. However, we have no interface to disclose what capabilities
> >>> are supported on this kernel. Thus, we have to maintain libcap version
> >>> in appropriate one synchronously.
> >>>
> >>> This patch enables libcap to collect the list of capabilities on
> >>> run time, and provide them for users.
> >>> It helps to improve portability of library.
> >>>
> >>> It exports these information as regular files under /sys/kernel/capability.
> >>> The numeric node exports its name, the symbolic node exports its code.
> >>>
> >>> Please consider to put this patch on the queue of 2.6.25.
> >> Looks good, except don't you need to put the code in commoncap.c under a
> >> #ifdef SYSFS?
> 
> Fair enough.
> I added the #ifdef - #endif block in this patch.

Not needed, if SYSFS is not build in, all of that code pretty much
compiles away to nothing.  So you can drop that.

> 
> >>> ===================================================
> >>> [kaigai@saba ~]$ ls -R /sys/kernel/capability/
> >>> /sys/kernel/capability/:
> >>> codes  names  version
> >>>
> >>> /sys/kernel/capability/codes:
> >>> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
> >>> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
> >>>
> >>> /sys/kernel/capability/names:
> >>> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
> >>> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
> >>> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
> >>> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
> >>> cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
> >>> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
> >>> cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
> >>> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
> >>> cap_ipc_owner        cap_net_broadcast     cap_sys_module
> >>> [kaigai@saba ~]$ cat /sys/kernel/capability/version
> >>> 0x20071026
> >>> [kaigai@saba ~]$ cat /sys/kernel/capability/codes/30
> >>> cap_audit_control
> >>> [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_sys_pacct
> >>> 20
> >>> [kaigai@saba ~]$
> >>> ===================================================
> > 
> > As you are adding new sysfs entries, please also add the needed
> > Documentation/ABI/ entries as well.
> 
> OK, I'll add a short description at Documentation/ABI/sysfs-kernel-capability .

Thank you.

> > Also, this code can be cleaned up a lot by just using the basic kobject
> > attributes, and not rolling your own types here.
> 
> I replaced my own defined capability_attribute by kobj_attribute.
> 
> It made the patch cleaned up, however, it also impossible to share a single
> _show() method instance, because kobj_attribute does not have any private member.
> Is there any reason why kobj_attribute does not have "void *private;"?

Because no one has asked for it?  :)

Or you can just do as the example in samples/kobject/ does it, no need
for the void pointer as that code shows.



> 
> Thanks,
> Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
> --
>  Documentation/ABI/testing/sysfs-kernel-capability |   23 +++++
>  scripts/mkcapnames.sh                             |   44 +++++++++
>  security/Makefile                                 |    9 ++
>  security/commoncap.c                              |  102 +++++++++++++++++++++
>  4 files changed, 178 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-capability b/Documentation/ABI/testing/sysfs-kernel-capability
> index e69de29..402ef06 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-capability
> +++ b/Documentation/ABI/testing/sysfs-kernel-capability
> @@ -0,0 +1,23 @@
> +What:		/sys/kernel/capability
> +Date:		Feb 2008
> +Contact:	KaiGai Kohei <kaigai@ak.jp.nec.com>
> +Description:
> +		The entries under /sys/kernel/capability are used to export
> +		the list of capabilities the running kernel supported.
> +
> +		- /sys/kernel/capability/version
> +		  returns the most preferable version number for the
> +		  running kernel.
> +		  e.g) $ cat /sys/kernel/capability/version
> +		       0x20071026
> +
> +		- /sys/kernel/capability/code/<numerical representation>
> +		  returns its symbolic representation, on reading.
> +		  e.g) $ cat /sys/kernel/capability/codes/30
> +		       cap_audit_control
> +
> +		- /sys/kernel/capability/name/<symbolic representation>
> +		  returns its numerical representation, on reading.
> +		  e.g) $ cat /sys/kernel/capability/names/cap_sys_pacct
> +		       20
> +
> diff --git a/scripts/mkcapnames.sh b/scripts/mkcapnames.sh
> index e69de29..5d36d52 100644
> --- a/scripts/mkcapnames.sh
> +++ b/scripts/mkcapnames.sh
> @@ -0,0 +1,44 @@
> +#!/bin/sh
> +
> +#
> +# generate a cap_names.h file from include/linux/capability.h
> +#
> +
> +CAPHEAD="`dirname $0`/../include/linux/capability.h"
> +REGEXP='^#define CAP_[A-Z_]+[ 	]+[0-9]+$'
> +NUMCAP=`cat "$CAPHEAD" | egrep -c "$REGEXP"`
> +
> +echo '#ifndef CAP_NAMES_H'
> +echo '#define CAP_NAMES_H'
> +echo
> +echo '/*'
> +echo ' * Do NOT edit this file directly.'
> +echo ' * This file is generated from include/linux/capability.h automatically'
> +echo ' */'
> +echo
> +echo '#if !defined(SYSFS_CAP_NAME_ENTRY) || !defined(SYSFS_CAP_CODE_ENTRY)'
> +echo '#error cap_names.h should be included from security/capability.c'
> +echo '#else'
> +echo "#if $NUMCAP != CAP_LAST_CAP + 1"
> +echo '#error mkcapnames.sh cannot collect capabilities correctly'
> +echo '#else'
> +cat "$CAPHEAD" | egrep "$REGEXP" \
> +    | awk '{ printf("SYSFS_CAP_NAME_ENTRY(%s,%s);\n", tolower($2), $2); }'
> +echo
> +echo 'static struct attribute *capability_name_attrs[] = {'
> +cat "$CAPHEAD" | egrep "$REGEXP" \
> +    | awk '{ printf("\t&%s_name_attr.attr,\n", tolower($2)); } END { print "\tNULL," }'
> +echo '};'
> +
> +echo
> +cat "$CAPHEAD" | egrep "$REGEXP" \
> +    | awk '{ printf("SYSFS_CAP_CODE_ENTRY(%s,%s);\n", tolower($2), $2); }'
> +echo
> +echo 'static struct attribute *capability_code_attrs[] = {'
> +cat "$CAPHEAD" | egrep "$REGEXP" \
> +    | awk '{ printf("\t&%s_code_attr.attr,\n", tolower($2)); } END { print "\tNULL," }'
> +echo '};'
> +
> +echo '#endif'
> +echo '#endif'
> +echo '#endif'
> diff --git a/security/Makefile b/security/Makefile
> index 9e8b025..c1ffc00 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -18,3 +18,12 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
>  obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
>  obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
>  obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
> +
> +# cap_names.h contains the code/name pair of capabilities.
> +# It is generated using include/linux/capability.h automatically.
> +$(obj)/commoncap.o: $(obj)/cap_names.h
> +quiet_cmd_cap_names  = CAPS    $@
> +	cmd_cap_names  = /bin/sh $(src)/../scripts/mkcapnames.sh > $@
> +targets += cap_names.h
> +$(obj)/cap_names.h: $(src)/../scripts/mkcapnames.sh $(src)/../include/linux/capability.h FORCE
> +	$(call if_changed,cap_names)
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 5aba826..0f2f778 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -24,6 +24,8 @@
>  #include <linux/hugetlb.h>
>  #include <linux/mount.h>
>  #include <linux/sched.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> 
>  /* Global security state */
> 
> @@ -637,3 +639,103 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
>  	return __vm_enough_memory(mm, pages, cap_sys_admin);
>  }
> 
> +#ifdef CONFIG_SYSFS
> +/*
> + * Export the list of capabilities on /sys/kernel/capability
> + */
> +static struct kobject *capability_kobj;
> +
> +#define SYSFS_CAP_NAME_ENTRY(_name,_code)				\
> +	static ssize_t capname_##_name##_show(struct kobject *kobj,	\
> +					      struct kobj_attribute *attr, \
> +					      char *buffer)		\
> +	{								\
> +		return scnprintf(buffer, PAGE_SIZE, "%d\n", _code);	\
> +	}								\
> +	static struct kobj_attribute _name##_name_attr = {		\
> +		.attr = { .name = __stringify(_name), .mode = 0444, },	\
> +		.show = capname_##_name##_show,				\
> +	}
> +
> +#define SYSFS_CAP_CODE_ENTRY(_name,_code)				\
> +	static ssize_t capcode_##_name##_show(struct kobject *kobj,	\
> +					      struct kobj_attribute *attr, \
> +					      char *buffer)		\
> +	{								\
> +		return scnprintf(buffer, PAGE_SIZE, "%s\n", __stringify(_name)); \
> +	}								\
> +	static struct kobj_attribute _name##_code_attr = {		\
> +		.attr = { .name = __stringify(_code), .mode = 0444, },	\
> +		.show = capcode_##_name##_show,				\
> +	}
> +
> +/*
> + * capability_attrs[] is generated automatically by scripts/mkcapnames.sh
> + * This script parses include/linux/capability.h
> + */
> +#include "cap_names.h"
> +
> +static struct attribute_group capability_name_attr_group = {
> +	.name = "names",
> +	.attrs = capability_name_attrs,
> +};
> +
> +static struct attribute_group capability_code_attr_group = {
> +	.name = "codes",
> +	.attrs = capability_code_attrs,
> +};
> +
> +static ssize_t capability_version_show(struct kobject *kobj,
> +				       struct kobj_attribute *attr,
> +				       char *buffer)
> +{
> +	return scnprintf(buffer, PAGE_SIZE, "0x%08x\n",
> +			 _LINUX_CAPABILITY_VERSION);
> +}
> +static struct kobj_attribute cap_version_attr = {
> +	.attr = { .name = "version", .mode = 0444 },
> +	.show = capability_version_show,
> +};

We do have macros for these kinds of things :)

Look at ATTR() and friends.

> +
> +static int __init capability_export_names(void)
> +{
> +	int rc = -ENOMEM;
> +
> +	/* make /sys/kernel/capability */
> +	capability_kobj = kobject_create_and_add("capability", kernel_kobj);
> +	if (!capability_kobj)
> +		goto error0;
> +
> +	/* make /sys/kernel/capability/names */
> +	rc = sysfs_create_group(capability_kobj,
> +				&capability_name_attr_group);
> +	if (rc)
> +		goto error1;
> +
> +	/* make /sys/kernel/capability/codes */
> +	rc = sysfs_create_group(capability_kobj,
> +				&capability_code_attr_group);
> +	if (rc)
> +		goto error2;
> +
> +	/* make /sys/kernel/capability/version */
> +	rc = sysfs_create_file(capability_kobj,
> +			       &cap_version_attr.attr);
> +	if (rc)
> +		goto error3;
> +
> +	return 0;
> +
> +error3:
> +	sysfs_remove_group(capability_kobj, &capability_code_attr_group);
> +error2:
> +	sysfs_remove_group(capability_kobj, &capability_name_attr_group);
> +error1:
> +	kobject_put(capability_kobj);
> +error0:
> +	printk(KERN_ERR "Unable to export capabilities\n");
> +
> +	return rc;
> +}
> +__initcall(capability_export_names);
> +#endif	/* CONFIG_SYSFS */

Where do you remove these files?  Or will that never happen?

thanks,

greg k-h
