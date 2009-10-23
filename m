Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZJWEb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZJWEb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 00:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZJWEb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 00:31:56 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:51424 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751412AbZJWEby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 00:31:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WA2gqQSekbDRc1MEoLCdDrUrR2mjv8FcT54bt33VJ7VGBszsIU0gbF0b9hi+5ga4BUJLI5wnZoDTRpCQc/L0+QNnKY61/BJRbypJ6wScfFYnsHgPy/tW9zmSI0CD1ArL;
Date: Fri, 23 Oct 2009 13:31:52 +0900
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, Thomas Schlichter <thomas.schlichter@web.de>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
Message-ID: <20091023133152.1a15ba69@jbarnes-x200>
In-Reply-To: <1256262799.15120.8.camel@gaiman.anholt.net>
References: <1394846127@web.de>
	<4ADF32A0020000780001B20A@vpn.id2.novell.com>
	<20091021173514.GA32227@elte.hu>
	<200910212201.36578.thomas.schlichter@web.de>
	<1256205210.2530.28.camel@sbs-t61>
	<1256225689.32075.6.camel@gaiman.anholt.net>
	<1256248050.2546.9.camel@sbs-t61>
	<20091023081047.4d8abc29@jbarnes-x200>
	<1256256717.2534.6.camel@sbs-t61>
	<1256262799.15120.8.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 210.229.158.64 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 18:53:19 -0700
Eric Anholt <eric@anholt.net> wrote:

> On Thu, 2009-10-22 at 17:11 -0700, Suresh Siddha wrote:
> > On Thu, 2009-10-22 at 16:10 -0700, Jesse Barnes wrote:
> > > On Thu, 22 Oct 2009 14:47:30 -0700
> > > Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > 
> > > > On Thu, 2009-10-22 at 08:34 -0700, Eric Anholt wrote:
> > > > > Can we just not create the _wc sysfs entry if we don't have
> > > > > PAT?  I don't think there's userland relying on its presence
> > > > > as opposed to the non-_wc entry.
> > > > 
> > > > Yes indeed. Jesse do you see an issue with this? This is simple
> > > > and clean. Thanks Eric.
> > > 
> > > Yeah, I think that will be fine.  In fact, older versions of
> > > libpciaccess will behave better if we do it that way (iirc it only
> > > allocates an MTRR if the resource_wc file doesn't exist or fails
> > > to get mapped).
> > 
> > Eric, care to send the patch?
> 
> I don't have a patch, I was just suggesting a way to handle the
> submitter's problem that won't involve complicated changes that nobody
> else will be testing since everyone *should* have a graphics driver
> for their graphics hardware.

Here's a quick & dirty version, totally untested.  A cleaner approach
would be to separate the WC mapping routines and hide the return
-EINVAL in arch specific code...

Jesse

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 0f6382f..41010bb 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -23,6 +23,9 @@
 #include <linux/mm.h>
 #include <linux/capability.h>
 #include <linux/pci-aspm.h>
+#ifdef CONFIG_X86
+#include <asm/pat.h>
+#endif
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -730,6 +733,10 @@ static int
 pci_mmap_resource_wc(struct kobject *kobj, struct bin_attribute *attr,
 		     struct vm_area_struct *vma)
 {
+#ifdef CONFIG_X86
+	if (!pat_enabled)
+		return -EINVAL;
+#endif
 	return pci_mmap_resource(kobj, attr, vma, 1);
 }
 
