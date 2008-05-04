Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbYEDHcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbYEDHcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYEDHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:32:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42490 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYEDHci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:32:38 -0400
Date: Sun, 4 May 2008 09:33:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Timur Tabi <timur@tabi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mconf.c and bindtextdomain() -- warnings while cross-compiling on OS X
Message-ID: <20080504073313.GA16259@uranus.ravnborg.org>
References: <481D344C.9080904@tabi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481D344C.9080904@tabi.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 10:58:04PM -0500, Timur Tabi wrote:
> I'm cross-compiling the kernel on an OS X system, and when I run "make 
> menuconfig", I get this warning:
> 
>   HOSTCC  scripts/kconfig/mconf.o
> scripts/kconfig/mconf.c: In function ‘main’:
> scripts/kconfig/mconf.c:871: warning: statement with no effect
> scripts/kconfig/mconf.c:872: warning: statement with no effect
> 
> Here is the code in question:
> 
> int main(int ac, char **av)
> {
> 	int saved_x, saved_y;
> 	char *mode;
> 	int res;
> 
> 	setlocale(LC_ALL, "");
> 	bindtextdomain(PACKAGE, LOCALEDIR);  <--- line 871
> 	textdomain(PACKAGE);
> 
> I believe the warnings are from this code in lkc.h:
> 
> #ifndef KBUILD_NO_NLS
> # include <libintl.h>
> #else
> # define gettext(Msgid) ((const char *) (Msgid))
> # define textdomain(Domainname) ((const char *) (Domainname))
> # define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
> #endif
> 
> Can someone explain to me why this macros are defined in this way? Every 
> place where textdomain() and bindtext() are used, they are used like this:
> 
> 	bindtextdomain(PACKAGE, LOCALEDIR);
> 	textdomain(PACKAGE);
> 
> In other words, the return value from these macros is never used, so the 
> warning is inevitable.
> 
> I think the code in lkc.h should be changed to:
> 
> # define textdomain(Domainname) do {} while(0)
> # define bindtextdomain(Domainname, Dirname) do {} while(0)
> 
> I can't say for certain whether this is a good idea, though, because I'm 
> not at all familiar with this code.

I have queued up following patch. It is obviously correct and builds without
warnings here. Can you give it a try on your box.

	Sam

diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4bc68f2..1a728fc 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -11,9 +11,9 @@
 #ifndef KBUILD_NO_NLS
 # include <libintl.h>
 #else
-# define gettext(Msgid) ((const char *) (Msgid))
-# define textdomain(Domainname) ((const char *) (Domainname))
-# define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
+static inline void const char *gettext(const char *txt) { return txt; }
+static inline void textdomain(const char *domainname) {}
+static inline void bindtextdomain(const char *name, const char *dir) {}
 #endif
 
 #ifdef __cplusplus
