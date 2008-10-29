Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJ2Fgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJ2Fgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ2Fgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:36:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:62321 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYJ2Fgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:36:43 -0400
Subject: Re: [PATCH] Fix range check on mmaped sysfs resource files
From: Ed Swierk <eswierk@aristanetworks.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <9ae48b020810282224x31706492mdbaae102909ba63b@mail.gmail.com>
References: <9ae48b020810282224x31706492mdbaae102909ba63b@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-vZszEMJZ5RjZX7hadPMU"
Date: Tue, 28 Oct 2008 22:36:35 -0700
Message-Id: <1225258595.3865.1.camel@eswierk-laptop.arastra.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vZszEMJZ5RjZX7hadPMU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2008-10-28 at 22:24 -0700, Ed Swierk wrote:
> pci_mmap_fits() in 2.6.27.4 returns the wrong answer if the sysfs
> resource file size is not a multiple of the page size. vm_end and
> vm_start are already page-aligned, so size - start < nr, causing
> mmap() to return EINVAL.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

...and here is the patch in a hopefully more readable form.


--=-vZszEMJZ5RjZX7hadPMU
Content-Disposition: attachment; filename=linux-2.6.27-pci-sysfs-mmap-bug.patch
Content-Type: text/x-patch; name=linux-2.6.27-pci-sysfs-mmap-bug.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.27.4/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.27.4.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.27.4/drivers/pci/pci-sysfs.c
@@ -492,7 +492,7 @@ static int pci_mmap_fits(struct pci_dev 
 
 	nr = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	start = vma->vm_pgoff;
-	size = pci_resource_len(pdev, resno) >> PAGE_SHIFT;
+	size = ((pci_resource_len(pdev, resno) - 1) >> PAGE_SHIFT) + 1;
 	if (start < size && size - start >= nr)
 		return 1;
 	WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on %s BAR %d (size 0x%08lx)\n",

--=-vZszEMJZ5RjZX7hadPMU--

