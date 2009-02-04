Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZBDDsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZBDDsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZBDDsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:48:25 -0500
Received: from ozlabs.org ([203.10.76.45]:34618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbZBDDsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:48:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Karsten Keil <kkeil@suse.de>
Subject: Re: [RFC] Suspicious bug in module refcounting
Date: Wed, 4 Feb 2009 14:18:08 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
       richard kennedy <richard@rsk.demon.co.uk>,
       Dan Williams <dan.j.williams@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>, dwmw2@infradead.org,
       Scott Wood <scottwood@freescale.com>, netdev@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20090203134721.GA11069@pingi.kke.suse.de>
In-Reply-To: <20090203134721.GA11069@pingi.kke.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041418.09630.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 00:17:21 Karsten Keil wrote:
> The refcount is a per CPU atomic variable, module_refcount() simple add
> in a fully unprotected loop (not disabled irqs, not protected against
> scheduling) all per cpu values.

Hi Karsten,

   Yes, the BUG_ON() is overly aggressive.  And I really hate __module_get,
and it looks like most of the callers are completely bogus.  The watchdog
drivers use it to nail themselves in place in their open routines: this is
OK, if a bit weird.

   We should only use __module_get() when you *can't handle* failure;
otherwise you should accept that the admin did rmmod --wait and don't use the
module any further.

  dmaengine.c seems to be taking liberties like this.  AFAICT it can error
out, so why not just try_module_get() always?

  gameport.c, serio.c and input.c increment their own refcount, but to get
into those init functions someone must be holding a refcount already (ie. a
module depends on this module).  Ditto cyber2000fb.c, and MTD.

  mdio-bitbang.c should definitely use try_module_get.

  loop.c bumping its own refcount, Al might know why, but definitely can be
try_module_get() if it's valid at all.

  net/socket.c can also handle failure, so that's another try_module_get.

etc.

> I think we should replace all unprotected __module_get() calls with
> try_module_get(), or remove __module_get() completely.

Agreed.  We will need a "nail_module()" call for those legitimate uses (which
should clear mod->exit, rather than manipulating the refcount at all).

Meanwhile, I'll remove the BUG_ON for 2.6.29.

Thanks,
Rusty.

module: remove over-zealous check in __module_get()

module_refcount() isn't reliable outside stop_machine(), as demonstrated
by Karsten Keil <kkeil@suse.de>, networking can trigger it under load
(an inc on one cpu and dec on another while module_refcount() is tallying
 can give false results, for example).

Almost noone should be using __module_get, but that's another issue.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -407,7 +407,6 @@ static inline void __module_get(struct m
 static inline void __module_get(struct module *module)
 {
 	if (module) {
-		BUG_ON(module_refcount(module) == 0);
 		local_inc(__module_ref_addr(module, get_cpu()));
 		put_cpu();
 	}
