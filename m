Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZIYImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZIYImR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZIYImR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:42:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38977 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZIYImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:42:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 25 Sep 2009 17:40:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-Id: <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4ABC80B0.5010100@crca.org.au>
References: <4AB9A0D6.1090004@crca.org.au>
	<20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com>
	<4ABC80B0.5010100@crca.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 18:34:56 +1000
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi.
> 
> KAMEZAWA Hiroyuki wrote:
> >> I have some code in TuxOnIce that needs a bit too (explicitly mark the
> >> VMA as needing to be atomically copied, for GEM objects), and am not
> >> sure what the canonical way to proceed is. Should a new unsigned long be
> >> added? The difficulty I see with that is that my flag was used in
> >> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
> >> function would need an extra parameter too..
> > 
> > Hmm, how about adding vma->vm_flags2 ?
> 
> The difficulty there is that some functions pass these flags as arguments.
> 
Ah yes. But I wonder some special flags, which is rarey used, can be moved
to vm_flags2...

For example,

 #define VM_SEQ_READ     0x00008000      /* App will access data sequentially */
 #define VM_RAND_READ    0x00010000      /* App will not benefit from clustered reads */
are all capsuled under
mm.h
 117 #define VM_READHINTMASK                 (VM_SEQ_READ | VM_RAND_READ)
 118 #define VM_ClearReadHint(v)             (v)->vm_flags &= ~VM_READHINTMASK
 119 #define VM_NormalReadHint(v)            (!((v)->vm_flags & VM_READHINTMASK))
 120 #define VM_SequentialReadHint(v)        ((v)->vm_flags & VM_SEQ_READ)
 121 #define VM_RandomReadHint(v)            ((v)->vm_flags & VM_RAND_READ)

Or

105 #define VM_PFN_AT_MMAP  0x40000000      /* PFNMAP vma that is fully mapped at mmap time */
is only used under special situation.

etc..

They'll be able to be moved to other(new) flag field, IIUC.

Thanks,
-Kame




> Regards,
> 
> Nigel
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

