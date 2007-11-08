Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXKHHOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXKHHOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXKHHOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:14:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38693
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbXKHHOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:14:41 -0500
Date: Wed, 07 Nov 2007 23:14:40 -0800 (PST)
Message-Id: <20071107.231440.145888291.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: paulus@samba.org, lkml@davidb.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071107230916.fa301e5a.akpm@linux-foundation.org>
References: <20071107212005.f039c279.akpm@linux-foundation.org>
	<20071107.222530.156152513.davem@davemloft.net>
	<20071107230916.fa301e5a.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 7 Nov 2007 23:09:16 -0800

> I don't think that's a big problem?  This syscall can (oddly) return any
> 32-bit (64-bit) number and a smart application developer (after saying wtf)
> would realise that he just can't check for errors and have correctly
> working code.
> 
> Then again, if he was smart he just wouldn't use times(2)'s return value
> for anything.  But what is the alternative?  I don't think there is one,
> apart from much saner things like gettimeofday().

You and I would say "wtf", but the manual states what it does:

	On error, (clock_t) -1 is returned, and errno is  set  appro-
	priately.

And I think this (obviously bogus) convention is something we
are really stuck with.

Another awful aspect of this is that glibc is going to overwrite
'errno' for this return value range.  That will likely cause more
application misbehavior than some of the other side effects we've been
discussing.

In short we have two problems:

1) glibc thinks -4096 < x < 0 is an error, and will write this
   value into errno and return -1 to the application

2) the manual states that -1 means error

