Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXFANwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXFANwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbXFANw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:52:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:41266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757616AbXFANw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:52:26 -0400
Subject: Re: [PATCH] ACPI Debug - for test, devel and possibly even for
	production kernels
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi
In-Reply-To: <200705311249.12762.lenb@kernel.org>
References: <1180624839.10908.71.camel@queen.suse.de>
	 <200705311249.12762.lenb@kernel.org>
Content-Type: multipart/mixed; boundary="=-b+rTRGIFql4G/kuUmF+s"
Organization: Novell/SUSE
Date: Fri, 01 Jun 2007 15:52:24 +0200
Message-Id: <1180705944.10908.184.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b+rTRGIFql4G/kuUmF+s
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-05-31 at 12:49 -0400, Len Brown wrote:
> The name of this patch is really "split ACPI function tracing
> out of CONFIG_ACPI_DEBUG to a new Kconfig build option"
> 
> I agree that tracing should be its own build option.

Thanks.

> I don't agree that enabling CONFIG_ACPI_DEBUG by default
> is what you want to do in a production kernel, but that
> isn't what this patch does, and I'm not going to stand
> in your way if you want to ship debug kernels by default.

I don't see significant negative impact.
I consider it much worse that on several HP models fan control is messed
up (to at least kernel .21, after suspend fan is gone for sure, possibly
already before), there are also fan breakage reports for FSCs.
These are only the worst, really sever kind of bugs... 

I hope that bugs like e.g.:
http://bugzilla.kernel.org/show_bug.cgi?id=7122
99 comments, already takes over half a year (still no working fan?)
http://bugzilla.kernel.org/show_bug.cgi?id=5534
211 comments, opened in Nov, final patches submitted in Feb 2007 - (ok
that was a tricky one with several patch approaches, still...)

end up with less question-answer posts and can be processed/solved much
faster.

Second point is to get more people on the boot, starting to work on
ACPI. People can identify bugs (kernel or BIOS misbehavior) by simply
understanding a bit ASL and by examining the debug output, no deep
kernel knowledge is really needed (unfortunately some people with deep
kernel knowledge don't want to touch ACPI parts at all, maybe some of
these guys then see that the interpreter itself isn't working that
bad...).
If we get bug reports like: My battery is not working, and I found out
that in line 42 of my DSDT a ACPI func returns a real strange value,
that's much more worth than 5, 10 or (IMO) even 100 ms of boot time.

> > we only make use of a small subset of current ACPI tables.
> > ACPI spreads more and more over different parts of the kernel and it's
> > likely that this will hold on.
> 
> There are two types of "ACPI tables", those with contents defined by
> the ACPI spec, and those where ACPI is just acting as the "envelope"
> to deliver a table from another spec to the OS.
> 
> We already use all the tables defined by the ACPI spec.
> It is unlikely that this patch will have any effect on the "envelope" tables.

I mean the ASL tables DSDT and SSDTs (not the enveloped, static once).
Vendor (or laptop model/series) specific ACPI devices are flying around.
Fortunately we got some support by the merged asus, thinkpad, toshiba
and sony ACPI drivers. But there is still a lot to improve and new
models come out every week... A big challenge could also be the move
from the proprietary ACPI to the video ACPI spec funcs...
Some define extra fan/temp control (these breaking with hwmon tools and
legacy i2c/smbus drivers) ACPI functions which we do not use. There are
WMI ACPI funcs and so on.
It's just a very rough guess, but I expect we make use of about 30-70
percent of the ACPI (AML) code provided by the BIOS (hard to guess which
are used or unused helper functions..). It's appreciated that Intel
helps to implement the spec stuff, but for full support more work and
more people working on it are needed...

> So I don't think you're going to see growing utility of CONFIG_ACPI_DEBUG
> over time, you're going to see what it does immediately.

