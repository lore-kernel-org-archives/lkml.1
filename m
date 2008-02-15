Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYCVCjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYCVCjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYCVCiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:38:15 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:18672 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbYCVCiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:references:to:date:message-id:sender;
        b=Kr10PMa/kUZ781zZHOD7kI0S1v207dDE+7YKbog+0USmpd8Y8UKMPVuIyxBShDedc3Z4hodmd8vtyb7I3mMk1iBdAb+xrXl+A+T3J9vF44hEU2xk1VP3lAz58snVo09qt1jLKleb8iuQqrVaxEZTW8xO5W/1Vv2137KpBXxT1+c=
Subject: [RFC][PATCH 2/9] cgroups: block: cfq: I/O bandwidth controlling subsystem for CGroups based on CFQ
From: Vasily Tarasov <vtaras@openvz.org>
References: <1203058414.042372.2088.nullmailer@me>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org
Date: Fri, 15 Feb 2008 01:59:43 -0500
Message-Id: <1203058783.643398.2139.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

Registers the cfqio_subsys subsystem in the CGroups framework.

Signed-off-by: Vasily Tarasov <vtaras@openvz.org>

---

--- /dev/null	2008-02-14 08:57:49.255923728 -0500
+++ linux-2.6.25-rc5-mm1/include/linux/cfqio-cgroup.h	2008-02-15 01:06:40.000000000 -0500
@@ -0,0 +1,26 @@
+/*
+ * include/linux/cfqio-cgroup.h
+ *
+ * cfqio_subsys: CGroup subsystem that allows CFQ recognize
+ * cgroups and perform scheduling according to this.
+ *
+ * Copyright (C) 2008 OpenVZ http://openvz.org
+ *
+ * Author: Vasily Tarasov <vtaras@openvz.org>
+ *
+ */
+
+#ifndef _LINUX_CFQIO_CGROUP_H
+#define _LINUX_CFQIO_CGROUP_H
+
+#define CFQIO_SS_IOPRIO_DEF	4
+#define CFQIO_SS_IOPRIO_MAX	7
+#define CFQIO_SS_IOPRIO_MIN	0
+
+/* cfqio_subsys's per cgroup state holder */
+struct cfqio_ss_css {
+	struct cgroup_subsys_state	css;
+	unsigned int			ioprio;
+};
+
+#endif /* _LINUX_CFQIO_CGROUP_H */
--- linux-2.6.25-rc5-mm1/include/linux/cgroup_subsys.h.subsys	2008-02-15 00:49:56.000000000 -0500
+++ linux-2.6.25-rc5-mm1/include/linux/cgroup_subsys.h	2008-02-15 01:06:40.000000000 -0500
@@ -42,3 +42,9 @@ SUBSYS(mem_cgroup)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_CFQIO
+SUBSYS(cfqio)
+#endif
+
+/* */
--- linux-2.6.25-rc5-mm1/block/Makefile.subsys	2008-02-15 00:49:11.000000000 -0500
+++ linux-2.6.25-rc5-mm1/block/Makefile	2008-02-15 01:06:40.000000000 -0500
@@ -11,6 +11,7 @@ obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosch
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
+obj-$(CONFIG_CGROUP_CFQIO)	+= cfqio-cgroup.o
 
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
--- /dev/null	2008-02-14 08:57:49.255923728 -0500
+++ linux-2.6.25-rc5-mm1/block/cfqio-cgroup.c	2008-02-15 01:06:40.000000000 -0500
@@ -0,0 +1,97 @@
+/*
+ * block/cfqio-cgroup.c
+ *
+ * cfqio_cgroup: CGroup subsystem that allows CFQ recognize
+ * cgroups and perform scheduling according to this.
+ *
+ * Copyright (C) 2008 OpenVZ http://openvz.org
+ *
+ * Author: Vasily Tarasov <vtaras@openvz.org>
+ *
+ */
+
+#include <linux/cgroup.h>
+#include <linux/cfqio-cgroup.h>
+#include <linux/err.h>
+
+static void cfqio_ss_fini(struct cfqio_ss_css *cfqio_css)
+{
+}
+
+static void cfqio_ss_init(struct cfqio_ss_css *cfqio_css)
+{
+	cfqio_css->ioprio = CFQIO_SS_IOPRIO_DEF;
+}
+
+static struct cgroup_subsys_state *
+cfqio_ss_cgrp_create(struct cgroup_subsys *subsys, struct cgroup *cgrp)
+{
+	struct cfqio_ss_css *cfqio_css;
+
+	cfqio_css = kmalloc(sizeof(*cfqio_css), GFP_KERNEL);
+	if (!cfqio_css)
+		return ERR_PTR(-ENOMEM);
+
+	cfqio_ss_init(cfqio_css);
+
+	return &cfqio_css->css;
+}
+
+static inline struct cfqio_ss_css *
+cfqio_ss_cgrp_css(struct cgroup *cgrp)
+{
+	return container_of(cgrp->subsys[cfqio_subsys_id],
+					struct cfqio_ss_css, css);
+}
+
+static void
+cfqio_ss_cgrp_destroy(struct cgroup_subsys *subsys, struct cgroup *cgrp)
+{
+	struct cfqio_ss_css *cfqio_css;
+
+	cfqio_css = cfqio_ss_cgrp_css(cgrp);
+	cfqio_ss_fini(cfqio_css);
+	kfree(cfqio_css);
+	return;
+}
+
+static u64
+cfqio_ss_ioprio_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return (u64)cfqio_ss_cgrp_css(cgrp)->ioprio;
+}
+
+static int
+cfqio_ss_ioprio_write(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	if (val > CFQIO_SS_IOPRIO_MAX || val < CFQIO_SS_IOPRIO_MIN)
+		return -EINVAL;
+
+	cfqio_ss_cgrp_css(cgrp)->ioprio = val;
+
+	return 0;
+}
+
+/* array since more then one file are expected in the future */
+static struct cftype cfqio_ss_files[] =  {
+	{
+		.name =		"ioprio",
+		.read_uint =	cfqio_ss_ioprio_read,
+		.write_uint =	cfqio_ss_ioprio_write,
+	},
+};
+
+static int
+cfqio_ss_populate_dir(struct cgroup_subsys *ss, struct cgroup *cgrp)
+{
+	return cgroup_add_files(cgrp, ss, cfqio_ss_files,
+					ARRAY_SIZE(cfqio_ss_files));
+}
+
+struct cgroup_subsys cfqio_subsys = {
+	.name =		"cfqio_subsys",
+	.subsys_id =	cfqio_subsys_id,
+	.create =	cfqio_ss_cgrp_create,
+	.destroy =	cfqio_ss_cgrp_destroy,
+	.populate =	cfqio_ss_populate_dir,
+};
