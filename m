Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZKYHNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZKYHNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZKYHNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:13:31 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41939 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZKYHNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:13:31 -0500
Message-ID: <4B0CD91C.1090704@austin.ibm.com>
Date: Wed, 25 Nov 2009 01:13:32 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
CC: gregkh@suse.de, paul Mackerras <paulus@samba.org>,
       Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2 3/3]CPU DLPAR handling
References: <4B0CD70F.6090600@austin.ibm.com>
In-Reply-To: <4B0CD70F.6090600@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the specific routines to probe and release (add and remove)
cpu resource for the powerpc pseries platform and registers these handlers
with the ppc_md callout structure.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 arch/powerpc/platforms/pseries/dlpar.c |   88 +++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-11-25 04:54:13.000000000 -0600
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-11-25 04:55:00.000000000 -0600
@@ -341,4 +341,92 @@
 	return 0;
 }
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
 
+static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
+{
+	struct device_node *dn;
+	unsigned long drc_index;
+	char *cpu_name;
+	int rc;
+
+	rc = strict_strtoul(buf, 0, &drc_index);
+	if (rc)
+		return -EINVAL;
+
+	dn = dlpar_configure_connector(drc_index);
+	if (!dn)
+		return -EINVAL;
+
+	/* configure-connector reports cpus as living in the base
+	 * directory of the device tree.  CPUs actually live in the
+	 * cpus directory so we need to fixup the full_name.
+	 */
+	cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus") + 1,
+			   GFP_KERNEL);
+	if (!cpu_name) {
+		dlpar_free_cc_nodes(dn);
+		return -ENOMEM;
+	}
+
+	sprintf(cpu_name, "/cpus%s", dn->full_name);
+	kfree(dn->full_name);
+	dn->full_name = cpu_name;
+
+	rc = dlpar_acquire_drc(drc_index);
+	if (rc) {
+		dlpar_free_cc_nodes(dn);
+		return -EINVAL;
+	}
+
+	rc = dlpar_attach_node(dn);
+	if (rc) {
+		dlpar_release_drc(drc_index);
+		dlpar_free_cc_nodes(dn);
+	}
+
+	return rc ? rc : count;
+}
+
+static ssize_t dlpar_cpu_release(const char *buf, size_t count)
+{
+	struct device_node *dn;
+	const u32 *drc_index;
+	int rc;
+
+	dn = of_find_node_by_path(buf);
+	if (!dn)
+		return -EINVAL;
+
+	drc_index = of_get_property(dn, "ibm,my-drc-index", NULL);
+	if (!drc_index) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	rc = dlpar_release_drc(*drc_index);
+	if (rc) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	rc = dlpar_detach_node(dn);
+	if (rc) {
+		dlpar_acquire_drc(*drc_index);
+		return rc;
+	}
+
+	of_node_put(dn);
+	return count;
+}
+
+static int __init pseries_dlpar_init(void)
+{
+	ppc_md.cpu_probe = dlpar_cpu_probe;
+	ppc_md.cpu_release = dlpar_cpu_release;
+
+	return 0;
+}
+machine_device_initcall(pseries, pseries_dlpar_init);
+
+#endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