> > ACPI_DEBUG=y is a powerful debug facility, that can ease up bug
> > communication with less (ACPI) experienced bug submitters and can shed
> > some light behind ACPI magic.
> > 
> > I've done some measurements and found out that most of the performance
> > costs are due the function tracing support in the ACPICA debug
> > subsystem.
> > 
> > This patch offers the possibility to compile out ACPI function tracing
> > support which is of none use for ordinary kernel debugging (is only used
> > for Intel internal debugging AFAIK), but takes most of the performance
> > costs.
> 
> I agree that function tracing is never used by people who can't build a kernel --
> and so it is fine to make it an additional build option.
> 
> > (This should efficiently be the same as the proposed big patch a year
> > ago from Pekka Enberg, just a bit smaller and should make ACPICA and
> > kernel/linux people happy:
> > http://marc.info/?l=linux-kernel&m=113699535303722&w=2
> > )
> > 
> > 
> > Kernel image size (compiled on x86_64):
> > Full acpi debug:
> > 1618277 bytes (+3.1%, +48k)
> > acpi debug function trace compiled out:
> > 1605359 bytes (+2.3%, +35k)
> > acpi debug not compiled in at all
> > 1569803 bytes (100%)
> > 
> > 
> > Speed measures on one specific machine (x86_64, laptop):
> > 
> > A) ACPI_DEBUG compiled in
> > B) ACPI_DEBUG compiled in, but Function trace compiled out
> > C) ACPI_DEBUG compiled out
> > D) ACPI_DEBUG compiled out (control run)
> > 
> > The time has been taken at following functions:
> > 
> > 1) drivers/acpi/bus.c:acpi_early_init (load tables and initialize
> >                                        ACPI namespace)
> > 2) drivers/acpi/bus.c:acpi_init (some more initialisation
> >                                  -> enable ACPI HW mode
> >                                  -> read PIC/APIC table, ...)
> > 3) drivers/acpi/scan.c:scan_init (Enumerate devices in the
> >                                   ACPI namespace)
> > 
> > register driver for acpi drivers:
> > 4)  ec
> > 5)  pci_root
> > 6)  pci_link
> > 
> > -----------------------------------------------------------------------
> >   |      A         |       B        |       C        |     D          | 
> > -----------------------------------------------------------------------
> > 1 | 434711 (+1.0%) | 432652 (+0.4%) |  430522 (100%) |  430512 (-0.00%)
> > -----------------------------------------------------------------------
> > 2 |  69156 (+3.7%) |  67007 (+0.4%) |   66696 (100%) |   66703 (+0.01%)
> > -----------------------------------------------------------------------
> > 3 |   8769(+63.3%) |   7363(+37.1%) |    5369 (100%) |    5369 ( 0.00%)
> > -----------------------------------------------------------------------
> 
> 37% sounds like a lot.
Yes, it looks like a side effect, that on very short taking
measurements, the debug time increase is that much, but I don't know for
sure.
I'd have expected more time increase for the whole namespace parsing
where millions of function trace or other debug statements could get
checked, but this came out to be not that much (even much better without
function trace). So I doubt the time increase for the short time taking
measurements are true or it's for some reason only for short taking
functions. If I find some time I check that again on a bigger Itanium
with some ten thousand lines of ASL, if it's fast enough it should be
fine...

> The ACPI interpreter is not supposed to be in performace critical sections,
> but at the same time, it isn't supposed to be a pig either.
> 
> > 4 |  15999 (+0.7%) |  15950 (+0.4%) |   15879 (100%) |   15878 (-0.01%)
> > -----------------------------------------------------------------------
> > 5 |   9492(+75.4%) |   7657(+41.5%) |    5411 (100%) |    5405 (-0.11%)
> > -----------------------------------------------------------------------
> > 6 |   1717(+64.0%) |   1494(+42.6%) |    1047 (100%) |    1046 (-0.10%)
> > -----------------------------------------------------------------------
> > All measured values are in us. TSC was used to obtain the values.
> > do_gettimeofday did only provide valid values after hpet got setup
> > (after pci_link).
> > 
> > I wonder why only the short time taking measures show that extreme
> > performance loss, maybe someone has an idea. However if you summarize
> > all additional time with ACPI_DEBUG without function trace, you get
> > about +5 ms boot time (which may vary from machine to machine...).
> > This should be acceptable for test and develop kernels.
> > If nothing bad happens in Beta phase I'd like to include this one into
> > the final OpenSUSE kernel to get detailed bug reports.
> > It would be great if others with their latest test/devel kernels follow,
> > so that even ordinary users can easily provide essential, detailed debug
> > information easily(e.g. Linus' Compaq and Andrew's Vaio are well known
> > on the acpi list, others do not have the luck to get that much of
> > support and they do not have the knowledge to compile kernel and so
> > on...).
> > 
> > I can also add a file "Documentation/acpi_debug" and add some debug
> > hints if this one gets accepted...
> > 
> > This one should not be really dangerous. If the patch is ok, can Len
> > still merge this in .22 time?
> 
> .22 after -rc3?  No.  I don't see a problem with a final version
> shipping in .23, however.
The only wanted changes are comments, right?
This could already be in your tree for three weeks.
Ok, may just have gone under,
looking forward to see this in your test tree then.

