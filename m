Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbXF3Wco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbXF3Wco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 18:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXF3Wcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 18:32:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3493 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXF3Wcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 18:32:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 15:32:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0> 
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com> 
 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007, Davide Libenzi wrote:

> Think about if we had this for the latest pselect/ppoll/epoll_pwait. 
> Think about how your solution and mine would apply to that very much 
> concrete case.

This is how all those overloaded syscalls looks like, BTW:

        if (sigmask) {
                if (sigsetsize != sizeof(sigset_t))
                        return -EINVAL;
                if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
                        return -EFAULT;
                sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
                sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
        }
        error = sys_XXX(...);
        if (sigmask) {
                if (error == -EINTR) {
                        memcpy(&current->saved_sigmask, &sigsaved,
                               sizeof(sigsaved));
                        set_thread_flag(TIF_RESTORE_SIGMASK);
                } else
                        sigprocmask(SIG_SETMASK, &sigsaved, NULL);
        }

How would you do that with a single shared strcture, w/out adding in all 
signal paths the knowledge of the structure?



- Davide


