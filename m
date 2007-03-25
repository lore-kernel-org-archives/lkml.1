Return-Path: <linux-kernel-owner+w=401wt.eu-S965075AbXCYE2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965075AbXCYE2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965088AbXCYE2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:28:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbXCYE2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:28:10 -0400
Date: Sat, 24 Mar 2007 21:28:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: yuan cooper <yuanxjtu@hotmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dmitry.torokhov@gmail.com
Subject: Re: About GCC4 Optimization
In-Reply-To: <BAY144-F24481F006CCA5D5D74D6F4DF680@phx.gbl>
Message-ID: <Pine.LNX.4.64.0703242123310.6730@woody.linux-foundation.org>
References: <BAY144-F24481F006CCA5D5D74D6F4DF680@phx.gbl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1281457997-1174796886=:6730"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1281457997-1174796886=:6730
Content-Type: TEXT/PLAIN; charset=gb2312
Content-Transfer-Encoding: 8BIT



On Sun, 25 Mar 2007, yuan cooper wrote:
>  
> during my work, I found there is a bug with GCC4 O2 optimization.

Technically, it's a misfeature fo gcc4, not a bug.

The C language allows for type-based alias detection, and gcc notices that 
a "float *" cannot ever alias with a "unsigned long *", so it decides to 
not even do the loads and stores..

Now, there's two things wrong with this picture:

 - gcc is being an ass. type-based alias detection should happen only as a 
   last resort, and gcc should know and notice that *despite* the types 
   being different, they definitely alias.

   So what gcc does may be technically legal, but it's still a horribly 
   bad thing to do. Sadly, some gcc people seem to care more about "letter 
   of the law" than "sanity and quality of implementation".

 - as a result, you should always compile any kernel stuff with 
   "-fno-strict-aliasing", which should turn this off. If it *still* 
   happens with that flag, then it is indeed a compiler bug.

> float ftmp;
> unsigned long tmp;
> ftmp = 1.0/1024.0;
> tmp  = *(unsigned long *)(&ftmp);
> tmp  = (tmp >> 11) && 0xFFF;
>  
> if optimization level is O2, gcc will MOV eax to tmp, but current eax has a random value.
> -O is ok and gcc3 with O2 is ok too.

That said, you really _really_ shouldn't be doing FP in the kernel anyway.

		Linus
---1463790079-1281457997-1174796886=:6730--
