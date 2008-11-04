Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYKDXiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYKDXiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYKDXhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:47152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756548AbYKDXhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:36 -0500
Date: Tue, 4 Nov 2008 15:31:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/57] S390: Fix sysdev class file creation.
Message-ID: <20081104233101.GD659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s390-fix-sysdev-class-file-creation.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit da5aae7036692fa8d03da1b705c76fd750ed9e38 upstream

Use sysdev_class_create_file() to create create sysdev class attributes
instead of sysfs_create_file(). Using sysfs_create_file() wasn't a very
good idea since the show and store functions have a different amount of
parameters for sysfs files and sysdev class files.
In particular the pointer to the buffer is the last argument and
therefore accesses to random memory regions happened.
Still worked surprisingly well until we got a kernel panic.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/smp.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1117,9 +1117,7 @@ out:
 	return rc;
 }
 
-static ssize_t __ref rescan_store(struct sys_device *dev,
-				  struct sysdev_attribute *attr,
-				  const char *buf,
+static ssize_t __ref rescan_store(struct sysdev_class *class, const char *buf,
 				  size_t count)
 {
 	int rc;
@@ -1127,12 +1125,10 @@ static ssize_t __ref rescan_store(struct
 	rc = smp_rescan_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_ATTR(rescan, 0200, NULL, rescan_store);
+static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static ssize_t dispatching_show(struct sys_device *dev,
-				struct sysdev_attribute *attr,
-				char *buf)
+static ssize_t dispatching_show(struct sysdev_class *class, char *buf)
 {
 	ssize_t count;
 
@@ -1142,9 +1138,8 @@ static ssize_t dispatching_show(struct s
 	return count;
 }
 
-static ssize_t dispatching_store(struct sys_device *dev,
-				 struct sysdev_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t dispatching_store(struct sysdev_class *dev, const char *buf,
+				 size_t count)
 {
 	int val, rc;
 	char delim;
@@ -1166,7 +1161,8 @@ out:
 	put_online_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_ATTR(dispatching, 0644, dispatching_show, dispatching_store);
+static SYSDEV_CLASS_ATTR(dispatching, 0644, dispatching_show,
+			 dispatching_store);
 
 static int __init topology_init(void)
 {
@@ -1176,13 +1172,11 @@ static int __init topology_init(void)
 	register_cpu_notifier(&smp_cpu_nb);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-			       &attr_rescan.attr);
+	rc = sysdev_class_create_file(&cpu_sysdev_class, &attr_rescan);
 	if (rc)
 		return rc;
 #endif
-	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-			       &attr_dispatching.attr);
+	rc = sysdev_class_create_file(&cpu_sysdev_class, &attr_dispatching);
 	if (rc)
 		return rc;
 	for_each_present_cpu(cpu) {

-- 
