Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZKEOYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZKEOYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZKEOYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:24:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43474 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbZKEOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:24:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lfmpTu3Yv2VAdg5wohNbo32/ywqYKQGvJ6VYM5Tvu+1jWVcEUgXGXjd26aDqKFlbSm
         obKgYkyNWXEA7MgIgo4wIKRARnjDDma0L/GCJ43s0nPi96zSBpdFpTbkWRFkQsnD/61J
         78hrE5FzYUKsmrpWjsFWTSx+UlHrNHJ5gfFNc=
Message-ID: <4AF2E00A.3010107@tuffmail.co.uk>
Date: Thu, 05 Nov 2009 14:24:10 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier.adi@gmail.com>
CC: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk> <200911041849.43311.rusty@rustcorp.com.au> <4AF150D2.6000207@tuffmail.co.uk> <20091104171916.GA6323@merkur.ravnborg.org>
In-Reply-To: <20091104171916.GA6323@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, Nov 04, 2009 at 10:00:50AM +0000, Alan Jenkins wrote:
>   
>> Rusty Russell wrote:
>>     
>>> On Tue, 3 Nov 2009 08:36:17 pm Alan Jenkins wrote:
>>>   
>>>       
>>>> +/*
>>>> + * We use CPP macros since they are more familiar than assembly macros.
>>>> + * Note that CPP macros eat newlines, so each statement must be terminated
>>>> + * by a semicolon.
>>>> + */
>>>> +
>>>> +#ifdef CONFIG_HAVE_SYMBOL_PREFIX
>>>> +#define __SYM(sym) _##sym
>>>> +#else
>>>> +#define __SYM(sym) sym
>>>> +#endif
>>>>     
>>>>         
>>> Ideally, you would used MODULE_SYMBOL_PREFIX here, but of course it's a
>>> string.  I don't think Kconfig can do arbitrary identifiers, so we can't
>>> make CONFIG_SYMBOL_PREFIX empty or _.
>>>
>>> Perhaps clarify it to a bool CONFIG_HAVE_MODULE_UNDERSCORE_PREFIX then,
>>> since that's what you're assuming here?
>>>
>>> Thanks,
>>> Rusty.
>>>       
>> I made the same assumption in patch 4.  The arch defines  
>> CONFIG_HAVE_SYMBOL_PREFIX, which then causes init/Kconfig to define  
>> CONFIG_SYMBOL_PREFIX="_".
>>
>> Mike suggested that I hack kbuild instead, to do something like
>>
>> unquote = ...
>> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(unquote CONFIG_SYMBOL_PREFIX)
>>
>> I'm experimenting with the idea, but I haven't managed to get it working  
>>     
>
> Something like this:
> unquote = $(patsubst "%",%,$($1))
>
> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(call unquote,CONFIG_SYMBOL_PREFIX)
>
> But the readability is low so we could be better off doing it direct:
>
> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(patsubst "%",",$(CONFIG_SYMBOL_PREFIX))
>
> 	Sam
>   

Thanks to both of you, I have something that works now. 

Unfortunately I had to export the variable AFLAGS_.tmp_export-asm.o, 
otherwise it had no effect.  I assume it's a limitation of the top-level 
Makefile. 

To make SYMBOL_PREFIX available for linker scripts, I also added it to 
"cpp_flags" in scripts/Makefile.lib.  (As far as I can see, cpp_flags is 
_only_ used for preprocessing linker scripts).

If this is all getting too brittle, I guess I could be less timid and 
add it to  the global KBUILD_CPPFLAGS instead :).

Here's the incremental diff:

diff --git a/Makefile b/Makefile
index d7e4ed9..dfd672b 100644
--- a/Makefile
+++ b/Makefile
@@ -912,6 +912,11 @@ vmlinux.o: $(modpost-init) $(vmlinux-main) FORCE
 # when loading modules.
 .tmp_exports-asm.S: vmlinux.o
 
+ifneq ($(CONFIG_SYMBOL_PREFIX),)
+export AFLAGS_.tmp_exports-asm.o += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
+
+
 # The actual objects are generated when descending, 
 # make sure no implicit rule kicks in
 $(sort $(vmlinux-init) $(vmlinux-main)) $(vmlinux-lds): $(vmlinux-dirs) ;
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 6c99419..1983662 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -5,6 +5,10 @@
 
 mainmenu "Blackfin Kernel Configuration"
 
+config SYMBOL_PREFIX
+	string
+	default "_"
+
 config MMU
 	def_bool n
 
@@ -26,7 +30,6 @@ config BLACKFIN
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
 	select HAVE_OPROFILE
-	select HAVE_SYMBOL_PREFIX
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
 config GENERIC_BUG
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index ffd90fb..1f585e8 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -27,8 +27,6 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-#define VMLINUX_SYMBOL(_sym_) _##_sym_
-
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/mem_map.h>
 #include <asm/page.h>
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index cc03bbf..53cc669 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -9,7 +9,10 @@ config H8300
 	bool
 	default y
 	select HAVE_IDE
-	select HAVE_SYMBOL_PREFIX
+
+config SYMBOL_PREFIX
+	string
+	default "_"
 
 config MMU
 	bool
diff --git a/arch/h8300/kernel/vmlinux.lds.S b/arch/h8300/kernel/vmlinux.lds.S
index b9e2490..03d356d 100644
--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -1,4 +1,3 @@
-#define VMLINUX_SYMBOL(_sym_) _##_sym_
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 9feb474..4a0e9b2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -52,10 +52,15 @@
 #define LOAD_OFFSET 0
 #endif
 
-#ifndef VMLINUX_SYMBOL
-#define VMLINUX_SYMBOL(_sym_) _sym_
+#ifndef SYMBOL_PREFIX
+#define VMLINUX_SYMBOL(sym) sym
+#else
+#define PASTE2(x,y) x##y
+#define PASTE(x,y) PASTE2(x,y)
+#define VMLINUX_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
 #endif
 
+
 /* Align . to a 8 byte boundary equals to maximum function alignment. */
 #define ALIGN_FUNCTION()  . = ALIGN(8)
 
diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
index 3bb14e9..f694ff5 100644
--- a/include/linux/mod_export.h
+++ b/include/linux/mod_export.h
@@ -18,7 +18,11 @@
 #endif
 
 /* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
 #define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define MODULE_SYMBOL_PREFIX ""
+#endif
 
 
 #ifndef __GENKSYMS__
@@ -98,14 +102,14 @@ struct kernel_symbol {
  * by a semicolon.
  */
 
-#ifdef CONFIG_HAVE_SYMBOL_PREFIX
-#define __SYM(sym) _##sym
+#ifndef SYMBOL_PREFIX
+#define SYM(sym) sym
 #else
-#define __SYM(sym) sym
+#define PASTE2(x,y) x##y
+#define PASTE(x,y) PASTE2(x,y)
+#define SYM(sym) PASTE(SYMBOL_PREFIX, sym)
 #endif
 
-#define SYM(sym) __SYM(sym)
-
 
 #ifdef CONFIG_MODVERSIONS
 #define __CRC_SYMBOL(sym, crcsec)				\
diff --git a/init/Kconfig b/init/Kconfig
index 7f4ddf6..bb4051c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1176,17 +1176,6 @@ config MODULE_SRCVERSION_ALL
 
 endif # MODULES
 
-config HAVE_SYMBOL_PREFIX
-	bool
-	help
-	  Some arch toolchains use a `_' prefix for all user symbols.
-	  This option will be taken into account when loading modules.
-
-config SYMBOL_PREFIX
-	string
-	default "_" if HAVE_SYMBOL_PREFIX
-	default ""
-
 config INIT_ALL_POSSIBLE
 	bool
 	help
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7a77787..f9f1f6c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -127,6 +127,11 @@ _c_flags += $(if $(patsubst n%,, \
 		$(CFLAGS_GCOV))
 endif
 
+ifdef CONFIG_SYMBOL_PREFIX
+_cpp_flags += -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
+endif
+
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 404b69a..b5a801d 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -19,7 +19,12 @@
 #include "../../include/linux/license.h"
 
 /* Some toolchains use a `_' prefix for all user symbols. */
+#ifdef CONFIG_SYMBOL_PREFIX
 #define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
+#else
+#define MODULE_SYMBOL_PREFIX ""
+#endif
+
 
 /* Are we using CONFIG_MODVERSIONS? */
 int modversions = 0;



