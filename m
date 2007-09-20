Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXITOOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXITOOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbXITOOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:14:18 -0400
Received: from mail.lysator.liu.se ([130.236.254.3]:54359 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbXITOOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:14:16 -0400
X-Greylist: delayed 1133 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 10:14:16 EDT
Message-ID: <46F27BA3.8060905@27m.se>
Date: Thu, 20 Sep 2007 15:54:43 +0200
From: Markus Gothe <markus.gothe@27m.se>
User-Agent: Icedove 1.5.0.12 (X11/20070730)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/pmag-ba-fb.c: Improve diagnostics
References: <Pine.LNX.4.64N.0709171736580.17606@blysk.ds.pg.gda.pl> <Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl> <20070919172412.725508d0.akpm@linux-foundation.org> <Pine.LNX.4.64N.0709201342160.30788@blysk.ds.pg.gda.pl> <alpine.LFD.0.999.0709201837160.17093@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709201837160.17093@enigma.security.iitk.ac.in>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

GCC 4.1.2 has been stable for a long time now, maybe you better
upgrade your binutils instead...

//Markus

Satyam Sharma wrote:
> Hi Maciej,
>
>
> On Thu, 20 Sep 2007, Maciej W. Rozycki wrote:
>> On Wed, 19 Sep 2007, Andrew Morton wrote:
>>
>>>> patch-mips-2.6.23-rc5-20070904-pmag-ba-err-2 diff -up
>>>> --recursive --new-file
>>>> linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c
>>>> linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c ---
>>>> linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c
>>>> 2007-02-21 05:56:47.000000000 +0000 +++
>>>> linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c
>>>> 2007-09-18 10:56:51.000000000 +0000 @@ -147,16 +147,23 @@
>>>> static int __init pmagbafb_probe(struct resource_size_t
>>>> start, len; struct fb_info *info; struct pmagbafb_par *par; +
>>>> int err = 0;
>>> This initialisation to zero is not good.
>>>
>>> Because if some error-path code forgot to do `err = -EFOO' then
>>> probe() will return zero and the driver will leave things in
>>> half-initialised state and will then proceed as if things had
>>> succeeded.  It will crash.
>> GCC used to complain: "`foo' might be used uninitialized..." and
>> this is the usual cure; let me see if this not the case anymore
>> (I have 4.1.2).
>
> Even so, initializing to zero isn't quite good. You could use the
> uninitialized_var() (once you've confirmed that the warning is
> bogus). However, some maintainers may still nack
> uninitialized_var() usage, quite legitimately.
>
>
>>> So it's better to leave this local uninitialised, because we
>>> really want to get that compiler warning if someone forgot to
>>> set the return value.
>> Yes of course, barring the issue mentioned.  Note the message
>> above is not the same as: "`foo' is used uninitialized..." that
>> would be reported in the case which you are concerned of.
>
> Firstly, "may be used uninitialized" can still be a bug.
>
> Secondly, latest gcc is *horribly* buggy (and has been so for last
> several releases including 4.1, 4.2 and 4.3 -- 3.x was good). See:
>
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=33327
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501
>
> We'd been hurling all sorts of abuses on gcc for quite long (when
> it fails to detect these "false positive" cases), but now, it turns
> out it is quite easy to write *genuinely* buggy code that still
> won't get any warnings, neither the "is used" nor "may be used"
> one!
>
> In short, there are three ways to fix these false positive
> warnings:
>
> 1. Do nothing, there are enough "uninitialized variable" warnings
> anyway, and hopefully, one day GCC would clean up its act.
>
> 2. Use uninitialized_var() to shut it up (only if it's genuinely
> bogus).
>
> 3. Do something like the following legendary patch [1]:
>
> http://kegel.com/crosstool/crosstool-0.43/patches/linux-2.6.11.3/arch_alpha_kernel_srcons.patch
>
>
> i.e., explicitly change the structure/logic of the function to make
> it obvious enough to gcc that the variable will not be used
> uninitialized.
>
>
> Satyam
>
> [1] That was a funny case -- the alpha linux maintainer is also a
> gcc maintainer. Alpha even sets -Werror, so either he had to fix
> the kernel code that produced the warning, or go fix GCC to not
> warn about it -- he chose the former :-)
>


- --
_______________________________________

Mr Markus Gothe
Software Engineer

Phone: +46 (0)13 21 81 20 (ext. 1046)
Fax: +46 (0)13 21 21 15
Mobile: +46 (0)73 718 72 80
Diskettgatan 11, SE-583 35 Linköping, Sweden
www.27m.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8nuh6I0XmJx2NrwRCIX3AJ9c1HwLMWXV6SFb/WmJ2zFR0xbJxgCeLrIb
g7N9BsOQhRre5iDf6hFcXF0=
=VXuc
-----END PGP SIGNATURE-----

