Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYLTTYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYLTTYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 14:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYLTTYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 14:24:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:46100 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYLTTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 14:24:12 -0500
Date: Sat, 20 Dec 2008 20:25:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 04/26] kbuild: introduce $(kecho) convenience echo
Message-ID: <20081220192543.GA2162@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org> <1229783497-19550-4-git-send-email-sam@ravnborg.org> <19f34abd0812200713i76261f99t2bae7c0e4a5460de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0812200713i76261f99t2bae7c0e4a5460de@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 04:13:36PM +0100, Vegard Nossum wrote:
> Hi,
> 
> On Sat, Dec 20, 2008 at 3:31 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > From: Mike Frysinger <vapier@gentoo.org>
> >
> > There is a bunch of places in the build system where we do 'echo' to show
> > some nice status lines.  This means we still get output when running in
> > silent mode.  So declare a new KECHO variable that only does 'echo' when we
> > are in a suitable verbose build mode.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > [sam: added Documentation]
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
> >  scripts/Kbuild.include             |    7 +++++++
> >  2 files changed, 21 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> > index 7a77533..51104f9 100644
> > --- a/Documentation/kbuild/makefiles.txt
> > +++ b/Documentation/kbuild/makefiles.txt
> > @@ -383,6 +383,20 @@ more details, with real examples.
> >        to prerequisites are referenced with $(src) (because they are not
> >        generated files).
> >
> > +    $(kecho)
> > +       echoing information to user in a rule is often a good practice
> > +       but when execution "make -s" one does not expect to see any output
> > +       except for warnings/errors.
> > +       To support this kbuild define $(kecho) which will echo out the
> > +       text following $(kecho) to stdout except if "make -s" is used.
> > +
> > +       Example:
> > +               #arch/blackfin/boot/Makefile
> > +               $(obj)/vmImage: $(obj)/vmlinux.gz
> > +                       $(call if_changed,uimage)
> > +                       @$(kecho) 'Kernel: $@ is ready'
> > +
> > +
> >  --- 3.11 $(CC) support functions
> >
> >        The kernel may be built with several different versions of
> > diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> > index 936940b..8cf87e8 100644
> > --- a/scripts/Kbuild.include
> > +++ b/scripts/Kbuild.include
> > @@ -25,6 +25,13 @@ basetarget = $(basename $(notdir $@))
> >  escsq = $(subst $(squote),'\$(squote)',$1)
> >
> >  ###
> > +# Easy method for doing a status message
> > +       kecho := :
> > + quiet_kecho := echo
> > +silent_kecho := :
> > +kecho := $($(quiet)kecho)
> 
> Hm, why don't we put
> 
>   +kecho := @$($(quiet)kecho)
> 
> instead, so each caller can omit the @? And the example would then be:
> 
> > +               $(obj)/vmImage: $(obj)/vmlinux.gz
> > +                       $(call if_changed,uimage)
> > +                       $(kecho) 'Kernel: $@ is ready'
> 
> It seems to work correctly over here.

kecho is used in scripts too where the '@' does not fly.
I considered adding another variant for scripts but that was too much
compared to the few users.

	Sam
