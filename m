Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXEKI3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXEKI3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXEKI2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:28:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:32242 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXEKI2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Hqr5svps8qd7LtKhwg40528xHxSoTyzbLUvy/WHzrKzo1OF0GVNaQA6JiH7tG9wzWH5vko1qCm3d9qXbD4FGY4FrNcVlJHEIls9Ueub/3ljWVZHs6q5xMIftt1EUPmOhCvFyMB8g67/556V+o9DFQatNxerWkVicq3m+uNJZxV4=
Date: Fri, 11 May 2007 10:27:38 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jorge@laser.satlink.net, agulbra@nvg.unit.no
Subject: [-mm patch] make csum_and_copy_from_user arch independent (was Re: 2.6.21-mm2)
Message-ID: <20070511082738.GA23560@slug>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509012322.199f292b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:23:22AM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 

ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!

Linking on ARM fails because albeit a generic csum_and_copy_from_user()
function is provided in the case ! _HAVE_ARCH_COPY_AND_CSUM_FROM_USER, the
generic function uses csum_partial_copy_from_user() which is i386 only.

The following patch uses copy_from_user() followed by csum_partial()
to make the function platform independent.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/include/net/checksum.h b/include/net/checksum.h
index 1242461..2eebb95 100644
--- a/include/net/checksum.h
+++ b/include/net/checksum.h
@@ -30,13 +30,16 @@ static inline
 __wsum csum_and_copy_from_user (const void __user *src, void *dst,
 				      int len, __wsum sum, int *err_ptr)
 {
-	if (access_ok(VERIFY_READ, src, len))
-		return csum_partial_copy_from_user(src, dst, len, sum, err_ptr);
+	if (access_ok(VERIFY_READ, src, len)) {
+		if (copy_from_user(dst, src, len))
+			return -EFAULT;
+		return csum_partial(dst, len, sum);
+	}
 
 	if (len)
 		*err_ptr = -EFAULT;
 
-	return sum;
+	return (__force __wsum)-1; /* invalid checksum */
 }
 #endif
 