> > If not, can you take it for some testing, Andrew?
> 
> It would be better for andrew to get it through acpi-test.
> 
> I'll be happy to include an updated version of this patch there.
> 
> Note that the testing that it is going to get will be small:
> 
> 1. people who don't enable CONFIG_ACPI_DEBUG
> 	no change
> 2. people who enable CONFIG_ACPI_DEBUG
> 	will lose function tracing if they don't ask for it
> 	will lose AML Debug-object messages unless they
> 		set the flag to get them back.
> 
> > Thanks,
> > 
> >    Thomas
> > 
> > 
> > 
> > Split ACPI_DEBUG into function trace enabled and not enabled.
> > 
> > Function trace is most of the ACPI_DEBUG costs, but is
> > not much of use for kernel ACPI debugging.
> > 
> > Size of kernel image increased on test compile:
> > + 48k  (Full ACPI_DEBUG)
> > + 35k  (ACPI_DEBUG with function trace compiled out)
> > 
> > Performance without function trace is also much better.
> > 
> > Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
> > a lot vendors let Store (value, debug) in their code and this
> > might confuse users when it pops up in syslog.
> 
> This, is an incompatible change, as one of the benefits of
> CONFIG_ACPI_DEBUG is to get the AML debug-object messages.
> After this patch, those will silently go away.
> 
> The patch needs to document the boot-time flag to make
> those messages come back.
Hm, who makes use of the store(xy, debug) functionality knows what he's
doing and should know where to enable it?
-> Mentioned the option in the patch.

> 
> > ---
> >  drivers/acpi/Kconfig    |    8 ++++++++
> >  include/acpi/acmacros.h |   23 +++++++++++++++++++++++
> >  include/acpi/acoutput.h |    4 ++--
> >  3 files changed, 33 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
> > +++ linux-2.6.22-rc3/drivers/acpi/Kconfig
> > @@ -280,6 +280,14 @@ config ACPI_DEBUG
> >  	  of verbosity. Saying Y enables these statements. This will increase
> >  	  your kernel size by around 50K.
> >  
> > +config ACPI_DEBUG_FUNC_TRACE
> > +	bool "Additionally enable ACPI function tracing"
> > +	default n
> > +	depends on ACPI_DEBUG
> > +	help
> > +	  ACPI Debug Statements slow down ACPI processing. Function trace
> > +	  is about half of the penalty and is rarely useful.
> 
> help text needs update -- it should say what tracing does,
> not if SuSE customers frequently use it or not...
The text is not perfect... -> corrected.
> 
> >  config ACPI_EC
> >  	bool
> >  	default y
> > Index: linux-2.6.22-rc3/include/acpi/acmacros.h
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
> > +++ linux-2.6.22-rc3/include/acpi/acmacros.h
> > @@ -486,6 +486,8 @@
> >  #define ACPI_FUNCTION_NAME(name)
> >  #endif
> >  
> > +#ifdef DEBUG_FUNC_TRACE
> > +
> >  #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
> >  			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
> >  #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
> > @@ -563,6 +565,27 @@
> >  
> >  #endif				/* ACPI_SIMPLE_RETURN_MACROS */
> >  
> > +#else /* !DEBUG_FUNC_TRACE */
> > +
> > +#define ACPI_FUNCTION_TRACE(a)
> > +#define ACPI_FUNCTION_TRACE_PTR(a,b)
> > +#define ACPI_FUNCTION_TRACE_U32(a,b)
> > +#define ACPI_FUNCTION_TRACE_STR(a,b)
> > +#define ACPI_FUNCTION_EXIT
> > +#define ACPI_FUNCTION_STATUS_EXIT(s)
> > +#define ACPI_FUNCTION_VALUE_EXIT(s)
> > +#define ACPI_FUNCTION_TRACE(a)
> > +#define ACPI_FUNCTION_ENTRY()
> > +
> > +#define return_VOID                     return
> > +#define return_ACPI_STATUS(s)           return(s)
> > +#define return_VALUE(s)                 return(s)
> > +#define return_UINT8(s)                 return(s)
> > +#define return_UINT32(s)                return(s)
> > +#define return_PTR(s)                   return(s)
> > +
> > +#endif /* DEBUG_FUNC_TRACE */
> 
> These non-defines already appear later in the file.
> Perhaps you can use an expression to make them appear just once instead of twice?
Good idea. But this does not work because you'd need a kind of curly
braces functionality for pre-processor conditionals.

