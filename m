Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbZBTA7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbZBTA7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZBTA7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:59:05 -0500
Received: from ozlabs.org ([203.10.76.45]:47079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZBTA7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:59:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Fri, 20 Feb 2009 11:28:55 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <ac3eb2510902191248w26f1d1c0o95d68aaa3be097a1@mail.gmail.com> <ac3eb2510902191359o3e32c424h830e78cd0ace446a@mail.gmail.com>
In-Reply-To: <ac3eb2510902191359o3e32c424h830e78cd0ace446a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201128.55959.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 08:29:48 Kay Sievers wrote:
> Further testing revealed, if I only comment out the stop_machine()
> preparation, which is used in an error case, I get almost the same
> improvement, even with the original mutex in place. Without the mutex
> it's still a bit better, maybe it would be much better if we have more
> CPUs, but all the long delays are gone only with removing the
> stop_machine() preparation.

Hmm, interesting.  The reason that reducing the lock coverage had this effect
is because stop_machine_create() just bumps a refcount if someone is already
between ...create() and ...destroy().

So, now we've found the problem, let's fix it, then re-visit mutex reduction.

module: don't use stop_machine on module load

Kay Sievers <kay.sievers@vrfy.org> discovered that boot times are slowed
by about half a second because all the stop_machine_create() calls,
and he only probes about 40 modules (I have 125 loaded on this laptop).

We only do stop_machine_create() so we can unlink the module if
something goes wrong, but it's overkill (and buggy anyway: if
stop_machine_create() fails we still call stop_machine_destroy()).

Since we are only protecting against kallsyms (esp. oops) walking the
list, synchronize_sched() is sufficient (synchronize_rcu() is probably
sufficient, but we're not in a hurry).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1881,12 +1881,6 @@ static noinline struct module *load_modu
 	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	/* Create stop_machine threads since the error path relies on
-	 * a non-failing stop_machine call. */
-	err = stop_machine_create();
-	if (err)
-		goto free_hdr;
-
 	if (copy_from_user(hdr, umod, len) != 0) {
 		err = -EFAULT;
 		goto free_hdr;
@@ -2271,12 +2265,13 @@ static noinline struct module *load_modu
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
-	stop_machine_destroy();
 	/* Done! */
 	return mod;
 
  unlink:
-	stop_machine(__unlink_module, mod, NULL);
+	/* Unlink carefully: kallsyms could be walking list. */
+	__list_del(&mod->list);
+	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
 	kobject_del(&mod->mkobj.kobj);
@@ -2297,7 +2292,6 @@ static noinline struct module *load_modu
 	kfree(args);
  free_hdr:
 	vfree(hdr);
-	stop_machine_destroy();
 	return ERR_PTR(err);
 
  truncated:
