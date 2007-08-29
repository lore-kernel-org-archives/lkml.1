Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbXH2WyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbXH2WyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbXH2Wx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:53:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:34520 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXH2Wx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HYCXuOibLQui27ndcmF5kT/CsFEB6GfinXOLhpaWedoKPByO1DqJVUxvVH/XPOO/RrNZgaKz+nNbk605CBkyihK+fkS5BMLvSDBBY35oytCMGGgSiXrxdi5jm8Pb3JlUivj79XaH4N1hAcpr34YRl73LAC/gi+rSRuitnjIZs/Y=
Message-ID: <9a8748490708291553j4c21bdf0ueae0b51c99c8190a@mail.gmail.com>
Date: Thu, 30 Aug 2007 00:53:56 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Eric Sandeen" <sandeen@redhat.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46D5F462.9010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D5F462.9010401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/2007, Eric Sandeen <sandeen@redhat.com> wrote:
> Noticed today that the combination of 4KSTACKS and DEBUG_STACKOVERFLOW
> config options is a bit deadly.
>
> DEBUG_STACKOVERFLOW warns in do_IRQ if we're within THREAD_SIZE/8 of the
> end of useable stack space, or 512 bytes on a 4k stack.
>
> If we are, then it goes down the dump_stack path, which uses most, if
> not all, of the remaining stack, thereby turning a well-intentioned
> warning into a full-blown catastrophe.
>
...
>
> 448 bytes to tell us that we're within 512 bytes (or less) of certain
> doom... and I think there's call overhead on top of that?
>
> The large stack usage in those 2 functions is due to big char arrays, of
> size KSYM_NAME_LEN (128 bytes) and KSYM_SYMBOL_LEN (223 bytes).
>
> IOW, the stack warning effectively reduces useful stack left in our itty
> bitty 4k stacks by over 10%.
>
> Any suggestions for ways around this?  The warning is somewhat helpful,
> and I guess the obvious option is to lighten up the dump_stack path, but
> it's still effectively reducing precious available stack space by some
> amount.
>
A first step could be to allocate those two char arrays with kmalloc()
instead of on the stack, but then I guess that dump_stack() gets
called from places where we may not really want to be calling
kmalloc(). I guess we could allocate the buffers earlier (like at boot
time) and store pointers somewhere where dump stack can get to them
later when it needs them.


> With CONFIG_DEBUG_STACK_USAGE, we could print at oops time: "oh, and by
> the way, you blew your stack" if there is no zeroed stack space left, as
> a post-mortem.  Even without that option, I think we could still check
> whether the *current* %esp at oops time has gone too far?  But if we
> blew the stack, returned, and *then* oops, I think it'd be hard to know
> without the DEBUG_STACK_USAGE option that we ran out of room.
>

We could also simply have it warn at a higher limit, like 1024 bytes
instead of 512. But I guess then we would get too many false positives
and make it less useful.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