> 
> >  /* Conditional execution */
> >  
> >  #define ACPI_DEBUG_EXEC(a)              a
> > Index: linux-2.6.22-rc3/include/acpi/acoutput.h
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
> > +++ linux-2.6.22-rc3/include/acpi/acoutput.h
> > @@ -178,8 +178,8 @@
> >  
> >  /* Defaults for debug_level, debug and normal */
> >  
> > -#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
> > -#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
> > +#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
> > +#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
> >  #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
> >  
> >  #endif				/* __ACOUTPUT_H__ */
> > 

Thanks,

   Thomas


Split ACPI_DEBUG function trace into its own compile option.

Function trace is most of the ACPI_DEBUG costs, but is
not much of use for kernel ACPI debugging.

Size of kernel image increased on test compile:
+ 48k  (Full ACPI_DEBUG)
+ 35k  (ACPI_DEBUG with function trace compiled out)

Performance without function trace is also much better.

Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
a lot vendors let Store (value, debug) in their code and this
might confuse users when it pops up in syslog.
That means, if you make use of your own, overridden DSDT and
store things to the debug object, you need to explicitly add the
debug_object flag to the boot param acpi.debug_level=
or enable it at runtime in the corresponding /sys/ file.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/Kconfig    |   13 ++++++++++++-
 include/acpi/acmacros.h |   23 +++++++++++++++++++++++
 include/acpi/acoutput.h |    4 ++--
 3 files changed, 37 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
+++ linux-2.6.22-rc3/drivers/acpi/Kconfig
@@ -278,7 +278,18 @@ config ACPI_DEBUG
 	help
 	  The ACPI driver can optionally report errors with a great deal
 	  of verbosity. Saying Y enables these statements. This will increase
-	  your kernel size by around 50K.
+	  your kernel size by around 35K.
+
+config ACPI_DEBUG_FUNC_TRACE
+	bool "Additionally enable ACPI function tracing"
+	default n
+	depends on ACPI_DEBUG
+	help
+	  This will increase your kernel size by another 15K.
+	  ACPI function tracing log the invoked ACPICA subsystem functions
+	  in syslog (still needs to be enabled via acpi.debug_level= mask).
+	  This significantly slows down ACPI code processing, only enable it
+	  if you know what you are doing.
 
 config ACPI_EC
 	bool
Index: linux-2.6.22-rc3/include/acpi/acmacros.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
+++ linux-2.6.22-rc3/include/acpi/acmacros.h
@@ -486,6 +486,8 @@
 #define ACPI_FUNCTION_NAME(name)
 #endif
 
+#ifdef DEBUG_FUNC_TRACE
+
 #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
 			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
 #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
