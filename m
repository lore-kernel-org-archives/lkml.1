Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbZLLKKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbZLLKKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756863AbZLLKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:10:34 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35735 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZLLKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=Rs65c+H88Ea9lQ0lbedt1gvM6/+752n86YTqhSgrNjILahbjOlVjPR2SJ4dW9xfM0t
         gmtDka5o43XKqiRUcPsrtA7n2WS4l+aQT1SBTIvZKrtHivbDn4PgiUwdeM08ngTdoMMO
         pN/YOSf8xIhfiz0Y2eg4eZHRHBMDGyEcucLJU=
Message-ID: <4B236C18.4050007@gmail.com>
Date: Sat, 12 Dec 2009 05:10:32 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20091211.181712.211179737.davem@davemloft.net>
In-Reply-To: <20091211.181712.211179737.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------080903000305090909040706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080903000305090909040706
Content-Type: text/plain; charset=iso-2022-jp-2; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> David S. Miller (4):
>       Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
>       tcp: Remove runtime check that can never be true.

This is a poor patch that was never sent to the netdev list for review.  Copies to
and from user space should always check for buffer overruns.  A better patch was
submitted (attached) some time ago.

Miller's patch has 2 flaws:

  1) It accidentally removed a comment line that describes the purpose of the
following memcpy(), paralleling language in the internet-draft.

  2) It fails to test for buffer overruns.  The existing code has an accurate test,
that compiles (to no code) correctly with current gcc.  But it produces a warning
in some (fairly old) gcc versions.

Instead, the better patch uses the Kernel defined BUILD_BUG_ON().  Please
substitute the better patch in the main tree.


>       Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
>       Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
> 

--------------080903000305090909040706
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="net-ipv4-tcp.c-fix-warning-for-older-compilers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="net-ipv4-tcp.c-fix-warning-for-older-compilers.patch"

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c8666b7..3d2229c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2541,10 +2541,7 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			ctd.tcpct_s_data_desired = cvp->s_data_desired;
 
 			/* Cookie(s) saved, return as nonce */
-			if (sizeof(ctd.tcpct_value) < cvp->cookie_pair_size) {
-				/* impossible? */
-				return -EINVAL;
-			}
+			BUILD_BUG_ON(sizeof(ctd.tcpct_value) < TCP_COOKIE_PAIR_SIZE);
 			memcpy(&ctd.tcpct_value[0], &cvp->cookie_pair[0],
 			       cvp->cookie_pair_size);
 			ctd.tcpct_used = cvp->cookie_pair_size;
-- 
1.6.3.3


--------------080903000305090909040706--
