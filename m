Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZBXE3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZBXE3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 23:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZBXE3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 23:29:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbZBXE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 23:29:34 -0500
Date: Mon, 23 Feb 2009 20:28:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance regression in write() syscall
In-Reply-To: <200902241510.33911.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902241510.33911.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, Nick Piggin wrote:
> 
> What does unixbench's fstime test do? If it is just writing to the
> pagecache, then this would be unexpected.

Hmm. Not necessarily. Even just plain writes may be slowed down, since the 
nontemporal loads and stores are generally slower than the normal case. So 
it does make some kind of sense to try to avoid the noncached versions for 
small writes - because small writes tend to be for temp-files.

I don't know if PAGE_SIZE is the right thing to test, and I also don't 
know if this is necessarily the best place to test it in, but I don't 
think it's necessarily wrong to do something like this.

In fact, I think we might also just check alignment. Doing the nontemporal 
crud makes little sense for a non-8-byte-aligned destination, since it 
will have to do the alignment stores cached anyway - and mixing them 
across a cacheline is just crazy.

(The test program doesn't seem to be testing that particular case)

			Linus
