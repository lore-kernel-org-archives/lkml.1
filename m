Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYEQWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYEQWe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYEQWet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 18:34:49 -0400
Received: from www.tglx.de ([62.245.132.106]:36355 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYEQWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 18:34:48 -0400
Date: Sun, 18 May 2008 00:34:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Tom Spink <tspink@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merge nmi_32-64 to nmi.c
In-Reply-To: <18479.21161.437325.251769@harpo.it.uu.se>
Message-ID: <alpine.LFD.1.10.0805180023100.18798@apollo.tec.linutronix.de>
References: <20080517192200.GA6914@cvg> <7b9198260805171328u555eec17t3597f3378edbda88@mail.gmail.com> <Pine.LNX.4.55.0805172148380.10067@cliff.in.clinika.pl> <18479.21161.437325.251769@harpo.it.uu.se>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Mikael Pettersson wrote:
> Maciej W. Rozycki writes:
>  > On Sat, 17 May 2008, Tom Spink wrote:
>  > 
>  > > static inline unsigned int get_nmi_count(int cpu)
>  > > {
>  > > #ifdef CONFIG_X86_64
>  > >         return cpu_pda(cpu)->__nmi_count;
>  > > #else
>  > >         return nmi_count(cpu);
>  > > #endif
>  > > }
>  > > 
>  > > I know it introduces a lot of these conditionals, but at least there
>  > > is one place to look for the get_nmi_count function, instead of
>  > > searching for all variants of the function.
>  > 
>  >  Well, I suppose some header should provide a definition like:
>  > 
>  > #ifdef CONFIG_X86_64
>  > #define cpu_x86_64 1
>  > #else
>  > #define cpu_x86_64 0
>  > #endif
>  > 
>  > and the you can remove the horrible #ifdef clutter and make the quoted 
>  > function look like:
>  > 
>  > static inline unsigned int get_nmi_count(int cpu)
>  > {
>  > 	return cpu_x86_64 ? cpu_pda(cpu)->__nmi_count : nmi_count(cpu);
>  > }
>  > 
>  > Much better -- isn't it?
> 
> IMO, no, the #ifdef is preferable.
> 
> Why? Because the #ifdef is a very visible signal to the platform
> people that there are (in this case) subarch differences that force
> "clients" to behave differently on different subarchs. By removing
> the #ifdef you're IMO making it less likely for the platform people
> to take notice and work towards eliminating those differences.

The #ifdef is a poor choice. Maciej is damned right, that the single
function with a clear distinction of the return value is better in
terms of readability and maintenance.

As I said before, We can make this more visible with an uppercase
CONFIG_WHATEVER instaed of the innocent cpu_x86_64 one, but both
solutions are better than #ifdefs and provide simple grepable
patterns.

The awareness of those differences does not depend at all on an
#ifdef. Developers who are aware of the platform differences prefer a
readable not ifdef poluted code base. People who need to be poked into
the difference via an #ifdef are probably not those who can actually
clean it up.

Thanks,

	tglx
