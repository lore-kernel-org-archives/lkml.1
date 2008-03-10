Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYCJBIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYCJBIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 21:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYCJBIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 21:08:11 -0400
Received: from ozlabs.org ([203.10.76.45]:37643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYCJBIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 21:08:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Date: Mon, 10 Mar 2008 12:07:19 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <200803051355.36502.rusty@rustcorp.com.au> <20080306104034.GB27894@ZenIV.linux.org.uk>
In-Reply-To: <20080306104034.GB27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803101207.20151.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 21:40:35 Al Viro wrote:
> extern void decay_to_pointer(void const volatile *);
> #define check_callback_type(f,x) (sizeof((0 ? decay_to_pointer(x),(f)(x) :
> (void)0), 0)) #define __setup_timer(timer, func, arg) \
> do {    \
> 	struct timer_list *__timer = (timer);   \
> 	__timer->function = (void (*)(unsigned long))(func); \
> 	__timer->data = (unsigned long)(arg);   \
> 	(void)check_callback_type(func, arg); \
> } while(0)

   Thanks for that snippet; it's much more complete than the last one I found.  
I especially like the handling of const- and volatile-taking callback fns.  
My version is uglier, pasted below.

   There are three problems I see here.  First, the lack of warning for "void 
intfn(int); DECLARE_TIMER(t, intfn, 0);", but that's relatively minor.  
Second, the change of all the users is just churn, with cast_if_type() it can 
be done over the next couple of years, if ever.

   Worst, I can't see a way to apply your technique in general, for 
non-void-returning functions (eg. interrupt handlers).

Here's the typesafe_cb () helper function from ccan (there are also 
typesafe_cb_preargs and postargs for callbacks with extra args):

/* Doesn't handle const volatile, but can be added. */
#define typesafe_cb(rettype, fn, arg)					\
	cast_if_type(cast_if_type(cast_if_type((fn),			\
					       rettype (*)(const typeof(arg)), \
					       rettype (*)(void *)),	\
				  rettype (*)(volatile typeof(arg)),	\
				  rettype (*)(void *)),			\
		     rettype (*)(typeof(arg)),				\
		     rettype (*)(void *))

> PS: apologies for missing your previous mail; ETOOBIGMBOX ;-/

That's fine, happens to all of us.  I was a little disappointed to return from 
holiday to discover that either your work or mine hadn't been merged tho :)

Cheers,
Rusty.
