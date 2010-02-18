Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab0BRTwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:52:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:39900 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295Ab0BRTwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,498,1262592000"; 
   d="scan'208";a="541866053"
Subject: Re: [LKML] Re: [PATCH] x86_64: allow sections that are recycled to
 set _PAGE_RW
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "jeremy@goop.org" <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100216221313.GA22869@phenom.dumpdata.com>
References: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>
	 <1266030928-2126-2-git-send-email-konrad.wilk@oracle.com>
	 <1266091697.2677.64.camel@sbs-t61>
	 <20100216221313.GA22869@phenom.dumpdata.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 18 Feb 2010 11:51:40 -0800
Message-Id: <1266522700.2909.34.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 14:13 -0800, Konrad Rzeszutek Wilk wrote:
> On Sat, Feb 13, 2010 at 12:08:17PM -0800, Suresh Siddha wrote:
> > The checks in static_protections() for kernel text mapping ensure that
> > we don't break the 2MB kernel text pages unnecessarily on 64bit kernels
> > (as it has performance implications). We should be fine as long as the
> > kernel identity mappings reflect the correct RW permissions.
> > 
> > But somehow this is working fine on native kernels but not on Xen pv
> > guest. Your patch will cause the performance issues that we are
> 
> That would not be good.
> 
> > addressing using the static protections checks. I will look at this more
> > detailed on tuesday.
> 
> Great. Thank you for doing that. If you find yourself in a bind, here are
> some steps on how to build the Xen pv-ops kernel and such:
> http://wiki.xensource.com/xenwiki/XenParavirtOps
> 
> It goes without saying that I would be happy to test your patch when
> you have one ready.

x86 folks, can you please queue the appended patch? If you think it is
too late for 2.6.33, I added a "cc: stable", so that they can pick this
up for both .32 and .33. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86_64, cpa: don't work hard in preserving kernel text 2M mapping when using 4K already

We currently enforce the !RW mapping for the kernel mapping that maps
holes between different text, rodata and data sections. However, kernel
identity mappings will have different RWX permissions to the pages mapping to
text and to the pages padding (which are freed) the text, rodata sections.
Hence kernel identity mappings will be broken to smaller pages. For 64-bit,
kernel text and kernel identity mappings are different, so we can enable
protection checks that come with CONFIG_DEBUG_RODATA, as well as retain 2MB
large page mappings for kernel text.

Konrad reported a boot failure with the Linux Xen paravirt guest because of
this. In this paravirt guest case, the kernel text mapping and the kernel
identity mapping share the same page-table pages. Thus forcing the !RW mapping
for some of the kernel mappings also cause the kernel identity mappings to be
read-only resulting in the boot failure. Linux Xen paravirt guest also
uses 4k mappings and don't use 2M mapping.

Fix this issue and retain large page performance advantage for native kernels
by not working hard and not enforcing !RW for the kernel text mapping,
if the current mapping is already using small page mapping.

Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stable@kernel.org	[2.6.32, 2.6.33]
---

index 1d4eb93..cf07c26 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -291,8 +291,29 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	 */
 	if (kernel_set_to_readonly &&
 	    within(address, (unsigned long)_text,
-		   (unsigned long)__end_rodata_hpage_align))
-		pgprot_val(forbidden) |= _PAGE_RW;
+		   (unsigned long)__end_rodata_hpage_align)) {
+		unsigned int level;
+
+		/*
+		 * Don't enforce the !RW mapping for the kernel text mapping,
+		 * if the current mapping is already using small page mapping.
+		 * No need to work hard to preserve large page mappings in this
+		 * case.
+		 *
+		 * This also fixes the Linux Xen paravirt guest boot failure
+		 * (because of unexpected read-only mappings for kernel identity
+		 * mappings). In this paravirt guest case, the kernel text
+		 * mapping and the kernel identity mapping share the same
+		 * page-table pages. Thus we can't really use different
+		 * protections for the kernel text and identity mappings. Also,
+		 * these shared mappings are made of small page mappings.
+		 * Thus this don't enforce !RW mapping for small page kernel
+		 * text mapping logic will help Linux Xen parvirt guest boot
+		 * aswell.
+		 */
+		if (lookup_address(address, &level) && (level != PG_LEVEL_4K))
+			pgprot_val(forbidden) |= _PAGE_RW;
+	}
 #endif
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));


