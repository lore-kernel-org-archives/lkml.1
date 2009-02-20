Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZBTLce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZBTLce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBTLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:32:26 -0500
Received: from ozlabs.org ([203.10.76.45]:56394 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZBTLcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:32:25 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Fri, 20 Feb 2009 22:02:13 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <ac3eb2510902191359o3e32c424h830e78cd0ace446a@mail.gmail.com> <200902201128.55959.rusty@rustcorp.com.au>
In-Reply-To: <200902201128.55959.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902202202.13994.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 11:28:55 Rusty Russell wrote:
> +	/* Unlink carefully: kallsyms could be walking list. */
> +	__list_del(&mod->list);
> +	synchronize_sched();

That should be list_del_rcu() of course.

Rusty.

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
---
 kernel/module.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

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
+	list_del_rcu(&mod->list);
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
