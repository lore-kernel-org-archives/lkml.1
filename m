Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXCNFkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXCNFkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933873AbXCNFkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:40:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59141
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933870AbXCNFkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:40:36 -0400
Date: Tue, 13 Mar 2007 22:40:35 -0700 (PDT)
Message-Id: <20070313.224035.70218068.davem@davemloft.net>
To: nish.aravamudan@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, akpm@osdl.org,
       torvalds@osdl.org, stable@kernel.org, sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.20.3
From: David Miller <davem@davemloft.net>
In-Reply-To: <29495f1d0703131729y56a99d9cj15288e7c18e277a8@mail.gmail.com>
References: <20070313.152054.31641425.davem@davemloft.net>
	<29495f1d0703131551k5c06170bma138f8c1f1f9c84e@mail.gmail.com>
	<29495f1d0703131729y56a99d9cj15288e7c18e277a8@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
Date: Tue, 13 Mar 2007 17:29:17 -0700

> Ok, truly bizarre, I found that I was not running stock 2.6.20.3, but
> had your small hugetlb patch on top.
> 
> So I went back and patched 2.6.20.1 with your patch, rebooted, got a
> soft lockup. Went back to stock 2.6.20.1 and did not.
> 
> I don't see how your patch (C&P below for reference) could make any
> difference...Especially because no hugepages were in use at the time.
> On patched 2.6.20.1, I was just trying to check if my source tree had
> your patch applied (by `patch -p1 < davem.patch`) and got the
> soft-lockup I saw in 2.6.20.3 with the patch applied. I am going to
> try a clean 2.6.20.3 as well, now.

We've seen cases in the past where something benign like this
triggers a bug because it moves the data/bss/etc. sections
around.

For example, if the used parts of the kernel image end up extending
into another page, this can influence the bootup memory detection
logic.

The softlockup in your first trace shows it spinning in the journaling
code.  Perhaps what is happening is that it is looping endlessly over
some data structure which is in a corrupted state.  This could happen
if the bootup code erroneously frees up pages it should not have.
I would recommend figuring out exactly what the journaling code is
stuck on, then try to trace the life of that page of memory from
early bootup until it is allocated.

I hope this can help you figure out this bug as I can't reproduce it
here at all, and I did merge the hugetlb fix into Linus's tree
already (and that is the right thing to do as we certainly have some
unrelated bug here).

On the flip side, I bet removing some kernel config option might make
the heisenbug go away if you're just eager to test the hugetlb patch
:-)
