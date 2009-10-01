Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZJAXYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZJAXYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZJAXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:24:22 -0400
Received: from kroah.org ([198.145.64.141]:39671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbZJAXXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:23:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:18:05 2009
Message-Id: <20091001231805.321427288@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:16:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jakub@redhat.com,
       security@kernel.org, mingo@elte.hu,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 6/9] net ax25: Fix signed comparison in the sockopt handler
References: <20091001231633.719696398@mini.kroah.org>
Content-Disposition: inline; filename=net-ax25-fix-signed-comparison-in-the-sockopt-handler.patch
In-Reply-To: <20091001231938.GA29593@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@linux.intel.com>

fixed upstream in commit b7058842c940ad2c08dd829b21e5c92ebe3b8758 in a different way

The ax25 code tried to use

        if (optlen < sizeof(int))
                return -EINVAL;

as a security check against optlen being negative (or zero) in the
set socket option.

Unfortunately, "sizeof(int)" is an unsigned property, with the
result that the whole comparison is done in unsigned, letting
negative values slip through.

This patch changes this to

        if (optlen < (int)sizeof(int))
                return -EINVAL;

so that the comparison is done as signed, and negative values
get properly caught.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/af_ax25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -539,7 +539,7 @@ static int ax25_setsockopt(struct socket
 	if (level != SOL_AX25)
 		return -ENOPROTOOPT;
 
-	if (optlen < sizeof(int))
+	if (optlen < (int)sizeof(int))
 		return -EINVAL;
 
 	if (get_user(opt, (int __user *)optval))


