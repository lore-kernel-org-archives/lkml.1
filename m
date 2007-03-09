Return-Path: <linux-kernel-owner+w=401wt.eu-S1767481AbXCIUU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767481AbXCIUU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767483AbXCIUU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:20:57 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:43267 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767481AbXCIUUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:20:55 -0500
Date: Fri, 9 Mar 2007 21:16:35 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: dmitry.torokhov@gmail.com, Christoph Hellwig <hch@infradead.org>,
       Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris 11_snv
In-Reply-To: <20070309190054.GA18641@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.61.0703092019250.8799@yvahk01.tjqt.qr>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org>
 <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org>
 <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr> <20070308212512.GA10584@uranus.ravnborg.org>
 <Pine.LNX.4.61.0703082242020.521@yvahk01.tjqt.qr> <20070309190054.GA18641@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 9 2007 20:00, Sam Ravnborg wrote:
>On Thu, Mar 08, 2007 at 11:01:57PM +0100, Jan Engelhardt wrote:
>> 
>> Since Solaris seems to be on the run, I did myself try compile it. 
>> However, unlike the original poster who said he did so on SunOS 4.8, I 
>> did it on 5.11_snv39, yielding a bigger changeset. I thought I just 
>> share the diff that piled up so far. It needs a lot of hacks on the 
>> Solaris side - prioritizing GNU names, then, second, gnu ld has a 
>> glitch, then, gcc has a missing file... it's fun fun fun!
>
>Can I please have a signed-off version of this patch.

_Are you sure_ you want all these hacks without further
review from other people? Also note the patch is incomplete,
for example I could not compile the acpi pieces because
acsolaris.h -- which is referenced in the acpi includes --
does not exist. (Yet another piece of software that has
crossplatform compatibilty stuff, like XFS.)

>> --- linux-2.6.21-rc3.orig/include/linux/input.h	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/include/linux/input.h	2007-03-07 23:40:39.417339000 +0100
>> @@ -16,7 +16,9 @@
>>  #include <sys/time.h>
>>  #include <sys/ioctl.h>
>>  #include <sys/types.h>
>> -#include <asm/types.h>
>> +#ifndef __sun__
>> +#	include <asm/types.h>
>> +#endif
>>  #endif

This is not a proper fix for sure. The problem lies in
file2alias.c, see (your own) http://lkml.org/lkml/2007/3/8/339

>> Index: linux-2.6.21-rc3/scripts/genksyms/genksyms.c
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/genksyms/genksyms.c	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/genksyms/genksyms.c	2007-03-07 23:28:35.659555000 +0100
>> @@ -21,6 +21,7 @@
>>     along with this program; if not, write to the Free Software Foundation,
>>     Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
>>  
>> +#include <alloca.h>
>>  #include <stdio.h>
>>  #include <string.h>
>>  #include <stdlib.h>

This is however, is valid. Can I gave sign-offs for single hunks?

>> Index: linux-2.6.21-rc3/scripts/kallsyms.c
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/kallsyms.c	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/kallsyms.c	2007-03-07 23:46:46.249005000 +0100
>> @@ -378,6 +378,40 @@
>>  	table_cnt = pos;
>>  }
>>  
>> +#ifdef __sun__
>> +/* Return the first occurrence of NEEDLE in HAYSTACK.  */
>> +void *
>> +memmem (haystack, haystack_len, needle, needle_len)
>> +     const void *haystack;
>> +     size_t haystack_len;
>> +     const void *needle;
>> +     size_t needle_len;
>> +{
>> +  const char *begin;
>> +  const char *const last_possible
>> +    = (const char *) haystack + haystack_len - needle_len;
>> +
>> +  if (needle_len == 0)
>> +    /* The first occurrence of the empty string is deemed to occur at
>> +       the beginning of the string.  */
>> +    return (void *) haystack;
>> +
>> +  /* Sanity check, otherwise the loop might search through the whole
>> +     memory.  */
>> +  if (__builtin_expect (haystack_len < needle_len, 0))
>> +    return NULL;
>> +
>> +  for (begin = (const char *) haystack; begin <= last_possible; ++begin)
>> +    if (begin[0] == ((const char *) needle)[0] &&
>> +        !memcmp ((const void *) &begin[1],
>> +                 (const void *) ((const char *) needle + 1),
>> +                 needle_len - 1))
>> +      return (void *) begin;
>> +
>> +  return NULL;
>> +}
>> +#endif
>> +
>>  /* replace a given token in all the valid symbols. Use the sampled symbols
>>   * to update the counts */
>>  static void compress_symbols(unsigned char *str, int idx)

