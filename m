Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbYG1TXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbYG1TXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYG1TXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:23:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42545 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYG1TXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:23:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Terry Loftin <terry.loftin@hp.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
References: <20080728015117.GA12055@verge.net.au>
	<m1tzeamust.fsf@frodo.ebiederm.org>
	<20080728062446.GC12655@il.ibm.com>
	<20080728134405.GD25963@redhat.com>
Date: Mon, 28 Jul 2008 12:12:41 -0700
In-Reply-To: <20080728134405.GD25963@redhat.com> (Vivek Goyal's message of
	"Mon, 28 Jul 2008 09:44:05 -0400")
Message-ID: <m1wsj5lt5i.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4568]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Jul 28, 2008 at 09:24:46AM +0300, Muli Ben-Yehuda wrote:
>> 
>> With an isolation-capable IOMMU (such as Calgary, VT-d and AMD's
>> IOMMU) on the I/O path, as long as we want to keep DMAs running and
>> going through to memory, we need to keep the IOMMU running, with the
>> same set of permissions and translation tables. If we don't mind DMAs
>> failing, we need to gracefully handle IOMMU DMA faults (where
>> possible---Calgary can't do it at the moment). What we do instead with
>> Calgary (c.f., the patch that instigated this discussion) is a hack,
>> we "reinitialize" the IOMMU with the old IOMMU's translation tables so
>> that DMAs continue working. 
>> 
>
> Hi Muli,
>
> Agree, using old kernel's TCE tables is a hack. As Eric pointed out,
> is there a reason why swiotlb will not work here? (I guess using
> swiotlb will mean disabling iommu and that will again fault if 
> DMA is going on).
>
> So one of the solutions, as eric suggested,  will be to reserve some
> entries in first kernel and then pass that info to second kernel and
> let second kernel use thos entries for setting up DMA and let the
> DMA's of first kernel run untouched.
>
> This patch is effectively doing that (using previous kernel's TCE table),
> except the fact that there are no gurantees that there are free table
> entries when kdump kernel wants to perform a DMA of its own. Should
> probably work though in most of the cases. 
>
>> My preference would be to have stopped all DMAs in the old kernel,
>> which would've made this nastiness go away. Can you explain in simple
>> words why we can't or won't do that?
>
> Is there a reliable way of stopping all ongoing DMAs after kernel crash?

When I investigated this there was no reliable way to stop DMAs from devices,
in a generic way, and a callback to each device in the system in the kexec
on panic path is less reliable then simply avoiding running out of regions
where those DMAs are running.

So it would be quite reasonable to drop all in flight DMA at the iommu.

We do need a way to allow the drivers in the kernel running after the
panic to use DMA.  Which is where the idea of reserving a region of
the iommu comes from.

Eric
