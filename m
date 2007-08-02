Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbXHBPJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbXHBPJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXHBPJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:09:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:49480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbXHBPJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:09:23 -0400
Subject: Re: scripts/mod/file2alias.c cross compile problem
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Adrian Bunk <bunk@stusta.de>, tony.luck@intel.com
Cc: Sam Ravnborg <sam@ravnborg.org>, Jan Dittmer <jdi@l4x.org>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
In-Reply-To: <20070728013950.GE15129@stusta.de>
References: <20070727230741.GD15129@stusta.de>
	 <617E1C2C70743745A92448908E030B2A0209BB9D@scsmsx411.amr.corp.intel.com>
	 <20070728013950.GE15129@stusta.de>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 17:09:19 +0200
Message-Id: <1186067359.18821.553.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-28 at 03:39 +0200, Adrian Bunk wrote:
> On Fri, Jul 27, 2007 at 04:21:47PM -0700, Luck, Tony wrote:
> > > So it seems on ia64 with gcc 3.3.6 there's some 8 byte alignment of the 
> > > array members?
> > >
> > > Sam and the ia64 maintainers Cc'ed - they might know better what's going 
> > > on here.
> > 
> > This ia64 maintainer is baffled ... but I don't see the problem here (perhaps
> > because my build machine has gcc 3.4.6).
> 
> 
> I found what causes this problem, and it only occurs during cross 
> compilation.
> 
> 
> The struct is:
> 
> #define ACPI_ID_LEN     9
> 
> struct acpi_device_id {
> 	 __u8 id[ACPI_ID_LEN];
> 	kernel_ulong_t driver_data;
> };
> 
> 
> When compiling for ia64, this results in:
> 
> struct acpi_device_id {
> 	__u8 id[9];
> 	uint64_t driver_data;
> };
> 
> 
> sizeof(struct acpi_device_id) for ia64 is due to different padding
> after id[] 20 bytes on i386 but 24 bytes on ia64.
> 
> scripts/mod/file2alias.c is compiled with HOSTCC and ensures that 
> kernel_ulong_t is correct (in this case uint64_t for ia64), but it can't 
> cope with different padding on different architectures.

This one should workaround it. Is this acceptable for now?
Don't know how to fix this in a cleaner way (but I am sure it's
possible... ). Maybe an IA64 guy who is more used to such things has a
better idea and could have a look at this if there is time...

   Thomas

-------------

Cross-compilation between e.g. i386 -> 64bit could break -> work around it

Adrian Bunk: scripts/mod/file2alias.c is compiled with HOSTCC and ensures that
kernel_ulong_t is correct, but it can't cope with different padding on
different architectures.

---
 include/linux/mod_devicetable.h |    2 ++
 1 file changed, 2 insertions(+)

Index: torvalds/include/linux/mod_devicetable.h
===================================================================
--- torvalds.orig/include/linux/mod_devicetable.h
+++ torvalds/include/linux/mod_devicetable.h
@@ -160,9 +160,11 @@ struct ap_device_id {
 #define AP_DEVICE_ID_MATCH_DEVICE_TYPE		0x01
 
 #define ACPI_ID_LEN	9
+#define FILLUP_LEN	7 /* dirty fix for i386 -> 64bit cross-compilation */
 
 struct acpi_device_id {
 	__u8 id[ACPI_ID_LEN];
+	__u8 dummy[FILLUP_LEN];
 	kernel_ulong_t driver_data;
 };
 


