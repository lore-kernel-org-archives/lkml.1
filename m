Return-Path: <linux-kernel-owner+w=401wt.eu-S1161382AbXDKWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382AbXDKWzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161363AbXDKWzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55658 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161340AbXDKWyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:49 -0400
Date: Wed, 11 Apr 2007 15:52:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       Sridhar Samudrala <sri@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/31] Fix length validation in rawv6_sendmsg()
Message-ID: <20070411225207.GP24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-length-validation-in-rawv6_sendmsg.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[IPv6]: Fix incorrect length check in rawv6_sendmsg()

In article <20070329.142644.70222545.davem@davemloft.net> (at Thu, 29 Mar 2007 14:26:44 -0700 (PDT)), David Miller <davem@davemloft.net> says:

> From: Sridhar Samudrala <sri@us.ibm.com>
> Date: Thu, 29 Mar 2007 14:17:28 -0700
>
> > The check for length in rawv6_sendmsg() is incorrect.
> > As len is an unsigned int, (len < 0) will never be TRUE.
> > I think checking for IPV6_MAXPLEN(65535) is better.
> >
> > Is it possible to send ipv6 jumbo packets using raw
> > sockets? If so, we can remove this check.
>
> I don't see why such a limitation against jumbo would exist,
> does anyone else?
>
> Thanks for catching this Sridhar.  A good compiler should simply
> fail to compile "if (x < 0)" when 'x' is an unsigned type, don't
> you think :-)

Dave, we use "int" for returning value,
so we should fix this anyway, IMHO;
we should not allow len > INT_MAX.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Sridhar Samudrala <sri@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/raw.c |    4 ++--
 net/ipv6/udp.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -688,9 +688,9 @@ static int rawv6_sendmsg(struct kiocb *i
 	int err;
 
 	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_build_xmit
+	   better check is made in ip6_append_data().
 	 */
-	if (len < 0)
+	if (len > INT_MAX)
 		return -EMSGSIZE;
 
 	/* Mirror BSD error message compatibility */
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -616,7 +616,7 @@ do_udp_sendmsg:
 		return udp_sendmsg(iocb, sk, msg, len);
 
 	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_build_xmit
+	   better check is made in ip6_append_data().
 	   */
 	if (len > INT_MAX - sizeof(struct udphdr))
 		return -EMSGSIZE;

-- 
