Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbYGKSSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbYGKSSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYGKSSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:18:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbYGKSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:18:05 -0400
Date: Fri, 11 Jul 2008 11:16:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080711180757.37CC9154213@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807111110330.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <20080711180757.37CC9154213@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Roland McGrath wrote:
>
> > +		/* Only check signals if we have filled at least one entry! */
> > +		if (signal_pending(current))
> > +			return -EINTR;
> 
> Shouldn't it return the short count?  
> (And if not, then probably should be -ERESTARTSYS.)

readdir (getdents) is a complex system call, and the path is

    sys_getdents64() ->
      vfs_readdir (with 'filldir64' as a callback) ->
        low-level filesystem 'readdir' function ->	
          filldir64 callback

and what happens is that when that 'filldir64()' callback returns an 
error, the low-level filesystem just stops and returns with a success 
(because everything worked for _it_ - it was the callback that errored 
out).

The 'sys_getdents64()' then does:

	..
	lastdirent = buf.previous;
        if (lastdirent) {
                typeof(lastdirent->d_off) d_off = file->f_pos;
                error = -EFAULT;
                if (__put_user(d_off, &lastdirent->d_off))
                        goto out_putf;
                error = count - buf.count;
        }
	..

ie we'll do that "return partial buffer size" at that level, not deep in 
the callback.

So making the callback just return an error is the right thing to do - 
because the callers will then fix up the file offset in the last directory 
entry and the final return value.

			Linus
