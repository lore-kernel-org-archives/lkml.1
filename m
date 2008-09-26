Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYIZSkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYIZSkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYIZSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:40:37 -0400
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:41261 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752018AbYIZSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:40:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id:X-Identified-User;
	b=capEWd5aVjv1/3DmMhrL6CBOm+n2YmsUuOIyCxLrfIMslQcu066lVobUSaw8KZ9Sr3kDbzqjkA781j20QuII2NqoSqN6Q0hOBBss/Rm7z76kAs79d3iJP2MlwvvLHvOf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: e1000e NVM corruption issue status
Date: Fri, 26 Sep 2008 11:39:52 -0700
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <200809261052.38966.jbarnes@virtuousgeek.org> <200809261123.52198.jbarnes@virtuousgeek.org>
In-Reply-To: <200809261123.52198.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9xS3IWAoPixPbsM"
Message-Id: <200809261139.57607.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9xS3IWAoPixPbsM
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday, September 26, 2008 11:23 am Jesse Barnes wrote:
> On Friday, September 26, 2008 10:52 am Jesse Barnes wrote:
> > On Friday, September 26, 2008 4:49 am Arjan van de Ven wrote:
> > > Jiri Kosina wrote:
> > > > On Thu, 25 Sep 2008, Brandeburg, Jesse wrote:
> > > >> this is the current set of patches that I have to help us debug
> > > >> and/or fix e1000e issues found during this debug effort for
> > > >> the corrupt NVM.  the "drop stats lock" - "reset swflag" patches
> > > >> allow Thomas' patch for a mutex in the SWFLAG acquire function to
> > > >> run without any errors.
> > > >
> > > > Thanks. Also Jesse Barnes' patch shouldn't be forgotten, could you
> > > > please add it to that lineup?
> > > >
> > > > 	http://marc.info/?l=linux-kernel&m=122237193628087&w=2
> > >
> > > can we (for now) also stick a WARN_ON() into that failure path? that
> > > way we can at least catch if/when this happens more visibly..... if it
> > > happens consistently in say the new distros we can be more confident
> > > that we're down the right path in diagnosing the issue.
> >
> > I'm spinning a new one now with some debug output, stay tuned (just gotta
> > boot my test box).
>
> Ok here's an updated one.  Jesse (Br) can you add it to your list?  If the
> X driver really is mapping too much this should catch it, as long as it
> goes through sysfs.

Arjan pointed out I may as well just use WARN() these days.  Updated patch 
attached.

-- 
Jesse Barnes, Intel Open Source Technology Center

--Boundary-00=_9xS3IWAoPixPbsM
Content-Type: text/x-diff;
  charset="utf-8";
  name="pci-sysfs-mmap-range-check-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pci-sysfs-mmap-range-check-3.patch"

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..070fbe9 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -16,6 +16,7 @@
 
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/stat.h>
 #include <linux/topology.h>
@@ -502,6 +503,8 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	struct resource *res = (struct resource *)attr->private;
 	enum pci_mmap_state mmap_type;
 	resource_size_t start, end;
+	unsigned long map_len = vma->vm_end - vma->vm_start;
+	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
 	int i;
 
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
@@ -510,6 +513,17 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	if (i >= PCI_ROM_RESOURCE)
 		return -ENODEV;
 
+	/*
+	 * Make sure the range the user is trying to map falls within
+	 * the resource
+	 */
+	if (map_offset + map_len > pci_resource_len(pdev, i)) {
+		WARN("process \"%s\" tried to map 0x%08lx-0x%08lx on BAR %d (size 0x%08lx)\n",
+		     current->comm, map_offset, map_offset + map_len, i,
+		     (unsigned long)pci_resource_len(pdev, i));
+		return -EINVAL;
+	}
+
 	/* pci_mmap_page_range() expects the same kind of entry as coming
 	 * from /proc/bus/pci/ which is a "user visible" value. If this is
 	 * different from the resource itself, arch will do necessary fixup.

--Boundary-00=_9xS3IWAoPixPbsM--
