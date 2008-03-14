Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYCNFtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYCNFtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYCNFsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:48:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:11630 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYCNFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=CGJ3yS2fFpSojb/ANNH1DCKB9WnFA3McprpIE28D7x/kpoGOxnVDS58x5G7a3/TbGe/NfvVEHMuSFj2M+z7ngzMLiJIMYhJ/pfojC1SCjnPdNE61acdlIHRQhZ0ELTHbGMvXh9kj4Aho4mJS3sw2M4+gYW+A1kxiJAJ12ueZ99E=
Date: Fri, 14 Mar 2008 08:47:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
Message-ID: <20080314054744.GA4216@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com> <Pine.LNX.4.64.0803140227100.14822@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.00.0803132149320.11864@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803132149320.11864@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 09:53:01PM -0400, Robert P. J. Day wrote:
> On Fri, 14 Mar 2008, Jan Engelhardt wrote:
> 
> >
> > On Mar 14 2008 00:53, Jesper Juhl wrote:
> > >I agree with you completely. A file should explicitly include
> > >headers for the stuff it uses and not rely on implicit includes
> > >done elsewhere. Cleaning that up is going to touch a lot of files
> > >though for no real short term gain (there is a long term gain of
> > >maintainability though), so it's going to be a loveless job :(
> >
> > But straightforward. You nuke the complete #include list of a .h/.c
> > file and "rebuild" it by hand, by looking at the code the .h/.c file
> > provides/uses and selecting appropriate #includes.

Which is generally wrong thing to do because you won't notice that
moving parts to another header will make list of necessary headers much
shorter.

> well, yes, that would certainly do it, but i'm not that ambitious.
> :-)  actually, what i'm testing now is deleting the two superfluous
> includes from <linux/percpu.h>:
> 
>   #include <linus/slab.h>

This needed for kzalloc().

>   #include <linux/string.h>

That looks unnecessary, yes.

> doing "make allyesconfig" on x86, watching where the compile fails,
> fixing that file, and noticing that errors fall into a fairly small
> set of localized clumps, so i'll just collect them and submit them.
> there's actually not that many.

Sir, why on earth do you breed so many patches?

If you're going to delete string.h from percpu.h (which is good idea)
you a) delete it, and b) fix all compile breakages, and c) submit as one
patch.

By "all compile" breakages I mean cross-compilation on archs other than
i386 and on many configs on each of them. If you can't do that, sorry,
stay far away from headers, especially core.

As for many preparatory patches, a) by itself they're useless -- A is
still including B and headers are protected against double inclusion,
b) late in game you can discover that, oops, B is needed in A and all
those patches were useless, c) submitting as one patch which removes B
from A means other people can compile-test that you haven't broken their
usual config, with many small patches scattered over mailing lists they
won't be able do that. Remember, A is still including B.

I suggest to add headers when there is compilation breakage and remove
headers when it's safe thing to do.

P.S.: Some common sense is also required when touching header
      dependencies. gfp.h is not included left and right by drivers,
      because it comes from slab.h. Some common sense is also required
      when touching header dependencies.

