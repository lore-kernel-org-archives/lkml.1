Return-Path: <linux-kernel-owner+w=401wt.eu-S933426AbXCJJh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbXCJJh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbXCJJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 04:37:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36764 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426AbXCJJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 04:37:23 -0500
Date: Sat, 10 Mar 2007 09:37:12 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paulo Marques <pmarques@grupopie.com>, dmitry.torokhov@gmail.com,
       Christoph Hellwig <hch@infradead.org>,
       Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris 11_snv
Message-ID: <20070310093712.GC22182@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Paulo Marques <pmarques@grupopie.com>, dmitry.torokhov@gmail.com,
	Deepak Saxena <dsaxena@plexity.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org> <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org> <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr> <20070308212512.GA10584@uranus.ravnborg.org> <Pine.LNX.4.61.0703082242020.521@yvahk01.tjqt.qr> <20070309190054.GA18641@uranus.ravnborg.org> <Pine.LNX.4.61.0703092019250.8799@yvahk01.tjqt.qr> <20070309222332.GA19615@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309222332.GA19615@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 11:23:32PM +0100, Sam Ravnborg wrote:
> > >> ===================================================================
> > >> --- linux-2.6.21-rc3.orig/scripts/kallsyms.c	2007-03-07 05:41:20.000000000 +0100
> > >> +++ linux-2.6.21-rc3/scripts/kallsyms.c	2007-03-07 23:46:46.249005000 +0100
> > >> @@ -378,6 +378,40 @@
> > >>  	table_cnt = pos;
> > >>  }
> > >>  
> > >> +#ifdef __sun__
> > >> +/* Return the first occurrence of NEEDLE in HAYSTACK.  */
> > >> +void *
> > >> +memmem (haystack, haystack_len, needle, needle_len)
> > >> +     const void *haystack;
> > >> +      return (void *) begin;
> > >> +
> > >> +  return NULL;
> > >> +}
> > >> +#endif
> > >> +
> > >>  /* replace a given token in all the valid symbols. Use the sampled symbols
> > >>   * to update the counts */
> > >>  static void compress_symbols(unsigned char *str, int idx)
> > 
> > This one, I am just waiting for someone to object to the extra #if-#endif.
> I was planning to ask Paulo if strstr could not be used - Paulo?

Yeah.  And if we can't use something else all the missing functions
should be in a compat-solaris.c files, similarly to how sparse handles
missing functions on various systems instead of polluting implementation
files with ifdefs and duplicates of library code.

> > >> -HOST_EXTRACFLAGS += -DLOCALE
> > >> +HOST_EXTRACFLAGS += -DLOCALE -std=c99 -D__EXTENSIONS__
> > >>  
> > >>  PHONY += $(obj)/dochecklxdialog
> > >>  $(obj)/dochecklxdialog:
> > 
> > The error message for this one was: <stdbool.h> only valid in C99 mode.
> > Linux GCC 4.1.2 does not print that, Solaris GCC 3.4.3 does. I do not
> > know offhand who is right.
> The -std= looks safe.

It's not though.  It's a gccisms, and I'm not sure we want to mandate
gcc for the host copiler, given that the only way you'd build a working
kernel on a foreign system would be a cross compilation anyway.

> > >>  #define M_EVENT (KEY_MAX+1)
> > >> +
> > >> +#ifndef KEY_RESIZE
> > >> +#	define KEY_RESIZE 0632
> > >> +#endif
> > 
> > Solaris only has curses, not ncurses. Consider this a supreme hack.
> > In fact, menuconfig has some weird display errors still.
> This hack looks OK to me.

Except that solaris curses doesn't actually understand this random
value for KEY_RESIZE.  Either we mandate that ncurses is installed on
the host for menuconfig to work (and ncurses at least used to work
on most unix variants), or some needs to do a proper curses port.

