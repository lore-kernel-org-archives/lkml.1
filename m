Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXBVVpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXBVVpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXBVVpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:45:33 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:58414 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbXBVVpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:45:31 -0500
In-Reply-To: <20070222213212.GJ18976@kvack.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <A97A8AFD-3D1C-49EC-84DE-901D900244A0@oracle.com> <20070222213212.GJ18976@kvack.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <00896E31-0A0A-4938-8638-49F893E308EF@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 22 Feb 2007 13:44:07 -0800
To: Benjamin LaHaise <bcrl@kvack.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> direct-io.c is evil.  Ridiculously.

You will have a hard time finding someone to defend it, I predict :).

There is good news on that front, too.  Chris (Mason) is making  
progress on getting rid of the worst of the Magical Locking that  
makes buffered races with O_DIRECT ops so awful.

I'm not holding my breath for a page cache so fine grained that it  
could pin and reference 512B granular user regions and build bios  
from them, though that sure would be nice :).

>> As an experiment, I'm working on backing the sys_io_*() calls with
>> syslets.  It's looking very promising so far.
>
> Great, I'd love to see the comparisons.

I'm out for data.  If it sucks, well, we'll know just how much.  I'm  
pretty hopeful that it won't :).

> One other implementation to consider is actually using kernel threads
> compared to how syslets perform.  Direct IO for one always blocks, so
> there shouldn't be much of a performance difference compared to  
> syslets,
> with the bonus that no arch specific code is needed.

Yeah, I'm starting with raw kernel threads so we can get some numbers  
before moving to syslets.

One of the benefits syslets bring is the ability to start processing  
the next pending request the moment current request processing  
blocks.  In the concurrent O_DIRECT write case that avoids releasing  
a ton of kernel threads which all just run to serialize on i_mutex  
(potentially bouncing it around cache domains) as the O_DIRECT ops  
are built and sent.

-z 