@@ -563,6 +565,27 @@
 
 #endif				/* ACPI_SIMPLE_RETURN_MACROS */
 
+#else /* !DEBUG_FUNC_TRACE */
+
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)
+#define ACPI_FUNCTION_TRACE_U32(a,b)
+#define ACPI_FUNCTION_TRACE_STR(a,b)
+#define ACPI_FUNCTION_EXIT
+#define ACPI_FUNCTION_STATUS_EXIT(s)
+#define ACPI_FUNCTION_VALUE_EXIT(s)
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_ENTRY()
+
+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)
+#define return_UINT32(s)                return(s)
+#define return_PTR(s)                   return(s)
+
+#endif /* DEBUG_FUNC_TRACE */
+
 /* Conditional execution */
 
 #define ACPI_DEBUG_EXEC(a)              a
Index: linux-2.6.22-rc3/include/acpi/acoutput.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
+++ linux-2.6.22-rc3/include/acpi/acoutput.h
@@ -178,8 +178,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #endif				/* __ACOUTPUT_H__ */


Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
a lot vendors let Store (value, debug) in their code and this
might confuse users when it pops up in syslog.

---
 drivers/acpi/Kconfig    |    8 ++++++++
 include/acpi/acmacros.h |   23 +++++++++++++++++++++++
 include/acpi/acoutput.h |    4 ++--
 3 files changed, 33 insertions(+), 2 deletions(-)

Index: linux-2.6.21/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.21.orig/drivers/acpi/Kconfig
+++ linux-2.6.21/drivers/acpi/Kconfig
@@ -346,6 +346,14 @@ config ACPI_DEBUG
 	  of verbosity. Saying Y enables these statements. This will increase
 	  your kernel size by around 50K.
 
+config ACPI_DEBUG_FUNC_TRACE
+	bool "Additionally enable ACPI function tracing"
+	default n
+	depends on ACPI_DEBUG
+	help
+	  ACPI Debug Statements slow down ACPI processing. Function trace
+	  is about half of the penalty and is rarely useful.
+
 config ACPI_EC
 	bool
 	default y
Index: linux-2.6.21/include/acpi/acmacros.h
===================================================================
--- linux-2.6.21.orig/include/acpi/acmacros.h
+++ linux-2.6.21/include/acpi/acmacros.h
@@ -486,6 +486,8 @@
 #define ACPI_FUNCTION_NAME(name)
 #endif
 
+#ifdef DEBUG_FUNC_TRACE
+
 #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
 			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
 #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
@@ -563,6 +565,27 @@
 
 #endif				/* ACPI_SIMPLE_RETURN_MACROS */
 
+#else /* !DEBUG_FUNC_TRACE */
+
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)
+#define ACPI_FUNCTION_TRACE_U32(a,b)
+#define ACPI_FUNCTION_TRACE_STR(a,b)
+#define ACPI_FUNCTION_EXIT
+#define ACPI_FUNCTION_STATUS_EXIT(s)
+#define ACPI_FUNCTION_VALUE_EXIT(s)
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_ENTRY()
+
+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)
+#define return_UINT32(s)                return(s)
+#define return_PTR(s)                   return(s)
+
+#endif /* DEBUG_FUNC_TRACE */
+
 /* Conditional execution */
 
 #define ACPI_DEBUG_EXEC(a)              a
Index: linux-2.6.21/include/acpi/acoutput.h
===================================================================
--- linux-2.6.21.orig/include/acpi/acoutput.h
+++ linux-2.6.21/include/acpi/acoutput.h
@@ -178,8 +178,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #endif				/* __ACOUTPUT_H__ */


--=-b+rTRGIFql4G/kuUmF+s
Content-Disposition: attachment; filename=acpi_split_out_debug_function_trace.patch
Content-Type: text/x-patch; name=acpi_split_out_debug_function_trace.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Split ACPI_DEBUG function trace into its own compile option.

Function trace is most of the ACPI_DEBUG costs, but is
not much of use for kernel ACPI debugging.

Size of kernel image increased on test compile:
+ 48k  (Full ACPI_DEBUG)
+ 35k  (ACPI_DEBUG with function trace compiled out)

