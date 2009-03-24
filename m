Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbZCXJir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbZCXJir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZCXJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:38:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36775 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZCXJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:38:36 -0400
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
In-Reply-To: <20090324093103.GA19463@elte.hu>
References: <1237884230.25315.33.camel@penberg-laptop>
	 <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop>
	 <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop>
	 <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop>
	 <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop>
	 <20090324093103.GA19463@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:38:33 +0200
Message-Id: <1237887513.25315.65.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 10:31 +0100, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Tue, 2009-03-24 at 10:17 +0100, Ingo Molnar wrote:
> > > > OK, I think all of them are now fixed. I haven't yet been able to 
> > > > complete a build so help is still appreciated. ;-)
> > > 
> > > unless there's a mail delay, we still have:
> > > 
> > > lib/decompress_unlzma.c:122: error: implicit declaration of function ‘kfree’
> > > lib/decompress_unlzma.c:551: error: implicit declaration of function ‘kmalloc’
> > 
> > Sorry, I missed that. I was testing the .config you sent in the 
> > initial mail, not allyesconfig. I sent you a patch to fix that as 
> > well now.
> 
> no problem, i missed it too - computer reminded us that it's still 
> there ;-)
> 
> there's a new headers-export-check failure:
> 
> /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
> /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
> make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
> make[2]: *** [linux] Error 2
> 
> (CONFIG_HEADERS_CHECK)

Hmm, I wonder what is the best way to fix this, though. I think we
better use macros there (like rest of linux/fs.h) does because of
dependency issues. What do you think?

			Pekka

diff --git a/include/linux/fs.h b/include/linux/fs.h
index add95da..4dda05d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,7 +8,6 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
-#include <linux/gfp.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -2233,15 +2232,8 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 
 
 #ifdef CONFIG_SECURITY
-static inline char *alloc_secdata(void)
-{
-       return (char *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void free_secdata(void *secdata)
-{
-       free_page((unsigned long)secdata);
-}
+#define alloc_secdata() (char *)get_zeroed_page(GFP_KERNEL)
+#define free_secdata()  free_page((unsigned long) secdata)
 #else
 static inline char *alloc_secdata(void)
 {


