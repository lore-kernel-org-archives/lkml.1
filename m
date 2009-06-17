Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZFQO5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZFQO5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZFQO5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:57:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbZFQO5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:57:23 -0400
Date: Wed, 17 Jun 2009 09:58:31 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: [PATCH] x86: efi/e820 table merge fix
Message-ID: <20090617145831.GA725@sgi.com>
References: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com> <1245201005.11965.4.camel@yhuang-dev.sh.intel.com> <4A384914.1090900@zytor.com> <1245203099.11965.7.camel@yhuang-dev.sh.intel.com> <4A386B14.8030702@zytor.com> <1245215302.11965.19.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245215302.11965.19.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:08:22PM +0800, Huang Ying wrote:
> On Wed, 2009-06-17 at 12:03 +0800, H. Peter Anvin wrote:
> > Huang Ying wrote:
> > >>> Why does BIOS mark memory region without EFI_MEMORY_WB as these types?
> > >>> Any example?
> > >>>
> > >> Probably not, but if it does, it's broken, and the memory should be
> > >> ignored. The original code had the EFI_MEMORY_WB check already, so it
> > >> seems prudent to keep it.
> > > 
> > > Maybe we need a real life example for that "fix". And attribute that to
> > > the vendor in comments.
> > > 
> > > Best Regards,
> > > Huang Ying
> > 
> > I think you're reading the patch backwards.
> > 
> > Before the patch, the EFI code didn't look at the type *AT ALL*, it only
> > looked at the EFI_MEMORY_WB attribute.  This broke for SGI when they
> > were -- correctly -- reserving real memory (and hence still
> > EFI_MEMORY_WB) with the type set to EFI_RESERVED_TYPE.  This is correct
> > behavior, but the old code saw that it was EFI_MEMORY_WB and therefore
> > considered it usable RAM.  This is obviously broken.
> > 
> > Now why, you're asking, do we still look at md->attribute at all?
> > That's where caution dictates that it is prudent to diverge from the
> > previous behavior, but it is not *this* patch that should be the source
> > of that question, but from the author of the existing code, which
> > appears to be Paul Jackson of SGI.  Unfortunately, his email now bounces
> > and noone has that information.
> 
> Yes. You are right. Thank you for your patient.
> 
> > If you think about it, though, we don't want to consider it as usable
> > RAM if it isn't EFI_MEMORY_WB, and it would in fact be a bug (or
> > workaround for a broken system) to ignore it.  In fact, we go through
> > great pains elsewhere in the kernel to remove memory which isn't WB from
> > the usable pool.
> 
> Because it appears that checking EFI_MEMORY_WB is not necessary, maybe
> it is necessary to add some comments about why it is checked to prevent
> it to be deleted later.

Paul Jackson retired from SGI a while back.  I haven't seen him
participating in the LKML.  But he must have been trying to assure 
that, as Peter says, memory that isn't WB doesn't get into the usable
pool.

I think we are in agreement.  I propose the below, with the comment about WB.


---
 arch/x86/kernel/efi.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -240,10 +240,39 @@ static void __init do_add_efi_memmap(voi
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
 
-		if (md->attribute & EFI_MEMORY_WB)
-			e820_type = E820_RAM;
-		else
+		switch (md->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			/*
+			 * make sure that memory that is not write-back does
+			 * not enter the usable memory pool
+			 */
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			break;
+		case EFI_ACPI_RECLAIM_MEMORY:
+			e820_type = E820_ACPI;
+			break;
+		case EFI_ACPI_MEMORY_NVS:
+			e820_type = E820_NVS;
+			break;
+		case EFI_UNUSABLE_MEMORY:
+			e820_type = E820_UNUSABLE;
+			break;
+		default:
+			/*
+			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
+			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
+			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
+			 */
 			e820_type = E820_RESERVED;
+			break;
+		}
 		e820_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);

-- 
Cliff Wickman
SGI
cpw@sgi.com
(651) 683-3824
