Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXLMHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXLMHRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXLMG6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762671AbXLMG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:20 -0500
Date: Wed, 12 Dec 2007 22:53:27 -0800
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
       Pavel Emelyanov <xemul@openvz.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 51/60] DECNET: dn_nl_deladdr() almost always returns no
	error
Message-ID: <20071213065327.GA6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="decnet-dn_nl_deladdr-almost-always-returns-no-error.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pavel Emelyanov <xemul@openvz.org>

[DECNET]: dn_nl_deladdr() almost always returns no error

[ Upstream commit: 3ccd86241b277249d5ac08e91eddfade47184520 ]

As far as I see from the err variable initialization
the dn_nl_deladdr() routine was designed to report errors
like "EADDRNOTAVAIL" and probaby "ENODEV".

But the code sets this err to 0 after the first nlmsg_parse
and goes on, returning this 0 in any case.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/decnet/dn_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -650,16 +650,18 @@ static int dn_nl_deladdr(struct sk_buff 
 	struct dn_dev *dn_db;
 	struct ifaddrmsg *ifm;
 	struct dn_ifaddr *ifa, **ifap;
-	int err = -EADDRNOTAVAIL;
+	int err;
 
 	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, dn_ifa_policy);
 	if (err < 0)
 		goto errout;
 
+	err = -ENODEV;
 	ifm = nlmsg_data(nlh);
 	if ((dn_db = dn_dev_by_index(ifm->ifa_index)) == NULL)
 		goto errout;
 
+	err = -EADDRNOTAVAIL;
 	for (ifap = &dn_db->ifa_list; (ifa = *ifap); ifap = &ifa->ifa_next) {
 		if (tb[IFA_LOCAL] &&
 		    nla_memcmp(tb[IFA_LOCAL], &ifa->ifa_local, 2))

-- 
