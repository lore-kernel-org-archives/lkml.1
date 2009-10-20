Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZJTTLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZJTTLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZJTTLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:11:45 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:2207 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZJTTLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:11:44 -0400
From: James Cloos <cloos@jhcloos.com>
To: hackers@lists.ntp.org, linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: ntp-dev-4.2.5p235-RC build failure: MOD_NANO not #defined
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 20 Oct 2009 14:38:03 -0400
Message-ID: <m3iqe9kj18.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:091020:hackers@lists.ntp.org::RjPUp5gzF0JdlCav:000000000000000000000000000000000000000g1qf3
X-Hashcash: 1:30:091020:linux-kernel@vger.kernel.org::pqdVmDC6UBTuixn8:00000000000000000000000000000000DwPWG
X-Hashcash: 1:30:091020:zippel@linux-m68k.org::vibRoYJkCKVU1haT:000000000000000000000000000000000000000sVryH
X-Hashcash: 1:30:091020:tglx@linutronix.de::QTLseCC9J6yT8rBv:000000000000000000000000000000000000000000YgBIq
X-Hashcash: 1:30:091020:johnstul@us.ibm.com::K4likwx7jZ7INcxC:00000000000000000000000000000000000000000C/Ank
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this when trying to build the 235 RC:

make[1]: Entering directory `.../work/ntp-dev-4.2.5p235-RC/ntpd'
if i686-pc-linux-gnu-gcc -DHAVE_CONFIG_H -I. -I. -I..  -I../include -I../lib/isc/include -I../lib/isc/nothreads/include -I../lib/isc/unix/include -I../libopts -I/usr/include  -march=pentium3 -O2 -Wno-error   -Wall -Wcast-qual -Wmissing-prototypes -Wpointer-arith -Wshadow -Winit-self -Wstrict-overflow -Wno-strict-prototypes -MT ntp_loopfilter.o -MD -MP -MF ".deps/ntp_loopfilter.Tpo" -c -o ntp_loopfilter.o ntp_loopfilter.c; \
        then mv -f ".deps/ntp_loopfilter.Tpo" ".deps/ntp_loopfilter.Po"; else rm -f ".deps/ntp_loopfilter.Tpo"; exit 1; fi
ntp_loopfilter.c: In function 'local_clock':
ntp_loopfilter.c:521: error: 'MOD_NANO' undeclared (first use in this function)
ntp_loopfilter.c:521: error: (Each undeclared identifier is reported only once
ntp_loopfilter.c:521: error: for each function it appears in.)
make[1]: *** [ntp_loopfilter.o] Error 1
make[1]: Leaving directory `.../work/ntp-dev-4.2.5p235-RC/ntpd'
make: *** [all] Error 2

In ntp_loopfilter.c, MOD_NANO is protected w/in an #ifdef STA_NANO.

I find STA_NANO #defined in <linux/timex.h>, but I cannot find a
definition for MOD_NANO anywhere.

That said, <linux/timex.h> does #define several MOD_ defines in a block
called /* xntp 3.4 compatibility names */ to match the ADJ_ defines;
it #defines ADJ_NANO, but does not include a MOD_NANO #define in that
compatability block.

Also, my <sys/timex.h> (from glibc-2.10.1) says:

sys/timex.h> /* These definitions from linux/timex.h as of 2.6.30.  */


Should ntp_loopfilter.c be using ADJ_NANO instead of MOD_NANO?

Or should timex.h #define MOD_NANO ADJ_NANO?

All of the additions to linux/timex.h since 2.6.30 then are protected
within an #ifdef __KERNEL__ and would, therefore, make no difference.

(In case it is an lk issue, I've included lkml and (following lkml style)
my best guess at the relevant CCs; in case it is an ntpd issue it is also
sent to the ntp hackers list; I do not know whether the latter list
requires subscription to post....)

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
