Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbYEGSYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbYEGSYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbYEGSYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:24:14 -0400
Received: from aun.it.uu.se ([130.238.12.36]:61985 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829AbYEGSYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:24:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18465.62390.662295.733626@alkaid.it.uu.se>
Date: Wed, 7 May 2008 20:23:50 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       armin76@gentoo.org
Subject: Re: [BUG] 2.6.26-rc1 hangs during boot on UltraSPARC 5
In-Reply-To: <20080506.152042.91330094.davem@davemloft.net>
References: <18464.3741.133714.308327@harpo.it.uu.se>
	<20080506.010523.113767579.davem@davemloft.net>
	<18464.46000.226753.230481@alkaid.it.uu.se>
	<20080506.152042.91330094.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Tue, 6 May 2008 21:38:24 +0200
 > 
 > > I removed "| CON_BOOT" and got what looks like the same oops
 > > Raúl Porcel reported earlier today (which he for some reason
 > > sent only to the lists, not to you or me); his oops was:
 > 
 > I can reproduce this problem here in my t1000.
 > 
 > It looks like some kind of initrd regression.
 > 
 > Looking at the crashes, the kernel seems to be trying
 > to dereference a physical address when peeking at the
 > initrd instead of using a virtual one.  That's a big
 > clue.
 > 
 > This patch should fix it:
 > 
 > commit d45100f7b69e3d9cd0cd5e956b6ac2c78d460d07
 > Author: David S. Miller <davem@davemloft.net>
 > Date:   Tue May 6 15:19:54 2008 -0700
 > 
 >     sparc64: Fix initrd regression.
 >     
 >     We die because we forget to convert initrd_start and
 >     initrd_end to virtual addresses.
 >     
 >     Reported by Mikael Pettersson
 >     
 >     Signed-off-by: David S. Miller <davem@davemloft.net>
 > 
 > diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
 > index db8e7fb..ec3e2c7 100644
 > --- a/arch/sparc64/mm/init.c
 > +++ b/arch/sparc64/mm/init.c
 > @@ -771,6 +771,9 @@ static void __init find_ramdisk(unsigned long phys_base)
 >  		initrd_end = ramdisk_image + sparc_ramdisk_size;
 >  
 >  		lmb_reserve(initrd_start, initrd_end);
 > +
 > +		initrd_start += PAGE_OFFSET;
 > +		initrd_end += PAGE_OFFSET;
 >  	}
 >  #endif
 >  }

This solved my boot problem. Thanks.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>
