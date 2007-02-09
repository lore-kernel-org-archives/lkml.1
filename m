Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXBIADi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXBIADi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbXBIADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:03:38 -0500
Received: from smtp.ono.com ([62.42.230.12]:46921 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932952AbXBIADh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:03:37 -0500
Date: Fri, 9 Feb 2007 01:03:17 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070209010317.3c442240@werewolf-wl>
In-Reply-To: <Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org>
	<Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
	<Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
	<Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
	<20070208221317.5beedaeb@werewolf-wl>
	<Pine.LNX.4.64.0702081338010.8424@woody.linux-foundation.org>
	<Pine.LNX.4.64.0702081351410.8424@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.2cvs25 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 14:03:06 -0800 (PST), Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 8 Feb 2007, Linus Torvalds wrote:
> > 
> > But THE CALLER CANNOT AND MUST NOT CARE! Because the sign of "char" is 
> > implementation-defined, so if you call "strcmp()", you are already 
> > basically saying: I don't care (and I _cannot_ care) what sign you are 
> > using.
> 
> Let me explain it another way.
> 
> Say you use
> 
> 	signed char *myname, *yourname;
> 
> 	if (strcmp(myname,yourname) < 0)
> 		printf("Ha, I win!\n")
> 
> and you compile this on an architecture where "char" is signed even 
> without the explicit "signed".
> 
> What should happen?
> 
> Should you get a warning? The types really *are* the same, so getting a 
> warning sounds obviously insane. But on the other hand, if you really care 
> about the sign that strcmp() uses internally, the code is wrong *anyway*, 

Thats the point. Mmmm, I think I see it the other way around. I defined
a variable as 'signed' or 'unsigned', because the sign info matters for me.
And gcc warns about using a function on it that will _ignore_ or even
misinterpret that info. Could it be a BUG ? Yes.

> because with another compiler, or with the *same* compiler on another 
> architecture or some other compiler flags, the very same code is buggy.
> 
> In other words, either you should get a warning *regardless* of whether 
> the sign actually matches or not, or you shouldn't get a warning at all 
> for the above code. Either it's buggy code, or it isn't.
> 

In fact, I tried to look for an arch where this gives only _one_ error:

#include <string.h>

void f()
{
	const unsigned char *a;
	const signed char *b;

	int la,lb;

	la = strlen(a);
	lb = strlen(b);
}

and guess, all give _both_ errors.

Linux/x86, gcc 4.1.2-0.20070115:
werewolf:~> gcc -Wpointer-sign -c t.c
t.c: In function ‘f’:
t.c:10: warning: pointer targets in passing argument 1 of ‘strlen’ differ in signedness
t.c:11: warning: pointer targets in passing argument 1 of ‘strlen’ differ in signedness

OSX ppc, gcc-4.0.1
belly:~> gcc -Wpointer-sign -c t.c
t.c: In function ‘f’:
t.c:10: warning: pointer targets in passing argument 1 of ‘strlen’ differ in signedness
t.c:11: warning: pointer targets in passing argument 1 of ‘strlen’ differ in signedness

Solaris5.7 Ultra, cc WorkShop Compilers 5.0
den:~> cc -Xa -c t.c                                                           
ucbcc: Warning: "-Xa" redefines compatibility mode from "SunC transition" to "ANSI"
"t.c", line 10: warning: argument #1 is incompatible with prototype:
        prototype: pointer to const char : "/usr/include/string.h", line 71
        argument : pointer to const uchar
"t.c", line 11: warning: argument #1 is incompatible with prototype:
        prototype: pointer to const char : "/usr/include/string.h", line 71
        argument : pointer to const schar

This makes sense.
Someone can try on something psychedelic, like ARM ;) ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.19-jam06 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
