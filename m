Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbXLNUpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbXLNUpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbXLNUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:45:32 -0500
Received: from ruby.spiritone.com ([216.99.193.130]:43791 "EHLO
	ruby.spiritone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXLNUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:45:31 -0500
Message-ID: <4762EB63.8070100@BitWagon.com>
Date: Fri, 14 Dec 2007 12:45:23 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
References: <4762DAB1.1020807@BitWagon.com> <20071214201305.GL19691@waste.org>
In-Reply-To: <20071214201305.GL19691@waste.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> Yes, we use uninitialized data. But it's not a leak in any useful
> sense. To the extent the previous data is secret, this actually
> improves our entropy.
> 
> It's getting folded into the random number pool, where it will be
> impossible to recover it unless you already know what was in the
> pool.  And if you know what's in the pool, you've already broken into
> the kernel.

The combination of capturing data from other users, plus seeding
the pool with your own data, just might be powerful enough to help
steal secrets, sometime in the next five years, from data that is
recorded today.

> But I'm sympathetic to making Valgrind happy.  ...

> [The code in John's patch is] hideous.  How about a memset instead ...

> And [John's] change is broken..   We have to add precisely the
> number of bytes returned by extract_entropy to keep the books
> balanced.

Matt is correct.  The rolled-up result follows.

Signed off by: jreiser@BitWagon.com

--- ./drivers/char/random.c.orig	2007-12-14 11:06:03.000000000 -0800
+++ ./drivers/char/random.c	2007-12-14 12:27:23.000000000 -0800
@@ -708,6 +708,8 @@

 		bytes=extract_entropy(r->pull, tmp, bytes,
 				      random_read_wakeup_thresh / 8, rsvd);
+		/* clear uninitialized bytes at the end to make valgrind happy */
+		memset((char *)tmp + bytes, 0, -bytes & 3);
 		add_entropy_words(r, tmp, (bytes + 3) / 4);
 		credit_entropy_store(r, bytes*8);
 	}
-- 
John Reiser, jreiser@BitWagon.com

