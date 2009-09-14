Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbZINGl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbZINGl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZINGl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:41:26 -0400
Received: from centrinvest.ru ([94.25.115.130]:55954 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbZINGlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:41:25 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Mon, 14 Sep 2009 10:41:27 +0400
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] kernel handling of CPU DLPAR
Message-ID: <20090914064127.GC13139@centrinvest.ru>
Mail-Followup-To: Nathan Fontenot <nfont@austin.ibm.com>,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <4AAABC55.4070207@austin.ibm.com>
 <4AAABDF5.4090604@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAABDF5.4090604@austin.ibm.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 254, 09 11, 2009 at 04:15:33PM -0500, Nathan Fontenot wrote:
> This adds the capability to DLPAR add and remove CPUs from the kernel. The
> creates two new files /sys/devices/system/cpu/probe and
> /sys/devices/system/cpu/release to handle the DLPAR addition and
> removal of
> CPUs respectively.
> 
> CPU DLPAR add is accomplished by writing the drc-index of the CPU to the
> probe file, and removal is done by writing the device-tree path of the cpu
> to the release file.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

> +static ssize_t cpu_probe_store(struct class *class, const char *buf,
> +			       size_t count)
> +{
> +	struct device_node *dn;
> +	u32 drc_index;
> +	char *cpu_name;
> +	int rc;
> +
> +	drc_index = simple_strtoull(buf, NULL, 0);
> +	if (!drc_index)
> +		return -EINVAL;
> +
> +	rc = acquire_drc(drc_index);
> +	if (rc)
> +		return rc;
> +
> +	dn = configure_connector(drc_index);
> +	if (!dn) {
> +		release_drc(drc_index);
> +		return rc;
> +	}
> +
> +	/* fixup dn name */
> +	cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus/") + 1,
> +			   GFP_KERNEL);

Unchecked memory allocation with immediate crash in case of failure.

> +	sprintf(cpu_name, "/cpus/%s", dn->full_name);
> +	kfree(dn->full_name);
> +	dn->full_name = cpu_name;
> +
> +	rc = add_device_tree_nodes(dn);
> +	if (rc)
> +		release_drc(drc_index);
> +
> +	return rc ? rc : count;
> +}
> +
> +static ssize_t cpu_release_store(struct class *class, const char *buf,
> +				 size_t count)
> +{
> +	struct device_node *dn;
> +	u32 *drc_index;
> +	int rc;
> +
> +	dn = of_find_node_by_path(buf);
> +	if (!dn)
> +		return -EINVAL;
> +
> +	drc_index = (u32 *)of_get_property(dn, "ibm,my-drc-index", NULL);
> +	if (!drc_index) {
> +		of_node_put(dn);
> +		return -EINVAL;
> +	}
> +
> +	rc = release_drc(*drc_index);
> +	if (rc) {
> +		of_node_put(dn);
> +		return rc;
> +	}
> +
> +	rc = remove_device_tree_nodes(dn);
> +	if (rc)
> +		acquire_drc(*drc_index);
> +
> +	of_node_put(dn);
> +	return rc? rc : count;
> +}
> +
> static struct class_attribute class_attr_mem_release =
> 			__ATTR(release, S_IWUSR, NULL, memory_release_store);
> +static struct class_attribute class_attr_cpu_probe =
> +			__ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> +static struct class_attribute class_attr_cpu_release =
> +			__ATTR(release, S_IWUSR, NULL, cpu_release_store);
> 
> static int pseries_dlpar_init(void)
> {
> @@ -576,6 +648,18 @@
> 		printk(KERN_INFO "DLPAR: Could not create sysfs memory "
> 		       "release file\n");
> 
> +	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
> +			       &class_attr_cpu_probe.attr);
> +	if (rc)
> +		printk(KERN_INFO "DLPAR: Could not create sysfs cpu "
> +		       "probe file\n");
> +
> +	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
> +			       &class_attr_cpu_release.attr);
> +	if (rc)
> +		printk(KERN_INFO "DLPAR: Could not create sysfs cpu "
> +		       "release file\n");
> +
> 	return 0;
> }
> __initcall(pseries_dlpar_init);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