Performance without function trace is also much better.

Also remove ACPI_LV_DEBUG_OBJECT from default debug level as
a lot vendors let Store (value, debug) in their code and this
might confuse users when it pops up in syslog.
If you make use of your own, overridden DSDT and store things
to the debug object, you need to explicitly add the
debug_object flag to the boot param acpi.debug_level=
or enable it at runtime in the corresponding /sys/ file.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/Kconfig    |   13 ++++++++++++-
 include/acpi/acmacros.h |   23 +++++++++++++++++++++++
 include/acpi/acoutput.h |    4 ++--
 3 files changed, 37 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc3/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/drivers/acpi/Kconfig
+++ linux-2.6.22-rc3/drivers/acpi/Kconfig
@@ -278,7 +278,18 @@ config ACPI_DEBUG
 	help
 	  The ACPI driver can optionally report errors with a great deal
 	  of verbosity. Saying Y enables these statements. This will increase
-	  your kernel size by around 50K.
+	  your kernel size by around 35K.
+
+config ACPI_DEBUG_FUNC_TRACE
+	bool "Additionally enable ACPI function tracing"
+	default n
+	depends on ACPI_DEBUG
+	help
+	  This will increase your kernel size by another 15K.
+	  ACPI function tracing log the invoked ACPICA subsystem functions
+	  in syslog (still needs to be enabled via acpi.debug_level= mask).
+	  This significantly slows down ACPI code processing, only enable it
+	  if you know what you are doing.
 
 config ACPI_EC
 	bool
Index: linux-2.6.22-rc3/include/acpi/acmacros.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acmacros.h
+++ linux-2.6.22-rc3/include/acpi/acmacros.h
@@ -486,6 +486,8 @@
 #define ACPI_FUNCTION_NAME(name)
 #endif
 
+#ifdef DEBUG_FUNC_TRACE
+
 #define ACPI_FUNCTION_TRACE(a)          ACPI_FUNCTION_NAME(a) \
 			  acpi_ut_trace(ACPI_DEBUG_PARAMETERS)
 #define ACPI_FUNCTION_TRACE_PTR(a,b)    ACPI_FUNCTION_NAME(a) \
@@ -563,6 +565,27 @@
 
 #endif				/* ACPI_SIMPLE_RETURN_MACROS */
 
+#else /* !DEBUG_FUNC_TRACE */
+
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)
+#define ACPI_FUNCTION_TRACE_U32(a,b)
+#define ACPI_FUNCTION_TRACE_STR(a,b)
+#define ACPI_FUNCTION_EXIT
+#define ACPI_FUNCTION_STATUS_EXIT(s)
+#define ACPI_FUNCTION_VALUE_EXIT(s)
+#define ACPI_FUNCTION_TRACE(a)
+#define ACPI_FUNCTION_ENTRY()
+
+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)
+#define return_UINT32(s)                return(s)
+#define return_PTR(s)                   return(s)
+
+#endif /* DEBUG_FUNC_TRACE */
+
 /* Conditional execution */
 
 #define ACPI_DEBUG_EXEC(a)              a
Index: linux-2.6.22-rc3/include/acpi/acoutput.h
===================================================================
--- linux-2.6.22-rc3.orig/include/acpi/acoutput.h
+++ linux-2.6.22-rc3/include/acpi/acoutput.h
@@ -178,8 +178,8 @@
 
 /* Defaults for debug_level, debug and normal */
 
-#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
-#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR | ACPI_LV_DEBUG_OBJECT)
+#define ACPI_DEBUG_DEFAULT          (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
+#define ACPI_NORMAL_DEFAULT         (ACPI_LV_INIT | ACPI_LV_WARN | ACPI_LV_ERROR)
 #define ACPI_DEBUG_ALL              (ACPI_LV_AML_DISASSEMBLE | ACPI_LV_ALL_EXCEPTIONS | ACPI_LV_ALL)
 
 #endif				/* __ACOUTPUT_H__ */

--=-b+rTRGIFql4G/kuUmF+s--

