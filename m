Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbYDVSe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbYDVSe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYDVSeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:34:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:23778 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYDVSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=v3KdpZWh8JfLfqZRIQIVCNYy96fRCIBmHwkp0sKOfa5WE7fOAzEAWfsJYu7dV2JkrmXjeqMswuBl7Yc7opgwa7V308r9ZNaeqGe8dZS3wCPFA8dnAq0oTnBdeW249PbAtZ78eNqYgqG1+Vnxx3CY1tLU8i0CAEAinEhCvTL26c0=
Date: Tue, 22 Apr 2008 23:29:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
Message-ID: <20080422192928.GA15768@martell.zuzino.mipt.ru>
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480DC80F.3060403@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:12:15PM +0900, KaiGai Kohei wrote:
> $ ls -R /sys/kernel/capability/
> /sys/kernel/capability/:
> codes  names  version
> 
> /sys/kernel/capability/codes:
> 0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
> 1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9
> 
> /sys/kernel/capability/names:
> cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
> cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
> cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
> cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
> cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
> cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
> cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
> cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
> cap_ipc_owner        cap_net_broadcast     cap_sys_module
> $ cat /sys/kernel/capability/names/cap_sys_pacct
> 20
> $ cat /sys/kernel/capability/codes/16
> cap_sys_module

This is amazing amount of bloat for such conceptually simple feature!

Below is /proc/capabilities ,
a) without all memory eaten by sysfs files and directories,
   generated on the fly
b) with capability names matching the ones in manpages
c) nicely formatted
e) with whole-whooping 2 lines of protection from fool
	(including helpful directions)
  Proposed regexp of course will incorrectly match someday

If this file will be used often, I can even make whole its content
become generated at compile time and then put into buffers
with 1 (one) seq_puts()!

	Alexey "0	CAP_CHOWN
		1	CAP_DAC_OVERRIDE
		2	CAP_DAC_READ_SEARCH
		3	CAP_FOWNER
		4	CAP_FSETID
		5	CAP_KILL
		6	CAP_SETGID
		7	CAP_SETUID
		8	CAP_SETPCAP
		9	CAP_LINUX_IMMUTABLE
		10	CAP_NET_BIND_SERVICE
		11	CAP_NET_BROADCAST
		12	CAP_NET_ADMIN
		13	CAP_NET_RAW
		14	CAP_IPC_LOCK
		15	CAP_IPC_OWNER
		16	CAP_SYS_MODULE
		17	CAP_SYS_RAWIO
		18	CAP_SYS_CHROOT
		19	CAP_SYS_PTRACE
		20	CAP_SYS_PACCT
		21	CAP_SYS_ADMIN
		22	CAP_SYS_BOOT
		23	CAP_SYS_NICE
		24	CAP_SYS_RESOURCE
		25	CAP_SYS_TIME
		26	CAP_SYS_TTY_CONFIG
		27	CAP_MKNOD
		28	CAP_LEASE
		29	CAP_AUDIT_WRITE
		30	CAP_AUDIT_CONTROL
		31	CAP_SETFCAP
		32	CAP_MAC_OVERRIDE
		33	CAP_MAC_ADMIN"	Dobriyan

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -19,6 +19,8 @@
 #include <linux/swap.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/ptrace.h>
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
@@ -597,3 +599,81 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
 	return __vm_enough_memory(mm, pages, cap_sys_admin);
 }
 
+#ifdef CONFIG_PROC_FS
+static const struct {
+	int val;
+	const char *str;
+} proc_cap[] = {
+#define _(cap) { .val = cap, .str = #cap }
+	_(CAP_CHOWN),
+	_(CAP_DAC_OVERRIDE),
+	_(CAP_DAC_READ_SEARCH),
+	_(CAP_FOWNER),
+	_(CAP_FSETID),
+	_(CAP_KILL),
+	_(CAP_SETGID),
+	_(CAP_SETUID),
+	_(CAP_SETPCAP),
+	_(CAP_LINUX_IMMUTABLE),
+	_(CAP_NET_BIND_SERVICE),
+	_(CAP_NET_BROADCAST),
+	_(CAP_NET_ADMIN),
+	_(CAP_NET_RAW),
+	_(CAP_IPC_LOCK),
+	_(CAP_IPC_OWNER),
+	_(CAP_SYS_MODULE),
+	_(CAP_SYS_RAWIO),
+	_(CAP_SYS_CHROOT),
+	_(CAP_SYS_PTRACE),
+	_(CAP_SYS_PACCT),
+	_(CAP_SYS_ADMIN),
+	_(CAP_SYS_BOOT),
+	_(CAP_SYS_NICE),
+	_(CAP_SYS_RESOURCE),
+	_(CAP_SYS_TIME),
+	_(CAP_SYS_TTY_CONFIG),
+	_(CAP_MKNOD),
+	_(CAP_LEASE),
+	_(CAP_AUDIT_WRITE),
+	_(CAP_AUDIT_CONTROL),
+	_(CAP_SETFCAP),
+	_(CAP_MAC_OVERRIDE),
+	_(CAP_MAC_ADMIN),
+#undef _
+};
+
+static int proc_capabilities_show(struct seq_file *m, void *v)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(proc_cap); i++)
+		seq_printf(m, "%d\t%s\n", proc_cap[i].val, proc_cap[i].str);
+	return 0;
+}
+
+static int proc_capabilities_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_capabilities_show, NULL);
+}
+
+static const struct file_operations capabilities_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_capabilities_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init commoncap_init(void)
+{
+	struct proc_dir_entry *pde;
+
+	pde = proc_create("capabilities", 0, NULL, &capabilities_proc_fops);
+	if (!pde)
+		return -ENOMEM;
+	/* Forgot to add new capability to proc_cap array? */
+	BUILD_BUG_ON(ARRAY_SIZE(proc_cap) != CAP_LAST_CAP + 1);
+	return 0;
+}
+module_init(commoncap_init);
+#endif

