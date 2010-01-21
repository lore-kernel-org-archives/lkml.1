Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489Ab0AUXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0AUXLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466Ab0AUXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:11:08 -0500
Received: from kroah.org ([198.145.64.141]:60841 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab0AUXLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:11:02 -0500
Date: Thu, 21 Jan 2010 15:10:10 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-ID: <20100121231010.GB29796@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
 <20100119210417.GC10928@kroah.com>
 <20100120104525.752a790f.sfr@canb.auug.org.au>
 <20100120172543.e884a8af.sfr@canb.auug.org.au>
 <20100120174441.e1b12fd7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120174441.e1b12fd7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 05:44:41PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Wed, 20 Jan 2010 17:25:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > (lines 262-266)
> > static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
> > #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> >         &class_attr_probe.attr,
> >         &class_attr_release.attr,
> > #endif
> 
> The reason you may not see this is because CONFIG_ARCH_CPU_PROBE_RELEASE
> is not set for x86_64 allmodconfig builds (and probably many others).

Ah, you are right, I was focusing on the lines after this.

Here's a patch that I just applied to my tree to hopefully resolve this
issue.

thanks,

greg k-h

----------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: sysdev: fix up the probe/release attributes

These should be sysdev attributes, not class attributes.  This patch
should resolve the problem.

Thanks to Stephen Rothwell for pointing out the problem.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -79,24 +79,24 @@ void unregister_cpu(struct cpu *cpu)
 }
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-static ssize_t cpu_probe_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t cpu_probe_store(struct sys_device *dev,
+				struct sysdev_attribute *attr,
 				const char *buf,
 			       size_t count)
 {
 	return arch_cpu_probe(buf, count);
 }
 
-static ssize_t cpu_release_store(struct class *class,
-				struct class_attribute *attr,
+static ssize_t cpu_release_store(struct sys_device *dev,
+				struct sysdev_attribute *attr,
 				const char *buf,
 				 size_t count)
 {
 	return arch_cpu_release(buf, count);
 }
 
-static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
-static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
+static SYSDEV_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static SYSDEV_ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -261,8 +261,8 @@ int __init cpu_dev_init(void)
 
 static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
-	&class_attr_probe.attr,
-	&class_attr_release.attr,
+	&attr_probe.attr,
+	&attr_release.attr,
 #endif
 	&cpu_attrs[0].attr,
 	&cpu_attrs[1].attr,
