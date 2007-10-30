Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbXJ3WS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbXJ3WS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXJ3WSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:18:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47658 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXJ3WSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:18:49 -0400
Date: Tue, 30 Oct 2007 23:20:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: raa.lkml@gmail.com, linux-kernel@vger.kernel.org, per.liden@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: tipc_config.h requires linux/string.h, which does not exist in exported headers
Message-ID: <20071030222025.GA19792@uranus.ravnborg.org>
References: <20071030191317.GB9403@steel.home> <20071030215409.GB19598@uranus.ravnborg.org> <20071030.145926.219328422.davem@davemloft.net> <20071030.150537.240140474.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030.150537.240140474.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 03:05:37PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 30 Oct 2007 14:59:26 -0700 (PDT)
> 
> > I think the thing to do is just __KERNEL__ protect the
> > <linux/string.h> include and require userspace to
> > include <string.h> itself when using these headers.
> > 
> > That's what I'm testing right now.
> > 
> > I'm pretty sure those inlines are indeed used by userspace.
> 
> Actually, I'm tempted to put <string.h> in the ifndef __KERNEL__
> block of that header.

Something like this..
I like it - much better than adding string.h to unidef-y.
PS - had not pulled latest -linus - so you must update Kbuild.
PPS - tipc.h should be exported too as I understood Stephen.

	Sam

diff --git a/include/linux/tipc_config.h b/include/linux/tipc_config.h
index b0c916d..30ddf1e 100644
--- a/include/linux/tipc_config.h
+++ b/include/linux/tipc_config.h
@@ -38,7 +38,6 @@
 #define _LINUX_TIPC_CONFIG_H_
 
 #include <linux/types.h>
-#include <linux/string.h>
 #include <asm/byteorder.h>
 
 /*
@@ -390,7 +389,8 @@ struct tipc_cfg_msg_hdr
 #define TCM_LENGTH(datalen) (sizeof(struct tipc_cfg_msg_hdr) + datalen)
 #define TCM_SPACE(datalen)  (TCM_ALIGN(TCM_LENGTH(datalen)))
 #define TCM_DATA(tcm_hdr)   ((void *)((char *)(tcm_hdr) + TCM_LENGTH(0)))
-
+#ifndef __KERNEL__
+#include <string.h>
 static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
 			  void *data, __u16 data_len)
 {
@@ -406,5 +406,5 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u16 flags,
 		memcpy(TCM_DATA(msg), data, data_len);
 	return TCM_SPACE(data_len);
 }
-
+#endif /* ifndef __KERNEL__ */
 #endif
