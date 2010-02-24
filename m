Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0BXBCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:02:55 -0500
Received: from ozlabs.org ([203.10.76.45]:47448 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab0BXBCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:02:54 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer dereference
Date: Wed, 24 Feb 2010 11:31:16 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Dongdong Deng <dongdong.deng@windriver.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com> <201002231426.45886.rusty@rustcorp.com.au> <20100223154519.GA4779@hack>
In-Reply-To: <20100223154519.GA4779@hack>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002241131.16766.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 02:15:19 am Américo Wang wrote:
> On Tue, Feb 23, 2010 at 02:26:45PM +1030, Rusty Russell wrote:
> >On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
> >> The param_set_fn() function will get a parameter which is a NULL
> >> pointer when insmod module via bare params as following method:
> >> 
> >> $insmod foo.ko foo
> >> 
> >> If the param_set_fn() function didn't check that parameter and used
> >> it directly, it could caused an OOPS due to NULL pointer dereference.
> >> 
> >> The solution is simple:
> >> Using "" to replace NULL parameter, thereby the param_set_fn()
> >> function will never get a NULL pointer.
> >
> >This changes the value of booleans, and loses checking for int params, etc.
> >
> >I liked Americo's approach; I've combined the two approaches below.
> >
> >Since I'm going away, can Andrew take this?
> >
> >Subject: params: don't hand NULL values to param.set callbacks.
> >
> >An audit by Dongdong Deng revealed that most driver-author-written param
> >calls don't handle val == NULL (which happens when parameters are specified
> >with no =, eg "foo" instead of "foo=1").
> >
> >The only real case to use this is boolean, so handle it specially for that
> >case and remove a source of bugs for everyone else as suggested by Americo.
> >
> >Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> >Cc: Dongdong Deng <dongdong.deng@windriver.com>
> >Cc: Américo Wang <xiyou.wangcong@gmail.com>
> >
> >diff --git a/kernel/params.c b/kernel/params.c
> >--- a/kernel/params.c
> >+++ b/kernel/params.c
> >@@ -59,6 +59,9 @@ static int parse_one(char *param,
> > 	/* Find parameter */
> > 	for (i = 0; i < num_params; i++) {
> > 		if (parameq(param, params[i].name)) {
> >+			/* Noone handled NULL, so do it here. */
> >+			if (!val && params[i].set != param_set_bool)
> >+				return -EINVAL;
> 
> Sorry, after rethinking about this, I think it might be wrong.
> 
> With this patch, when I use non-standard bool functions, I will not
> have a chance to use '!val' which should be valid for all bool
> functions. Or am I missing something?

Sure, at that point we'd need something more sophisticated.  But to
fix this properly we want a flags word, and thus something like this
which I worked on earlier:

http://ozlabs.org/~rusty/kernel/rr-latest/param:param_ops.patch

Cheers,
Rusty.
-- 
Away travelling 25Feb-26Mar (6 .de + 1 .pl + 17 .lt + 2 .sg)
