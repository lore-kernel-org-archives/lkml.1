Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYGMF0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYGMF0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 01:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYGMFZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 01:25:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbYGMFZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 01:25:57 -0400
Date: Sat, 12 Jul 2008 22:24:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: flamingice@sourmilk.net, linville@tuxdriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix warnings on calls to P54P_READ() for which the
 result is discarded
Message-Id: <20080712222446.552f4069.akpm@linux-foundation.org>
In-Reply-To: <20080711141443.14665.63279.stgit@warthog.procyon.org.uk>
References: <20080711141443.14665.63279.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 15:14:43 +0100 David Howells <dhowells@redhat.com> wrote:

> Fix warnings on calls to P54P_READ() for which the result is discarded because
> the side-effect of accessing hardware is what's of interest, not the result of
> performing the read.
> 
> The warnings are of the form:
> 
> drivers/net/wireless/p54/p54pci.c:55: warning: value computed is not used

hm, why aren't I seeing these?

> Casting to (void) gets rid of this.

This makes the ugly uglier.  Would it fix the warnings if we were to do

-#define P54P_READ(r) (__force __le32)__raw_readl(&priv->map->r)
+static inline __le32 p54p_read(__le32 *addr)
+{
+	return (__force __le32)__raw_readl(addr);
+}

...
-	P54P_READ(dev_int);
+	P54P_READ(&priv->map->dev_int);

or something along those lines?

Because the cpp trickery in there really isn't very nice.
