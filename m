Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZEIKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZEIKsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 06:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZEIKsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 06:48:05 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:53932 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEIKsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 06:48:03 -0400
Date: Sat, 9 May 2009 06:46:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __setup_param(), unique_id and vdso_setup
In-Reply-To: <20090509073227.GA22397@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0905090635530.14376@localhost.localdomain>
References: <alpine.LFD.2.00.0905061519050.32023@localhost.lan> <20090509073227.GA22397@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  regarding the sole remaining invocation of __setup_param() in the
entire tree that could possibly be removed, taking the definition of
__setup_param() with it:

On Sat, 9 May 2009, Sam Ravnborg wrote:

> On Wed, May 06, 2009 at 03:24:21PM -0400, Robert P. J. Day wrote:
> > ...
> > =====
> >
> >   in short, both invocations of __setup_param() use identical second
> > and third parameters, and a tree-wide grep shows:
> >
> > $ grep -rw __setup_param *
> > arch/x86/vdso/vdso32-setup.c:__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
> > include/linux/init.h:#define __setup_param(str, unique_id, fn, early)                   \
> > include/linux/init.h:   __setup_param(str, fn, fn, 0)
> > include/linux/init.h:   __setup_param(str, fn, fn, 1)
> > include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
> > $
> >
> >   so apart from that single exception involving "vdso", that macro
> > could be simplified to just get rid of that third parameter.  is
> > there something special about the vdso boot-time parm that
> > *requires* it to be the only boot-time parm in the entire kernel
> > to have a different unique id?  just curious.  or does that have
> > to be preserved for out-of-tree builds?

> No - so please go ahead and clean it up.

  i'd be happy to, except i'm not sure how to resolve that last
invocation to no longer use __setup_param().  from
arch/x86/vdso/vdso32-setup.c:

=====
...
unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;

static int __init vdso_setup(char *s)
{
        vdso_enabled = simple_strtoul(s, NULL, 0);

        return 1;
}

/*
 * For consistency, the argument vdso32=[012] affects the 32-bit vDSO
 * behavior on both 64-bit and 32-bit kernels.
 * On 32-bit kernels, vdso=[012] means the same thing.
 */
__setup("vdso32=", vdso_setup);

#ifdef CONFIG_X86_32
__setup_param("vdso=", vdso32_setup, vdso_setup, 0);

EXPORT_SYMBOL_GPL(vdso_enabled);
#endif
...
=====

  if someone wants to resolve that file to remove the use of
__setup_param(), this cleanup should be done in two steps, anyway.
first, get rid of that final invocation, followed by removing the
definition from moduleparam.h.  suggestions?

rday

p.s.  there are only three architectures that appear to support a
boot-time parm of vdso (or some equivalent):

$ grep -rw __setup * | grep vdso
arch/sh/kernel/vsyscall/vsyscall.c:__setup("vdso=", vdso_setup);
arch/x86/vdso/vdso32-setup.c:__setup("vdso32=", vdso_setup);
arch/x86/vdso/vma.c:__setup("vdso=", vdso_setup);
arch/s390/kernel/vdso.c:__setup("vdso=", vdso_setup);
$

  that doesn't quite match with what one finds in
Documentation/kernel-parameters.txt:

        vdso=           [X86,SH]
                        vdso=2: enable compat VDSO (default with COMPAT_VDSO)
                        vdso=1: enable VDSO (default)
                        vdso=0: disable VDSO mapping

        vdso32=         [X86]
                        vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
                        vdso32=1: enable 32-bit VDSO (default)
                        vdso32=0: disable 32-bit VDSO mapping

just an observation.
--
========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
