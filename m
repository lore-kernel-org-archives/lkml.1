Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYEXPfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYEXPfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYEXPfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:35:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38526 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYEXPfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:35:32 -0400
Date: Sat, 24 May 2008 17:36:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524153611.GA13890@uranus.ravnborg.org>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org> <483827CE.9080200@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483827CE.9080200@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 03:35:58PM +0100, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> >I assume you wanted to say:
> >  
> >>   #undef  CONFIG_FOO
> >>   #define CFG_FOO   1
> >>   #define CONFIG_FOO_MODULE
> >>   #define CFG_FOO_MODULE 1
> >>    
> >Because then the CONFIG_* is not changed
> >and we do not want to change that.
> >  
> 
> Yeah, I didn't intend to change the meaning of CONFIG_FOO.
> 
> >I'm not fully convinced about:
> >  
> >>   #define CFG_FOO   1
> >>    
> >But on the other hand it is only in odd
> >cases we distingush between built-in and module.
> >So it makes most sense.
> >  
> 
> I think CONFIG_ and CFG_ should be exact parallels, so if CONFIG_FOO is 
> undefined, CFG_FOO should be 0.

We should actually do as you intially suggested and alwyas
define CONFIG_FOO no matter if FOO is built-in or module.
Because we do only want to distingush between the two in rare cases.

But that is a separate patch and lets not do the same
mistage with CFG_*
I cooked up following patch - but I have not test-build a kernel yet.
We may use CFG_* here and there and clash is not good.

	Sam

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index ee5fe94..98a2c39 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -717,15 +717,21 @@ int conf_write_autoconf(void)
 		case S_BOOLEAN:
 		case S_TRISTATE:
 			switch (sym_get_tristate_value(sym)) {
-			case no:
-				break;
 			case mod:
 				fprintf(out, "CONFIG_%s=m\n", sym->name);
 				fprintf(out_h, "#define CONFIG_%s_MODULE 1\n", sym->name);
+				fprintf(out_h, "#define CFG_%s 1\n", sym->name);
+				fprintf(out_h, "#define CFG_%s_MODULE 1\n", sym->name);
 				break;
 			case yes:
 				fprintf(out, "CONFIG_%s=y\n", sym->name);
 				fprintf(out_h, "#define CONFIG_%s 1\n", sym->name);
+				fprintf(out_h, "#define CFG_%s 1\n", sym->name);
+				fprintf(out_h, "#define CFG_%s_MODULE 0\n", sym->name);
+				break;
+			case no:
+				fprintf(out_h, "#define CFG_%s 0\n", sym->name);
+				fprintf(out_h, "#define CFG_%s_MODULE 0\n", sym->name);
 				break;
 			}
 			break;
