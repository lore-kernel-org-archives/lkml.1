Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYKDTsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYKDTsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYKDTru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:47:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbYKDTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:47:49 -0500
Date: Tue, 4 Nov 2008 11:47:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: __bprm_mm_init(): remove uneeded goto
Message-Id: <20081104114703.c950f078.akpm@linux-foundation.org>
In-Reply-To: <20081104171414.6c1a8b52@doriath.conectiva>
References: <20081104140314.1b196764@doriath.conectiva>
	<20081104105707.39dc5e30.akpm@linux-foundation.org>
	<20081104171414.6c1a8b52@doriath.conectiva>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 17:14:14 -0200
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:

> Em Tue, 4 Nov 2008 10:57:07 -0800
> Andrew Morton <akpm@linux-foundation.org> escreveu:
> 
> | The above code now uses the most common pattern for a kernel
> | function.  One we've learned from hard experience!
> 
>  Wow, I have no words to thank you enough for this full explanation!

How about "don't be so anal"?

I have more!

The code as we have it now looks like this:

foo()
{
	if (!(mem = kmalloc(...)))
		return -ENOMEM;

	down(sem);
	err = something();
	if (err)
		goto err;
	...
	return 0;
err:
	up(sem);
	kfree(mem);
	return err;
}

it is legitimate (and arguably better) to do:

foo()
{
	if (!(mem = kmalloc(...))) {
		err = -ENOMEM;
		goto err;
	}

	down(sem);
	err = something();
	if (err)
		goto err_locked;
	...
	return 0;
err_locked:
	up(sem);
	kfree(mem);
err:
	return err;
}

so we now have a single `return' point and we've maximised
maintainability.  But that's a fairly minor detail, and we often leave
those initial `return's in place.




Secondly, there are instruction-cache concerns.

This code:

foo()
{
	if (!(mem = kmalloc(...)))
		return -ENOMEM;

	down(sem);
	err = something();
	if (err) {
		up(sem);
		kfree(mem);
		goto err;
	}
	...
	return 0;
}

might cause the instructions for the `up' and the `kfree' to be laid
out in the middle of the function fastpath.  This will, on average,
cause the function to consume additional instruction cache lines.

Doing this:

foo()
{
	if (!(mem = kmalloc(...)))
		return -ENOMEM;

	down(sem);
	err = something();
	if (err)
		goto err;
	...
	return 0;
err:
	up(sem);
	kfree(mem);
	return err;
}

will, we hope, help the compiler to move the rarely-executed error-path
instructions out of line, thus maybe reducing the function's average
icache footprint.  The fastpath now spans a smaller address range.


We used to do this trick a *lot* in the kernel (back in the 2.2 days?)
for this performance reason.  Nowdays gcc is a lot more complex and we
hope that it can sometimes work these things out for itself and we hope
that `unlikely' might cause the compiler to move the unlikely code out
of line.  But I don't know how successful the compiler is at doing
this, and it'll be dependent upon the gcc version, the wind direction,
etc.

As long as it doesn't muck up the code readability, I expect that it's
still beneficial to provide this layout hint to the compiler.  A bit of
poking around in the .s files would be instructive..

