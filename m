Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbXJXM7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbXJXM7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXJXM7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:59:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9821 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXJXM7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:59:02 -0400
Date: Wed, 24 Oct 2007 14:58:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] Fix asm-avr32/dma-mapping.h breakage
Message-ID: <20071024125858.GY14671@kernel.dk>
References: <20071024132220.14070582@dhcp-255-175.norway.atmel.com> <20071024112453.GP14671@kernel.dk> <20071024112938.GA1770@uranus.ravnborg.org> <Pine.LNX.4.64.0710240814570.31881@localhost.localdomain> <20071024122120.GV14671@kernel.dk> <20071024124123.GD30533@stusta.de> <Pine.LNX.4.64.0710240840390.1257@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710240840390.1257@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Robert P. J. Day wrote:
> On Wed, 24 Oct 2007, Adrian Bunk wrote:
> 
> > On Wed, Oct 24, 2007 at 02:21:20PM +0200, Jens Axboe wrote:
> > > On Wed, Oct 24 2007, Robert P. J. Day wrote:
> 
> > > > i was just about to ask -- is this one of those cases where the
> > > > asm versions of scatterlist.h should have a warning/error that
> > > > they should not be included directly, and to include
> > > > linux/scatterlist.h instead?
> 
> > > No, using asm/scatterlist.h is perfectly fine. The problem is code
> > > using the sg helpers should include linux/scatterlist.h since that
> > > is where those are defined.
> 
> > > If you just need the scatterlist structure definition, then
> > > asm/scatterlist.h is the correct include.
> 
> > But there's also the general question whether it's good practice for
> > not architecture specific code to include asm/ headers.
> 
> > For APIs available on all architectures linux/ header are the right
> > thing to use, and what is in the asm/ header and what in the linux/
> > header becomes an implementation detail that can be changed.
> 
> more to the point, what the above shows is that the headers aren't
> well defined.  one would think that a header file whose name is
> "scatterlist.h" should provide content related solely to that name.
> 
> if there's different content, such as the "sg helpers" mentioned
> above, then those should require a different header file inclusion.
> it makes no sense to suggest that one should include
> <asm/scatterlist.h> if you need *only* that content, but to include
> <linux/scatterlist.h> if you need stuff *in addition to* the
> scatterlist content.  that's just begging for confusion.

Completely disagree, it's well defined. The asm/ header adds the arch
private stuff, like the actual structure definition. That absolutely has
to reside there. The linux/ header adds manipulation headers for that
structure. You'd want to put that in all the asm/ headers? I didn't
think so.

So I'll repeat - arch code may use the asm/ header, if they just need
the structure definition. Drivers should use the linux/ header, since
they should also use the accessor functions. Right now there's still a
lot of open coding of

        for (i = 0; i < sg_nents; i++)
                sg_table[i] ...

usage which should go away eventually and use a

        sg = sg_table;
        do {
                ...
        } while ((sg = sg_next(sg)) != NULL);

construct, in which case there's no way around using the linux/ header.
arch IOMMU code will want to be using the linux/ header as well, since
they will be browsing the list also. That switch should happen when the
driver actually needs it, not needlessly. The problems seen in the last
few days have been code that actually use sg accessors AND don't use the
linux/ header, and that problem only showing up on archs where
linux/scatterlist.h doesn't get magically included from some other file.
That is of course a bug, you should include the header with the
functions that you use. It has nothing to do with asm/ vs linux/ include
messiness.

-- 
Jens Axboe

