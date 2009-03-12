Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZCLUDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZCLUDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZCLUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:03:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37499
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCLUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:03:41 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Thu, 12 Mar 2009 15:03:36 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
References: <200903120437.03837.rob@landley.net> <20090312095854.GA9398@uranus.ravnborg.org>
In-Reply-To: <20090312095854.GA9398@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121503.37195.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 04:58:54 Sam Ravnborg wrote:
> On Thu, Mar 12, 2009 at 04:37:03AM -0500, Rob Landley wrote:
> > So I'm doing this:
> >
> > make ARCH=m68k headers_install INSTALL_HDR_PATH=walrus
> >
> > And it doesn't install unistd_mm.h which is included from asm/unistd.h. 
> > (The file is there in arch/m68k/include/asm/unistd_mm.h, it just doesn't
> > get installed.  So any code that #includes <asm/unistd.h> results in a
> > file not found error for the other one, which is essentially just a
> > wrapper.)
> >
> > I don't understand what the code's currently doing here well enough to
> > fix it, specifically where does this file list come from?  The file
> > arch/m68k/include/asm/Kbuild is adding "cachectl.h" to header-y, but
> > there are 31 files getting installed from that directory and only one in
> > there.
>
> Kbuild contains the following:
>
> include include/asm-generic/Kbuild.asm
> header-y += cachectl.h
>
> And if you look up the content of "include/asm-generic/Kbuild.asm"

Ah, I was grepping for header-y and this is full of unifdef-y, so I didn't 
look too closely at this file.  (I did glance at it, but the first thing I saw 
was "errno.h" and there's an errno.h in the include/asm-generic directory, so 
I thought it was describing itself.  I presume it tries the arch one first and 
falls back to asm-generic if it's not there?)

> you will realize that this is a list of all the "always to be exported
> headers" from any arch - so the list is consolidated in asm-generic.
>
> The fix for m68k is to eiter:
> 1) unify unistd.h so we get rid of the _no.h and _mm.h variants
> 2) or add the _no.h and _mm.h files to Kbuild.
>
> I recall that someone already did 1) and this is pending in m68k.git.

I hope this patch can be cherry picked so 2.6.29 doesn't ship broken for m68k.

> You could look in -next - I think it is fixed there.

Is there any way to download that as a tarball?  No mention of it on the main 
kernel.org page.  I checked 
http://www.kernel.org/pub/linux/kernel/testing/
http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/ 
http://www.kernel.org/pub/linux/kernel/v2.6/testing/
and a few other places.  No dice.

Googling for "linux-next" finds a blog entry and a few links to discussion on 
kernel trap, but no link to where to _get_ it in any of those...

Googling for "linux-next tarball" finds... http://lkml.org/lkml/2008/2/21/449 
which has a dead link.  And by the third google hit we're into discussion of 
the 2.4.18 kernel and hppa platform.  Not promising.

Seems kind of silly to let git grind away downloading hundreds of megabytes of 
history that'll just get wiped (especially since that tree gets regenerated 
nightly), but oh well.  Assuming that kernel development is git-centric enough 
that a tarball version of a regenerated nightly resource just never seemed 
important, said git repository would be on git.kernel.org, but where...
linux/kernel/git/eranian/linux-next.git isn't it...
linux/kernel/git/mchehab/linux-next.git isn't it...
Ah, linux/kernel/git/sfr/linux-next.git is the one I'm looking for.  Now where 
was the magic incantation to translate from the web url to a git url...  Ah, 
at the top of the page.

time git clone \
  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

Wander off to read the big long http://lkml.org/lkml/2008/2/11/512 thread 
google pulled up earlier, wander back when bored, the download is at 43% 
averaging about 350k/second...  Go read some more...

Am I doing something wrong here?  Other people can't possibly find this A) 
this tedious, B) this undocumented.

And it finished:
> real	22m38.058s
> user	2m27.257s
> sys	0m34.258s

And, yes, I can confirm the m68k include/asm/unistd.h from linux-next actually 
has contents, thanks to commit 646652bded41f4c3bd375b4e03a25b42da93f40b

Anyway, here's hoping the fix makes it into 2.6.29.

> 	Sam

Rob
