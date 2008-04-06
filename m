Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYDFSvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYDFSvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 14:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYDFSvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 14:51:39 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41058 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbYDFSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 14:51:38 -0400
Message-Id: <1207507897.18129.1246358115@webmail.messagingengine.com>
X-Sasl-Enc: H4HzeaOs8eBg2o/QzzZQ6g3gRbfgXmKdr1EbA46IsheY 1207507897
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "dean gaudet" <dean@arctic.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> 
     <20080401094618.GA24862@mailshack.com>   
   <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert  
   i386
In-Reply-To: <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
Date: Sun, 06 Apr 2008 20:51:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Apr 2008 10:03:43 -0700 (PDT), "dean gaudet" <dean@arctic.org>
said:
> fwiw there's a way to do ffz / ntz which can do lg(n) conditional moves in 
> parallel... i'm not sure what (non-x86) architectures this might be best 
> on, but it might be a good choice for the generic code... although maybe 
> the large number of constants required will be a burden on RISC 
> processors.

Hello Dean,

The current generic implementation of ffz is O(lg(n)) already, but
the version you suggest might indeed be a bit faster if the compiler
recognises that is can use conditional moves and the architecture
can handle large constants efficiently.

On the other had, the bit-search functions tend to be avoided as
much as possible, because they are often not implemented as a
hardware instruction and even if they are implemented in hardware,
they might be slow. The generic version is slow anyhow. That's
why the bitmap searches first test if a word in the bitmap is
all-0-bits/all-1-bits. The single-word version of ffz might even
be better off if it was optimized for size instead of being fully
unrolled!

> take a look at figure 5-17 here http://hackersdelight.org/revisions.pdf
> 
> int ntz(unsigned x) {
> 	unsigned y, bz, b4, b3, b2, b1, b0;
> 	y = x & -x; // Isolate rightmost 1-bit.
> 	bz = y ? 0 : 1; // 1 if y = 0.
> 	b4 = (y & 0x0000FFFF) ? 0 : 16;
> 	b3 = (y & 0x00FF00FF) ? 0 : 8;
> 	b2 = (y & 0x0F0F0F0F) ? 0 : 4;
> 	b1 = (y & 0x33333333) ? 0 : 2;
> 	b0 = (y & 0x55555555) ? 0 : 1;
> 	return bz + b4 + b3 + b2 + b1 + b0;
> }

Note: mask32 = ~0ul; mask16 = mask32 ^ (mask32 << 16), mask8 = ...

Greetings,
    Alexander
> 
> -dean
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

