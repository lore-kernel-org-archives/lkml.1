Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbXGMJ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbXGMJ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXGMJ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:58:50 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:7134 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXGMJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:58:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pQkanQHfePlyQhHteYgERQL8K2ZYuurxBlCLSDDPv3C244ggj8FpjQC2VhNxGAmYv5YFq3qxVYdtBLCGYSDX87qizbQdl96ra3Y3kFwgzYDarfivt/sTk3ZK3W6OgPchEY2Z1TPxBuchhiNiug54sLNWrmOw8hOmuagVBIY7iV8=
Message-ID: <40378e40707130258j7e3571e2h8a97c332e0b1b4b6@mail.gmail.com>
Date: Fri, 13 Jul 2007 11:58:47 +0200
From: "Mohamed Bamakhrama" <bamakhrama@gmail.com>
Reply-To: bamakhrama@gmail.com
To: linux-kernel@vger.kernel.org
Subject: CACHE instruction on MIPS32 24KE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,
I have one question regarding the CACHE instruction in the MIPS32
24KE core. In the software user's manual (page 317), it mentions that it is
possible to perform "fetch & lock" operation on a given cache line.
I am developing a driver for 2.4.31 kernel and I want to be able to
lock some "hot spots" inside the instruction cache to maximize the
throughput. Nevertheless, the manual states that if all the 4-ways of
the cache set were locked, then the core will just replace one of
them. So theoretically, the core should overwrite one of the ways in
case of the first collision and then use that overwritten line for
subsequent collisions. What I observe in my program is different. The
# of I$ misses is the same. I tried to move the locking code around
and when I did it just before the basic block I got an improvement of
20% only!!
My questions are:
1) Are there any parts in the kernel which unlocks the I$ lines under
some circumstances?
2) Is there anyone who worked with the cache instruction under MIPS
before and have any ideas about this behaviour?

Here is the macro used for cache locking:


***** BEGIN CODE *****

#define LOCK_IN_CACHE(function, lines)   \
       asm volatile (  ".set   mips32 \n"      \
                       ".set   noreorder \n"   \
                       "lock_me_" #function ": \n"      \
                       "       cache   0x1C, 0x00(%0) \n"      \
                       "       addiu   %z0, %z0, 0x20 \n"      \
                       "       sub     %z1, %z1, %z3  \n"      \
                       "       bgez    %z1, lock_me_" #function " \n"   \
                       ".set   mips0 \n"       \
                       : : "Jr" (&function),    \
                       "Jr" (lines), "Jr" (0), "Jr" (1));

***** END CODE *****

Best Regards,

--
Mohamed
