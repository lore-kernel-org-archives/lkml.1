Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXF0BdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXF0BdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 21:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXF0BdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 21:33:00 -0400
Received: from smtpout.mac.com ([17.250.248.178]:53377 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbXF0Bc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 21:32:59 -0400
In-Reply-To: <20070622150038.GN23017@stusta.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       LKML Kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Linux Kernel include files
Date: Tue, 26 Jun 2007 21:32:39 -0400
To: Adrian Bunk <bunk@stusta.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2007, at 11:00:38, Adrian Bunk wrote:
> It would certainly help if Joerg would tell what exactly breaks,  
> but I spot one likely problem in include/asm-i386/types.h:
>
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
> typedef __signed__ long long __s64;
> typedef unsigned long long __u64;
> #endif
>
> It might make sense to remove the #if and simply require that a C  
> compiler under Linux must know about the C99 "long long"?

Gah, this particular topic and a few other similar header- 
compatibility ones show up once a month on LKML; I should probably  
just make a patch to fix all the types.h files and be done with it.   
The proper solution is this:

# if __STDC_VERSION__ >= 19901L
typedef   signed long long __s64;
typedef unsigned long long __u64;
# elif defined(__GNUC__)
__extension__ typedef   signed long long __s64;
__extension__ typedef unsigned long long __u64;
# else
#  error "Your compiler doesn't support long long (IOW: It sucks).   
Please get a new one"
# endif

That way if you have any kind of vaguely-long-long-compatible  
compiler then it will work, and otherwise you'll get a nice useful  
error message.  It also makes sure that GCC doesn't spew warnings/ 
errors when in c89-pedantic mode.  The "__extension__" keyword is  
designed for use in implementation header files which want to use GCC- 
isms unconditionally.

Cheers,
Kyle Moffett

