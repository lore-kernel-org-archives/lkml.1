Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZL0UTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZL0UTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZL0UTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:19:42 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:57329 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZL0UTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:19:41 -0500
Message-ID: <4B37C159.5080202@msgid.tls.msk.ru>
Date: Sun, 27 Dec 2009 23:19:37 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alain Knaff <alain@knaff.lu>
CC: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.33-rc1: LZMA kernel fails to decompress
References: <200912211643.18173.tvrtko.ursulin@sophos.com> <4B2FEC10.6050900@msgid.tls.msk.ru> <4B37AC87.1070607@knaff.lu>
In-Reply-To: <4B37AC87.1070607@knaff.lu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alain Knaff wrote:
> Michael Tokarev wrote:
>> Tvrtko Ursulin wrote:
>>> Hi,
>>>
>>> When run under VMware, LZMA compressed 2.6.33-rc1 instantly reboots in the 
>>> decompression stage. At least I suppose so, because switching to GZIP makes 
>>> it work.
>> Switch /bin/sh from dash to bash and recompile (actually relink) - it should work.
>>
>> /mjt
> 
> I can confirm this. A similar issue used to exist for older kernels,
> which then got fixed by replacing "echo" with "/bin/echo" in the
> size_append command scripts/Makefile.lib . The reason why this was
> needed is that some shells (such as dash) have a defective built-in echo
> command. Specifying the full path forces to use the system echo command
> rather than the broken shell builtin.
> 
> In 2.6.33, for some reason, echo has been replaced with printf. With a
> _pathless_ printf! The fix is the same as in earlier kernels: add the path.

It should be pathless, or else we'll come to issue when printf is in /bin
vs /usr/bin and the like.

But you're wrong, and this has been discussed already in this very thread.
Neither approach is right.  The whole issues is not because of "defects"
in sh or printf or echo, but because of over-expectations. POSIX does not
specify that printf should support \x (hexadecimal) escape sequences or
that echo should interpret _any_ escape sequences at all.  "Non-defective"
system echo is *extension* to standard.  Set $POSIXLY_CORRECT with GNU
echo or printf and you should have the same issue again.

> With the attached patch applied, the kernel compiles correctly even if
> sh is linked to dash.

What I think should be done here is to revert my patch (that replaces
/bin/echo with printf, so that /bin/echo will be used) and test the
real solution, which is to stop doing all this hackery altogether,
and calculate the size the right way instead.  Sam already posted a
possible solution, and it seems to be correct.

/mjt
