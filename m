Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbXFOOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbXFOOur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbXFOOtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:11 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40999 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbXFOOtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:04 -0400
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
From: Vasily Tarasov <vtaras@openvz.org>
Reply-To: vtaras@openvz.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org, dev@sw.ru,
       devel@openvz.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       nataliep@google.com, vvs@sw.ru
In-Reply-To: <200706151243.02186.arnd@arndb.de>
References: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
	 <200706151243.02186.arnd@arndb.de>
Content-Type: text/plain
Organization: OpenVZ community
Date: Fri, 15 Jun 2007 18:48:02 +0400
Message-Id: <1181918882.3241.48.camel@dhcp0-149.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 12:43 +0200, Arnd Bergmann wrote:
> On Friday 15 June 2007, Mikael Pettersson wrote:
> > > --- linux-2.6.22-rc4-fixed/fs/quota.c.orig    2007-06-14 15:55:26.000000000 +0400
> > > +++ linux-2.6.22-rc4-fixed/fs/quota.c 2007-06-14 19:50:13.000000000 +0400
> > ...
> > > +#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> > > +/*
> > > + * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
> > > + * and is necessary due to alignment problems.
> > > + */
> > 
> > The #ifdef looks way too arch-specific. And isn't there a shared
> > compat.c module somewhere that this should go into?
> > 
> 
> Only x86_64 and ia64 have this particular problem, the other architectures,
> and hopefully all future 64 bit platforms with 32 bit user space use
> the same alignment rules in elf32 and elf64.
> 
> Still, the patch should be converted to use the compat_u64 type and not
> add an 'attribute((packed))' so that you _can_ use the same code on all
> architectures. See my 'Introduce compat_u64 and compat_s64 types' patch
> that I just posted in another thread.
> 
> 	Arnd <><
> 

Hello, 

I just noticed that we can not avoid the addition of packed attribute.
Look, for example:

struct if_dqblk {
        __u64 dqb_bhardlimit; 
        __u64 dqb_bsoftlimit;
        __u64 dqb_curspace;
        __u64 dqb_ihardlimit;
        __u64 dqb_isoftlimit;
        __u64 dqb_curinodes; 
        __u64 dqb_btime;
        __u64 dqb_itime;
        __u32 dqb_valid;
};

sizeof(if_dqblk) = 0x48
On 32 bit: 0x44

If I replace __u64/__u32 with compat equivalents - it will not help!
alligned attribute can _only_ _increase_ the size of structure, but not
decrease it.

So we should use packed or just use the array of ints: int[2].

Vasily



