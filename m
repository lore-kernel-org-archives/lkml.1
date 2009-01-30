Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZA3SPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZA3SPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZA3SPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:15:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbZA3SPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:15:02 -0500
Date: Fri, 30 Jan 2009 10:14:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Greg KH <gregkh@suse.de>, Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
Message-ID: <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> <20090130055639.GA30950@suse.de> <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
 <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Hugh Dickins wrote:
> 
> ... what I think you have done is break the vma merging on
> ordinary files: because of that irritating VM_CAN_NONLINEAR
> flag which generic_file_mmap() and some others add in.

Ahh. Yes. VM_CAN_NONLINEAR is a "reverse flag", ie unlike the other flags 
it's to some degree about being extra _normal_, not about being odd. Most 
special flags tend to disable the VM from doing some clever thing, this 
one enables it.

> To break the merging won't cause anyone much trouble,
> but is a slight regression we should fix.

Yeah. Just masking it off when comparing is probably the simplest option. 
Make it a separate #define just for readability. There might be other 
flags like this in the future.

> I'd have been very upset not to find something ;)

Yay for you ;)

And yes, this is the kind of thing that probably does mean that we're 
better off with the no-semantic-changes patches in -stable.

		Linus

---
 mm/mmap.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index d3fa10a..c581df1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -658,6 +658,9 @@ again:			remove_next = 1 + (end > next->vm_end);
 	validate_mm(mm);
 }
 
+/* Flags that can be inherited from an existing mapping when merging */
+#define VM_MERGEABLE_FLAGS (VM_CAN_NONLINEAR)
+
 /*
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
@@ -665,7 +668,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	if (vma->vm_flags != vm_flags)
+	if ((vma->vm_flags ^ vm_flags) & ~VM_MERGEABLE_FLAGS)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
