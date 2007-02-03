Return-Path: <linux-kernel-owner+w=401wt.eu-S1423145AbXBCLen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423145AbXBCLen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423199AbXBCLen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:34:43 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:50748 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423145AbXBCLem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:34:42 -0500
Date: Sat, 3 Feb 2007 12:32:08 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string
 termination trick
In-Reply-To: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
Message-ID: <Pine.LNX.4.61.0702031213220.27840@yvahk01.tjqt.qr>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 3 2007 03:08, Bodo Eggert wrote:
>
>This patch changes the module license handling code to:
>- allow modules to have multiple licenses
>- access GPL symbols if at least one license is GPL-compatible

I strongly nak that. If you combine two object files (e.g. foo.o, bar.o)
that have different licenses, the resulting object file (comb.o) IMHO
constitutes a combined work, and hence the GPL should be applied to all of
it. That obviously "does not work" - what good is a GPL comb.o file if you
don't have the source to bar.o? I think a module (.ko) should be denied
access to GPL symbols if any of the MODULE_LICENSE()s are not GPL.
Otherwise, ndiswrapper, CiscoVPN, etc. would just add a dummy.c GPL file
with a MODULE_LICENSE("GPL") in there and get the symbols. Though you
could still get at the GPL symbols by use of a dedicated wrapper (think
nvidia kernel module), I would not want to make it easier for them by
allowing your two points. At best, foo.o and bar.o should be compiled
independently to foo.ko and bar.ko and work with EXPORT_SYMBOLs.

>- prevent the "GPL\0 for nothing"-trick
>- fix an off-by-one buffer overflow
>  (exploitable only if the attacker can load modules)
>- move the ndiswrapper check into the new license checking routine
>
>Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
>---
>
>The license handling code was kind of strange:
> - The kernel itself would only consider the first license, while modpost
>   looks at all of them.
> - If you offer your module under a non-GPL license in addition to GPL,
>   modpost would consider this module to be non-GPL. Therefore you can't
>   say MODULE_LICENSE("GPL");\nMODULE_LICENSE("completely free");

The idea to allow MODULE_LICENSE("GPL");\nMODULE_LICENSE("Public Domain");
is good, but how would you interpret an .o file (with no source!) with
MODULE_LICENSE("GPL");\nMODULE_LICENSE("Proprietary") ? (Well, see above)

>Prohibiting the \0-trick is done by storing the length of the license
>behind the license itself, uuencoded, as $=xyz.
>
>Currently, only 18 bits (256 KB) of the length are stored, but storing up
>to 30 bits is possible without changing anything besides the macro.
>
>You can still trick this code by including "...\0license=GPL\0$=$\0..." or
>by manually fabricating this string into .modinfo. Fix: Document this to
>mean that you actually GPL-license the module. 

$=$ is interpreted as what? [Ah ok, uuencoded uint32_t] That does not look
good. What if the length thing does not immediately come after the license
string? (E.g. someone hand-crafted a .ko)

>TODO: get_modinfo: make sure the value returned does not exceed the end of 
>      the buffer.
>
>diff -X dontdiff -pruN 2.6.19/include/linux/license.h 2.6.19.license/include/linux/license.h
>--- 2.6.19/include/linux/license.h	2006-11-29 22:57:37.000000000 +0100
>+++ 2.6.19.license/include/linux/license.h	2007-02-02 18:30:44.000000000 +0100
>@@ -1,14 +1,27 @@
> #ifndef __LICENSE_H
> #define __LICENSE_H
> 
>-static inline int license_is_gpl_compatible(const char *license)
>+static inline int license_is_gpl_compatible(const char *license,
>+                                            int length)
> {
>-	return (strcmp(license, "GPL") == 0
>-		|| strcmp(license, "GPL v2") == 0
>-		|| strcmp(license, "GPL and additional rights") == 0
>-		|| strcmp(license, "Dual BSD/GPL") == 0
>-		|| strcmp(license, "Dual MIT/GPL") == 0
>-		|| strcmp(license, "Dual MPL/GPL") == 0);
>+	static char *gpl_compatible[] = {

static const char *const gpl_compatible[];

>+	    "GPL",
>+		"GPL v2",
>+		"GPL and additional rights",
>+		"Dual BSD/GPL",
>+		"Dual MIT/GPL",
>+		"Dual MPL/GPL",

If we allowed multiple MODULE_LICENSE()s, all the Dual XYZ/GPL
combinations and so can go, since it would be possible to have
MODULE_LICENSE("GPL")\nMODULE_LICENSE("BSD");, simplifying the
module loader code.

>+extern void do_get_next_modinfo_len(struct pstring_len *ret,
>+                                    char * start,
>+                                    unsigned long size,
>+                                    const char *tag);

"char * t" vs "char *t", also elsewhere.

>+	/* We'll consider the kernel to be tainted by ndiswrapper
>+	 * & co., since they'll usurally load proprietary code */

usually



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
