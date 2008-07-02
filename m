Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYGBOGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYGBOGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYGBOGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:06:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbYGBOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:06:39 -0400
Message-ID: <486B8B6C.2050109@firstfloor.org>
Date: Wed, 02 Jul 2008 16:06:36 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org>	<m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>	<alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org> <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
In-Reply-To: <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +unsigned long
> +copy_user_handle_tail(char *to, char *from, unsigned len, unsigned zerorest)
> +{
> +	char c;
> +	unsigned zero_len;
> +
> +	for (; len; --len) {
> +		if (__get_user_nocheck(c, from++, sizeof(char)))
> +			break;
> +		if (__put_user_nocheck(c, to++, sizeof(char)))

get/put user are macros and it's normally not a good idea to use ++ in macro
arguments because they might expand multiple times.

sizeof(char) is always 1

Also hopefully there's no sign extension anywhere with the signed char

Overall you could write it much simpler with a rep ; movs I think,
like traditional linux did.

> +			break;
> +	}
> +
> +	for (c = 0, zero_len = len; zerorest && zero_len; --zero_len)
> +		if (__put_user_nocheck(c, to++, sizeof(char)))
> +			break;

Similar problem with ++

If zerorest is ever 0 then retesting it on every iteration seems somewhat dumb.

I think a simple memset would be actually ok, i don't think we ever zero
anything that faults. That would be obviously racy anyways. If the zero
are supposed to override something  then a racing user thread could always
catch it.

-Andi
