Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYBRUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYBRUBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbYBRUBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:01:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14787 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643AbYBRUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oC3Ql1jThYr9G9HTZ/ZZXWp1sh7HrgMDX5plf8LAQB8Ujfmf6C8FkpuS+6g7kpdFR4GVgMXgcBJ2WdojXMf7UE9Ie9V5ey047dhr8uxXIA/k+1QGYwG65+ASNKWAloB8J7BIw0lZl8qT4w0PV3NmACJCJj8sJyfwndzq6Ibi2yo=
Message-ID: <6101e8c40802181201m2cb8ba3ag3bb5f1dd35be6961@mail.gmail.com>
Date: Mon, 18 Feb 2008 21:01:20 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y #2] Be more robust about bad arguments in get_user_pages()
Cc: "Jonathan Corbet" <corbet@lwn.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy. Dunlap" <rdunlap@xenotime.net>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Dave Jones" <davej@redhat.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>
In-Reply-To: <6101e8c40802170918n19c2fb19l29b564fc289fe77e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802170918n19c2fb19l29b564fc289fe77e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From a8a7690626756b6dcd49ad23b58f4406bfa59d7f Mon Sep 17 00:00:00 2001
 From: Jonathan Corbet <corbet@lwn.net>
 Date: Mon, 11 Feb 2008 16:17:33 -0700
 Subject: [PATCH] Be more robust about bad arguments in get_user_pages()
 
 MAINLINE: 900cf086fd2fbad07f72f4575449e0d0958f860f
 
 So I spent a while pounding my head against my monitor trying to figure
 out the vmsplice() vulnerability - how could a failure to check for
 *read* access turn into a root exploit? It turns out that it's a buffer
 overflow problem which is made easy by the way get_user_pages() is
 coded.
 
 In particular, "len" is a signed int, and it is only checked at the
 *end* of a do {} while() loop.  So, if it is passed in as zero, the loop
 will execute once and decrement len to -1.  At that point, the loop will
 proceed until the next invalid address is found; in the process, it will
 likely overflow the pages array passed in to get_user_pages().
 
 I think that, if get_user_pages() has been asked to grab zero pages,
 that's what it should do.  Thus this patch; it is, among other things,
 enough to block the (already fixed) root exploit and any others which
 might be lurking in similar code.  I also think that the number of pages
 should be unsigned, but changing the prototype of this function probably
 requires some more careful review.
 
 Signed-off-by: Jonathan Corbet <corbet@lwn.net>
 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 CC: Oliver Pinter <oliver.pntr@gmail.com>
 
 diff --git a/mm/memory.c b/mm/memory.c
 index f64cbf9..538f054 100644
 --- a/mm/memory.c
 +++ b/mm/memory.c
 @@ -983,6 +983,8 @@ int get_user_pages(struct task_struct *tsk, struct
 mm_struct *mm,
  	int i;
  	unsigned int vm_flags;
 
 +	if (len <= 0)
 +		return 0;
  	/*
  	 * Require read or write permissions.
  	 * If 'force' is set, we only require the "MAY" flags.
 
 
 -- 
 Thanks,
 Oliver

