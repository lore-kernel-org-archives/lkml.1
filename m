Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZDZV5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZDZV5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 17:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZDZV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 17:56:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45149 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZDZV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 17:56:49 -0400
Date: Sun, 26 Apr 2009 17:53:42 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections
 -fdata-sections
In-Reply-To: <20090426090906.GA27809@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0904261332110.10199@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org> <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <20090426090906.GA27809@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Sam Ravnborg wrote:

> I was not specific in my last mail about this - but I assume you have
> understood that the naming ".head.text" was selected so it is compatible
> wiht -ffunction-sections. In other words no need for any ugly ".." here.

Yes, I did notice this.  However, I think that the ".text..foo" naming 
scheme is a better choice than the ".head.text" naming scheme.

One advantage is that it works better if people add new assembly code in 
that section without using the proper macros.  With ".head.text", if 
someone were to naively write ".section .head.text", the section would not 
have the SEC_ALLOC flag set.  With ".text..head", gcc will assume the "ax" 
section flags, and everything will work fine.

More importantly, the .head.text naming scheme fails for BSS sections.  
If you replace

__attribute__((__section__(".bss.page_aligned")));

with 

__attribute__((__section__(".page_aligned.bss")));

then you get section flags of @progbits rather than @nobits, which is 
inappropriate for bss.  The ".bss..page_aligned" naming scheme supports 
this just fine.

Since it is desirable to have the Linux magic section names all use a 
single naming scheme, this is why we settled on the .text..foo section 
naming style.

> We should try to be as consistent as possible across architectures here
> so it is better to toach a few additiona files rather than adding macros
> and the like to accept there sub-optimal section naming.

I'm OK with doing this.  But I prefer to avoid having ".head.text" appear 
in all these places as it encourages people to write new code using 
".head.text".

Also, as discussed above, we may want to change the name to ".text..head" 
for consistency in the future, and having everything use the macros makes 
this really easy.

	-Tim Abbott
