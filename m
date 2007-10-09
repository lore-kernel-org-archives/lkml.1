Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbXJIBVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbXJIBVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 21:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbXJIBVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 21:21:30 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:58155 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJIBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 21:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=skSEMgi2zDUGxQJCKMwE4LNXL08/nrhqi+/+0/wYK/K0uygeV4J+fRfQhndgCVpa8vpUU0oEurkZpee/w1aOsYnTNF+Bk5TX0oQB6s3Wfp/VJVlOMV0yxMI6kEfWLuL5OA0sg7EwThXRCPyXlT0yuduVGwaorLQo61Er8gzoFrQ=
Date: Tue, 9 Oct 2007 09:21:11 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH] param_sysfs_builtin memchr argument fix
Message-ID: <20071009012111.GA2877@darkstar.te-china.tietoenator.com>
References: <20071008071730.GA2979@darkstar.te-china.tietoenator.com> <20071008091354.30598ee4.randy.dunlap@oracle.com> <a8e1da0710081807l74ca63ayf93183eac75193a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0710081807l74ca63ayf93183eac75193a@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > If memchr argument is longer than strlen(kp->name), there will be some
> > weird result.
> 
> Just to clarify:  this was causing duplicate filenames in sysfs ?
Yes, it will casuse duplicate filenames in sysfs. For me, the "nousb"
will cause the "usbcore" created twice. 
> 
> 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > ---
> > kernel/params.c |    8 +++++++-
> > 1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff -upr linux/kernel/params.c linux.new/kernel/params.c
> > --- linux/kernel/params.c     2007-10-08 14:30:06.000000000 +0800
> > +++ linux.new/kernel/params.c 2007-10-08 15:13:04.000000000 +0800
> > @@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
> >
> >       for (i=0; i < __stop___param - __start___param; i++) {
> >               char *dot;
> > +             size_t kplen;
> >
> >               kp = &__start___param[i];
> > +             kplen = strlen(kp->name);
> >
> >               /* We do not handle args without periods. */
> > -             dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
> > +             if (kplen > MAX_KBUILD_MODNAME) {
> > +                     DEBUGP("kernel parameter %s is too long\n", kp->name);
> 
> how about
>         kernel parameter name %s is too long
> or
>         kernel parameter name is too long: %s
> 
> (primary is addition of "name")
Yes, "name" should be added, thanks.
> 
> > +                     continue;
> > +             }
> > +             dot = memchr(kp->name, '.', kplen);
> >               if (!dot) {
> >                       DEBUGP("couldn't find period in %s\n", kp->name);
> >                       continue;
> > -
> 

Regards
dave

====================================================

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
kernel/params.c |    8 +++++++-
1 file changed, 7 insertions(+), 1 deletion(-)

diff -upr linux/kernel/params.c linux.new/kernel/params.c
--- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
+++ linux.new/kernel/params.c	2007-10-09 09:16:55.000000000 +0800
@@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;
