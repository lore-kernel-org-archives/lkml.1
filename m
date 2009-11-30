Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZK3MBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZK3MBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZK3MBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:01:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbZK3MBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:01:40 -0500
Date: Mon, 30 Nov 2009 13:01:45 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mark Veltzer <mark.veltzer@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: get_user_pages question
Message-ID: <20091130120145.GB21639@wotan.suse.de>
References: <200911090850.26724.mark.veltzer@gmail.com> <Pine.LNX.4.64.0911101613080.22198@sister.anvils> <20091128185052.GB30235@random.random> <200911290022.17568.mark.veltzer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911290022.17568.mark.veltzer@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 12:22:17AM +0200, Mark Veltzer wrote:
> On Saturday 28 November 2009 20:50:52 you wrote:
> > Hi Hugh and everyone,
> > 
> > On Tue, Nov 10, 2009 at 04:33:30PM +0000, Hugh Dickins wrote:
> > > In fairness I've added Andrea and KOSAKI-san to the Cc, since I know
> > > they are two people keen to fix this issue once and for all.  Whereas
> > 
> > Right, I'm sure Nick also wants to fix this once and for all (adding
> > him too to Cc ;).
> > 
> > I thought and I still think it's bad to leave races like this open for
> > people to find out the hard way. It just takes somebody to use
> > pthread_create, open a file with O_DIRECT with 512byte (not page
> > ....
> 
> Hello all!
> 
> First let me state that I solved my problems by simply avoiding GUP completely 
> and going with a clean mmap implemenation (with the nopage version) which 
> causes no problems what so ever. mmap does not suffer from all the problems 
> discussed above (aside from the fact that you have to do your own book keeping 
> as far as vma_open and vma_close and fault function goes...). Please correct 
> me if I'm wrong...:)
> 
> The fact that I solved all my problems with mmap and the complexity of the 
> proposed solutions got me thinking about GUP in more general terms. Would it 
> be fair to say that mmap is much more aligned to the kernels way of doing 
> things than GUP? It feels like the vma concept which is a solid one and 
> probably works well for most architectures is in conflict with GUP and so is 
> fork. It also feels like the vma concept is well aligned with fork which means 
> in turn that mmap is well aligned with fork while GUP is not. This is a new 
> conclusion for me and one which did not register back when reading the LDD 
> book (I got the impression that you can pick between mmap and GUP and it does 
> not really matter but now I feel that mmap is much advanced and trouble free).
> 
> Testing it out I grepped the drivers folder of a recent kernel with ONLY 26 
> mentions of GUP in the entire drivers folder! The main drivers using GUP are 
> scsi st and infiniband. If GUP is so unused is it really essential as an in 
> kernel interface? If GUP is slowly dropped and drivers converted to mmap would 
> it not simplify kernel code or at least prevent complex solutions to GUP 
> problems from complicating mm code even more? Again, I'm no kernel expert so 
> please don't flame me too hard if I'm talking heresy or nonsense, I would just 
> like to hear your take on this. It may well be that I simply have no clue and 
> so my conclusions are way too radical...

GUP is basically required to do any kind of IO operations on user
addresses (those not owned by your driver, ie. arbitrary addresses)
without first copying memory into kernel.

If you can wean O_DIRECT off get_user_pages, you'd have most of the
battle won. I don't think it's really possible though.

