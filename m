Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYCHSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYCHSrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 13:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbYCHSra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 13:47:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:48956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYCHSr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 13:47:29 -0500
Date: Sat, 8 Mar 2008 10:47:17 -0800
From: Greg KH <gregkh@suse.de>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 sysdev API problem
Message-ID: <20080308184717.GA7476@suse.de>
References: <18386.46903.998159.519599@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18386.46903.998159.519599@harpo.it.uu.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 04:56:39PM +0100, Mikael Pettersson wrote:
> In kernels up to and including 2.6.24, it was possible to
> register-then-unregister a sysdev_class/sys_device pair
> multiple times. Starting with the 2.6.24-git1 kernel, doing
> so causes a warning
> 
> kobject (f88e96c8): tried to init an initialized object, something is seriously wrong

This is a warning only, I have a patch queued up to fix this.  I've
included it below.

> the second time the class/device pair is registered, followed
> soon thereafter by random BUG()s and a kernel panic.

That's odd.  I don't think that is related, but it might be.  Can you
try the patch and let me know if it still happens?

thanks,

greg k-h


From: Balaji Rao <balajirrao@gmail.com>
Date: Thu, 6 Mar 2008 22:23:18 +0530
Subject: kobjects: mark cleaned up kobjects as unitialized
To: gregkh@suse.de
Cc: <kvm-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Message-ID: <200803062223.18857.balajirrao@gmail.com>
Content-Disposition: inline


When I remove only the kvm-intel module without removing the kvm module
itself, I get an error saying that a kobject is trying to be
reinitialized. Its because of the fact that kvm reuses a kobject in
kvm_init when calling sysdev_register.

This patch fixes kobject_cleanup by marking the kobject as uninitialized
when we cleanup to allow kobjects to be reused.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -577,6 +577,9 @@ static void kobject_cleanup(struct kobje
 		pr_debug("kobject: '%s': free name\n", name);
 		kfree(name);
 	}
+
+	/* Set the state to uninitialized */
+	kobj->state_initialized = 0;
 }
 
 static void kobject_release(struct kref *kref)
