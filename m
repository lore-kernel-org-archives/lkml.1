Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbYD1FLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbYD1FLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYD1FLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:11:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:55391 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbYD1FLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:11:30 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 27 Apr 2008 22:11:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] eventfd, signalfd, timerfd, epoll_create w/flags
In-Reply-To: <200804280315.m3S3FKsw028335@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0804272200090.18184@alien.or.mcafeemobile.com>
References: <200804280315.m3S3FKsw028335@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Ulrich Drepper wrote:

> +	int fflags = 0;
> +
> +	if (flags) {
> +		if ((flags & EFD_CLOEXEC) != 0) {
> +			fflags |= O_CLOEXEC;
> +			flags &= ~EFD_CLOEXEC;
> +		}
> +		if (flags)
> +			return -EINVAL;
> +	}

...

> +	int fflags = 0;
> +
> +	if (flags) {
> +		if ((flags & EPOLL_CLOEXEC) != 0) {
> +			fflags |= O_CLOEXEC;
> +			flags &= ~EPOLL_CLOEXEC;
> +		}
> +		if (flags)
> +			return -EINVAL;
> +	}

...

> +	int fflags = 0;
> +
> +	if (flags) {
> +		if ((flags & SFD_CLOEXEC) != 0 && ufd == -1) {
> +			fflags |= O_CLOEXEC;
> +			flags &= ~SFD_CLOEXEC;
> +		}
> +		if (flags)
> +			return -EINVAL;
> +	}

...

> +	int fflags = 0;
>  
> -	if (flags)
> -		return -EINVAL;
> +	if (flags) {
> +		if ((flags & TFD_CLOEXEC) != 0) {
> +			fflags |= O_CLOEXEC;
> +			flags &= ~TFD_CLOEXEC;
> +		}
> +		if (flags)
> +			return -EINVAL;
> +	}

Maybe something like:

struct oflags_rmap {
	int f, of;
};

unsigned int oflags_remap(const struct oflags_rmap *m, int n,
			  int f, int *rf)
{
	int i;
	for (i = 0, *rf = 0; i < n; i++, m++)
		if (f & m->f) {
			*rf |= m->of;
			f &= ~m->f;
		}
	return f ? -EINVAL: 0;
}

Then, in all the cases above (modulo different "struct oflags_rmap" 
fillings):

const struct oflags_rmap ormap[] = {
	{ TFD_CLOEXEC, O_CLOEXEC }
};

error = oflags_remap(ormap, ARRAY_SIZE(ormap), flags, &fflags);




- Davide


