Return-Path: <linux-kernel-owner+w=401wt.eu-S936358AbXHOXRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936358AbXHOXRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbXHOXQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:16:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758122AbXHOXQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:16:53 -0400
Date: Wed, 15 Aug 2007 16:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Message-Id: <20070815161642.1bfbbe9c.akpm@linux-foundation.org>
In-Reply-To: <1186990219.22431.37.camel@caritas-dev.intel.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 15:30:19 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> Interface) runtime services support to x86_64 architecture.

OK, we have a major trainwreck when these patches meet Peter's
get-newsetup.patch.

I'm halfway into fixing it when I see this.  You have:

 #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
+#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
+#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
+#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
+#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
+#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
+#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
 #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))

But Peter's include/asm-i386/bootparam.h has:

struct efi_info {
	u32 _pad1;
	u32 efi_systab;
	u32 efi_memdesc_size;
	u32 efi_memdesc_version;
	u32 efi_memmap;
	u32 efi_memmap_size;
	u32 _pad2[2];
};

/* The so-called "zeropage" */
struct boot_params {
	struct screen_info screen_info;			/* 0x000 */
	struct apm_bios_info apm_bios_info;		/* 0x040 */
	u8  _pad2[12];					/* 0x054 */
	struct ist_info ist_info;			/* 0x060 */
	u8  _pad3[16];					/* 0x070 */
	u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
	u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
	u8  _pad4[144];					/* 0x0b0 */
	struct edid_info edid_info;			/* 0x140 */
	struct efi_info efi_info;			/* 0x1c0 */
	u32 alt_mem_k;					/* 0x1e0 */

So for example, Peter has memdesc_size at 0x1c8 and you have it at 0x1c4.

I'll give up and will drop the EFI patches.  I'd suggest that you work with
Peter on getting these patches integrated.

