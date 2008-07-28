Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYG1GZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYG1GZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYG1GZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:25:25 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43471 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbYG1GZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:25:24 -0400
Date: Mon, 28 Jul 2008 09:24:46 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>, Chandru <chandru@in.ibm.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Terry Loftin <terry.loftin@hp.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [patch] crashdump: fix undefined reference to `elfcorehdr_addr'
Message-ID: <20080728062446.GC12655@il.ibm.com>
References: <20080728015117.GA12055@verge.net.au> <m1tzeamust.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzeamust.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 10:39:30PM -0700, Eric W. Biederman wrote:
> Simon Horman <horms@verge.net.au> writes:
> 
> > There has long been a strong aversion to providing the second
> > kernel with flags like im_in_kexec or im_in_kdump, as its felt
> > that this kind of problem is better handled by making sure that
> > the hardware is in a sensible state before leaving the
> > first-kernel.  But this is arguably more reasonable in the kexec
> > case than the kdump case.
> 
> That and because we can generally solve the specific problem with a
> general feature.  Something we can enable/disable on the command
> line if needed.  Right now this is especially interesting as on
> several architectures distros are not building special kdump kernels
> but have a single kernel binary that works in both cases.
> 
> Skimming through your patches this is a case we really do need to
> implement and handle cleanly.
> 
> Currently we leave DMA running in the kexec on panic case.  We avoid
> problems by only running out of a reserved area of memory.
> 
> As as general strategy that is fine.  However we have not
> implemented that strategy in the case of IOMMUs.  And we are having
> trouble with IOMMUs.
> 
> My hunch is that we should implement options to reserve a section of
> the iommu and to tell to the iommu to use the previously reserved
> section. Although turning iommus off altogether and simply using
> swiotlb may be acceptable.  In which case we should just force usage
> of the swiotlb on the command line in /sbin/kexec.

With an isolation-capable IOMMU (such as Calgary, VT-d and AMD's
IOMMU) on the I/O path, as long as we want to keep DMAs running and
going through to memory, we need to keep the IOMMU running, with the
same set of permissions and translation tables. If we don't mind DMAs
failing, we need to gracefully handle IOMMU DMA faults (where
possible---Calgary can't do it at the moment). What we do instead with
Calgary (c.f., the patch that instigated this discussion) is a hack,
we "reinitialize" the IOMMU with the old IOMMU's translation tables so
that DMAs continue working. 

My preference would be to have stopped all DMAs in the old kernel,
which would've made this nastiness go away. Can you explain in simple
words why we can't or won't do that?

Cheers,
Muli