This one, I am just waiting for someone to object to the extra #if-#endif.

>> Index: linux-2.6.21-rc3/scripts/kconfig/Makefile
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/kconfig/Makefile	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/kconfig/Makefile	2007-03-07 23:21:19.730679000 +0100
>> @@ -88,7 +88,7 @@
>>  HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
>>  HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>>  
>> -HOST_EXTRACFLAGS += -DLOCALE
>> +HOST_EXTRACFLAGS += -DLOCALE -std=c99 -D__EXTENSIONS__
>>  
>>  PHONY += $(obj)/dochecklxdialog
>>  $(obj)/dochecklxdialog:

The error message for this one was: <stdbool.h> only valid in C99 mode.
Linux GCC 4.1.2 does not print that, Solaris GCC 3.4.3 does. I do not
know offhand who is right.

>> Index: linux-2.6.21-rc3/scripts/kconfig/lxdialog/dialog.h
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/kconfig/lxdialog/dialog.h	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/kconfig/lxdialog/dialog.h	2007-03-07 23:14:48.462956000 +0100
>> @@ -222,3 +222,7 @@
>>   *   -- uppercase chars are used to invoke the button (M_EVENT + 'O')
>>   */
>>  #define M_EVENT (KEY_MAX+1)
>> +
>> +#ifndef KEY_RESIZE
>> +#	define KEY_RESIZE 0632
>> +#endif

Solaris only has curses, not ncurses. Consider this a supreme hack.
In fact, menuconfig has some weird display errors still.

>> Index: linux-2.6.21-rc3/scripts/mod/file2alias.c
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/mod/file2alias.c	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/mod/file2alias.c	2007-03-07 23:41:23.772026000 +0100
>> @@ -32,6 +32,8 @@
>>  typedef uint32_t	__u32;
>>  typedef uint16_t	__u16;
>>  typedef unsigned char	__u8;
>> +typedef int32_t		__s32;
>> +typedef int16_t		__s16;
>>  
>>  /* Big exception to the "don't include kernel headers into userspace, which
>>   * even potentially has different endianness and word sizes, since

HAX.

>> Index: linux-2.6.21-rc3/scripts/mod/modpost.h
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/mod/modpost.h	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/mod/modpost.h	2007-03-07 23:37:01.315290000 +0100
>> @@ -41,6 +41,11 @@
>>  #define ELF_R_TYPE  ELF64_R_TYPE
>>  #endif
>>  
>> +#ifdef __sun__
>> +typedef uint16_t Elf32_Section;
>> +typedef uint16_t Elf64_Section;
>> +#endif
>> +
>>  /* The 64-bit MIPS ELF ABI uses an unusual reloc format. */
>>  typedef struct
>>  {

More HAX because Sol does not have them >:-(

>> Index: linux-2.6.21-rc3/scripts/mod/sumversion.c
>> ===================================================================
>> --- linux-2.6.21-rc3.orig/scripts/mod/sumversion.c	2007-03-07 05:41:20.000000000 +0100
>> +++ linux-2.6.21-rc3/scripts/mod/sumversion.c	2007-03-07 23:43:55.668334000 +0100
>> @@ -6,6 +6,7 @@
>>  #endif
>>  #include <ctype.h>
>>  #include <errno.h>
>> +#include <limits.h>
>>  #include <string.h>
>>  #include "modpost.h"
>>  

Valid hunk, should be applied (to get the PATH_MAX constant).

>> @@ -417,7 +418,8 @@
>>  	*end = '\0';
>>  
>>  	md4_init(&md);
>> -	while ((fname = strsep(&sources, " ")) != NULL) {
>> +	for(fname = strtok(sources, " "); fname != NULL;
>> +	  fname = strtok(NULL, " ")) {
>>  		if (!*fname)
>>  			continue;
>>  		if (!parse_source_files(fname, &md))
>> #<EOF>

See thread debate as to whether to keep strsep or use
strtok, since strtok is not thread-safe, and strtok_r
is a GNUism unlikely to be available in Solaris either.


Jan
-- 
