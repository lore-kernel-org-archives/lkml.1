Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbYLXLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbYLXLgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYLXLg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:36:29 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44580 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751623AbYLXLg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:36:29 -0500
Date: Wed, 24 Dec 2008 22:36:17 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: asterisk hangs with RT priority
Message-ID: <20081224113617.GA29037@gondor.apana.org.au>
References: <483054DB.4030504@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483054DB.4030504@trash.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 06:10:03PM +0200, Patrick McHardy wrote:
> I'm seeing hanging asterisk processes on startup when using
> RT priority with current -git. Unfortunately I'm not sure about
> the last working version, but it was one of the final 2.6.25 rcs.
> The hang stops when executing "schedtool -N $(pidof asterisk)".

I'm now hitting exactly the same problem with 2.6.28-rc9 (I had
it with 2.6.27 too but thought it might go away on its own :)

I've made a small program to attempt to reproduce this based on
the asterisk code.  Unfortunately it doesn't work on its own.
However, if you run it under strace then it does hang in the
same away as asterisk (which seems to happen after the setuid
call, as strace shows it before hanging and the printk after
it in asterisk gets executed).

Note that the hang goes away if either setscheduler or setuid
is removed.

#include <sched.h>

int main(void)
{
	struct sched_param sched = {.sched_priority = 10};

	sched_setscheduler(0, SCHED_RR, &sched);
	setuid(106);
	return 0;
}

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
