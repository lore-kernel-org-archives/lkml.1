Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZJVOCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZJVOCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZJVOCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:02:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:29046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZJVOCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:02:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,605,1249282800"; 
   d="scan'208";a="460216193"
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
       Jan Beulich <JBeulich@novell.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Thomas Hellstrom <thellstrom@vmware.com>, Tejun Heo <tj@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "x86@kernel.org" <x86@kernel.org>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <4AE04C95.6070402@zytor.com>
References: <1395763521@web.de>  <4AE04C95.6070402@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 22 Oct 2009 06:26:53 -0700
Message-Id: <1256218013.2546.9.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 05:14 -0700, H. Peter Anvin wrote:
> On 10/22/2009 09:08 PM, Thomas Schlichter wrote:
> >>
> >> I have couple of issues with this patchset still. pci_mmap_page_range()
> >> doesn't get called for each fork(). So, we won't be ref counting the
> >> mtrr usage properly.
> >
> > When forking, what happens with the "struct file"? If it is being copied, then the
> > processes share the same private data which would be freed during the first
> > release(). I think this would be a problem whereever file-private data are used.
> >
> > So I think it must be shared between the forked processes and some reference
> > counting must exist. This reference counting must ensure that release() is only
> > called when all processes did close() their file.
> >
> > And in that case (shared "struct file", one single release() call in the end) this
> > implementation should be completely safe...
> >
> 
> struct file is shared between forked processes.

That is correct. But I am referring to the ref-count getting incremented
in Thomas's patch only in the pci_mmap_page_range() which will be called
only during first mmap.

We need to keep track of the counts of later forks too. For PAT, we keep
track of this ref counting in track_pfn_vma_copy(). We shouldn't use
different tracking mechanisms for PAT and non-PAT. We should cleanly tap
into track_pfn_vma_copy() or extend that to cover this case aswell.

thanks,
suresh

