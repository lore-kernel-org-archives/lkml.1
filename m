Return-Path: <linux-kernel-owner+w=401wt.eu-S1767611AbXCIXBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767611AbXCIXBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767610AbXCIXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:01:30 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:34054 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767611AbXCIXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:01:28 -0500
Date: Fri, 9 Mar 2007 23:55:56 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Paulo Marques <pmarques@grupopie.com>, dmitry.torokhov@gmail.com,
       Christoph Hellwig <hch@infradead.org>,
       Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris 11_snv
In-Reply-To: <20070309222332.GA19615@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0703092344250.8799@yvahk01.tjqt.qr>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org>
 <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org>
 <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr> <20070308212512.GA10584@uranus.ravnborg.org>
 <Pine.LNX.4.61.0703082242020.521@yvahk01.tjqt.qr> <20070309190054.GA18641@uranus.ravnborg.org>
 <Pine.LNX.4.61.0703092019250.8799@yvahk01.tjqt.qr> <20070309222332.GA19615@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 9 2007 23:23, Sam Ravnborg wrote:

>Date: Fri, 9 Mar 2007 23:23:32 +0100
>From: Sam Ravnborg <sam@ravnborg.org>
>To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
>    Paulo Marques <pmarques@grupopie.com>
>Cc: dmitry.torokhov@gmail.com, Christoph Hellwig <hch@infradead.org>,
>    Deepak Saxena <dsaxena@plexity.net>,
>    Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] Fix building kernel under Solaris 11_snv
>

Reference: http://lkml.org/lkml/2007/3/8/368
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Happy cherrypicking.
More comments below.

>> >> Index: linux-2.6.21-rc3/scripts/kallsyms.c
>> >> ===================================================================
>> >> --- linux-2.6.21-rc3.orig/scripts/kallsyms.c	2007-03-07 05:41:20.000000000 +0100
>> >> +++ linux-2.6.21-rc3/scripts/kallsyms.c	2007-03-07 23:46:46.249005000 +0100
>> >> @@ -378,6 +378,40 @@
>> >>  	table_cnt = pos;
>> >>  }
>> >>  
>> >> +#ifdef __sun__
>> >> +/* Return the first occurrence of NEEDLE in HAYSTACK.  */
>> >> +void *
>> >> +memmem (haystack, haystack_len, needle, needle_len)
>> >> +     const void *haystack;
>> >> +      return (void *) begin;
>> >> +
>> >> +  return NULL;
>> >> +}
>> >> +#endif
>> >> +
>> >>  /* replace a given token in all the valid symbols. Use the sampled symbols
>> >>   * to update the counts */
>> >>  static void compress_symbols(unsigned char *str, int idx)
>> 
>> This one, I am just waiting for someone to object to the extra #if-#endif.
>
>I was planning to ask Paulo if strstr could not be used - Paulo?

I am not sure, but I would tend to say "no".

kallsyms.c:
	p1 = table[i].sym;                                              
                                                                                
	/* find the token on the symbol */                              
	p2 = memmem(p1, len, str, 2);                                   
	if (!p2) continue;                                              

My first impression would be that 'p1' is a multi-nul-terminated string
array ("foo\0bar\0next\0symbol\0..."), much like the entire .strtab
section (I have not actually bothered to check, so it is a raw guess), and
I do not think strstr would replace memmem here if that was the case.

>> >> Index: linux-2.6.21-rc3/scripts/kconfig/Makefile
>> >> ===================================================================
>> >> --- linux-2.6.21-rc3.orig/scripts/kconfig/Makefile	2007-03-07 05:41:20.000000000 +0100
>> >> +++ linux-2.6.21-rc3/scripts/kconfig/Makefile	2007-03-07 23:21:19.730679000 +0100
>> >> @@ -88,7 +88,7 @@
>> >>  HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
>> >>  HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>> >>  
>> >> -HOST_EXTRACFLAGS += -DLOCALE
>> >> +HOST_EXTRACFLAGS += -DLOCALE -std=c99 -D__EXTENSIONS__
>> >>  
>> >>  PHONY += $(obj)/dochecklxdialog
>> >>  $(obj)/dochecklxdialog:
>> 
>> The error message for this one was: <stdbool.h> only valid in C99 mode.
>> Linux GCC 4.1.2 does not print that, Solaris GCC 3.4.3 does. I do not
>> know offhand who is right.
>
>The -std= looks safe. The __EXTENSIONS__ part seems safe and needed after a
>bit googling.

Humm humm. Linux's /usr/include does not have any (glibc) file with the
string __EXTENSIONS__ in it. Though, the linux manpage for fileno() does
not mention fileno() conforming to anything. Under Linux, fileno() is
wrapped inside __USE_POSIX, and the comments in Solaris's headers also
indicate it is something posixy.

Perhaps have something like

#ifdef __sun__
#	define __EXTENSIONS__ 1
#endif

>> >> Index: linux-2.6.21-rc3/scripts/mod/file2alias.c
>> >> ===================================================================
>> >> --- linux-2.6.21-rc3.orig/scripts/mod/file2alias.c	2007-03-07 05:41:20.000000000 +0100
>> >> +++ linux-2.6.21-rc3/scripts/mod/file2alias.c	2007-03-07 23:41:23.772026000 +0100
>> >> @@ -32,6 +32,8 @@
>> >>  typedef uint32_t	__u32;
>> >>  typedef uint16_t	__u16;
>> >>  typedef unsigned char	__u8;
>> >> +typedef int32_t		__s32;
>> >> +typedef int16_t		__s16;
>> >>  
>> >>  /* Big exception to the "don't include kernel headers into userspace, which
>> >>   * even potentially has different endianness and word sizes, since
>> 
>> HAX.
>
>This goes away when we do not include input.h I think.

Exactly.

>> >> Index: linux-2.6.21-rc3/scripts/mod/modpost.h
>> >> ===================================================================
>> >> --- linux-2.6.21-rc3.orig/scripts/mod/modpost.h	2007-03-07 05:41:20.000000000 +0100
>> >> +++ linux-2.6.21-rc3/scripts/mod/modpost.h	2007-03-07 23:37:01.315290000 +0100
>> >> @@ -41,6 +41,11 @@
>> >>  #define ELF_R_TYPE  ELF64_R_TYPE
>> >>  #endif
>> >>  
>> >> +#ifdef __sun__
>> >> +typedef uint16_t Elf32_Section;
>> >> +typedef uint16_t Elf64_Section;
>> >> +#endif
>> >> +
>> >>  /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
>> >>  typedef struct
>> >>  {
>> 
>> More HAX because Sol does not have them >:-(
>
>Yup - but needed.

How much do we want to support Solaris anyway? It's like trying to make
ICC a thoroughly supported compiler. Hey, do we want to support GCC
compilation under BSD too? What about CYGWIN - there have been efforts
before! :p  Seriously, what build platforms do we want to support in
the near future?



Thanks,
Jan
-- 
