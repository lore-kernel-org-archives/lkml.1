Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZBSKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZBSKvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZBSKvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:51:09 -0500
Received: from ozlabs.org ([203.10.76.45]:60447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZBSKvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:51:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] module: fix build for CONFIG_SYSFS=n
Date: Thu, 19 Feb 2009 21:20:59 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <499C54E8.7060004@oracle.com> <20090218191529.GC8889@elte.hu>
In-Reply-To: <20090218191529.GC8889@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192120.59634.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 05:45:29 Ingo Molnar wrote:
> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > Is destroy_params() dependent on SYSFS? If yes then it would be 
> > 
> > Yes.
> > 
> > > far cleaner if there was a NOP destroy_params() inline for the 
> > > !SYSFS case.
...
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix this build error when CONFIG_SYSFS=n:

Thanks for the find Randy.  I chose to put it in the header.  People who turn
off SYSFS probably appreciate a few bytes saved:

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -139,7 +139,14 @@ extern int parse_args(const char *name,
 		      int (*unknown)(char *param, char *val));
 
 /* Called by module remove. */
+#ifdef CONFIG_SYSFS
 extern void destroy_params(const struct kernel_param *params, unsigned num);
+#else
+static inline void destroy_params(const struct kernel_param *params,
+				  unsigned num)
+{
+}
+#endif /* !CONFIG_SYSFS */
 
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub

Cheers,
Rusty.
