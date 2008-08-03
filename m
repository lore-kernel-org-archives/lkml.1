Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYHCKYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYHCKYV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 06:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYHCKYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 06:24:12 -0400
Received: from ozlabs.org ([203.10.76.45]:32915 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbYHCKYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 06:24:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PULL] typesafe callbacks for kthread and stop_machine
Date: Sun, 3 Aug 2008 20:24:03 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>,
       Tejun Heo <htejun@gmail.com>
References: <200807311452.36025.rusty@rustcorp.com.au> <200808011039.30195.rusty@rustcorp.com.au> <20080801142806.GX23938@one.firstfloor.org>
In-Reply-To: <20080801142806.GX23938@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808032024.03764.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008 00:28:06 Andi Kleen wrote:
> On Fri, Aug 01, 2008 at 10:39:29AM +1000, Rusty Russell wrote:
> > Yes, but the benefits of using them everywhere is that they do become
> > part of the landscape.  "Oh, that's a typesafe callback, OK".
>
> It's still an additional step slowing the reader/debugger/maintainer/etc.
> down even when he recognizes that pattern.

I agree, and if it didn't have real benefits I'd oppose it.

> > That's aimed at a slightly different case, where the function knows what
> > types it can get.  But that doesn't work for truly generic callbacks: the
> > type is completely controlled by the caller. ie. we want to allow
> > whatever type matches the arg.
>
> In my experience often call backs are just numbers.

Really?

> Wouldn't we get a significant part of the benefit by just allowing void *
> and unsigned long by default? (that can be done with the gcc extension)

No.  See below patch for how these patches are used.

> Or alternatively perhaps just teach sparse about this common pattern by
> adding new annotations (new annotations would be fine for me, i just don't
> like the additional indirection)

But we'd have to make callbacks take void * for the function param.  That
would be a big step backwards.

---
 drivers/char/hw_random/intel-rng.c |    3 +--
 kernel/module.c                    |   10 +++-------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -r e279190b7b43 drivers/char/hw_random/intel-rng.c
--- a/drivers/char/hw_random/intel-rng.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/drivers/char/hw_random/intel-rng.c	Mon Jan 21 15:04:00 2008 +1100
@@ -227,9 +227,8 @@ struct intel_rng_hw {
 	u8 fwh_dec_en1_val;
 };
 
-static int __init intel_rng_hw_init(void *_intel_rng_hw)
+static int __init intel_rng_hw_init(struct intel_rng_hw *intel_rng_hw)
 {
-	struct intel_rng_hw *intel_rng_hw = _intel_rng_hw;
 	u8 mfc, dvc;
 
 	/* interrupts disabled in stop_machine_run call */
diff -r e279190b7b43 kernel/module.c
--- a/kernel/module.c	Mon Jan 21 14:42:54 2008 +1100
+++ b/kernel/module.c	Mon Jan 21 15:04:00 2008 +1100
@@ -623,10 +623,8 @@ struct stopref
 };
 
 /* Whole machine is stopped with interrupts off when this runs. */
-static int __try_stop_module(void *_sref)
+static int __try_stop_module(struct stopref *sref)
 {
-	struct stopref *sref = _sref;
-
 	/* If it's not unused, quit unless we are told to block. */
 	if ((sref->flags & O_NONBLOCK) && module_refcount(sref->mod) != 0) {
 		if (!(*sref->forced = try_force_unload(sref->flags)))
@@ -1305,9 +1303,8 @@ static void mod_kobject_remove(struct mo
  * link the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __link_module(void *_mod)
+static int __link_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_add(&mod->list, &modules);
 	return 0;
 }
@@ -1316,9 +1313,8 @@ static int __link_module(void *_mod)
  * unlink the module with the whole machine is stopped with interrupts off
  * - this defends against kallsyms not taking locks
  */
-static int __unlink_module(void *_mod)
+static int __unlink_module(struct module *mod)
 {
-	struct module *mod = _mod;
 	list_del(&mod->list);
 	return 0;
 }


