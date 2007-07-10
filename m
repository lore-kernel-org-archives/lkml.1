Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbXGJRUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbXGJRUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXGJRUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:20:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbXGJRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:20:43 -0400
Date: Tue, 10 Jul 2007 10:19:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OOPS at dmar_table_init (2.6.22-rc6-mm1 kernel)
Message-Id: <20070710101903.e5629588.akpm@linux-foundation.org>
In-Reply-To: <46939045.5070508@sw.ru>
References: <46939045.5070508@sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 17:57:25 +0400 Pavel Emelianov <xemul@sw.ru> wrote:

> Hi.
> 
> While working with Andrew's kernel I faced an OOPS on x86_64 
> machine. Unfortunately kernel logs are not appearing in serial 
> console by the time oops happens, but I have some info on the
> screen:
> 
> OOPs is at dmar_table_init() here:
> ffffffff80532873 <dmar_table_init>:
> ffffffff80532873:       41 55                   push   %r13
> ffffffff80532875:       41 54                   push   %r12
> ffffffff80532877:       55                      push   %rbp
> ffffffff80532878:       53                      push   %rbx
> ffffffff80532879:       51                      push   %rcx
> ffffffff8053287a:       4c 8b 2d 07 21 01 00    mov    73991(%rip),%r13        # ffffffff80544988 <dmar_tbl>
> ffffffff80532881:       41 0f b6 45 24          movzbl 0x24(%r13),%eax  <<<<<<<<<<< OOPS, %r13 = NULL
> ffffffff80532886:       84 c0                   test   %al,%al
> ffffffff80532888:       75 11                   jne    ffffffff8053289b <dmar_table_init+0x28>
> ffffffff8053288a:       48 c7 c7 b0 3d 45 80    mov    $0xffffffff80453db0,%rdi
> ffffffff80532891:       e8 c2 4a cf ff          callq  ffffffff80227358 <printk>
> ffffffff80532896:       e9 f2 01 00 00          jmpq   ffffffff80532a8d <dmar_table_init+0x21a>
> 
> Looks like dmar_tbl is NULL. 
> BUG is 100% reproducible. Is there any other info that can be useful?
> 

This?

From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Check for dmar_tbl pointer as this can be NULL on systems with no Intel
VT-d support.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64
+++ a/drivers/pci/dmar.c
@@ -260,6 +260,8 @@ parse_dmar_table(void)
 	int ret = 0;
 
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar)
+		return -ENODEV;
 
 	if (!dmar->width) {
 		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
@@ -301,7 +303,7 @@ int __init dmar_table_init(void)
 
 	parse_dmar_table();
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
 	return 0;
_

