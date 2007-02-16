Return-Path: <linux-kernel-owner+w=401wt.eu-S932620AbXBPRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbXBPRkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbXBPRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:40:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:55389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbXBPRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:40:34 -0500
Date: Fri, 16 Feb 2007 18:40:02 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Sergei Organov <osv@javad.com>
cc: 7eggert@gmx.de, Linus Torvalds <torvalds@linux-foundation.org>,
       "J.A. =?utf-8?B?TWFn?= =?utf-8?B?YWxsw4PDg8ODw4LCs24=?=" 
	<jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <87zm7ei836.fsf@javad.com>
Message-ID: <Pine.LNX.4.58.0702161553050.2481@be1.lrz>
References: <7Mj5f-3oz-21@gated-at.bofh.it> <7MktH-5EW-35@gated-at.bofh.it>
 <7Mmvy-vj-17@gated-at.bofh.it> <7MnBC-2fk-13@gated-at.bofh.it>
 <7MoQx-4p8-11@gated-at.bofh.it> <7MpjE-50z-7@gated-at.bofh.it>
 <7MpCS-5Fe-9@gated-at.bofh.it> <7MDd7-17w-1@gated-at.bofh.it>
 <7MGkB-62k-31@gated-at.bofh.it> <7NHoe-2Mb-37@gated-at.bofh.it>
 <7NMe9-1ZN-7@gated-at.bofh.it> <7Oagl-6bO-1@gated-at.bofh.it>
 <7ObvW-89N-23@gated-at.bofh.it> <7Oc8t-NS-1@gated-at.bofh.it>
 <E1HHmuB-0001lW-E1@be1.lrz> <87zm7ei836.fsf@javad.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX18er8OkE5WD+EwcTW0DrpWRlgGMO4iQbNJclN+0QseOXeAGSjE5iAPL6LJ8ZCbU3Qy/23TeHDFQIVDrllCkICYIccsgpcUBrGBMmI+HZ8kn3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007, Sergei Organov wrote:
> Bodo Eggert <7eggert@gmx.de> writes:
> > Sergei Organov <osv@javad.com> wrote:
> >> Linus Torvalds <torvalds@linux-foundation.org> writes:

> > If you don't code for a specific compiler with specific settings, there is
> > no implementation defining the signedness of char, and each part of the code
> > using char* will be wrong unless it handles both cases correctly.
> 
> The problem here is that due to historical reasons, there could be code
> out there that abuses "char" for "signed char" (not sure about "unsigned
> char"). Old code and old habits are rather persistent.

There could be code using trigraphs ... and gcc has an option for that.

If this code uses signed chars, using it on unsigned-char-archs is broken
and should be warned about, but the compiler will not warn about this
because this code will not use "signed char" and therefore it's bug-to-bug
syntax compatible, waiting for a semantic breakdown.

I'll say it again: Either the code using unspecified chars is correct, or 
it isn't. If it's correct, neither using with signed nor with unsigned 
chars is a bug and you should not warn at all, and if it's not correct, 
you should always warn. Instead, gcc warns on "code compiles for $arch".

> > Therefore it's either always wrong to call your char* function with char*,
> > unsigned char* _and_ signed char unless you can guarantee not to overflow any
> > of them, or it's always correct to call char* functions with any kind
> > of these.
> 
> How are you sure those who wrote foo(char*) agrees with your opinion or
> even understands all the involved issues?

Let's asume we have this piece of buggy code. We compile it on an unsigned
char architecture. No warning. *BOOM*


Let's asume there is correct code, and we use it as designed:
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch
Warning: real issue 
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch
<scroll off screen/>
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch
Warning: Wrong arch

You don't see "real issue". *BOOM*


What can you do about this warning? Let's asume we cast everywhere:

struct foo * p;
printf(strlen(char*)p); *BOOM*


Let's asume we disable this warning:

int f(unsigned short x)
{
	if (!x)
		return 0;
	return (int) x + f(x-1);
}

f(-1); *BOOM*


Therefore unless you program for one arch with one set of compiler flags, 
this warning is useless, and I did not see much code explicitely designed 
to be non-portable.

Warning on wrong signedness is good, but if you can't enable it on 
portable code, it's useless.

-- 
Funny quotes:
39. Ever wonder about those people who spend $2.00 apiece on those little
    bottles of Evian water? Try spelling Evian backwards: NAIVE
