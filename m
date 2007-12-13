Return-Path: <linux-kernel-owner+w=401wt.eu-S1762092AbXLMG4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092AbXLMG4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbXLMGze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759776AbXLMGzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:33 -0500
Date: Wed, 12 Dec 2007 22:51:10 -0800
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
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 03/60] NETFILTER: Fix NULL pointer dereference in
	nf_nat_move_storage()
Message-ID: <20071213065110.GD6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-fix-null-pointer-dereference-in-nf_nat_move_storage.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

[NETFILTER]: Fix NULL pointer dereference in nf_nat_move_storage()

[ Upstream commit: 7799652557d966e49512479f4d3b9079bbc01fff ]

Reported by Chuck Ebbert as:

	https://bugzilla.redhat.com/show_bug.cgi?id=259501#c14

This routine is called each time hash should be replaced, nf_conn has
extension list which contains pointers to connection tracking users
(like nat, which is right now the only such user), so when replace takes
place it should copy own extensions. Loop above checks for own
extension, but tries to move higer-layer one, which can lead to above
oops.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -109,7 +109,7 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 			rcu_read_lock();
 			t = rcu_dereference(nf_ct_ext_types[i]);
 			if (t && t->move)
-				t->move(ct, ct->ext + ct->ext->offset[id]);
+				t->move(ct, ct->ext + ct->ext->offset[i]);
 			rcu_read_unlock();
 		}
 		kfree(ct->ext);
--
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable

-- 
