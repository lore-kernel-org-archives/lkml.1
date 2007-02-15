Return-Path: <linux-kernel-owner+w=401wt.eu-S1030244AbXBORFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244AbXBORFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXBORFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:05:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4687 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030244AbXBORFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:05:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Feb 2007 09:05:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702150847420.10697@alien.or.mcafeemobile.com>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Linus Torvalds wrote:

> I don't think the "atom" approach is bad per se. I think it could be fine 
> to have some state information in user space. It's just that I think 
> complex interfaces that people largely won't even use is a big mistake. We 
> should concentrate on usability first, and some excessive cleverness 
> really isn't a big advantage.
> 
> Being able to do a "open + stat" looks like a fine thing. But I doubt 
> you'll see a lot of other combinations.

I actually think that building chains of syscalls bring you back to a 
multithreaded solution. Why? Because suddendly the service thread become 
from servicing a syscall (with possible cachehit optimization), to 
servicing a whole session. So the number of service threads needed (locked 
down by a chain) becomes big because requests goes from being short-lived 
syscalls to long-lived chains of them. Think about the trivial web server, 
and think about a chain that does open->fstat->sendhdrs->sendfile after an 
accept. What's the difference with a multithreaded solution that does 
accept->clone and execute the above code in the new thread? Nada, NIL. 
Actually, there is a difference. The standard multithreaded function is 
easier to code in C than with the complex atoms chains. The number of 
service thread becomes suddendly proportional to the number of active 
sessions.
The more I look at this, the more I think that async_submit should submit 
simple syscalls, or an array of them (unrelated/parallel).



- Davide


