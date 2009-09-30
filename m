Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZI3VFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZI3VFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZI3VFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:05:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52227 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753681AbZI3VF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:05:28 -0400
Date: Wed, 30 Sep 2009 16:05:31 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/2] x86: UV hardware performance counter and topology access
Message-ID: <20090930210531.GC12090@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds device named "/dev/uv_hwperf" that supports an ioctl interface
to call down into BIOS to read/write memory mapped performance
monitoring registers.
Adds /proc/sgi_uv/topology file, providing the node locations, etc.

Diffed against 2.6.31

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Russ Anderson <rja@sgi.com>

---

This patch only effects UV systems.

 arch/x86/Kconfig            |    6 
 arch/x86/kernel/Makefile    |    1 
 arch/x86/kernel/uv_hwperf.c | 1095 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uv/geo.h    |  121 ++++
 include/asm-x86/uv/hwperf.h |  255 ++++++++++
 5 files changed, 1478 insertions(+)

Index: linux/arch/x86/kernel/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/Makefile	2009-09-30 15:22:48.000000000 -0500
+++ linux/arch/x86/kernel/Makefile	2009-09-30 15:22:55.000000000 -0500
@@ -38,6 +38,7 @@ obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
+obj-$(CONFIG_UV_HWPERF)	+= uv_hwperf.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
Index: linux/arch/x86/kernel/uv_hwperf.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/uv_hwperf.c	2009-09-30 15:22:55.000000000 -0500
@@ -0,0 +1,1095 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Silicon Graphics International Corp. All rights reserved.
+ *
+ * SGI UV hardware performance monitoring API.
+ * Cliff Wickman <cpw@sgi.com>.
+ *
+ * Creates a dynamic device named "/dev/uv_hwperf" that supports an ioctl
+ * interface to call down into BIOS to read/write memory mapped registers,
+ * e.g. for performance monitoring.
+ * The "uv_hwperf" device is registered only after the sysfs
+ * file is first opened, i.e. only if/when it's needed.
+ *
+ * The /proc/sgi_uv/topology file provides the node locations, etc.
+ *
+ * This API is used by SGI Performance Co-Pilot and other
+ * tools, see http://oss.sgi.com/projects/pcp
+ */
+
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/seq_file.h>
+#include <linux/miscdevice.h>
+#include <linux/utsname.h>
+#include <linux/cpumask.h>
+#include <linux/smp_lock.h>
+#include <linux/nodemask.h>
+#include <linux/smp.h>
+#include <linux/mutex.h>
+#include <linux/cpufreq.h>
+#include <linux/sysdev.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <asm/processor.h>
+#include <asm/topology.h>
+#include <asm/uaccess.h>
+#include <asm/types.h>
+#include <asm/uv/hwperf.h>
+#include <asm/uv/geo.h>
+#include <asm/uv/bios.h>
+#include <asm/uv/uv.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/genapic.h>
+
+static void *uv_hwperf_biosheap;
+static int uv_hwperf_obj_cnt;
+static signed short uv_hwperf_master_nasid = INVALID_NASID;
+static int uv_hwperf_initial_bios_calls(void);
+static DEFINE_MUTEX(uv_hwperf_init_mutex);
+static int num_cnodes;
+
+struct kobject *uv_hwperf_kobj;
+
+#define cnode_possible(n)	((n) < num_cnodes)
+
+static int uv_hwperf_enum_objects(int *nobj, struct uv_hwperf_object_info **ret)
+{
+	s64 e;
+	u64 sz;
+	struct uv_hwperf_object_info *objbuf = NULL;
+
+	sz = uv_hwperf_obj_cnt * sizeof(struct uv_hwperf_object_info);
+	objbuf = vmalloc(sz);
+	if (objbuf == NULL) {
+		printk(KERN_ERR "uv_hwperf_enum_objects: vmalloc(%d) failed\n",
+			 (int)sz);
+		e = -ENOMEM;
+		goto out;
+	}
+
+	e = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_ENUM_OBJECTS, 0,
+		sz, (u64 *)objbuf, NULL);
+	if (e != BIOS_STATUS_SUCCESS) {
+		e = -EINVAL;
+		vfree(objbuf);
+	}
+
+out:
+	*nobj = uv_hwperf_obj_cnt;
+	*ret = objbuf;
+	return e;
+}
+
+static int uv_hwperf_location_to_bpos(char *location,
+	int *rack, int *slot, int *blade)
+{
+	char type;
+
+	/* first scan for a geoid string */
+	if (sscanf(location, "%03d%c%02db%d", rack, &type, slot, blade) != 4)
+		return -1;
+	return 0;
+}
+
+int
+cnodeid_to_nasid(int pnode)
+{
+	return UV_PNODE_TO_NASID(pnode);
+}
+
+union geoid_u
+cnodeid_get_geoid(int cnode)
+{
+	union geoid_u geoid;
+	/*
+	 * if per-node info from the pcfg (prom configuration table) has
+	 * already been located and squirreled away, return this nodes's
+	 * geoid.
+	 *
+	 * else
+	 *   read the pcfg from the bios
+	 *   for each cnode:
+	 *     convert cnode to nasid
+	 *     search the pcfg by nasid
+	 *     squirrel away the node's geoid
+	 *   return this cnode's geoid
+	 */
+
+	uv_bios_get_geoinfo(cnodeid_to_nasid(cnode), (u64)&geoid,
+			    sizeof(union geoid_u));
+	return geoid;
+}
+
+static int uv_hwperf_geoid_to_cnode(char *location)
+{
+	int cnode;
+	union geoid_u geoid;
+	int rack, slot, blade;
+	int this_rack, this_slot, this_blade;
+
+	if (uv_hwperf_location_to_bpos(location, &rack, &slot, &blade))
+		return -1;
+
+	for (cnode = 0; cnode < num_cnodes; cnode++) {
+		geoid = cnodeid_get_geoid(cnode);
+		this_rack = geo_rack(geoid);
+		this_slot = geo_slot(geoid);
+		this_blade = geo_blade(geoid);
+		if (rack == this_rack && slot == this_slot &&
+		    blade == this_blade) {
+			break;
+		}
+	}
+
+	return cnode_possible(cnode) ? cnode : -1;
+}
+
+static int uv_hwperf_obj_to_cnode(struct uv_hwperf_object_info *obj)
+{
+	if (!UV_HWPERF_IS_NODE(obj) && !UV_HWPERF_IS_IONODE(obj))
+		BUG();
+	if (UV_HWPERF_FOREIGN(obj))
+		return -1;
+	return uv_hwperf_geoid_to_cnode(obj->location);
+}
+
+static int uv_hwperf_generic_ordinal(struct uv_hwperf_object_info *obj,
+				struct uv_hwperf_object_info *objs)
+{
+	int ordinal;
+	struct uv_hwperf_object_info *p;
+
+	for (ordinal = 0, p = objs; p != obj; p++) {
+		if (UV_HWPERF_FOREIGN(p))
+			continue;
+		if (UV_HWPERF_SAME_OBJTYPE(p, obj))
+			ordinal++;
+	}
+
+	return ordinal;
+}
+
+static const char *slabname_node =	"node"; /* UVhub asic */
+static const char *slabname_ionode =	"ionode"; /* TIO asic */
+static const char *slabname_router =	"router"; /* NL5 */
+static const char *slabname_other =	"other"; /* unknown asic */
+
+static const char *uv_hwperf_get_slabname(struct uv_hwperf_object_info *obj,
+			struct uv_hwperf_object_info *objs, int *ordinal)
+{
+	int isnode;
+	const char *slabname = slabname_other;
+
+	isnode = UV_HWPERF_IS_NODE(obj);
+	if (isnode || UV_HWPERF_IS_IONODE(obj)) {
+		slabname = isnode ? slabname_node : slabname_ionode;
+		*ordinal = uv_hwperf_obj_to_cnode(obj);
+	} else {
+		*ordinal = uv_hwperf_generic_ordinal(obj, objs);
+		if (UV_HWPERF_IS_ROUTER(obj))
+			slabname = slabname_router;
+	}
+
+	return slabname;
+}
+
+static void print_pci_topology(struct seq_file *s)
+{
+	char *p;
+	size_t sz;
+	s64 e;
+
+	for (sz = PAGE_SIZE; sz < 16 * PAGE_SIZE; sz += PAGE_SIZE) {
+		p = kmalloc(sz, GFP_KERNEL);
+		if (!p)
+			break;
+		e = uv_bios_get_pci_topology((u64)p, sz);
+		if (e == BIOS_STATUS_SUCCESS)
+			seq_puts(s, p);
+		kfree(p);
+		if (e == BIOS_STATUS_SUCCESS || e == BIOS_STATUS_UNIMPLEMENTED)
+			break;
+	}
+}
+
+static inline int uv_hwperf_has_cpus(short node)
+{
+	return node < MAX_NUMNODES && node_online(node) && nr_cpus_node(node);
+}
+
+static inline int uv_hwperf_has_mem(short node)
+{
+	return node < MAX_NUMNODES && node_online(node) &&
+		NODE_DATA(node)->node_present_pages;
+}
+
+static struct uv_hwperf_object_info *
+uv_hwperf_findobj_id(struct uv_hwperf_object_info *objbuf,
+	int nobj, int id)
+{
+	int i;
+	struct uv_hwperf_object_info *p = objbuf;
+
+	for (i = 0; i < nobj; i++, p++) {
+		if (p->id == id)
+			return p;
+	}
+
+	return NULL;
+
+}
+
+static int uv_hwperf_get_nearest_node_objdata
+	(struct uv_hwperf_object_info *objbuf, int nobj, short node,
+	 short *near_mem_node, short *near_cpu_node)
+{
+	s64 e;
+	struct uv_hwperf_object_info *nodeobj = NULL;
+	struct uv_hwperf_object_info *op;
+	struct uv_hwperf_object_info *dest;
+	struct uv_hwperf_object_info *router;
+	struct uv_hwperf_port_info ptdata[16];
+	int sz, i, j;
+	short c;
+	int found_mem = 0;
+	int found_cpu = 0;
+
+	if (!cnode_possible(node))
+		return -EINVAL;
+
+	if (uv_hwperf_has_cpus(node)) {
+		if (near_cpu_node)
+			*near_cpu_node = node;
+		found_cpu++;
+	}
+
+	if (uv_hwperf_has_mem(node)) {
+		if (near_mem_node)
+			*near_mem_node = node;
+		found_mem++;
+	}
+
+	if (found_cpu && found_mem)
+		return 0; /* trivially successful */
+
+	/* find the argument node object */
+	for (i = 0, op = objbuf; i < nobj; i++, op++) {
+		if (!UV_HWPERF_IS_NODE(op) && !UV_HWPERF_IS_IONODE(op))
+			continue;
+		if (node == uv_hwperf_obj_to_cnode(op)) {
+			nodeobj = op;
+			break;
+		}
+	}
+	if (!nodeobj) {
+		e = -ENOENT;
+		goto err;
+	}
+
+	/* get its interconnect topology */
+	sz = op->ports * sizeof(struct uv_hwperf_port_info);
+	if (sz > sizeof(ptdata))
+		BUG();
+	e = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_ENUM_PORTS,
+		nodeobj->id, sz, (u64 *)&ptdata, NULL);
+	if (e != BIOS_STATUS_SUCCESS) {
+		e = -EINVAL;
+		goto err;
+	}
+
+	/* find nearest node with cpus and nearest memory */
+	for (router = NULL, j = 0; j < op->ports; j++) {
+		dest = uv_hwperf_findobj_id(objbuf, nobj, ptdata[j].conn_id);
+		if (dest && UV_HWPERF_IS_ROUTER(dest))
+			router = dest;
+		if (!dest || UV_HWPERF_FOREIGN(dest) ||
+		    !UV_HWPERF_IS_NODE(dest) || UV_HWPERF_IS_IONODE(dest)) {
+			continue;
+		}
+		c = uv_hwperf_obj_to_cnode(dest);
+		if (!found_cpu && uv_hwperf_has_cpus(c)) {
+			if (near_cpu_node)
+				*near_cpu_node = c;
+			found_cpu++;
+		}
+		if (!found_mem && uv_hwperf_has_mem(c)) {
+			if (near_mem_node)
+				*near_mem_node = c;
+			found_mem++;
+		}
+	}
+
+	if (router && (!found_cpu || !found_mem)) {
+		/* search for a node connected to the same router */
+		sz = router->ports * sizeof(struct uv_hwperf_port_info);
+		if (sz > sizeof(ptdata))
+			BUG();
+		e = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_ENUM_PORTS,
+				router->id, sz, (u64 *)&ptdata, NULL);
+		if (e != BIOS_STATUS_SUCCESS) {
+			e = -EINVAL;
+			goto err;
+		}
+		for (j = 0; j < router->ports; j++) {
+			dest = uv_hwperf_findobj_id(objbuf, nobj,
+				ptdata[j].conn_id);
+			if (!dest || dest->id == node ||
+			    UV_HWPERF_FOREIGN(dest) ||
+			    !UV_HWPERF_IS_NODE(dest) ||
+			    UV_HWPERF_IS_IONODE(dest)) {
+				continue;
+			}
+			c = uv_hwperf_obj_to_cnode(dest);
+			if (!found_cpu && uv_hwperf_has_cpus(c)) {
+				if (near_cpu_node)
+					*near_cpu_node = c;
+				found_cpu++;
+			}
+			if (!found_mem && uv_hwperf_has_mem(c)) {
+				if (near_mem_node)
+					*near_mem_node = c;
+				found_mem++;
+			}
+			if (found_cpu && found_mem)
+				break;
+		}
+	}
+
+	if (!found_cpu || !found_mem) {
+		/* resort to _any_ node with CPUs and memory */
+		for (i = 0, op = objbuf; i < nobj; i++, op++) {
+			if (UV_HWPERF_FOREIGN(op) ||
+			    UV_HWPERF_IS_IONODE(op) ||
+			    !UV_HWPERF_IS_NODE(op)) {
+				continue;
+			}
+			c = uv_hwperf_obj_to_cnode(op);
+			if (!found_cpu && uv_hwperf_has_cpus(c)) {
+				if (near_cpu_node)
+					*near_cpu_node = c;
+				found_cpu++;
+			}
+			if (!found_mem && uv_hwperf_has_mem(c)) {
+				if (near_mem_node)
+					*near_mem_node = c;
+				found_mem++;
+			}
+			if (found_cpu && found_mem)
+				break;
+		}
+	}
+
+	if (!found_cpu || !found_mem)
+		e = -ENODATA;
+err:
+	return e;
+}
+
+static int uv_topology_show(struct seq_file *s, void *d)
+{
+	int sz;
+	int pt;
+	int e = 0;
+	int i;
+	int j = 0;
+	const char *slabname;
+	int ordinal;
+	const struct cpumask *cpumask;
+	struct cpuinfo_x86 *c;
+	struct uv_hwperf_port_info *ptdata;
+	struct uv_hwperf_object_info *p;
+	struct uv_hwperf_object_info *obj = d;	/* this object */
+	struct uv_hwperf_object_info *objs = s->private; /* all objects */
+	int uv_type = 0;
+	long partid = 0;
+	long coher = 0;
+	long region_size = 0;
+	long system_serial_number = 0;
+	unsigned int freq;
+
+	if (obj == objs) {
+		seq_printf(s, "# uv_topology version 1\n");
+		seq_printf(s, "# objtype ordinal location partition"
+			" [attribute value [, ...]]\n");
+
+		if (uv_bios_get_sn_info(0, &uv_type, &partid, &coher,
+			&region_size, &system_serial_number))
+			BUG();
+		seq_printf(s, "partition %ld %s local "
+			"uvtype %s, "
+			"coherency_domain %ld, "
+			"region_size %ld, "
+			"system_serial_number %ld\n",
+			partid, utsname()->nodename,
+			uv_type ? "unknown" : "UVhub",
+			coher, region_size, system_serial_number);
+
+		print_pci_topology(s);
+	}
+
+	if (UV_HWPERF_FOREIGN(obj)) {
+		/* private in another partition: not interesting */
+		return 0;
+	}
+
+	for (i = 0; i < UV_HWPERF_MAXSTRING && obj->name[i]; i++) {
+		if (obj->name[i] == ' ')
+			obj->name[i] = '_';
+	}
+
+	slabname = uv_hwperf_get_slabname(obj, objs, &ordinal);
+	seq_printf(s, "%s %d %s %s asic %s", slabname, ordinal, obj->location,
+		obj->uv_hwp_this_part ? "local" : "shared", obj->name);
+
+	if (ordinal < 0 ||
+	    (!UV_HWPERF_IS_NODE(obj) && !UV_HWPERF_IS_IONODE(obj)))
+		seq_putc(s, '\n');
+	else {
+		short near_mem = -1;
+		short near_cpu = -1;
+
+		seq_printf(s, ", nasid 0x%x", cnodeid_to_nasid(ordinal));
+
+		if (uv_hwperf_get_nearest_node_objdata(objs, uv_hwperf_obj_cnt,
+			ordinal, &near_mem, &near_cpu) == 0) {
+			seq_printf(s,
+				   ", near_mem_nodeid %d, near_cpu_nodeid %d",
+				   near_mem, near_cpu);
+		}
+
+		if (!UV_HWPERF_IS_IONODE(obj)) {
+			for_each_online_node(i) {
+				seq_printf(s, i ? ":%d" : ", dist %d",
+					node_distance(ordinal, i));
+			}
+		}
+
+		seq_putc(s, '\n');
+
+		/*
+		 * CPUs on this node, if any
+		 */
+		if (!UV_HWPERF_IS_IONODE(obj)) {
+			cpumask = cpumask_of_node(ordinal);
+			for_each_online_cpu(i) {
+				if (cpu_isset(i, *cpumask)) {
+					c = (struct cpuinfo_x86 *)&cpu_data(i);
+					freq = cpufreq_quick_get(j);
+					if (!freq)
+						freq = cpu_khz;
+					seq_printf(s, "cpu %d %s%d local"
+						" freq %uMHz, arch UV",
+						i, obj->location,
+						c->cpu_core_id,
+						freq / 1000);
+					for_each_online_cpu(j) {
+						seq_printf(s, j ?
+							":%d" : ", dist %d",
+							node_distance(
+							cpu_to_node(i),
+							cpu_to_node(j)));
+					}
+					seq_putc(s, '\n');
+				}
+			}
+		}
+	}
+
+	if (obj->ports) {
+		/*
+		 * numalink ports
+		 */
+		sz = obj->ports * sizeof(struct uv_hwperf_port_info);
+		ptdata = kmalloc(sz, GFP_KERNEL);
+		if (ptdata == NULL)
+			return -ENOMEM;
+		e = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_ENUM_PORTS,
+				obj->id, sz, (u64 *)ptdata, NULL);
+		if (e != BIOS_STATUS_SUCCESS)
+			return -EINVAL;
+		for (ordinal = 0, p = objs; p != obj; p++)
+			if (!UV_HWPERF_FOREIGN(p))
+				ordinal += p->ports;
+		for (pt = 0; pt < obj->ports; pt++) {
+			for (p = objs, i = 0; i < uv_hwperf_obj_cnt; i++, p++) {
+				if (ptdata[pt].conn_id == p->id)
+					break;
+			}
+			seq_printf(s, "numalink %d %s-%d",
+				ordinal+pt, obj->location, ptdata[pt].port);
+
+			if (i >= uv_hwperf_obj_cnt) {
+				/* no connection */
+				seq_puts(s, " local endpoint disconnected"
+					    ", protocol unknown\n");
+				continue;
+			}
+
+			if (obj->uv_hwp_this_part && p->uv_hwp_this_part)
+				/* both ends local to this partition */
+				seq_puts(s, " local");
+			else if (UV_HWPERF_FOREIGN(p))
+				/* both ends of the link in foreign partiton */
+				seq_puts(s, " foreign");
+			else
+				/* link straddles a partition */
+				seq_puts(s, " shared");
+
+			seq_printf(s, " endpoint %s-%d, protocol %s\n",
+				p->location, ptdata[pt].conn_port,
+				(UV_HWPERF_IS_NL5ROUTER(p)) ?  "LLP5" : "LL??");
+		}
+		kfree(ptdata);
+	}
+
+	return 0;
+}
+
+static void *uv_topology_start(struct seq_file *s, loff_t * pos)
+{
+	struct uv_hwperf_object_info *objs = s->private;
+
+	if (*pos < uv_hwperf_obj_cnt)
+		return (void *)(objs + *pos);
+
+	return NULL;
+}
+
+static void *uv_topology_next(struct seq_file *s, void *v, loff_t * pos)
+{
+	++*pos;
+	return uv_topology_start(s, pos);
+}
+
+static void uv_topology_stop(struct seq_file *m, void *v)
+{
+	return;
+}
+
+/*
+ * /proc/sgi_uv/topology, read-only using seq_file
+ */
+static const struct seq_operations uv_topology_seq_ops = {
+	.start = uv_topology_start,
+	.next = uv_topology_next,
+	.stop = uv_topology_stop,
+	.show = uv_topology_show
+};
+
+struct uv_hwperf_op_info {
+	u64 op;
+	struct uv_hwperf_ioctl_args *a;
+	void *p;
+	int *v0;
+	int ret;
+};
+
+static void uv_hwperf_call_bios(void *info)
+{
+	struct uv_hwperf_op_info *op_info = info;
+	s64 r;
+
+	r = uv_bios_hwperf(uv_hwperf_master_nasid, op_info->op, op_info->a->arg,
+			 op_info->a->sz, (u64 *)op_info->p, NULL);
+	*op_info->v0 = r;
+	op_info->ret = r;
+}
+
+static int uv_hwperf_op_cpu(struct uv_hwperf_op_info *op_info)
+{
+	u32 cpu;
+	u32 use_ipi;
+	int r = 0;
+	cpumask_t save_allowed;
+
+	cpu = (op_info->a->arg & UV_HWPERF_ARG_CPU_MASK) >> 32;
+	use_ipi = op_info->a->arg & UV_HWPERF_ARG_USE_IPI_MASK;
+	op_info->a->arg &= UV_HWPERF_ARG_OBJID_MASK;
+
+	if (cpu != UV_HWPERF_ARG_ANY_CPU) {
+		if (!cpu_possible(cpu) || !cpu_online(cpu)) {
+			r = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (cpu == UV_HWPERF_ARG_ANY_CPU || cpu == get_cpu()) {
+		/* don't care, or already on correct cpu */
+		uv_hwperf_call_bios(op_info);
+	} else {
+		if (use_ipi)
+			/* use an interprocessor interrupt to call BIOS */
+			{
+			smp_call_function_single(cpu, uv_hwperf_call_bios,
+				op_info, 1);
+			}
+		else {
+			/* migrate the task before calling BIOS */
+			save_allowed = current->cpus_allowed;
+			set_cpus_allowed_ptr(current, cpumask_of(cpu));
+			uv_hwperf_call_bios(op_info);
+			set_cpus_allowed_ptr(current, &save_allowed);
+		}
+	}
+	r = op_info->ret;
+
+out:
+	return r;
+}
+
+/* map BIOS hwperf error code to system error code */
+static int uv_hwperf_map_err(int hwperf_err)
+{
+	int e;
+
+	switch (hwperf_err) {
+	case BIOS_STATUS_SUCCESS:
+		e = 0;
+		break;
+
+	case UV_HWPERF_OP_NOMEM:
+		e = -ENOMEM;
+		break;
+
+	case UV_HWPERF_OP_NO_PERM:
+		e = -EPERM;
+		break;
+
+	case UV_HWPERF_OP_IO_ERROR:
+		e = -EIO;
+		break;
+
+	case UV_HWPERF_OP_BUSY:
+		e = -EBUSY;
+		break;
+
+	case UV_HWPERF_OP_RECONFIGURE:
+		e = -EAGAIN;
+		break;
+
+	case UV_HWPERF_OP_INVAL:
+	default:
+		e = -EINVAL;
+		break;
+	}
+
+	return e;
+}
+
+/*
+ * ioctl for "uv_hwperf" misc device
+ * (called via the uv_hwperf_dev and uv_hwperf_fops structures)
+ */
+static int
+uv_hwperf_ioctl(struct inode *in, struct file *fp, unsigned int op,
+		unsigned long arg)
+{
+	struct uv_hwperf_ioctl_args a;
+	struct uv_hwperf_object_info *objs;
+	struct uv_hwperf_object_info *cpuobj;
+	struct uv_hwperf_op_info op_info;
+	struct cpuinfo_x86 *cdata;
+	void *p = NULL;
+	int nobj;
+	int node = 0;
+	int r;
+	int v0;
+	int i;
+	int j;
+	unsigned int freq;
+
+	unlock_kernel();
+
+	/* only user requests are allowed here */
+	if ((op & UV_HWPERF_OP_MASK) <
+		(UV_HWPERF_OBJECT_COUNT & UV_HWPERF_OP_MASK)) {
+		r = -EINVAL;
+		goto error;
+	}
+	r = copy_from_user(&a, (const void __user *)arg,
+		sizeof(struct uv_hwperf_ioctl_args));
+	if (r != 0) {
+		r = -EFAULT;
+		goto error;
+	}
+
+	/*
+	 * Allocate memory to hold a kernel copy of the user buffer. The
+	 * buffer contents are either copied in or out (or both) of user
+	 * space depending on the flags encoded in the requested operation.
+	 */
+	if (a.ptr) {
+		p = vmalloc(a.sz);
+		if (!p) {
+			r = -ENOMEM;
+			goto error;
+		}
+	}
+
+	if (op & UV_HWPERF_OP_MEM_COPYIN) {
+		r = copy_from_user(p, (const void __user *)a.ptr, a.sz);
+		if (r != 0) {
+			r = -EFAULT;
+			goto error;
+		}
+	}
+
+	switch (op) {
+	case UV_HWPERF_GET_CPU_INFO:
+		if (a.sz == sizeof(u64)) {
+			/* special case to get size needed */
+			*(u64 *) p =
+				(u64) num_online_cpus() *
+				sizeof(struct uv_hwperf_object_info);
+		} else if (a.sz < num_online_cpus() *
+				sizeof(struct uv_hwperf_object_info)) {
+			r = -ENOMEM;
+			goto error;
+		} else {
+			r = uv_hwperf_enum_objects(&nobj, &objs);
+			if (r == 0) {
+				int cpuobj_index = 0;
+
+				memset(p, 0, a.sz);
+				for (i = 0; i < nobj; i++) {
+					if (!UV_HWPERF_IS_NODE(objs + i))
+						continue;
+					node = uv_hwperf_obj_to_cnode(objs + i);
+					for_each_online_cpu(j) {
+						if (node != cpu_to_node(j))
+							continue;
+						cpuobj =
+						(struct uv_hwperf_object_info *)
+							 p + cpuobj_index++;
+						freq = cpufreq_quick_get(j);
+						if (!freq)
+							freq = cpu_khz;
+						cdata = (struct cpuinfo_x86 *)
+							 &cpu_data(j);
+						cpuobj->id = j;
+						snprintf(cpuobj->name,
+							 sizeof(cpuobj->name),
+							 "CPU %uMHz %s",
+							 freq / 1000,
+							 (char *)
+							 &cdata->x86_vendor_id);
+						snprintf(cpuobj->location,
+							 sizeof
+							 (cpuobj->location),
+							 "%s%d",
+							 objs[i].location,
+							 cdata->cpu_core_id);
+					}
+				}
+			}
+
+			vfree(objs);
+		}
+		break;
+
+	case UV_HWPERF_GET_NODE_NASID:
+		node = a.arg;
+		if (a.sz != sizeof(int) || node < 0 || !cnode_possible(node)) {
+			r = -EINVAL;
+			goto error;
+		}
+		*(int *)p = cnodeid_to_nasid(node);
+		break;
+
+	case UV_HWPERF_GET_OBJ_NODE:
+		if (a.sz != sizeof(u64) || a.arg < 0) {
+			r = -EINVAL;
+			goto error;
+		}
+		r = uv_hwperf_enum_objects(&nobj, &objs);
+		if (r == 0) {
+			if (a.arg >= nobj) {
+				r = -EINVAL;
+				vfree(objs);
+				goto error;
+			}
+			i = a.arg;
+			if (objs[i].id != a.arg) {
+				for (i = 0; i < nobj; i++) {
+					if (objs[i].id == a.arg)
+						break;
+				}
+			}
+			if (i == nobj) {
+				r = -EINVAL;
+				vfree(objs);
+				goto error;
+			}
+
+			if (!UV_HWPERF_IS_NODE(objs + i) &&
+			    !UV_HWPERF_IS_IONODE(objs + i)) {
+				r = -ENOENT;
+				vfree(objs);
+				goto error;
+			}
+
+			*(u64 *)p = (u64)
+				uv_hwperf_obj_to_cnode(objs + i);
+			vfree(objs);
+		}
+		break;
+
+	case UV_HWPERF_GET_MMRS:
+	case UV_HWPERF_SET_MMRS:
+	case UV_HWPERF_OBJECT_DISTANCE:
+		op_info.p = p;
+		op_info.a = &a;
+		op_info.v0 = &v0;
+		op_info.op = op;
+		r = uv_hwperf_op_cpu(&op_info);
+		if (r) {
+			r = uv_hwperf_map_err(r);
+			a.v0 = v0;
+			goto error;
+		}
+		break;
+
+	default:
+		/* all other ops are a direct BIOS call */
+		r = uv_bios_hwperf(uv_hwperf_master_nasid, op, a.arg, a.sz,
+				   (u64 *)p, NULL);
+		if (r) {
+			r = uv_hwperf_map_err(r);
+			goto error;
+		}
+		a.v0 = r;
+		break;
+	}
+
+	if (op & UV_HWPERF_OP_MEM_COPYOUT) {
+		r = copy_to_user((void __user *)a.ptr, p, a.sz);
+		if (r != 0) {
+			r = -EFAULT;
+			goto error;
+		}
+	}
+
+error:
+	vfree(p);
+
+	lock_kernel();
+	return r;
+}
+
+static const struct file_operations uv_hwperf_fops = {
+	.ioctl = uv_hwperf_ioctl,
+};
+
+static struct miscdevice uv_hwperf_dev = {
+	MISC_DYNAMIC_MINOR,
+	UV_HWPERF_DEVICE_NAME,
+	&uv_hwperf_fops
+};
+
+static int uv_hwperf_initial_bios_calls(void)
+{
+	u64 v;
+	s64 biosr;
+	int e = 0;
+
+	/* single threaded, once-only initialization */
+	mutex_lock(&uv_hwperf_init_mutex);
+
+	if (uv_hwperf_biosheap) {
+		mutex_unlock(&uv_hwperf_init_mutex);
+		return e;
+	}
+
+	num_cnodes = uv_num_possible_blades();
+
+	/*
+	 * The PROM code needs a fixed reference node. For convenience the
+	 * same node as the console I/O is used.
+	 */
+	e = uv_bios_hwperf(0, UV_HWPERF_MASTER_NASID, 0,
+			   (u64)sizeof(uv_hwperf_master_nasid),
+			   (u64 *)&uv_hwperf_master_nasid, NULL);
+	if (e) {
+		e = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Request the needed size and install the PROM scratch area.
+	 * The PROM keeps various tracking bits in this memory area.
+	 */
+	biosr = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_GET_HEAPSIZE,
+				0, (u64)sizeof(u64), (u64 *)&v, NULL);
+	if (biosr != BIOS_STATUS_SUCCESS) {
+		e = -EINVAL;
+		goto out;
+	}
+
+	uv_hwperf_biosheap = vmalloc(v);
+	if (uv_hwperf_biosheap == NULL) {
+		e = -ENOMEM;
+		goto out;
+	}
+	biosr = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_INSTALL_HEAP,
+				0, v, (u64 *)uv_hwperf_biosheap, NULL);
+	if (biosr != BIOS_STATUS_SUCCESS) {
+		e = -EINVAL;
+		goto out;
+	}
+
+	biosr = uv_bios_hwperf(uv_hwperf_master_nasid, UV_HWPERF_OBJECT_COUNT,
+				0, sizeof(u64), (u64 *)&v, NULL);
+	if (biosr != BIOS_STATUS_SUCCESS) {
+		e = -EINVAL;
+		goto out;
+	}
+	uv_hwperf_obj_cnt = (int)v;
+
+out:
+	if (e < 0 && uv_hwperf_biosheap) {
+		vfree(uv_hwperf_biosheap);
+		uv_hwperf_biosheap = NULL;
+		uv_hwperf_obj_cnt = 0;
+	}
+	mutex_unlock(&uv_hwperf_init_mutex);
+	return e;
+}
+
+#ifdef CONFIG_PROC_FS
+static const struct file_operations proc_uv_topo_fops = {
+	.open		= uv_topology_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= uv_topology_release,
+};
+
+/*
+ * set up /proc/sgi_uv/topology
+ */
+void uv_hwperf_register_procfs(void)
+{
+	struct proc_dir_entry *sgi_topology;
+
+	sgi_topology = create_proc_entry("sgi_uv/topology", 0444, NULL);
+	if (!sgi_topology) {
+		printk(KERN_ERR "unable to create /proc/sgi_uv/topology\n");
+		return;
+	}
+	sgi_topology->proc_fops = &proc_uv_topo_fops;
+}
+
+/*
+ * take down the /proc/sgi_uv/topology file
+ */
+void uv_hwperf_deregister_procfs(void)
+{
+	remove_proc_entry("sgi_uv/topology", NULL);
+}
+
+/*
+ * called because of uv_hwperf_register_procfs
+ */
+int uv_topology_open(struct inode *inode, struct file *file)
+{
+	int e;
+	struct seq_file *seq;
+	struct uv_hwperf_object_info *objbuf;
+	int nobj;
+
+	e = uv_hwperf_enum_objects(&nobj, &objbuf);
+	if (e == 0) {
+		e = seq_open(file, &uv_topology_seq_ops);
+		seq = file->private_data;
+		seq->private = objbuf;
+	}
+
+	return e;
+}
+
+/*
+ * called because of uv_hwperf_register_procfs
+ */
+int uv_topology_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+
+	vfree(seq->private);
+	return seq_release(inode, file);
+}
+#endif
+
+/*
+ * Register a dynamic misc device for hwperf ioctls. Platforms
+ * supporting hotplug will create /dev/uv_hwperf, else user
+ * can to look up the minor number in /proc/misc.
+ */
+static int uv_hwperf_device_register(void)
+{
+	int e;
+
+	e = misc_register(&uv_hwperf_dev);
+	if (e != 0) {
+		printk(KERN_ERR "uv_hwperf_device_register: failed to "
+		"register misc device for \"%s\"\n", uv_hwperf_dev.name);
+	}
+	return e;
+}
+
+/*
+ * Register a dynamic misc device for hwperf ioctls. Platforms
+ * supporting hotplug will create /dev/uv_hwperf, else user
+ * can to look up the minor number in /proc/misc.
+ */
+static void uv_hwperf_device_deregister(void)
+{
+	int e;
+
+	e = misc_deregister(&uv_hwperf_dev);
+	if (e != 0) {
+		printk(KERN_ERR "uv_hwperf_device_deregister: failed to "
+		"deregister misc device \"%s\"\n", uv_hwperf_dev.name);
+	}
+
+	return;
+}
+
+/*
+ * entry to this module (at insmod time)
+ */
+static int uv_hwperf_entry(void)
+{
+	if (!is_uv_system())
+		return 0;
+
+	uv_hwperf_initial_bios_calls();
+	uv_hwperf_device_register();
+#ifdef CONFIG_PROC_FS
+	uv_hwperf_register_procfs();
+#endif
+	return 0;
+}
+
+/*
+ * exit from this module (at rmmod time)
+ */
+static void uv_hwperf_exit(void)
+{
+	if (!is_uv_system())
+		return;
+
+	uv_hwperf_device_deregister();
+	uv_hwperf_deregister_procfs();
+}
+
+module_init(uv_hwperf_entry);
+module_exit(uv_hwperf_exit);
+
+MODULE_AUTHOR("Silicon Graphics, Inc.");
+MODULE_DESCRIPTION("Driver for SGI UV hub counter access and topology");
+/* ?? should this be GPL? */
+MODULE_LICENSE("GPL");
Index: linux/include/asm-x86/uv/hwperf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/asm-x86/uv/hwperf.h	2009-09-30 15:22:55.000000000 -0500
@@ -0,0 +1,255 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Silicon Graphics International Corp. All rights reserved.
+ *
+ * Data types used by the UV_HWPERF_OP BIOS call for monitoring
+ * SGI UV node and router hardware
+ *
+ * Copyright (C) Cliff Wickman <cpw@sgi.com>
+ */
+
+#ifndef UV_HWPERF_H
+#define UV_HWPERF_H
+
+#define UV_HWPERF_DEVICE_NAME "hwperf"
+
+/*
+ * object structure. UV_HWPERF_ENUM_OBJECTS and UV_HWPERF_GET_CPU_INFO
+ * return an array of these. Do not change this without also
+ * changing the corresponding BIOS code.
+ */
+#define UV_HWPERF_MAXSTRING		128
+struct uv_hwperf_object_info {
+	unsigned int id;
+	union {
+		struct {
+			unsigned long long this_part:1;
+			unsigned long long is_shared:1;
+		} fields;
+		struct {
+			unsigned long long flags;
+			unsigned long long reserved;
+		} b;
+	} f;
+	char name[UV_HWPERF_MAXSTRING];
+	char location[UV_HWPERF_MAXSTRING];
+	unsigned int ports;
+};
+
+#define uv_hwp_this_part	f.fields.this_part
+#define uv_hwp_is_shared	f.fields.is_shared
+#define uv_hwp_flags		f.b.flags
+
+/* macros for object classification */
+#define UV_HWPERF_IS_NODE(x)		((x) && strstr((x)->name, "Hub"))
+#define UV_HWPERF_IS_IONODE(x)		((x) && strstr((x)->name, "IORiser"))
+#define UV_HWPERF_IS_NL5ROUTER(x)	((x) && strstr((x)->name, "NL5Router"))
+#define UV_HWPERF_IS_OLDROUTER(x)	((x) && strstr((x)->name, "Router"))
+#define UV_HWPERF_IS_ROUTER(x)		UV_HWPERF_IS_NL5ROUTER(x)
+#define UV_HWPERF_FOREIGN(x)		((x) && !(x)->uv_hwp_this_part && \
+					!(x)->uv_hwp_is_shared)
+#define UV_HWPERF_SAME_OBJTYPE(x, y)	((UV_HWPERF_IS_NODE(x) && \
+					 UV_HWPERF_IS_NODE(y)) || \
+					(UV_HWPERF_IS_IONODE(x) && \
+					 UV_HWPERF_IS_IONODE(y)) || \
+					(UV_HWPERF_IS_ROUTER(x) && \
+					 UV_HWPERF_IS_ROUTER(y)))
+
+/* numa port structure, UV_HWPERF_ENUM_PORTS returns an array of these */
+struct uv_hwperf_port_info {
+	unsigned int port;
+	unsigned int conn_id;
+	unsigned int conn_port;
+};
+
+/* for HWPERF_{GET,SET}_MMRS */
+struct uv_hwperf_data {
+	unsigned long long addr;
+	unsigned long long data;
+};
+
+/* user ioctl() argument, see below */
+struct uv_hwperf_ioctl_args {
+	unsigned long long arg;		/* argument, usually an object id */
+	unsigned long long sz;		/* size of transfer */
+	void *ptr;			/* pointer to source/target */
+	unsigned int v0;		/* second return value */
+};
+
+/*
+ * For UV_HWPERF_{GET,SET}_MMRS and UV_HWPERF_OBJECT_DISTANCE,
+ * uv_hwperf_ioctl_args.arg can be used to specify a CPU on which
+ * to call BIOS, and whether to use an interprocessor interrupt
+ * or task migration in order to do so. If the CPU specified is
+ * UV_HWPERF_ARG_ANY_CPU, then the current CPU will be used.
+ */
+#define UV_HWPERF_ARG_ANY_CPU		0x7fffffffUL
+#define UV_HWPERF_ARG_CPU_MASK		0x7fffffff00000000ULL
+#define UV_HWPERF_ARG_USE_IPI_MASK	0x8000000000000000ULL
+#define UV_HWPERF_ARG_OBJID_MASK	0x00000000ffffffffULL
+
+/*
+ * ioctl requests on the "uv_hwperf" misc device that call BIOS.
+ */
+#define UV_HWPERF_OP_MEM_COPYIN		0x1000
+#define UV_HWPERF_OP_MEM_COPYOUT	0x2000
+#define UV_HWPERF_OP_MASK		0x0fff
+
+/*
+ * Determine mem requirement.
+ * arg	don't care
+ * sz	8
+ * p	pointer to unsigned long long integer
+ */
+#define	UV_HWPERF_GET_HEAPSIZE		1
+
+/*
+ * Install mem for BIOS driver
+ * arg	don't care
+ * sz	sizeof buffer pointed to by p
+ * p	pointer to buffer for scratch area
+ */
+#define UV_HWPERF_INSTALL_HEAP		2
+
+/*
+ * Get the master (console) nasid
+ * arg	don't care
+ * sz	sizeof nasid_t, pointed to by p
+ * p	pointer to nasid_t master nasid
+ */
+#define UV_HWPERF_MASTER_NASID		3
+
+/*
+ * Determine number of objects
+ * arg	don't care
+ * sz	8
+ * p	pointer to unsigned long long integer
+ */
+#define UV_HWPERF_OBJECT_COUNT		(10|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Determine object "distance", relative to a cpu. This operation can
+ * execute on a designated logical cpu number, using either an IPI or
+ * via task migration. If the cpu number is UV_HWPERF_ANY_CPU, then
+ * the current CPU is used. See the UV_HWPERF_ARG_* macros above.
+ *
+ * arg	bitmap of IPI flag, cpu number and object id
+ * sz	8
+ * p	pointer to unsigned long long integer
+ */
+#define UV_HWPERF_OBJECT_DISTANCE	(11|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Enumerate objects. Special case if sz == 8, returns the required
+ * buffer size.
+ * arg	don't care
+ * sz	sizeof buffer pointed to by p
+ * p	pointer to array of struct uv_hwperf_object_info
+ */
+#define UV_HWPERF_ENUM_OBJECTS		(12|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Enumerate NumaLink ports for an object. Special case if sz == 8,
+ * returns the required buffer size.
+ * arg	object id
+ * sz	sizeof buffer pointed to by p
+ * p	pointer to array of struct uv_hwperf_port_info
+ */
+#define UV_HWPERF_ENUM_PORTS		(13|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * SET/GET memory mapped registers. These operations can execute
+ * on a designated logical cpu number, using either an IPI or via
+ * task migration. If the cpu number is UV_HWPERF_ANY_CPU, then
+ * the current CPU is used. See the UV_HWPERF_ARG_* macros above.
+ *
+ * arg	bitmap of ipi flag, cpu number and object id
+ * sz	sizeof buffer pointed to by p
+ * p	pointer to array of struct uv_hwperf_data
+ */
+#define UV_HWPERF_SET_MMRS		(14|UV_HWPERF_OP_MEM_COPYIN)
+#define UV_HWPERF_GET_MMRS		(15|UV_HWPERF_OP_MEM_COPYOUT| \
+					    UV_HWPERF_OP_MEM_COPYIN)
+/*
+ * Lock a shared object
+ * arg	object id
+ * sz	don't care
+ * p	don't care
+ */
+#define UV_HWPERF_ACQUIRE		16
+
+/*
+ * Unlock a shared object
+ * arg	object id
+ * sz	don't care
+ * p	don't care
+ */
+#define UV_HWPERF_RELEASE		17
+
+/*
+ * Break a lock on a shared object
+ * arg	object id
+ * sz	don't care
+ * p	don't care
+ */
+#define UV_HWPERF_FORCE_RELEASE		18
+
+/*
+ * ioctl requests on "uv_hwperf" that do not call BIOS
+ */
+
+/*
+ * get cpu info as an array of hwperf_object_info_t.
+ * id is logical CPU number, name is description, location
+ * is geoid (e.g. 001i04b1). Special case if sz == 8,
+ * returns the required buffer size.
+ *
+ * arg	don't care
+ * sz	sizeof buffer pointed to by p
+ * p	pointer to array of struct uv_hwperf_object_info
+ */
+#define UV_HWPERF_GET_CPU_INFO		(100|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Given an object id, return it's node number (aka cnode).
+ * arg	object id
+ * sz	8
+ * p	pointer to unsigned long long integer
+ */
+#define UV_HWPERF_GET_OBJ_NODE		(101|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Given a node number (cnode), return it's nasid.
+ * arg	ordinal node number (aka cnodeid)
+ * sz	8
+ * p	pointer to unsigned long long integer
+ */
+#define UV_HWPERF_GET_NODE_NASID	(102|UV_HWPERF_OP_MEM_COPYOUT)
+
+/*
+ * Given a node id, determine the id of the nearest node with CPUs
+ * and the id of the nearest node that has memory. The argument
+ * node would normally be a "headless" node, e.g. an "IO node".
+ * Return 0 on success.
+ */
+extern int uv_hwperf_get_nearest_node(short node, short *near_mem,
+					short *near_cpu);
+
+/* return codes */
+#define UV_HWPERF_OP_OK			0
+#define UV_HWPERF_OP_NOMEM		1
+#define UV_HWPERF_OP_NO_PERM		2
+#define UV_HWPERF_OP_IO_ERROR		3
+#define UV_HWPERF_OP_BUSY		4
+#define UV_HWPERF_OP_RECONFIGURE	253
+#define UV_HWPERF_OP_INVAL		254
+
+#ifdef CONFIG_PROC_FS
+int uv_topology_open(struct inode *inode, struct file *file);
+int uv_topology_release(struct inode *inode, struct file *file);
+#endif
+
+#endif				/* UV_HWPERF_H */
Index: linux/include/asm-x86/uv/geo.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/include/asm-x86/uv/geo.h	2009-09-30 15:22:55.000000000 -0500
@@ -0,0 +1,121 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2009 Silicon Graphics International Corp. All rights reserved.
+ */
+
+#ifndef _ASM_UV_GEO_H
+#define _ASM_UV_GEO_H
+
+/* The geoid_s implementation below is based loosely on the pcfg_t
+   implementation in sys/SN/promcfg.h. */
+
+/* Type declaractions */
+
+/* Size of a geoid_s structure (must be before decl. of geoid_u) */
+#define GEOID_SIZE	8	/* Would 16 be better?  The size can
+				   be different on different platforms. */
+
+/* Fields common to all substructures */
+struct geo_common_s {
+    unsigned int rack;
+    unsigned char type;		/* What type of h/w is named by this geoid_s */
+    unsigned char slot:4;	/* slot is IRU */
+    unsigned char blade:4;
+};
+
+/* Additional fields for particular types of hardware */
+struct geo_node_s {
+    struct geo_common_s common;		/* No additional fields needed */
+};
+
+struct geo_rtr_s {
+    struct geo_common_s common;		/* No additional fields needed */
+};
+
+struct geo_iocntl_s {
+    struct geo_common_s common;		/* No additional fields needed */
+};
+
+struct geo_pcicard_s {
+    struct geo_iocntl_s common;
+    char bus;				/* Bus/widget number */
+    char slot;				/* PCI slot number */
+};
+
+/* Subcomponents of a node */
+struct geo_cpu_s {
+    struct geo_node_s node;
+    char slice;				/* Which CPU on the node */
+};
+
+struct geo_mem_s {
+    struct geo_node_s node;
+    char membus;			/* The memory bus on the node */
+    char memslot;			/* The memory slot on the bus */
+};
+
+union geoid_u {
+    struct geo_common_s common;
+    struct geo_node_s node;
+    struct geo_iocntl_s iocntl;
+    struct geo_pcicard_s pcicard;
+    struct geo_rtr_s rtr;
+    struct geo_cpu_s cpu;
+    struct geo_mem_s mem;
+    char padsize[GEOID_SIZE];
+};
+
+/* Preprocessor macros */
+
+#define GEO_MAX_LEN	48	/* max. formatted length, plus some pad:
+				   module/001c07/slab/5/node/memory/2/slot/4 */
+
+#define GEO_TYPE_INVALID	0
+#define GEO_TYPE_MODULE		1
+#define GEO_TYPE_NODE		2
+#define GEO_TYPE_RTR		3
+#define GEO_TYPE_IOCNTL		4
+#define GEO_TYPE_IOCARD		5
+#define GEO_TYPE_CPU		6
+#define GEO_TYPE_MEM		7
+#define GEO_TYPE_MAX		(GEO_TYPE_MEM+1)
+
+/* Parameter for hwcfg_format_geoid_compt() */
+#define GEO_COMPT_MODULE	1
+#define GEO_COMPT_SLAB		2
+#define GEO_COMPT_IOBUS		3
+#define GEO_COMPT_IOSLOT	4
+#define GEO_COMPT_CPU		5
+#define GEO_COMPT_MEMBUS	6
+#define GEO_COMPT_MEMSLOT	7
+
+#define GEO_INVALID_STR		"<invalid>"
+
+#define INVALID_NASID           ((signed short)-1)
+#define INVALID_CNODEID         ((short)-1)
+#define INVALID_PNODEID         ((pnodeid_t)-1)
+#define INVALID_SLOT            ((unsigned char)-1)
+#define INVALID_MODULE          ((unsigned int)-1)
+
+static inline unsigned int geo_rack(union geoid_u g)
+{
+	return (g.common.type == GEO_TYPE_INVALID) ?
+		INVALID_MODULE : g.common.rack;
+}
+
+static inline unsigned char geo_slot(union geoid_u g)
+{
+	return (g.common.type == GEO_TYPE_INVALID) ?
+		INVALID_SLOT : g.common.slot;
+}
+
+static inline unsigned char geo_blade(union geoid_u g)
+{
+	return (g.common.type == GEO_TYPE_INVALID) ?
+		INVALID_SLOT : g.common.blade;
+}
+
+#endif /* _ASM_UV_GEO_H */
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2009-09-30 15:22:48.000000000 -0500
+++ linux/arch/x86/Kconfig	2009-09-30 15:22:55.000000000 -0500
@@ -397,6 +397,12 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+config UV_HWPERF
+	tristate "SGI UV hwperf: hub counters and topology"
+	help
+	If you have an SGI UV system and you want to enable access to hub
+	counters and topology, say Y here, otherwise say N.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
