Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbXIZCGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbXIZCGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXIZCGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:06:08 -0400
Received: from ozlabs.org ([203.10.76.45]:49394 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbXIZCGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:06:07 -0400
Subject: Re: [PATCH] put_user() on struct is not nice
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IaLAA-000853-8q@ZenIV.linux.org.uk>
References: <E1IaLAA-000853-8q@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 12:05:46 +1000
Message-Id: <1190772346.2227.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 01:54 +0100, Al Viro wrote:
> use copy_to_user() instead...

Thanks Al, Jes sent me the same fix which I have queued for for 2.6.24:

From: Jes Sorensen <jes@sgi.com>

Use copy_to_user() when copying a struct timespec to the guest -
put_user() cannot handle two long's in one go on a 64bit arch.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/hypercalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- linux-2.6.23-rc4.orig/drivers/lguest/hypercalls.c
+++ linux-2.6.23-rc4/drivers/lguest/hypercalls.c
@@ -243,6 +243,6 @@ void write_timestamp(struct lguest *lg)
 {
 	struct timespec now;
 	ktime_get_real_ts(&now);
-	if (put_user(now, &lg->lguest_data->time))
+	if (copy_to_user(&lg->lguest_data->time, &now, sizeof(struct timespec)))
 		kill_guest(lg, "Writing timestamp");
 }


