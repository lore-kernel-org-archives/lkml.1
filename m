Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZAEUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZAEUam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZAEUaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:30:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbZAEUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:30:28 -0500
Date: Mon, 5 Jan 2009 15:30:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] module: clean up initialization of variable
In-Reply-To: <20090105195415.GA6204@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0901051523370.25066@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <20090105195415.GA6204@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Impact: clean up

On Mon, 5 Jan 2009, Sam Ravnborg wrote:
> 
> Fully ageed on the readability.
> I happen to trigger this as an error in the sparc code.
> But I see the same warning also in generic code.
> 
> >From kernel/module.c:
>         /* Suck in entire file: we'll want most of it. */
>         /* vmalloc barfs on "unusual" numbers.  Check here */
>         if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
>                 return ERR_PTR(-ENOMEM);
> 
> 
> This gives following warning:
> kernel/module.c: In function `load_module':
> kernel/module.c:1842: warning: 'hdr' might be used uninitialized in this function

The above is caused by having the branch tracer on and the following type 
of initialization:

	if (x || !(y = init_me())
		return;

	use_me(y);

This is sloppy initialization because it initializes, not only in an
if condition, but also as the second part of a complex conditional.

This patch makes the code a bit easier to read.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Reported-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/kernel/module.c b/kernel/module.c
index 9712c52..112d6cd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1864,7 +1864,10 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Suck in entire file: we'll want most of it. */
 	/* vmalloc barfs on "unusual" numbers.  Check here */
-	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
+	if (len > 64 * 1024 * 1024)
+		return ERR_PTR(-ENOMEM);
+	hdr = vmalloc(len);
+	if (hdr == NULL)
 		return ERR_PTR(-ENOMEM);
 	if (copy_from_user(hdr, umod, len) != 0) {
 		err = -EFAULT;
