Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYG1FnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYG1FnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYG1Fm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:42:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56703 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYG1Fmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:42:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Simon Horman <horms@verge.net.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Terry Loftin <terry.loftin@hp.com>, Tony Luck <tony.luck@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-ia64@vger.kernel.org
References: <20080728015117.GA12055@verge.net.au>
Date: Sun, 27 Jul 2008 22:39:30 -0700
In-Reply-To: <20080728015117.GA12055@verge.net.au> (Simon Horman's message of
	"Mon, 28 Jul 2008 11:51:19 +1000")
Message-ID: <m1tzeamust.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Simon Horman <horms@verge.net.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1742]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman <horms@verge.net.au> writes:

>
> Hi,
>
> I started looking into a simple fix to change the name of
> the is_kdump_kernel() to kernel_has_vmcore(), which is what
> the code in its current incarnatation does.
>
> This also lead to cleaning the usage of elfcorehdr_addr,
> which is in the folloing messy state after recent changes.
>
> #ifdef CONFIG_PROC_VMCORE
> * Declared non-static include/linux/crash_dump.h
> * Initialised in fs/proc/vmcore.c
> #else
> * Declared and initialised as static in include/linux/crash_dump.h
> * Only used by is_kdump_kernel() which is a static function
>   also in include/linux/crash_dump.h
> #endif
>
>
> Howerver, in the course of doing this I came to thinking that actually
> this code won't solve the problem at hand in the case where
> CONFIG_CRASH_DUMP is defined but CONFIG_PROC_VMCORE is not.
> Or in other words, what happens if the calgary initialisation code
> runs in a kdump kernel that does not have CONFIG_PROC_VMCORE ?
>
> A similar problem appears to exist in
> arch/ia64/hp/common/sba_iommu.c:sba_init(), which currently doesn't
> compile if CONFIG_CRASH_DUMP is set but CONFIG_PROC_VMCORE is not.  The
> compilation issue could be solved by using kernel_has_vmcore() (as per
> the patch below) instead of checking elfcorehdr_addr directly, but does
> it actually lead to working code?
>
> There has long been a strong aversion to providing the second
> kernel with flags like im_in_kexec or im_in_kdump, as its felt
> that this kind of problem is better handled by making sure that the
> hardware is in a sensible state before leaving the first-kernel.
> But this is arguably more reasonable in the kexec case than the
> kdump case.

That and because we can generally solve the specific problem with
a general feature.  Something we can enable/disable on the
command line if needed.  Right now this is especially interesting
as on several architectures distros are not building special kdump
kernels but have a single kernel binary that works in both cases.

Skimming through your patches this is a case we really do need to
implement and handle cleanly.

Currently we leave DMA running in the kexec on panic case.  We avoid
problems by only running out of a reserved area of memory.

As as general strategy that is fine.  However we have not implemented that
strategy in the case of IOMMUs.  And we are having trouble with IOMMUs.

My hunch is that we should implement options to reserve a section of
the iommu and to tell to the iommu to use the previously reserved section.
Although turning iommus off altogether and simply using swiotlb
may be acceptable.  In which case we should just force usage of the swiotlb
on the command line in /sbin/kexec.

Eric
