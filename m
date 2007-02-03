Return-Path: <linux-kernel-owner+w=401wt.eu-S1946022AbXBCNCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946022AbXBCNCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945989AbXBCNCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:02:10 -0500
Received: from raven.upol.cz ([158.194.120.4]:43222 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946022AbXBCNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:02:08 -0500
Date: Sat, 3 Feb 2007 14:10:11 +0100
To: Tim Schmielau <tim@physik3.uni-rostock.de>, Rob Landley <rob@landley.net>,
       Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/makelst: bc -> shell Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070203131011.GA26632@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701251438.03213.rob@landley.net> <20070125211802.GC10907@flower.upol.cz> <200701261247.22374.rob@landley.net> <20070126201451.GA14946@flower.upol.cz> <Pine.LNX.4.63.0701270113400.4567@gockel.physik3.uni-rostock.de> <20070127063836.GA15178@flower.upol.cz> <20070203112459.GW28152@vasa.acc.umu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203112459.GW28152@vasa.acc.umu.se>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 12:24:59PM +0100, David Weinehall wrote:
> On Sat, Jan 27, 2007 at 06:38:36AM +0000, Oleg Verych wrote:
> [snip]
> > ,-*- diff snip -*-
> > |-    t4=`echo $t3 | gawk '{ print $1 }'`
> > |-    t5=`echo $t1 | gawk '{ print $1 }'`
> > |+    t4=`pos_param 1 $t3`
> > |+    t5=`pos_param 1 $t1`
> > 5     t6=`echo $t4 - $t5 | tr a-f A-F`
> > 6     t7=`( echo  ibase=16 ; echo $t6 ) | bc`
> > `-*-
> > 
> > I've just noticed, that things on lines 5 and 6 may be optimized.
> > 
> > t7=`printf "%lu" $(( 0x$t4 - 0x$t5 ))`
> 
> %lu does not seem to agree with SuSv3:
> 
> http://www.opengroup.org/onlinepubs/009695399/utilities/printf.html
> http://www.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap05.html

,-*- xbd_chap05.html -*-
|     The EXTENDED DESCRIPTION section almost exactly matches the
|     printf() function in the ISO C standard, although it is described
|     in terms of the file format notation in the Base Definitions volume
|     of IEEE Std 1003.1-2001, Chapter 5, File Format Notation.
`-*-
In other words, it does *not* match it at all. How it can without
the length modifiers?

As for me, "shalls" and "shoulds", "Implementations are encouraged" are
standard terms of The Standards.

Thus, i think, "%ul" is more "implementation wise":

,-*- printf test on bash, dash, busybox -*-
|olecom@flower:~$
|olecom@flower:~$ printf "%u \n" 0xffffffffffffffff
|18446744073709551615
|olecom@flower:~$ printf "%u \n" 0xffffffffffffffffA
|bash: printf: warning: 0xffffffffffffffffA: Numerical result out of range
|18446744073709551615
|olecom@flower:~$
|olecom@flower:~$ echo $BASH_VERSION
|3.1.17(1)-release
|olecom@flower:~$
|olecom@flower:~$ /bin/dash
|flower:-$ printf "%u \n" 0xffffffffffffffff
|18446744073709551615
|flower:-$ printf "%u \n" 0xffffffffffffffffA
|printf: 2: 0xffffffffffffffffA: Numerical result out of range
|18446744073709551615
|flower:-$
|flower:-$ /bin/busybox sh
|
|
|BusyBox v1.1.3 (Debian 1:1.1.3-4) Built-in shell (ash)
|Enter 'help' for a list of built-in commands.
|
|flower:-$
|flower:-$
|flower:-$ printf "%u \n" 0xffffffffffffffff
|4294967295
|flower:-$ printf "%u \n" 0xffffffffffffffffA
|0xffffffffffffffffA4294967295
|flower:-$ printf "%lu \n" 0xffffffffffffffff
|18446744073709551615
|flower:-$ printf "%lu \n" 0xffffffffffffffffA
|0xffffffffffffffffA18446744073709551615
|flower:-$
|flower:-$
`-*-

____
