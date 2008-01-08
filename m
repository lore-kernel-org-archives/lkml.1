Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYAHDRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYAHDRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYAHDQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:16:52 -0500
Received: from ozlabs.org ([203.10.76.45]:59502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbYAHDQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:16:49 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
Date: Tue, 8 Jan 2008 11:47:00 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
References: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu> <1199700326.7143.10.camel@twins>
In-Reply-To: <1199700326.7143.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801081147.00701.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2008 21:05:26 Peter Zijlstra wrote:
> On Sun, 2008-01-06 at 14:11 -0500, Erez Zadok wrote:
> > > Ingo, Peter, does either of you actually care about this problem?  In
> > > the last round when I debugged this problem there was a notable lack of
> > > reaction from either of you.
> >
> > The problem appears to be an interaction of two components--module
> > loading and lockdep--that's perhaps why it wasn't given enough attention.
>
> Would something like this work for people?

Hi Peter,

    There's nothing wrong with this patch, but I think it papers over a more
general problem: we enter the module (to parse args) while it's not in the
module list.  This also means we won't get a nice oops if it crashes.

    This is untested, but does it solve it for you?

Thanks,
Rusty.

diff -r 68fd1b22db89 kernel/module.c
--- a/kernel/module.c	Mon Jan 07 18:59:50 2008 +1100
+++ b/kernel/module.c	Tue Jan 08 11:46:11 2008 +1100
@@ -2043,6 +2043,11 @@ static struct module *load_module(void _
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
 
+	/* Now sew it into the lists so we can get lockdep and oops
+         * info during argument parsing.  Noone should access us, since
+         * strong_try_module_get() will fail. */
+	stop_machine_run(__link_module, mod, NR_CPUS);
+
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
 			 (struct kernel_param *)
@@ -2051,7 +2056,7 @@ static struct module *load_module(void _
 			 / sizeof(struct kernel_param),
 			 NULL);
 	if (err < 0)
-		goto arch_cleanup;
+		goto unlink;
 
 	err = mod_sysfs_setup(mod,
 			      (struct kernel_param *)
@@ -2059,7 +2064,7 @@ static struct module *load_module(void _
 			      sechdrs[setupindex].sh_size
 			      / sizeof(struct kernel_param));
 	if (err < 0)
-		goto arch_cleanup;
+		goto unlink;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
@@ -2074,7 +2079,8 @@ static struct module *load_module(void _
 	/* Done! */
 	return mod;
 
- arch_cleanup:
+ unlink:
+	stop_machine_run(__unlink_module, mod, NR_CPUS);
 	module_arch_cleanup(mod);
  cleanup:
 	module_unload_free(mod);
@@ -2130,10 +2136,6 @@ sys_init_module(void __user *umod,
 		mutex_unlock(&module_mutex);
 		return PTR_ERR(mod);
 	}
-
-	/* Now sew it into the lists.  They won't access us, since
-           strong_try_module_get() will fail. */
-	stop_machine_run(__link_module, mod, NR_CPUS);
 
 	/* Drop lock so they can recurse */
 	mutex_unlock(&module_mutex);
