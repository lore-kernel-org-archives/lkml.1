Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0CFWa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 17:30:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1475 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0CFWa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 17:30:57 -0500
Subject: Re: [RESEND PATCH 0/2] Make functions of dev_<level> macros,
 recursive vsnprintf
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
References: <cover.1267682641.git.joe@perches.com>
	 <20100304143837.af39845d.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>
	 <1267911399.849.39.camel@Joe-Laptop.home>
	 <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Mar 2010 14:30:54 -0800
Message-ID: <1267914654.849.81.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-06 at 14:03 -0800, Linus Torvalds wrote:
> On Sat, 6 Mar 2010, Joe Perches wrote:
> > Is that an ack, a nack or a get the hell out?
> It's mostly an Ack. I think the concept is great. I'd love to have some 
> way to limit recursion,

Maybe limit the %pV recursion depth to 1 with something like:
(in vsprintf.c: pointer() )

	case 'V': {
		char *rtn;
		static int rcount++;

		if (rcount > 1) {	/* Don't recurse more than once */
			rcount--;
			break;		/* Use print the pointer */
		}
		rtn = buf + vsnprintf(buf, end - buf,
				      ((struct va_format *)ptr)->fmt,
				      *(((struct va_format *)ptr)->va));
		rcount--;
		return rtn;
	}
	
> and I'd also love to see some actual numbers of 
> how deep the vsnprintf stack frame is, but I don't see how to do the 
> first, and I'm hoping the second isn't too horrible.

I believe it's the arguments, a long long, a couple of pointers,
and a struct printf_spec.  Not too bad.

