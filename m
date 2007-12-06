Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbXLFWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbXLFWgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXLFWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:36:08 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37366 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXLFWgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:36:06 -0500
Date: Thu, 6 Dec 2007 23:37:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
Message-ID: <20071206223754.GB25209@uranus.ravnborg.org>
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com> <47565486.8050701@gmail.com> <20071205190609.GA14997@uranus.ravnborg.org> <47573403.1060203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47573403.1060203@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 08:28:03AM +0900, Tejun Heo wrote:
> Sam Ravnborg wrote:
> > On Wed, Dec 05, 2007 at 04:34:30PM +0900, Tejun Heo wrote:
> >> Tejun Heo wrote:
> >>>> It would also simplify the kbuild integration if depmod
> >>>> could read the modules as a space separated list where
> >>>> duplicates are allowed.
> >>>> If we do so then the is no reason to escape to the shell
> >>>> in Makeilfe.build and we do not have to remove duplicates either.
> >>> I'm no Makefile expert so no doubt my modifications are ugly.  But I
> >>> think producing a file w/ duplicates in it is just ugly.
> >> Oh, and, depmod should do just fine with duplicate entries as it is.
> > What is the purpose of REMOVE-DUP then?
> > If depmod handle duplicate entries there is no need to remove them.
> 
> As I said, I don't think leaving duplicate lines in a file which will be
> installed, distributed and used widely is the RTTD.  There can be other
> uses of the file.  For example, the file can be parsed and modified by
> distro specific module selector.  Sure, all of them can be made to deal
> with dup entries but that's just not the right place to solve the problem.

googled a bit.
It looks like:
awk '!x[$0]++'
does the trick.

So we can skip the C file (good thing).
> 
> > And this change in Makefile.lib seems bogus:
> > +# make sure '/' follows subdirs
> > +subdir-y       := $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
> > +subdir-m       := $(patsubst %//,%/, $(addsuffix, /,$subdir-m))
> 
> Some subdir-y|m entries have following / while others don't.  subdir-y|m
> are lax about because either way it points to subdirectory.  The above
> two lines are to normalize them so that there's no surprises when
> concatenating file name to it.  I think it's a good idea to have the
> above with or without other changes.
With this change building modpost no longer worked so kbuild
does not like the preceeding slashes. It could be fixed but thats
another patch.
> 
> > I commented it out and with my config everything seems to still
> > work as expected.
> 
> Yeah, it depends on config.  If you don't have subdir-y|m entries which
> don't have following '/', it will work just fine.  If you do, it will break.
> 
> > And I get scripts/mod/modpost built in a mrproper tree again (bug!).
> 
> This I dunno much about.
> 
> > subdir-y and subdir-m does not point to directories that
> > contains modules (built-in or not) so they can be ignored for modorder.
> 
> I didn't know that.  Is it forced that modules can't be put in
> subdir-y|m directories?  What happens if I do that?

I guess modules can be built as modules - but they can never be built-in.
And if someone uses subdir-y to point to a dir with modules
I would anyway cosider that a bug.

	Sam
