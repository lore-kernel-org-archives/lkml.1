Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbZDJMIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbZDJMIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZDJMIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:08:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbZDJMIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:08:30 -0400
Date: Fri, 10 Apr 2009 14:08:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] headercheck - check dependencies on header files
Message-ID: <20090410120816.GM21506@elte.hu>
References: <20090409204219.GA31511@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409204219.GA31511@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> We have at several occasions discussed if our header files
> should include their dependencies or not.
> 
> But we were lacking a tool to tell us if our header files
> included the headerfiles they needed or not.
> 
> headercheck can be used to do so.
> 
> headercheck use the existing Kbuild files in
> include/ to determine which directories to visit.
> 
> And for each directory it create one .c file for each
> .h file and build it.
> 
> A .c file looks like this:
> 
> 	$cat module.h.c
> 		#include <linux/module.h>
> 
> 
> Building this file will tell us if module.h is
> missing any dependencies (but NOT if it has too many) with
> the current configuration.
> 
> We know that some header files are simply NOT supposed to be included
> direct and thus is not eligble to such a check.
> 
> To avoid checking these we can say in Kbuild:
> 
> 	ignore-y += compiler-gcc.h
> 
> This tells headercheck to ignore compiler-gcc.h when performing
> the headercheck.
> 
> The current implementation leaves a lot of .c files.
> I will address this if the concept is considered acceptable.
> 
> To visit all relevant directories we need to adjust the Kbuild
> files but that can wait until we have the current pile fixed.
> Likewise it does not support arch specific include files.
> That can wait too.
> 
> I have tried running headercheck on an i386 defconfig and
> the result shows that a lot af headers does not include there
> dependencies.
> 
> The numbers (including sub-directories): 
> 
>      25 include/asm-generic
>      12 include/drm
>     282 include/linux
>       2 include/mtd
>      24 include/sound
>      12 include/video
> 
> Remember we do not visit all directories - only those listed in include/Kbuild.
> 
> To try it yourself apply following patch and on a configured kernel use:
> 
>     make -k headercheck
> 
> Looking at the errors I would assume that at least 75% of the errors
> can be fixed in one day but the rest may be a bit more troublesome.
> 
> The open question is if this is worthwhile? 

Definitely a good idea IMHO. The current practice of 'include enough 
.h files in the .c file to make it build' has resulted in perversely 
long #include line sections in .c files.

For example arch/x86/kernel/setup.c has 76 headers (!) at the 
moment, and you have to go down 4 pages in the file before you see 
the first line of substantial code.

Or arch/x86/mm/fault.c had 32 headers - i recently cut that down to 
11 only.

Nice would be to have a tool that lists the minimum set of required 
headers for any given .c file, for a current .config. If we run that 
in allyesconfig we get a pretty good approximation of the headers 
needed.

	Ingo
