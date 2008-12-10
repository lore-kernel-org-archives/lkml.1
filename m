Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYLJNPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYLJNPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYLJNPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:15:21 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51428 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752962AbYLJNPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:15:18 -0500
Date: Wed, 10 Dec 2008 14:15:15 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Howells <dhowells@redhat.com>
cc: Yuri Tikhonov <yur@emcraft.com>, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>, linuxppc-dev@ozlabs.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ilya Yanok <yanok@emcraft.com>
Subject: Re: Re[2]: [PATCH] fork_init: fix division by zero
In-Reply-To: <5545.1228914404@redhat.com>
Message-ID: <Pine.LNX.4.64.0812101412130.27886@vixen.sonytel.be>
References: <1795455197.20081210132912@emcraft.com> <200812092044.40649.yur@emcraft.com>
 <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be> <503391615.20081210130113@emcraft.com>
 <20081210101745.GG28946@ZenIV.linux.org.uk> <5545.1228914404@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, David Howells wrote:
> Yuri Tikhonov <yur@emcraft.com> wrote:
> >  In any case, adding braces as follows probably would be better:
> > 
> > +     max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> 
> I think you mean brackets, not braces '{}'.
> 
> >  Right ?
> 
> Definitely not.
> 
> I added this function to the above:
> 
> 	unsigned long alt(void)
> 	{
> 		unsigned long max_threads;
> 		max_threads = mempages * (PAGE_SIZE / (8 * THREAD_SIZE));
> 		return max_threads;
> 	}
> 
> and ran it through "gcc -S -O2" for x86_64:
> 
> 	jump:
> 		movq    mempages(%rip), %rax
> 		salq    $12, %rax
> 		shrq    $16, %rax
> 		ret
> 	alt:
> 		xorl    %eax, %eax
> 		ret
> 
> Note the difference?  In jump(), x86_64 first multiplies mempages by 4096, and
> _then_ divides by 8*8192.
> 
> In alt(), it just returns 0 because the compiler realised that you're
> multiplying by 0.

The case were the multiplier is 0 (actually smaller than 1, but not integer)
is handled by

	#if (8 * THREAD_SIZE) > PAGE_SIZE
	      max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
	#else
	     ...

> If you're going to bracket the expression, it must be:
> 
> 		max_threads = (mempages * PAGE_SIZE) / (8 * THREAD_SIZE);
> 
> which should be superfluous.

No, `mempages * PAGE_SIZE' may overflow.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
