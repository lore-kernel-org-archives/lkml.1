Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYHFGa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYHFGa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 02:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYHFGat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 02:30:49 -0400
Received: from ozlabs.org ([203.10.76.45]:45819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYHFGas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 02:30:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Make kthread_stop() not oops when passed a bad pointer
Date: Wed, 6 Aug 2008 11:22:58 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <20080805135559.GQ26461@parisc-linux.org>
In-Reply-To: <20080805135559.GQ26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808061122.59584.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 23:55:59 Matthew Wilcox wrote:
> Make kthread_stop a little more robust against numbskulls
> like me.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Hi Willy,

I really do sympathize with your problem; but the quest is to figure out how 
to identify it before the code is run, not to put a non-orthogonal bandaid 
here which can hurt other cases.

How about a more ambitious "we've oopsed so break a mutex every 30 seconds of 
waiting" patch?

> +     if (!k || IS_ERR(k))
> +             return -EINVAL;

1) There's no reason that kthread_stop is uniquely difficult to use.  Why pick 
on that one?

2) I know that kfree() handles NULL, but kthread_create/kthread_run never 
return NULL, unlike kmalloc().

3) If we really want to pass a failed kthread_create() through kthread_stop(), 
we should return PTR_ERR(k) here.  But that should only be done if it made it 
harder for the callers to screw up, which I don't think it does.

4) After a successful kthread_run(), kthread_stop() will always return the 
value from the threadfn callback.  ie. kthread_stop() doesn't ever fail.  A 
simple semantic, which this patch breaks.

5) Covering up programmer errors is not good policy.  I dislike WARN_ON() 
because an oops is much harder to miss.  Painful for you, but The System 
Works.

Sorry,
Rusty.
