Return-Path: <linux-kernel-owner+w=401wt.eu-S1764956AbXLMHT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764956AbXLMHT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbXLMG6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55761 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762315AbXLMG6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:43 -0500
Date: Wed, 12 Dec 2007 22:53:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 57/60] XFRM: Fix leak of expired xfrm_states
Message-ID: <20071213065345.GG6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xfrm-fix-leak-of-expired-xfrm_states.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

[XFRM]: Fix leak of expired xfrm_states

[ Upstream commit: 5dba4797115c8fa05c1a4d12927a6ae0b33ffc41 ]

The xfrm_timer calls __xfrm_state_delete, which drops the final reference
manually without triggering destruction of the state. Change it to use
xfrm_state_put to add the state to the gc list when we're dropping the
last reference. The timer function may still continue to use the state
safely since the final destruction does a del_timer_sync().

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -370,7 +370,7 @@ int __xfrm_state_delete(struct xfrm_stat
 		 * The xfrm_state_alloc call gives a reference, and that
 		 * is what we are dropping here.
 		 */
-		__xfrm_state_put(x);
+		xfrm_state_put(x);
 		err = 0;
 	}
 

-- 
