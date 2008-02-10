Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYBJWJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYBJWJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYBJWJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:09:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:48244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYBJWJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=xBb+qpf189DFAqd4K6S0HaKlamzgzxgzXxZxa5vkeBFmLiut8LmikBR3+UvfOz58FxMJEgLyLOIaagnq8gmuwqyFcJUs5Gz+2nimVLxd4UlPKpsvgBDMVCDKswKJM1fRh3Xh4AWrRg81ATma2NSIe0wDjwqpLKNVa1skwOiUh+o=
Date: Mon, 11 Feb 2008 01:09:06 +0300
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@sw.ru,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] Whine about suspicious return values from module's ->init() hook
Message-ID: <20080210220906.GG1754@martell.zuzino.mipt.ru>
References: <20080204154215.GA26618@localhost.sw.ru> <200802060948.11133.rusty@rustcorp.com.au> <20080205153752.243d3b63.akpm@linux-foundation.org> <200802061755.27057.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802061755.27057.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 05:55:26PM +1100, Rusty Russell wrote:
> On Wednesday 06 February 2008 10:37:52 Andrew Morton wrote:
> > On Wed, 6 Feb 2008 09:48:10 +1100
> >
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > > It's a no-brainer.
> > >
> > > For non-developers, WARN_ON is a noop.
> >
> > Oh..  Rusty.  The mailing list and bugzilla are *full* of WARN_ON reports
> > from testers.  Your statement is empirically wrong.
> 
> My apologies.  I had extrapolated from my own behaviour: I don't notice 
> WARN_ON unless something else goes wrong to make me look in the logs.
> 
> > > BUG_ON() will make us fix it in return for short-term pain.
> >
> > Pain to our users and testers.  People upon whom we are very dependent and
> > to whom we are hugely indebted.  People who I have to spend a lot of time
> > defending from the likes of you!
> 
> I think you misunderstand.  I proposed that we audit all the code before such 
> a change.  We shouldn't do *anything* until we can estimate the impact this 
> change will have.

With such rate of changes, good luck doing that.

Good example is sysctl checks. There was initial influx of reports and
they were fixed and there were no sysctl reports recently.

> Our users deserve better than "I don't know if this will break anything so I 
> used WARN_ON".  They deserve "we have confidence that this change won't break 
> any existing code".
> 
> Now, if an audit is impractical or unreliable, we are better off with a 
> WARN_ON.

It's impractical as in it's extremely boring to read every modules init
function and propagate return values in mind.

> But it is still an admission of ignorance.

I love BUG_ON and BUILD_BUG_ON very much but on such scale you can't
just throw them in.

Here goes version 2 with improved changelog. Let's put in -mm and see
what happens, then put it in mainline and see what happens.


[PATCH v2] Whine about suspicious return values from module's ->init() hook

Return value convention of module's init functions is 0/-E. Sometimes, e.g.
during forward-porting mistakes happen and buggy module created, where result
of comparison "workqueue != NULL" is propagated all the way up to
sys_init_module. What happens is that some other module created workqueue in
question, our module created it again and module was successfully loaded.

Or it could be some other bug.

Let's make such mistakes much more visible. In retrospective, such messages
would noticeably shorten some of my head-scratching sessions.

Note, that dump_stack() is just a way to get attention from user.
Sample message:

sys_init_module: 'foo'->init suspiciously returned 1, it should follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 4223, comm: modprobe Not tainted 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #5

Call Trace:
 [<ffffffff80254b05>] sys_init_module+0xe5/0x1d0
 [<ffffffff8020b39b>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/module.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2174,6 +2174,14 @@ sys_init_module(void __user *umod,
 		wake_up(&module_wq);
 		return ret;
 	}
+	if (ret > 0) {
+		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
+				    "it should follow 0/-E convention\n"
+		       KERN_WARNING "%s: loading module anyway...\n",
+		       __func__, mod->name, ret,
+		       __func__);
+		dump_stack();
+	}
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);
