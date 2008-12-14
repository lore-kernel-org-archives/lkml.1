Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYLNLtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYLNLtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYLNLtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:49:35 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:49297 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYLNLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:49:34 -0500
Date: Sun, 14 Dec 2008 12:49:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081214114931.GA4556@osiris.boeblingen.de.ibm.com>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212152929.GM26095@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 08:29:29AM -0700, Matthew Wilcox wrote:
> On Fri, Dec 12, 2008 at 03:00:40PM +0100, Gerd Hoffmann wrote:
> > The patch sports the actual system call implementation and the windup in
> > the x86 system call tables.  Other archs are TBD.
> 
> > +asmlinkage ssize_t sys_preadv(unsigned long fd, const struct iovec __user *vec,
> > +                              unsigned long vlen, loff_t pos)
> > +asmlinkage ssize_t sys_pwritev(unsigned long fd, const struct iovec __user *vec,
> > +                               unsigned long vlen, loff_t pos)
> 
> Are these prototypes required?  MIPS and PARISC will need wrappers to
> fix them if they are.  These two architectures have an ABI which
> requires 64-bit arguments to be passed in aligned pairs of registers,
> but glibc doesn't know that (and given the existence of syscall(3),
> can't do much about it even if it knew), so some of the arguments end up
> in the wrong registers.
> 
> Things will go much better if we can prototype these as:
> 
> asmlinkage ssize_t sys_preadv(unsigned int fd, const struct iovec __user *vec,
> 				loff_t pos, unsigned long vlen);
> asmlinkage ssize_t sys_pwritev(unsigned int fd, const struct iovec __user *vec,
> 				loff_t pos, unsigned long vlen);
> 
> That way 'pos' ends up split between arg2 and arg3 and vlen ends up in
> arg4 instead of having vlen in arg2 and pos in arg3 and arg4 which then
> have to be munged to be in arg4 and arg5 by a compat wrapper.
> 
> I seem to recall the s390 folks having some concerns with this kind of
> thing too, but I forget what they are, so I'll let them weigh in on
> this.

I think a lot of stuff that needs to be known for new system calls was
written up with these two postings:

http://marc.info/?l=linux-arch&m=118277150812137&w=2
http://lkml.org/lkml/2007/8/1/354
