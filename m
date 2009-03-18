Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZCRO6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZCRO6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 10:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZCRO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 10:57:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbZCRO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 10:57:50 -0400
Date: Wed, 18 Mar 2009 07:52:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?G=E1bor_Melis?= <mega@retes.hu>
cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: RT signal queue overflow (Was: Q: SEGSEGV && uc_mcontext->ip
 (Was: Signal delivery order))
In-Reply-To: <200903181002.07584.mega@retes.hu>
Message-ID: <alpine.LFD.2.00.0903180742320.3082@localhost.localdomain>
References: <200903141750.37238.mega@retes.hu> <20090317041337.GA29740@redhat.com> <20090318075901.4FA19FC3AB@magilla.sf.frob.com> <200903181002.07584.mega@retes.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Mar 2009, Gábor Melis wrote:
> 
> It was just a month or so ago when I finally made to change to use a 
> non-real-time signal for signalling stop-for-gc.

Ahh, and that is when you noticed the issue with SIGSEGV?

One thing you might try is to still use a non-real-time signal, but simply 
depend on the fact that signals are basically peeled off the signal 
bitmask in a signal number order (with the exception that fatal signals 
are handled specially).

IOW, on x86, just about the _only_ normal user-generated signal that can 
happen before SIGSEGV is SIGUSR1, because SIGSEGV is 11, and SIGUSR1 is 
10.

If you were to use SIGUSR2 (signal #12) you'd probably never see this.

Of course, there are other signals with numbers < 11, but they are 
generally meant for other synchronous traps (ie signals like 
SIGTRAP/AIGABRT/SIGFPE/SIGBUS), or for killing the process (signals
SIGHUP/SIGINT/SIGQUIT).

So maybe you'd be happy with just picking another signal? It's not a 
_pretty_ solution, but it should work across most kernel versions.

			Linus
