Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYAUJ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYAUJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 04:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbYAUJ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 04:57:16 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33718 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336AbYAUJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:57:14 -0500
Date: Mon, 21 Jan 2008 10:57:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Use separate sections for __dev/__cpu/__mem code/data
Message-ID: <20080121095722.GA29145@uranus.ravnborg.org>
References: <20080120200527.GA23852@uranus.ravnborg.org> <1200859743-24037-1-git-send-email-sam@ravnborg.org> <1200859743-24037-2-git-send-email-sam@ravnborg.org> <1200859743-24037-3-git-send-email-sam@ravnborg.org> <1200859743-24037-4-git-send-email-sam@ravnborg.org> <1200859743-24037-5-git-send-email-sam@ravnborg.org> <1200859743-24037-6-git-send-email-sam@ravnborg.org> <1200859743-24037-7-git-send-email-sam@ravnborg.org> <1200859743-24037-8-git-send-email-sam@ravnborg.org> <20080121073341.GA20050@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121073341.GA20050@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 04:33:41PM +0900, Paul Mundt wrote:
> On Sun, Jan 20, 2008 at 09:09:03PM +0100, Sam Ravnborg wrote:
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index ded7ca2..e0a56fb 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -9,10 +9,46 @@
> >  /* Align . to a 8 byte boundary equals to maximum function alignment. */
> >  #define ALIGN_FUNCTION()  . = ALIGN(8)
> >  
> > +/* The actual configuration determine if the init/exit sections
> > + * are handled as text/data or they can be discarded (which
> > + * often happens at runtime)
> > + */
> > +#ifdef CONFIG_HOTPLUG
> > +#define DEV_KEEP(sec)    *(.dev##sec)
> > +#define DEV_DISCARD(sec)
> > +#else
> > +#define DEV_KEEP(sec)
> > +#define DEV_DISCARD(sec) *(.dev##sec)
> > +#endif
> > +
> Using your kbuild.git, these blow up for me:
> 
>   LD      .tmp_vmlinux1
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:364: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:364: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:364: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:364: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:381: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:381: ignoring invalid character `#' in script
> sh4-linux-ld:arch/sh/kernel/vmlinux.lds:381: ignoring invalid character `#' in script
> ...
> 
> This comes out as:
> 
>         .text : {
>                 *(.text.head)
>                 . = ALIGN(8);                                                   *(.text)                                                                *(.text.init.refok)                                                     *(.exit.text.refok)                                             *(.dev##init.text)
>                                         *(.dev##exit.text)
> 
>                 . = ALIGN(8);                                                   __sched_text_start = .;                                 *(.sched.text)
>                                                 __sched_text_end = .;
>                 . = ALIGN(8);                                                   __lock_text_start = .;                                  *(.spinlock.text)
>                                                 __lock_text_end = .;
>                 . = ALIGN(8);                                                   __kprobes_text_start = .;                               *(.kprobes.text)
>                                                 __kprobes_text_end = .;
>                 *(.fixup)
>                 *(.gnu.warning)
> ...
> 
> so the ## is being taken directly rather than acting as a concatenation.

Strange...
I can reproduce with gcc 3.4.5 here - will fix.

Setting CONFIG_HOTPLUG=n for sparc64 also cause troubles. Something with local symbols discarded.
So more work is needed.

	Sam
