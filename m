Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbXHBAAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbXHBAAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 20:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbXHBAA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 20:00:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753936AbXHBAAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 20:00:25 -0400
Date: Thu, 2 Aug 2007 02:00:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Maurice Volaski <mvolaski@aecom.yu.edu>
Cc: jheffner@psc.edu, discussion@web100.org, linux-kernel@vger.kernel.org,
       drbd-user@linbit.com
Subject: Re: drbd 8.0.2/3 doesn't load under kernel 2.6.21
Message-ID: <20070802000005.GT3972@stusta.de>
References: <a0624045cc2d691fb7294@[129.98.90.227]> <20070801223440.GS3972@stusta.de> <a06240463c2d6bfa92746@[129.98.90.227]>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a06240463c2d6bfa92746@[129.98.90.227]>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 07:02:14PM -0400, Maurice Volaski wrote:
> First, did you confirm this behavior? Can you please explain that? How 
> could they possibly interact with one another?


It's obvious when looking at the source code that both modules you are
trying to use are buggy, and the sum of the bugs in both modules is the 
drbd breakage you observe.


30% of the guilt go to the drbd developers for doing the following:

#ifdef NETLINK_ROUTE6
        /* pre 2.6.16 */
        err = cn_init();
        if(err) return err;
#endif

The author wanted to check for pre-2.6.14 when the connector code was 
added to the kernel, not for pre-2.6.16 as the comment implies or 
pre-2.6.13 as the code does.

Or he wanted to check whether it's a recent kernel and the connector 
code is compiled into the kernel.


70% of the guilt go to the web100 developers for shipping the following 
to their users:

--- linux-2.6-web100/include/linux/netlink.h	19 Jul 2007 17:49:17 -0000	1.1.1.16
+++ linux-2.6-web100/include/linux/netlink.h	19 Jul 2007 18:11:01 -0000	1.17
@@ -14,6 +14,7 @@
 #define NETLINK_SELINUX		7	/* SELinux event notifications */
 #define NETLINK_ISCSI		8	/* Open-iSCSI */
 #define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_ROUTE6		11	/* af_inet6 route comm channel */
 #define NETLINK_FIB_LOOKUP	10	
 #define NETLINK_CONNECTOR	11
 #define NETLINK_NETFILTER	12	/* netfilter subsystem */
 
That's not only buggy but also not used by web100.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

