Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0BWSW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:22:27 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:53286 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0BWSWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KFh/a5U6//eLNIbH04oTsPl+tMoE7QTJa2zd1n2lvNSe6Dz9GR0b4/SxRdrGLx8QL4
         egwbU4xI7qpTD4UGEp2a9S8ld6EI1sP1Dd8bsn+rhlLsaGpaQBH1tuh5EZbEQVwPJ/Dn
         j76BAJ587DXSHjBMP2KERbEOzoDJb4Lppqq7s=
Date: Tue, 23 Feb 2010 23:53:38 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
Message-ID: <20100223182338.GC5836@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-8-git-send-email-rabin@rab.in>
 <1266931846.19540.9.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266931846.19540.9.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 08:30:46AM -0500, Steven Rostedt wrote:
> On Sun, 2010-02-14 at 01:18 +0530, Rabin Vincent wrote:
> > On ARM, we have two ABIs, and the ABI used is controlled via a config
> > option.  Object files built with one ABI can't be merged with object
> > files built with the other ABI.  So, record_mcount.pl needs to use the
> > same compiler flags as the kernel when generating the object file with
> > the mcount locations.  Ensure this by passing CFLAGS to the script.
> 
> I'm fine with this for now, but I'm wondering if we should pass the
> autoconf.h to the script and parse that instead. This would give us all
> set config options that we can look at.

The correct ABI options are constructed using cc-option and friends, and
that logic would need to be duplicated in recordmcount.pl if we had to
parse autoconf.h.

I originally tried to add a new RECORDMCOUNT_CFLAGS variable in the ARM
Makefile and have that used here instead of KBUILD_CFLAGS (since
KBUILD_CFLAGS includes a whole bunch of possibly irrelevant options),
but coudn't figure out why my new variable wasn't accessible in
Makefile.build.

> 
> But I need to go back and start looking at converting recordmcount.pl to
> recordmcount.c again.
> 
> > 
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
> > ---
> >  scripts/Makefile.build |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 0b94d2f..2535c11 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> >  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> >  	"$(if $(CONFIG_64BIT),64,32)" \
> > -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> > +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> > +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> 
> Doesn't this need to be with the change of recordmcount.pl too?
> Otherwise applying this patch alone will break it. We need every step of
> the patches to work otherwise we risk breaking a kernel bisect.

Dynamic ftrace for ARM is only enabled in the last patch of the series,
so this woudn't be breaking it.  No modification should be required for
record_mcount.pl for other archs because this doesn't add/remove any
parameters.

Rabin
