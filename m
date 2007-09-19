Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbXISTbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbXISTbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXISTbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:31:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54001 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXISTbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:31:43 -0400
Date: Wed, 19 Sep 2007 21:33:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Miles Lane <miles.lane@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.23-rc6-mm1
Message-ID: <20070919193308.GA4253@uranus.ravnborg.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <a44ae5cd0709180827w7156dc17q13853c3f2c127142@mail.gmail.com> <20070918191741.GA27725@uranus.ravnborg.org> <a44ae5cd0709181242j517e39e0xc3f78224bcda360a@mail.gmail.com> <20070918202654.GA27836@uranus.ravnborg.org> <46F05378.8020907@googlemail.com> <46F055BA.6000705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F055BA.6000705@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 12:48:26AM +0200, Gabriel C wrote:
> Gabriel C wrote:
> > Sam Ravnborg wrote:
> >> On Tue, Sep 18, 2007 at 03:42:58PM -0400, Miles Lane wrote:
> >>> On 9/18/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> >>>> Hi Miles.
> >>>> On Tue, Sep 18, 2007 at 11:27:23AM -0400, Miles Lane wrote:
> >>>>> Selecting Help for "Subarchitecture Type" causes "make menuconfig" to
> >>>>> crash, and the bash display settings have to be reset.
> >>>> Not reproduceable here.
> >>>> But I noticed that we pass a null pointer to a vsprintf function which
> >>>> in the cases you pointed out printed a (null) at my system.
> >>>> Could you plase try if attached patch fix your system.
> >>> Sorry, it still crashes.  I am running Ubuntu pre-6.10 (Gutsy -- the
> >>> development version of the distro).  Maybe I should try "make
> >>> mrproper" first?
> >> make mrproper should not do any difference here.
> >> I rather think you hit some ncurses bug.
> >>
> >> If you could add '-g' to HOSTCFLAGS in top-level Makefile
> >> and then do:
> >> rm scripts/kconfig/mconf.o scripts/kconfig/mconf
> >> make menuconfig
> >>
> >> (to build mconf and to check that the error is still reproduceable).
> >> And then run it in a debugger like this:
> >> gdb scripts/kconfig/mconf
> >> run arch/x86_64/Kconfig
> >>          ^^^^^^ replace with your actual arch
> >>
> >> Provoke the error and get a back-trace with 'bt'.
> > 
> > Hi Sam,
> > 
> > I can reproduce this bug on Frugalware Linux. 
> > 
> > Here the bt:
> > 
> > Program received signal SIGSEGV, Segmentation fault.                                                     
> > 0xb7dc4143 in strlen () from /lib/libc.so.6                                                                                                                                       
> > (gdb) bt                                                                                                                                                                          
> > #0  0xb7dc4143 in strlen () from /lib/libc.so.6                                                                                                                                   
> > #1  0x0804fd60 in str_append (gs=0xbfe4f6e8, s=0x0) at scripts/kconfig/util.c:87                                                                                                  
> > #2  0x0804e0cb in expr_print (e=0x8e22df8, fn=0x804fda0 <expr_print_gstr_helper>, data=0xbfe4f6e8, prevtoken=0) at scripts/kconfig/expr.c:1037                                    
> > #3  0x0804e1e7 in expr_gstr_print (e=0x8e22df8, gs=0xbfe4f6e8) at scripts/kconfig/expr.c:1099                                                                                     
> > #4  0x0804a07e in get_symbol_str (r=0xbfe4f6e8, sym=0x8b54ee8) at scripts/kconfig/mconf.c:334                                                                                     
> > #5  0x0804a363 in show_help (menu=0x8b54f88) at scripts/kconfig/mconf.c:738                                                                                                       
> > #6  0x0804acec in conf (menu=0x8b69480) at scripts/kconfig/mconf.c:781                                                                                                            
> > #7  0x0804a971 in conf (menu=0x8063c40) at scripts/kconfig/mconf.c:703                                                                                                            
> > #8  0x0804af8a in main (ac=Cannot access memory at address 0x0                                                                                                                    
> > ) at scripts/kconfig/mconf.c:917
> > 
> > 
> > Looks somewhat strange -> http://194.231.229.228/menuconfig.png
> > 
> > PS: Is without the patch you posted , I'll try with in a bit
> 
> The crash is still there but the (null)'s are all fixed by this patch.

Got it. We sometimes get a numm pointer when printing the expression (in expr.c).
I have queued following fix.

Thanks for reporting!

	Sam

Patch is copy'n'pased due to temporary setup troubles after upgradign to Gutsy.
Will be at kbuil.git in a few minutes.

>From 69d39ec036b4fca541efc3c9ee31ec65d6b95bd4 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 19 Sep 2007 21:23:09 +0200
Subject: [PATCH] kconfig: fix segv fault in menuconfig

With specific configurations requesting help for certain
menu lines caused menuconfig to crash.
This was tracked down to a null pointer bug.
Thanks to "Miles Lane" <miles.lane@gmail.com> for inital reporting
and to Gabriel C <nix.or.die@googlemail.com> for the backtrace
that helped me locating the bug.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/mconf.c |    5 +++--
 scripts/kconfig/util.c  |   13 ++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 2ee12a7..1935818 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -357,8 +357,9 @@ static void get_symbol_str(struct gstr *r, struct symbol *sym)
        bool hit;
        struct property *prop;
 
-       str_printf(r, "Symbol: %s [=%s]\n", sym->name,
-                                      sym_get_string_value(sym));
+       if (sym && sym->name)
+               str_printf(r, "Symbol: %s [=%s]\n", sym->name,
+                                                   sym_get_string_value(sym));
        for_all_prompts(sym, prop)
                get_prompt_str(r, prop);
        hit = false;
diff --git a/scripts/kconfig/util.c b/scripts/kconfig/util.c
index e3f28b9..e1cad92 100644
--- a/scripts/kconfig/util.c
+++ b/scripts/kconfig/util.c
@@ -84,12 +84,15 @@ void str_free(struct gstr *gs)
 /* Append to growable string */
 void str_append(struct gstr *gs, const char *s)
 {
-       size_t l = strlen(gs->s) + strlen(s) + 1;
-       if (l > gs->len) {
-               gs->s   = realloc(gs->s, l);
-               gs->len = l;
+       size_t l;
+       if (s) {
+               l = strlen(gs->s) + strlen(s) + 1;
+               if (l > gs->len) {
+                       gs->s   = realloc(gs->s, l);
+                       gs->len = l;
+               }
+               strcat(gs->s, s);
        }
-       strcat(gs->s, s);
 }
 
 /* Append printf formatted string to growable string */

