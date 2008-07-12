Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYGLRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYGLRnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 13:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYGLRmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 13:42:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYGLRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 13:42:54 -0400
Date: Sat, 12 Jul 2008 10:41:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <87mykn2sos.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <87mykn2sos.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Andi Kleen wrote:
> 
> Linus, the fact that is not explained by your theory is why
> Ctrl-Z+kill works but Ctrl-C doesn't.

Umm. Read the reports more carefully. Many of the complaints are about ^Z 
too.

More-over, ^Z and ^C are very different from an app standpoint. A _lot_ of 
applications block or catch ^C (SIGINT), while doing the same for ^Z 
(SIGTSTP) and SIGTERM is much less common (but possible: a tty sends 
SIGTSTP, which is blockable, not SIGSTOP, which is not).

The reason? It's quite common to catch ^C in order to do cleanup. The 
common handler case is that you catch SIGINT, do cleanup, and then kill 
yourself with SIGINT in order to make it _look_ like you reacted directly 
to the ^C.


So there are a _lot_ of loads where ^C will not kill things immediately, 
but ^Z + SIGKILL (or SIGTERM, the default for "sig") will.

Try doing a "yum update", for example.

Or use 'git', for that matter. git does exactly that kind of thing: 
catches SIGINT and removes temp-files etc. But if you kill it manually 
using some "stronger" signal (and using ^Z to get the shell back before 
you do that is obviously one way), that won't happen.

And trust me, git is not at all unusual in this respect.

			Linus
