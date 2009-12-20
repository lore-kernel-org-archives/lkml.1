Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZLTKiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZLTKiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZLTKiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:38:50 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:39502 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZLTKit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:38:49 -0500
Message-ID: <4B2DFEB7.4080507@msgid.tls.msk.ru>
Date: Sun, 20 Dec 2009 13:38:47 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Sam Ravnborg <sam@ravnborg.org>, Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mmarek@suse.cz
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091019.GA20246@sig21.net>
In-Reply-To: <20091220091019.GA20246@sig21.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: multipart/mixed;
 boundary="------------090102060300010406090407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090102060300010406090407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Johannes Stezenbach wrote:
> On Sun, Dec 20, 2009 at 09:46:56AM +0100, Sam Ravnborg wrote:
>> On Sun, Dec 20, 2009 at 12:34:57AM +0100, Michael Guntsche wrote:
>>> I took me some time but I tracked down my reboot problem. The culprit is
>>> commit 
>>>
>>> 4a2ff67c88211026afcbdbc190c13f705dae1b59: kbuild: fix bzImage build for
>>> x86
>> Just to check what is going wrong here could you try to execute the following two commands:
>> printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
>> /usr/bin/printf \\xa8\\x51\\x37\\x00 > x ; hexdump x
>> echo -ne \\xa8\\x51\\x37\\x00 > x ; hexdump x
>>
>> Please try as above and also with full path to printf (/usr/bin/printf)
> 
> Debian dash has a built-in printf which doesn't support \x.
> /usr/bin/printf works fine.

So it looks like I was wrong with the last patch here.
I changed `/bin/echo -ne' to printf.  And while it worked
for me at that time, apparently it does not work for others.

Now I wonder why it worked for me.  I can confirm that
in current debian testing (dash-0.5.5.1-3) and in debian
stable (dash-0.5.4-12) dash's built-in printf does not
interpret \x escape sequence.  I sure verified the fix
I proposed, rebuilding kernels in a freshly-installed
debian testing with /bin/sh pointing to dash.  I'll try
to investigate this.  (Side note: since the time this
issue first hit me, I carry 4a2ff67c88211026afcbdbc190c13f705dae1b59
locally.)

It is even more interesting.  I re-read POSIX description
of printf, see
http://www.opengroup.org/onlinepubs/000095399/utilities/printf.html
And this one, too, does NOT mention \x at all.  Printf is
still "better" than echo because for echo _no_ interpretation
of escape sequences is mandated -- see
http://www.opengroup.org/onlinepubs/000095399/utilities/echo.html
but that does not help much since for printf, while \-sequences
are mandated, particular \x is not, so \x is a {GNU|common sense|...}
extension.

What the...

So now I don't know what to do.  According to the standard, there's
no utility that will work here. ;)  Maybe the attached (together
with 4a2ff67c88211026afcbdbc190c13f705dae1b59) will make everyone happy?

/mjt

--------------090102060300010406090407
Content-Type: text/x-patch;
 name="use-printf-octal.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use-printf-octal.diff"

--- a/scripts/Makefile.lib.orig	2009-12-19 18:36:01.944153109 +0300
+++ a/scripts/Makefile.lib	2009-12-20 13:36:04.014530573 +0300
@@ -215,6 +215,6 @@
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
-	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
+printf "%012o" $$dec_size |						\
+	sed 's/\(...\)\(...\)\(...\)\(...\)/\\\\4\\\\3\\\\2\\\\1/g'	\
 )
 

--------------090102060300010406090407--
