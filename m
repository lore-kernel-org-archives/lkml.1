Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYGKXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYGKXYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYGKXYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:24:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbYGKXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:24:07 -0400
Date: Fri, 11 Jul 2008 16:22:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Linus Torvalds wrote:
> 
> No, after testing more, I think Edwin is right.

Naah. It is true that there is a huge delay in doing

	ls -l /usr/bin

and then pressing ^C, but after having hit my head against this for a 
while, I realized that it has nothing to do with the kernel.

Doing an "strace ls" showed that ls doesn't play any games with signals 
etc, which fooled me into looking for a kernel reason. 

HOWEVER, it looks like at least fedora does a

	alias ls='ls --color=auto'

and it turns out that if you do that --color=auto, then ls will indeed 
catch all normal signals and set a "please stop now" flag, instead of 
dying immediately. The reason is probably to avoiding leaving the terminal 
with some odd color if interrupted in an inconvenient place.

So I was chasing this latency thing totally unnecessarily. It's in user 
space (or at least _my_ particular issue was).

Other user cases may obviously be elsewhere.

		Linus
