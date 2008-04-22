Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbYDVLQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbYDVLQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYDVLQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:16:45 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44164 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYDVLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:16:44 -0400
Message-ID: <480DC80F.3060403@ak.jp.nec.com>
Date: Tue, 22 Apr 2008 20:12:15 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
References: <47C25AE9.7080305@ak.jp.nec.com>
In-Reply-To: <47C25AE9.7080305@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches enables to export code/name pairs of
capabilities the running kernel supports, and add a documentation
and samples to use this feature.
It was too late for 2.6.25 merge window, so I submit them again
for the next development cycle.

[PATCH 1/3] add a private data field within kobj_attribute structure.

This patch add a private data field, declared as void *, within kobj_attribute
structure. The _show() and _store() method in the sysfs attribute entries can
refer this information to identify what entry is accessed.
It makes easier to share a single method implementation with several similar
entries, like ones to export the list of capabilities the running kernel
supports.

[PATCH 2/3] exporting capability name/code pairs

This patch enables to export code/name pairs of capabilities the running
kernel supported.

A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
at 2.6.25. However, we have no interface to disclose what capabilities
are supported on the running kernel. Thus, we have to maintain libcap
version in appropriate one synchronously.

This patch enables libcap to collect the list of capabilities at run time,
and provide them for users. It helps to improve portability of library.

It exports these information as regular files under /sys/kernel/capability.
The numeric node exports its name, the symbolic node exports its code.

[PATCH 3/3] a new example to use kobject/kobj_attribute

This patch can provide a new exmple to use kobject and attribute.
The _show() and _store() method can refer/store the private data field of
kobj_attribute structure to know what entries are accessed by users.
It will make easier to share a single _show()/_store() method with several
entries.

--------------
Example of execution:
[kaigai@saba ~]$ uname -r
2.6.25.capnames
[kaigai@saba ~]$ ls -R /sys/kernel/capability/
/sys/kernel/capability/:
codes  names  version

/sys/kernel/capability/codes:
0  10  12  14  16  18  2   21  23  25  27  29  30  32  4  6  8
1  11  13  15  17  19  20  22  24  26  28  3   31  33  5  7  9

/sys/kernel/capability/names:
cap_audit_control    cap_kill              cap_net_raw     cap_sys_nice
cap_audit_write      cap_lease             cap_setfcap     cap_sys_pacct
cap_chown            cap_linux_immutable   cap_setgid      cap_sys_ptrace
cap_dac_override     cap_mac_admin         cap_setpcap     cap_sys_rawio
cap_dac_read_search  cap_mac_override      cap_setuid      cap_sys_resource
cap_fowner           cap_mknod             cap_sys_admin   cap_sys_time
cap_fsetid           cap_net_admin         cap_sys_boot    cap_sys_tty_config
cap_ipc_lock         cap_net_bind_service  cap_sys_chroot
cap_ipc_owner        cap_net_broadcast     cap_sys_module
[kaigai@saba ~]$ cat /sys/kernel/capability/names/cap_sys_pacct
20
[kaigai@saba ~]$ cat /sys/kernel/capability/codes/16
cap_sys_module
[kaigai@saba ~]$
--------------

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
