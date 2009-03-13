Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZCMOqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZCMOqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZCMOqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:46:46 -0400
Received: from aun.it.uu.se ([130.238.12.36]:50036 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbZCMOqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:46:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18874.29131.187639.775744@pilspetsen.it.uu.se>
Date: Fri, 13 Mar 2009 15:46:35 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Andrew Malton <andrew.malton@esentire.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mixed protection flags for mmap() ?
In-Reply-To: <30C3FDF7-8830-4220-A207-A7C8417427D8@esentire.com>
References: <30C3FDF7-8830-4220-A207-A7C8417427D8@esentire.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Malton writes:
 > A) I have a driver whcih (vm)allocates some space and writes data  
 > from its device there: user processes (readers) mmap the region read- 
 > only and to get at the data more quickly than using read(). Writing  
 > has priority but flags are placed to warn readers where writing is  
 > going on.  Lke this (some details omitted):
 > 
 > 	vma->vm_flags = VM_READ;
 > 	remap_vmalloc_range(vma,region,0)
 > 
 > B) For improving synchronization between the running parts of this I  
 > want to add a control section, which the readers can write to in  
 > order to communicate what they're doing to each other and to the  
 > writer (which is the driver itself).   Abstractly it seems that this  
 > control section should be "part of" being mmaped to the device... But  
 > mmap() is dispatched to the driver with only one vma_area_struct, and  
 > I need two because the flags are different (read, and read-write).   
 > Logically, I want to split the vma then map the two sections  
 > separately (checking that sizes match) and with different flags,  
 > roughly like this :
 > 
 > 	// map part1 of size size1 and part2 of size size2
 > 	split_vma(vma->vm_mm, vma, vma->vm_start + size1, 0);
 > 
 > 	vma->vm_flags = VM_READ|VM_WRITE;
 > 	remap_vmalloc_range(vma,part1,0)
 > 
 > 	vma->vm_next->vm_flags = VM_READ;
 > 	remap_vmalloc_range(vma->vm_next,part2,0)
 > 
 > I can't do this because split_vma is not exported.
 > 
 > 1) If split_vma would work at this point, I'd consider a local patch  
 > to export it.  But does this work? The relevant lock in the mm seems  
 > to be held right through the mmap callback....  but I am probably  
 > missing something.
 > 
 > 2) If it doesn't work, what is the right way to achieve (B)?
 > 
 > A Malton
 > eSentire, Inc.

Do multiple mmaps(), either using multiple fds (fd determines role)
or multiple offsets on one fd (offset determines role).
