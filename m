Return-Path: <linux-kernel-owner+w=401wt.eu-S1761681AbXI1OgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761681AbXI1OgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbXI1OgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:36:08 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:32504 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbXI1OgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:36:07 -0400
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <200709270900.36602.arnd@arndb.de> <200709270900.36602.arnd@arndb.de> <200709271906.48601.rob@landley.net>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: [Announce] Linux-tiny project revival
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <9b4.46fd1153.78517@altium.nl>
Date: Fri, 28 Sep 2007 14:36:03 -0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> wrote:
| The "change every printk in the kernel" suggestion came from me trying to 
| figure out how to get the printk() calls below a certain log level to 
| optimize out and not take up space in the binary.
| 
| The above doesn't address the original cause of the thread, as far as I can 
| tell.

It does, provided you change the macro definition to:

#define _printk(level, str, ...) \
   do { \
     if (sizeof(level) == 1) /* continued printk */\
      actual_printk(str, __VA_ARGS__); \
     else if ((level[1] - '0') < CONFIG_PRINTK_DOICARE) \
       actual_printk(level str, __VA_ARGS__); \
   } while(0);
#define printk(level_str, ...)	_printk(level_str, __VA_ARGS__)

Gcc will do constant folding on the string subscripts, and remove the
code and the string constants for calls above the desired level.

This is basically the same as I proposed in my earlier message [*],
but with the disadvantage that you need to modify all printk() calls
without an explicit level and add the ugly comma to the KERN_* macros.
Just compile the code in my message with -O and -S and you will see
that the KERN_NOTICE call and the corresponding string literal are
optimized away.

[*] http://lkml.org/lkml/2007/9/21/151

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

