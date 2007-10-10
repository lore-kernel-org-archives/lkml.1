Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXJJShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXJJShq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXJJShj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:37:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37634 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbXJJShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:37:38 -0400
Date: Wed, 10 Oct 2007 20:38:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       parisc-linux-request@lists.parisc-linux.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: parisc arch makefile clean-up needed [Was: cleaning up "make headers_install" for various architectures]
Message-ID: <20071010183858.GA2270@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0710101234340.32502@localhost.localdomain> <20071010095954.79c39a73.randy.dunlap@oracle.com> <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710101324230.6071@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added parisc mailing-listi and cc'ed parisc maintainers.

On Wed, Oct 10, 2007 at 01:26:16PM -0400, Robert P. J. Day wrote:
> On Wed, 10 Oct 2007, Randy Dunlap wrote:
> 
> > On Wed, 10 Oct 2007 12:44:58 -0400 (EDT) Robert P. J. Day wrote:
> >
> > >   the final example, parisc, just plain fails:
> > >
> > > $ make ARCH=parisc headers_install
> > > /home/rpjday/k/git/scripts/gcc-version.sh: line 16: hppa-linux-gcc: command not found
> > > /home/rpjday/k/git/scripts/gcc-version.sh: line 17: hppa-linux-gcc: command not found
> > > /home/rpjday/k/git/arch/parisc/Makefile:39: *** Sorry, GCC v3.3 or above is required..  Stop.
> >
> >
> > Try
> > $ make CROSS_COMPILE="" CC=gcc ARCH=parisc headers_install
> >
> > :(
> > ---
> > ~Randy
> 
> oh, i know how to get around it -- i was just thinking that it
> shouldn't *require* a workaround, that's all.  all of those previous
> warnings and errors are clearly due to the early part of the make
> testing for the appropriate arch-specific build tools without
> realizing that the make target doesn't *need* any of those things just
> to install headers.

parisc arch Makefile needs some love and care...

The logic selecting CROSS_COMPILE seems fishy and wrong -
the error reported by rday is obvious in this respect.

FINAL_LD is unused - kill it.

Building with oldpalo has been broken for a loong time - time to kill it?
Hint - the "cd ../palo" is not working as expected.
And use of TOPDIR is deprecated.

The libs-y assignment should learn from the other architectures how to
get the gcc lib filename:
$(shell $(CC) $(CFLAGS) -print-libgcc-file-name)


And this snippet is also wrong:
PALO := $(shell if which palo; then : ; \
	elif [ -x /sbin/palo ]; then echo /sbin/palo; \
	fi)

palo: vmlinux
	@if [ -x $PALO ]; then \


Make does not export variables so $PALO is not the same as $(PALO).
The latter should be used.

I did not supply a patch because I do not fully understand the
logic behind setting CROSS_COMPILE and 64BIT or not.
But I will be happy to review a patch to fix the issues in the
parisc Makefile.

	Sam
