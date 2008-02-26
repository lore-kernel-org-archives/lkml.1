Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYBZGRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYBZGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYBZGRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:17:30 -0500
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:22540 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751670AbYBZGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:17:29 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 01:17:29 EST
X-Yahoo-Newman-Id: 469242.24456.bm@omp422.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=laycOc6JdPaLWpoOfdGEFrWNgBQT+Uh/A0exp0m2Y2Ah5Oj1WK/7QrKv2WtkOVNsqE052zKC36lq6tr+ZW7cVO8QGeTXsF9nbphz79+Js4LE/takM1RjLxJhlEpNQUFODbNkAUV2OlS9zciki7pwnV/5mspjG6KfOIebgglv7UI=  ;
X-YMail-OSG: rVhxpqkVM1nPFgslbTYPXMiGqa4Mc5W8Nuq_VeEDYEx4lM4qr99IaluKekAKZf4KtKSqEfDd.Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Robin Holt <holt@sgi.com>
Subject: Re: [patch 5/6] mmu_notifier: Support for drivers with revers maps (f.e. for XPmem)
Date: Tue, 26 Feb 2008 17:11:32 +1100
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
References: <20080215064859.384203497@sgi.com> <200802211520.03529.nickpiggin@yahoo.com.au> <20080221105838.GJ11391@sgi.com>
In-Reply-To: <20080221105838.GJ11391@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261711.33213.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 21:58, Robin Holt wrote:
> On Thu, Feb 21, 2008 at 03:20:02PM +1100, Nick Piggin wrote:
> > > > So why can't you export a device from your xpmem driver, which
> > > > can be mmap()ed to give out "anonymous" memory pages to be used
> > > > for these communication buffers?
> > >
> > > Because we need to have heap and stack available as well.  MPT does
> > > not control all the communication buffer areas.  I haven't checked, but
> > > this is the same problem that IB will have.  I believe they are
> > > actually allowing any memory region be accessible, but I am not sure of
> > > that.
> >
> > Then you should create a driver that the user program can register
> > and unregister regions of their memory with. The driver can do a
> > get_user_pages to get the pages, and then you'd just need to set up
> > some kind of mapping so that userspace can unmap pages / won't leak
> > memory (and an exit_mm notifier I guess).
>
> OK.  You need to explain this better to me.  How would this driver
> supposedly work?  What we have is an MPI library.  It gets invoked at
> process load time to establish its rank-to-rank communication regions.
> It then turns control over to the processes main().  That is allowed to
> run until it hits the
> 	MPI_Init(&argc, &argv);
>
> The process is then totally under the users control until:
> 	MPI_Send(intmessage, m_size, MPI_INT, my_rank+half, tag, MPI_COMM_WORLD);
> 	MPI_Recv(intmessage, m_size, MPI_INT, my_rank+half,tag, MPI_COMM_WORLD,
> &status);
>
> That is it.  That is all our allowed interaction with the users process.

OK, when you said something along the lines of "the MPT library has
control of the comm buffer", then I assumed it was an area of virtual
memory which is set up as part of initialization, rather than during
runtime. I guess I jumped to conclusions.


> That doesn't seem too unreasonable, except when you compare it to how the
> driver currently works.  Remember, this is done from a library which has
> no insight into what the user has done to its own virtual address space.
> As a result, each MPI_Send() would result in a system call (or we would
> need to have a set of callouts for changes to a processes VMAs) which
> would be a significant increase in communication overhead.
>
> Maybe I am missing what you intend to do, but what we need is a means of
> tracking one processes virtual address space changes so other processes
> can do direct memory accesses without the need for a system call on each
> communication event.

Yeah it's tricky. BTW. what is the performance difference between
having a system call or no?


> > Because you don't need to swap, you don't need coherency, and you
> > are in control of the areas, then this seems like the best choice.
> > It would allow you to use heap, stack, file-backed, anything.
>
> You are missing one point here.  The MPI specifications that have
> been out there for decades do not require the process use a library
> for allocating the buffer.  I realize that is a horrible shortcoming,
> but that is the world we live in.  Even if we could change that spec,

Can you change the spec? Are you working on it?


> we would still need to support the existing specs.  As a result, the
> user can change their virtual address space as they need and still expect
> communications be cheap.

That's true. How has it been supported up to now? Are you using
these kind of notifiers in patched kernels?

