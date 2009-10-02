Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZJBQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZJBQ5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZJBQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:57:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbZJBQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:57:36 -0400
Date: Fri, 2 Oct 2009 09:54:43 -0700
From: Greg KH <gregkh@suse.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [122/136] mmap: avoid unnecessary anon_vma lock acquisition in
 vma_adjust()
Message-ID: <20091002165443.GB3901@suse.de>
References: <20091002011548.335611824@mini.kroah.org>
 <20091002012426.308241169@mini.kroah.org>
 <Pine.LNX.4.64.0910021734090.20933@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910021734090.20933@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:36:44PM +0100, Hugh Dickins wrote:
> On Thu, 1 Oct 2009, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > 
> > commit 252c5f94d944487e9f50ece7942b0fbf659c5c31 upstream.
> > 
> > We noticed very erratic behavior [throughput] with the AIM7 shared
> > workload running on recent distro [SLES11] and mainline kernels on an
> > 8-socket, 32-core, 256GB x86_64 platform.  On the SLES11 kernel
> > [2.6.27.19+] with Barcelona processors, as we increased the load [10s of
> > thousands of tasks], the throughput would vary between two "plateaus"--one
> > at ~65K jobs per minute and one at ~130K jpm.  The simple patch below
> > causes the results to smooth out at the ~130k plateau.
> > 
> > But wait, there's more:
> > 
> > We do not see this behavior on smaller platforms--e.g., 4 socket/8 core.
> > This could be the result of the larger number of cpus on the larger
> > platform--a scalability issue--or it could be the result of the larger
> > number of interconnect "hops" between some nodes in this platform and how
> > the tasks for a given load end up distributed over the nodes' cpus and
> > memories--a stochastic NUMA effect.
> > 
> > The variability in the results are less pronounced [on the same platform]
> > with Shanghai processors and with mainline kernels.  With 31-rc6 on
> > Shanghai processors and 288 file systems on 288 fibre attached storage
> > volumes, the curves [jpm vs load] are both quite flat with the patched
> > kernel consistently producing ~3.9% better throughput [~80K jpm vs ~77K
> > jpm] than the unpatched kernel.
> > 
> > Profiling indicated that the "slow" runs were incurring high[er]
> > contention on an anon_vma lock in vma_adjust(), apparently called from the
> > sbrk() system call.
> > 
> > The patch:
> > 
> > A comment in mm/mmap.c:vma_adjust() suggests that we don't really need the
> > anon_vma lock when we're only adjusting the end of a vma, as is the case
> > for brk().  The comment questions whether it's worth while to optimize for
> > this case.  Apparently, on the newer, larger x86_64 platforms, with
> > interesting NUMA topologies, it is worth while--especially considering
> > that the patch [if correct!] is quite simple.
> > 
> > We can detect this condition--no overlap with next vma--by noting a NULL
> > "importer".  The anon_vma pointer will also be NULL in this case, so
> > simply avoid loading vma->anon_vma to avoid the lock.
> > 
> > However, we DO need to take the anon_vma lock when we're inserting a vma
> > ['insert' non-NULL] even when we have no overlap [NULL "importer"], so we
> > need to check for 'insert', as well.  And Hugh points out that we should
> > also take it when adjusting vm_start (so that rmap.c can rely upon
> > vma_address() while it holds the anon_vma lock).
> > 
> > akpm: Zhang Yanmin reprts a 150% throughput improvement with aim7, so it
> > might be -stable material even though thiss isn't a regression: "this
> > issue is not clear on dual socket Nehalem machine (2*4*2 cpu), but is
> > severe on large machine (4*8*2 cpu)"
> 
> Thanks a lot for including this little fix in 2.6.31.2.
> It is equally relevant to both 2.6.27.36 and 2.6.30.9,
> so if not too late, please consider adding it into those too.
> 
> It feels weird to be arguing this way, when I argued against its
> relevance to -stable in the first place: but it deserves to be
> in the older stables as much as it deserves to be in the latest.

Ok, I'll go queue it up for these .30 and .27 releases.

thanks for letting me know.

greg k-h
