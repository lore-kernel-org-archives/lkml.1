Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbXEVVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbXEVVnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXEVVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:43:11 -0400
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:43669 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755001AbXEVVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:43:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH 1/2] allow console unregistration
Date: Tue, 22 May 2007 14:43:04 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
References: <200705171423.46748.jesse.barnes@intel.com> <200705171532.28799.jesse.barnes@intel.com> <1179444190.5092.4.camel@daplas>
In-Reply-To: <1179444190.5092.4.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221443.04859.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007, Antonino A. Daplas wrote:
> On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> > Randy just informed me that the patch limits are bigger now, so here
> > are the actual patches.
> >
> > This patch allows for proper console unregistration via the VT layer,
> > and updates the FB layer to use it.  This makes debugging new console
> > drivers much easier, since you can properly clean them up before
> > unloading. Antonio already checked it out (and suggested a tweak for
> > the fbcon side) so I think it's on its way already via the FB tree.
>
> Sorry, I was busy and got sidetracked so I wasn't able to work on this
> for 2 weeks.  Yes, this should work for now, at least for debugging
> purposes. I'll work on refining on fbcon side, hopefully for
> 2.6.22-2.6.23 time frame.

Btw, here's an updated console unregister patchset with signoff in the
off chance you like it right away. :)

When rmmod'd, some drivers might like to unregister the console they have
registered (e.g. the fbcon driver), so export unbind_con_driver.  It
properly cleans up console references and takes care of switching to
one of the other registered drivers as needed.

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>

diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/drivers/char/vt.c linux-2.6.22-rc2-modesetting/drivers/char/vt.c
--- linux-2.6.22-rc2/drivers/char/vt.c	2007-05-18 21:06:17.000000000 -0700
+++ linux-2.6.22-rc2-modesetting/drivers/char/vt.c	2007-05-22 14:10:35.000000000 -0700
@@ -2981,8 +2981,24 @@ static int con_is_graphics(const struct 
 	return retval;
 }
 
-static int unbind_con_driver(const struct consw *csw, int first, int last,
-			     int deflt)
+/**
+ * unbind_con_driver - unbind a console driver
+ * @csw: pointer to console driver to unregister
+ * @first: first in range of consoles that @csw should be unbound from
+ * @last: last in range of consoles that @csw should be unbound from
+ * @deflt: should next bound console driver be default after @csw is unbound?
+ * 
+ * To unbind a driver from all possible consoles, pass 0 as @first and
+ * %MAX_NR_CONSOLES as @last.
+ *
+ * @deflt controls whether the console that ends up replacing @csw should be
+ * the default console.
+ *
+ * RETURNS:
+ * -ENODEV if @csw isn't a registered console driver or can't be unregistered
+ * or 0 on success.
+ */
+int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
 	struct module *owner = csw->owner;
 	const struct consw *defcsw = NULL;
@@ -3067,6 +3083,7 @@ err:
 	return retval;
 
 }
+EXPORT_SYMBOL(unbind_con_driver);
 
 static int vt_bind(struct con_driver *con)
 {
diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/include/linux/console.h linux-2.6.22-rc2-modesetting/include/linux/console.h
--- linux-2.6.22-rc2/include/linux/console.h	2007-05-18 21:06:17.000000000 -0700
+++ linux-2.6.22-rc2-modesetting/include/linux/console.h	2007-05-22 14:10:35.000000000 -0700
@@ -64,6 +64,7 @@ extern const struct consw vga_con;	/* VG
 extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
+int unbind_con_driver(const struct consw *csw, int first, int last, int deflt);
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
