Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbYBVIi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbYBVIi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 03:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYBVIiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 03:38:46 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:60472 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYBVIio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 03:38:44 -0500
Message-ID: <47BE8A10.3080103@kernel.org>
Date: Fri, 22 Feb 2008 00:38:40 -0800
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
CC: greg@kroah.com, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] exporting capability name/code pairs (final)
References: <47BE2A29.4010302@ak.jp.nec.com>
In-Reply-To: <47BE2A29.4010302@ak.jp.nec.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

KaiGai,

I've just tried to build this with a separate obj tree: make O=/path.../
~ the build failed as follows:

~  CC      security/dummy.o
~  CC      security/inode.o
~  CAPS    security/cap_names.h
/bin/sh: security/../scripts/mkcapnames.sh: No such file or directory
make[3]: *** [security/cap_names.h] Error 127
make[2]: *** [security] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

when I replace $(src)/../scripts/...  with $(srctree)/scripts/... I get
it to compile, but (x86_64) see this warning fly by:

~  CC      security/commoncap.o
/home/morgan/gits/linux-2.6/security/commoncap.c: In function
`capability_name_show':
/home/morgan/gits/linux-2.6/security/commoncap.c:652: warning: cast from
pointer to integer of different size

Cheers

Andrew

Kohei KaiGai wrote:
| [2/3] Exporting capability code/name pairs
|
| This patch enables to export code/name pairs of capabilities the running
| kernel supported.
|
| A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
| at 2.6.25. However, we have no interface to disclose what capabilities
| are supported on the running kernel. Thus, we have to maintain libcap
| version in appropriate one synchronously.
|
| This patch enables libcap to collect the list of capabilities at run time,
| and provide them for users. It helps to improve portability of library.
|
| It exports these information as regular files under
/sys/kernel/capability.
| The numeric node exports its name, the symbolic node exports its code.
|
| Please consider to put this patch on the queue of 2.6.25.
|
| Thanks,
|
| ------------ BEGIN EXAMPLE ----
| [kaigai@saba ~]$ ls -R /sys/kernel/capability/
| /sys/kernel/capability/:
| codes  names  version
|
| /sys/kernel/capability/codes:
| 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
| 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
|
| /sys/kernel/capability/names:
| cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
| cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
| cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
| cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
| cap_dac_read_search  cap_mac_override      cap_setuid
cap_sys_resource
| cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
| cap_fsetid           cap_net_admin         cap_sys_boot
cap_sys_tty_config
| cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
| cap_ipc_owner        cap_net_broadcast     cap_sys_module
| [kaigai@saba ~]$ cat /sys/kernel/capability/version
| 0x20071026
| [kaigai@saba ~]$ cat /sys/kernel/capability/codes/30
| cap_audit_control
| [kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_sys_pacct
| 20
| [kaigai@saba ~]$
| ------------ END EXAMPLE ------
|
| Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
| --
|  Documentation/ABI/testing/sysfs-kernel-capability |   23 +++++
|  scripts/mkcapnames.sh                             |   44 +++++++++
|  security/Makefile                                 |    9 ++
|  security/commoncap.c                              |   99
+++++++++++++++++++++
|  4 files changed, 175 insertions(+), 0 deletions(-)
|
| diff --git a/Documentation/ABI/testing/sysfs-kernel-capability
b/Documentation/ABI/testing/sysfs-kernel-capability
| index e69de29..402ef06 100644
| --- a/Documentation/ABI/testing/sysfs-kernel-capability
| +++ b/Documentation/ABI/testing/sysfs-kernel-capability
| @@ -0,0 +1,23 @@
| +What:		/sys/kernel/capability
| +Date:		Feb 2008
| +Contact:	KaiGai Kohei <kaigai@ak.jp.nec.com>
| +Description:
| +		The entries under /sys/kernel/capability are used to export
| +		the list of capabilities the running kernel supported.
| +
| +		- /sys/kernel/capability/version
| +		  returns the most preferable version number for the
| +		  running kernel.
| +		  e.g) $ cat /sys/kernel/capability/version
| +		       0x20071026
| +
| +		- /sys/kernel/capability/code/<numerical representation>
| +		  returns its symbolic representation, on reading.
| +		  e.g) $ cat /sys/kernel/capability/codes/30
| +		       cap_audit_control
| +
| +		- /sys/kernel/capability/name/<symbolic representation>
| +		  returns its numerical representation, on reading.
| +		  e.g) $ cat /sys/kernel/capability/names/cap_sys_pacct
| +		       20
| +
| diff --git a/scripts/mkcapnames.sh b/scripts/mkcapnames.sh
| index e69de29..5d36d52 100644
| --- a/scripts/mkcapnames.sh
| +++ b/scripts/mkcapnames.sh
| @@ -0,0 +1,44 @@
| +#!/bin/sh
| +
| +#
| +# generate a cap_names.h file from include/linux/capability.h
| +#
| +
| +CAPHEAD="`dirname $0`/../include/linux/capability.h"
| +REGEXP='^#define CAP_[A-Z_]+[ 	]+[0-9]+$'
| +NUMCAP=`cat "$CAPHEAD" | egrep -c "$REGEXP"`
| +
| +echo '#ifndef CAP_NAMES_H'
| +echo '#define CAP_NAMES_H'
| +echo
| +echo '/*'
| +echo ' * Do NOT edit this file directly.'
| +echo ' * This file is generated from include/linux/capability.h
automatically'
| +echo ' */'
| +echo
| +echo '#if !defined(SYSFS_CAP_NAME_ENTRY) ||
!defined(SYSFS_CAP_CODE_ENTRY)'
| +echo '#error cap_names.h should be included from security/capability.c'
| +echo '#else'
| +echo "#if $NUMCAP != CAP_LAST_CAP + 1"
| +echo '#error mkcapnames.sh cannot collect capabilities correctly'
| +echo '#else'
| +cat "$CAPHEAD" | egrep "$REGEXP" \
| +    | awk '{ printf("SYSFS_CAP_NAME_ENTRY(%s,%s);\n", tolower($2),
$2); }'
| +echo
| +echo 'static struct attribute *capability_name_attrs[] = {'
| +cat "$CAPHEAD" | egrep "$REGEXP" \
| +    | awk '{ printf("\t&%s_name_attr.attr,\n", tolower($2)); } END {
print "\tNULL," }'
| +echo '};'
| +
| +echo
| +cat "$CAPHEAD" | egrep "$REGEXP" \
| +    | awk '{ printf("SYSFS_CAP_CODE_ENTRY(%s,%s);\n", tolower($2),
$2); }'
| +echo
| +echo 'static struct attribute *capability_code_attrs[] = {'
| +cat "$CAPHEAD" | egrep "$REGEXP" \
| +    | awk '{ printf("\t&%s_code_attr.attr,\n", tolower($2)); } END {
print "\tNULL," }'
| +echo '};'
| +
| +echo '#endif'
| +echo '#endif'
| +echo '#endif'
| diff --git a/security/Makefile b/security/Makefile
| index 9e8b025..c1ffc00 100644
| --- a/security/Makefile
| +++ b/security/Makefile
| @@ -18,3 +18,12 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
|  obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
|  obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
|  obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
| +
| +# cap_names.h contains the code/name pair of capabilities.
| +# It is generated using include/linux/capability.h automatically.
| +$(obj)/commoncap.o: $(obj)/cap_names.h
| +quiet_cmd_cap_names  = CAPS    $@
| +	cmd_cap_names  = /bin/sh $(src)/../scripts/mkcapnames.sh > $@
| +targets += cap_names.h
| +$(obj)/cap_names.h: $(src)/../scripts/mkcapnames.sh
$(src)/../include/linux/capability.h FORCE
| +	$(call if_changed,cap_names)
| diff --git a/security/commoncap.c b/security/commoncap.c
| index 5aba826..2f3b49a 100644
| --- a/security/commoncap.c
| +++ b/security/commoncap.c
| @@ -24,6 +24,8 @@
|  #include <linux/hugetlb.h>
|  #include <linux/mount.h>
|  #include <linux/sched.h>
| +#include <linux/kobject.h>
| +#include <linux/sysfs.h>
|
|  /* Global security state */
|
| @@ -637,3 +639,100 @@ int cap_vm_enough_memory(struct mm_struct *mm,
long pages)
|  	return __vm_enough_memory(mm, pages, cap_sys_admin);
|  }
|
| +/*
| + * Export the list of capabilities on /sys/kernel/capability
| + */
| +static struct kobject *capability_kobj;
| +
| +static ssize_t capability_name_show(struct kobject *kobj,
| +				    struct kobj_attribute *attr,
| +				    char *buffer)
| +{
| +	/* It returns numerical representation of capability. */
| +	return scnprintf(buffer, PAGE_SIZE, "%d\n", (int) attr->data);
| +}
| +
| +static ssize_t capability_code_show(struct kobject *kobj,
| +				    struct kobj_attribute *attr,
| +				    char *buffer)
| +{
| +	/* It returns symbolic representation of capability. */
| +	return scnprintf(buffer, PAGE_SIZE, "%s\n", (char *) attr->data);
| +}
| +
| +static ssize_t capability_version_show(struct kobject *kobj,
| +				       struct kobj_attribute *attr,
| +				       char *buffer)
| +{
| +	return scnprintf(buffer, PAGE_SIZE, "0x%08x\n",
| +			 _LINUX_CAPABILITY_VERSION);
| +}
| +
| +#define SYSFS_CAP_NAME_ENTRY(_name,_code)				\
| +	static struct kobj_attribute _name##_name_attr =		\
| +		__ATTR_DATA(_name, 0444, capability_name_show, NULL, (int)(_code))
| +
| +#define SYSFS_CAP_CODE_ENTRY(_name,_code)				\
| +	static struct kobj_attribute _name##_code_attr =		\
| +		__ATTR_DATA(_code, 0444, capability_code_show, NULL,
__stringify(_name))
| +
| +/*
| + * capability_attrs[] is generated automatically by scripts/mkcapnames.sh
| + * This script parses include/linux/capability.h
| + */
| +#include "cap_names.h"
| +
| +static struct attribute_group capability_name_attr_group = {
| +	.name = "names",
| +	.attrs = capability_name_attrs,
| +};
| +
| +static struct attribute_group capability_code_attr_group = {
| +	.name = "codes",
| +	.attrs = capability_code_attrs,
| +};
| +
| +static struct kobj_attribute cap_version_attr =
| +	__ATTR(version, 0444, capability_version_show, NULL);
| +
| +static int __init capability_export_names(void)
| +{
| +	int rc = -ENOMEM;
| +
| +	/* make /sys/kernel/capability */
| +	capability_kobj = kobject_create_and_add("capability", kernel_kobj);
| +	if (!capability_kobj)
| +		goto error0;
| +
| +	/* make /sys/kernel/capability/names */
| +	rc = sysfs_create_group(capability_kobj,
| +				&capability_name_attr_group);
| +	if (rc)
| +		goto error1;
| +
| +	/* make /sys/kernel/capability/codes */
| +	rc = sysfs_create_group(capability_kobj,
| +				&capability_code_attr_group);
| +	if (rc)
| +		goto error2;
| +
| +	/* make /sys/kernel/capability/version */
| +	rc = sysfs_create_file(capability_kobj,
| +			       &cap_version_attr.attr);
| +	if (rc)
| +		goto error3;
| +
| +	return 0;
| +
| +error3:
| +	sysfs_remove_group(capability_kobj, &capability_code_attr_group);
| +error2:
| +	sysfs_remove_group(capability_kobj, &capability_name_attr_group);
| +error1:
| +	kobject_put(capability_kobj);
| +error0:
| +	printk(KERN_ERR "Unable to export capabilities\n");
| +
| +	return rc;
| +}
| +__initcall(capability_export_names);
|

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFHvooQ+bHCR3gb8jsRAsjEAJ4ywPBy5cmwOVvcLRbqZ1ev5yPc7ACgrols
s4wJfHBWdaM1zQLPPmH4WSM=
=2ojk
-----END PGP SIGNATURE-----
