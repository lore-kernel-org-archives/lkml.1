Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0CANJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:09:35 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35552 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0CANJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=icR/G43F4vw0Lsf5W+CS8Rjme9CqVnOQ0P8jJb+MmaBIBFgkRp3WYFj50LY7MFZAw3
         ta88NxxcXKPlj95N4U69FNCzyjaC3aDa1TQeQ4LAH12sWYfkKMXUA+CXuvw+5CuK2GGM
         HkPBdhH+G4P9yw++8lSEsQ/n6/lNBV838LekU=
Subject: Re: sparse checking prevented by "net: fix kmemcheck annotations"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
In-Reply-To: <4B8BAE79.9000609@s5r6.in-berlin.de>
References: <4B8BAE79.9000609@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 14:09:26 +0100
Message-ID: <1267448966.3039.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 mars 2010 à 13:09 +0100, Stefan Richter a écrit :
> Hi all,
> 
> the post 2.6.32-rc5, pre 2.6.32-rc6 commit 14d18a81 causes a serious
> regression for sparse checks:  make C=1 CF="-D__CHECK_ENDIAN__" now
> causes sparse to log
> 
>     include/linux/skbuff.h:357:41: error: invalid bitfield specifier for
>     type restricted __be16.
> 
> 
> I reported this already shortly after this hit the mainline.  But back
> then I didn't notice that this sparse error causes sparse to remain
> silent on all subsequent warnings in a file!
> 
> We need to either change sparse to accept this bogus bit field that
> occurs in skbuff.h (__be16 protocol:16;), silently or with a warning, or
> revert this kmemcheck annotation.
> 
> ("We" == preferably Eric :-)
> 
> skbuff.h is included by lots of drivers, even ones that are not even
> networking drivers, notably DVB drivers.  None of these drivers can be
> checked with sparse's __CHECK_ENDIAN__ at the moment.

Hi Stefan

I believe kmemcheck side effects were solved by commit e992cd9b72a18122
(kmemcheck: make bitfield annotations truly no-ops when disabled),
so there is no problem to partially revert the patch and fix this
problem.

Thanks !

[PATCH] net: fix protocol sk_buff field

Commit e992cd9b72a18 (kmemcheck: make bitfield annotations truly no-ops
when disabled) allows us to revert a workaround we did in the past to
not add holes in sk_buff structure.

This patch partially reverts commit 14d18a81b5171
(net: fix kmemcheck annotations) so that sparse doesnt complain:

include/linux/skbuff.h:357:41: error: invalid bitfield specifier for
type restricted __be16.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ae836fd..b40f56b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -354,8 +354,8 @@ struct sk_buff {
 				ipvs_property:1,
 				peeked:1,
 				nf_trace:1;
-	__be16			protocol:16;
 	kmemcheck_bitfield_end(flags1);
+	__be16			protocol;
 
 	void			(*destructor)(struct sk_buff *skb);
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)


