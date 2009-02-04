Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZBDSiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZBDSiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZBDShA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:00 -0500
Received: from kroah.org ([198.145.64.141]:50902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758193AbZBDSg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:36:59 -0500
Date: Wed, 4 Feb 2009 10:34:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 02/33] xen: make sysfs files behave as their names suggest
Message-ID: <20090204183418.GC13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-make-sysfs-files-behave-as-their-names-suggest.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 618b2c8db24522ae273d8299c6a936ea13793c4d upstream.

1: make "target_kb" only accept and produce a memory size in kilobytes.
2: add a second "target" file which produces output in bytes, and will accept
   memparse input (scaled bytes)

This fixes the rather irritating problem that writing the same value
read back into target_kb would end up shrinking the domain by a factor
of 1024, with generally bad results.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/balloon.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -488,7 +488,7 @@ static ssize_t store_target_kb(struct sy
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	target_bytes = memparse(buf, &endchar);
+	target_bytes = simple_strtoull(buf, &endchar, 0) * 1024;
 
 	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
 
@@ -498,8 +498,39 @@ static ssize_t store_target_kb(struct sy
 static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
 		   show_target_kb, store_target_kb);
 
+
+static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%llu\n",
+		       (u64)balloon_stats.target_pages << PAGE_SHIFT);
+}
+
+static ssize_t store_target(struct sys_device *dev,
+			    struct sysdev_attribute *attr,
+			    const char *buf,
+			    size_t count)
+{
+	char *endchar;
+	unsigned long long target_bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	target_bytes = memparse(buf, &endchar);
+
+	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
+
+	return count;
+}
+
+static SYSDEV_ATTR(target, S_IRUGO | S_IWUSR,
+		   show_target, store_target);
+
+
 static struct sysdev_attribute *balloon_attrs[] = {
 	&attr_target_kb,
+	&attr_target,
 };
 
 static struct attribute *balloon_info_attrs[] = {

