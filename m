Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYGMTJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYGMTJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYGMTJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:09:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbYGMTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:09:39 -0400
Date: Sun, 13 Jul 2008 12:08:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <487A5082.6050704@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807131204280.2959@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <87mykn2sos.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807121030260.2875@woody.linux-foundation.org>
 <4879CCFD.70208@firstfloor.org> <alpine.LFD.1.10.0807131017180.2959@woody.linux-foundation.org> <487A5082.6050704@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Jul 2008, Andi Kleen wrote:
> 
> While the bit about color ls (which I use here) catching signals was
> also interesting I wouldn't expect the color ls to take longer to
> process Ctrl-C even if it hits user space because it shouldn't
> do anything block here (unless the terminal is in flow control,
> but is unlikely)

I didn't take a look at the source, but I literally think that the 'ls' 
SIGINT handler is something like

	static void sigint(int signr)
	{
		exit_with_sigint = 1;
	}

and then in the output routine it does a

	if (exit_with_sigint) {
		signal(SIGINT, SIG_DFL);
		kill(-1, SIGINT);
	}

at the end because that's the only thing that explains that it always 
exits after printing the _first_ line of output (ignoring the header - it 
obviously doesn't have that "if (exit_with_sigint)" test in that 
code-path).

Sad. Horrible crap. It means that it totally disables the kernels ability 
to make fatal signals break out of disk wait etc. It's also totally 
_unnecessary_, because 'ls' shouldn't even bother to block signals until 
just before it starts doing the printout.

Oh well. You can't expect too much of user level programmers.

			Linus
