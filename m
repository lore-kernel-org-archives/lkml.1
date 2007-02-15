Return-Path: <linux-kernel-owner+w=401wt.eu-S965602AbXBOPPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbXBOPPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965581AbXBOPPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:15:43 -0500
Received: from javad.com ([216.122.176.236]:1996 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965602AbXBOPPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:15:42 -0500
From: Sergei Organov <osv@javad.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J.A. =?utf-8?B?TWFnYWxsw4PDg8ODw4PDgsKzbg==?=" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
	<87abznsdyo.fsf@javad.com>
	<Pine.LNX.4.64.0702090753500.8424@woody.linux-foundation.org>
	<874pprr5nn.fsf@javad.com>
	<Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org>
	<87ps8end9b.fsf@javad.com>
	<Pine.LNX.4.64.0702131121590.3604@woody.linux-foundation.org>
	<87odnxn80u.fsf@javad.com>
	<Pine.LNX.4.64.0702131212120.3604@woody.linux-foundation.org>
Date: Thu, 15 Feb 2007 18:15:06 +0300
Message-ID: <87vei3jvut.fsf@javad.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Tue, 13 Feb 2007, Sergei Organov wrote:
[...]
> BUT (and this is a big but) within the discussion of "strlen()", that is 
> no longer true. "strlen()" exists _outside_ of a single particular 
> implementation. As such, "implementation-defined" is no longer something 
> that "strlen()" can depend on.
>
> As an example of this argument, try this:
>
> 	#include <string.h>
> 	#include <stdio.h>
>
> 	int main(int argc, char **argv)
> 	{
> 		char a1[] = { -1, 0 }, a2[] = { 1, 0 };
>
> 		printf("%d %d\n", a1[0] < a2[0], strcmp(a1, a2) < 0);
> 		return 0;
> 	}
>
> and *before* you compile it, try to guess what the output is.

Well, I'll try to play fair, so I didn't yet compile it. Now, strcmp()
is defined in the C standard so that its behavior doesn't depend on the
sign of char:

   "The sign of a nonzero value returned by the comparison functions
    memcmp, strcmp, and strncmp is determined by the sign of the
    difference between the values of the first pair of characters (both
    interpreted as unsigned char) that differ in the objects being
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    compared."

[Therefore, at least I don't need to build GCC multilib'ed on
-fsigned/unsigned-char to get consistent results even if strcmp() in
fact lives in a library, that was my first thought before I referred to
the standard ;)]

Suppose the char is signed. Then a1[0] < a2[0] (= -1 < 1) should be
true. On 2's-complement implementation with 8bit char, -1 converted by
strcmp() to unsigned char should be 0xFF, and 1 converted should be
1. So strcmp() should be equivalent to (0xFF < 1) that is false. So
I'd expect

 1 0

result on implementation with signed char.

Now suppose the char is unsigned. Then on 2's-complement implementation
with 8bit-byte CPU, a1[0] should be 0xFF, and a2[0] should be 1. The
result from strcmp() won't change. So I'd expect

 0 0

result on implementation with unsigned char.

Now I'm going to compile it (I must admit I'm slightly afraid to get
surprising results, so I've re-read my above reasonings before
compiling):

osv@osv tmp$ cat strcmp.c
#include <stdio.h>
#include <string.h>
int main()
{
  char a1[] = { -1, 0 }, a2[] = { 1, 0 };

  printf("%d %d\n", a1[0] < a2[0], strcmp(a1, a2) < 0);
  return 0;
}
osv@osv tmp$ gcc -v
Using built-in specs.
Target: i486-linux-gnu
...
gcc version 4.1.2 20061028 (prerelease) (Debian 4.1.1-19)
osv@osv tmp$ gcc -O2 strcmp.c -o strcmp && ./strcmp
1 0

> And when that confuses you,

It didn't, or did I miss something? Is char unsigned by default?

> try to compile it using gcc with the 
> "-funsigned-char" flag (or "-fsigned-char" if you started out on an 
> architecture where char was unsigned by default)

osv@osv tmp$ gcc -O2 -fsigned-char strcmp.c -o strcmp && ./strcmp
1 0
osv@osv tmp$ gcc -O2 -funsigned-char strcmp.c -o strcmp && ./strcmp
0 0
osv@osv tmp$

Due to above, apparently char is indeed signed by default, so what?

> And when you really *really* think about it afterwards, I think you'll go 
> "Ahh.. Linus is right". It's more than "implementation-defined": it really 
> is totally indeterminate for code like this.

The fact is that strcmp() is explicitly defined in the C standard so
that it will bring the same result no matter what the sign of "char"
type is. Therefore, it obviously can't be used to determine the sign of
"char", so from the POV of usage of strcmp(), the sign of its argument
is indeed "indeterminate". What I fail to see is how this fact could
help in proving that for any function taking "char*" argument the sign
of char is indeterminate.

Anyway, it seems that you still miss (or ignore) my point that it's not
(only) sign of "char" that makes it suspect to call functions requesting
"char*" argument with "unsigned char*" value.

-- Sergei.
