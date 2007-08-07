Return-Path: <linux-kernel-owner+w=401wt.eu-S935400AbXHGUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400AbXHGUsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964826AbXHGUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:46:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51330 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935222AbXHGUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:46:53 -0400
Date: Tue, 7 Aug 2007 13:43:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Vlad Yasevich <vladislav.yasevich@hp.com>
Subject: [2.6.22.2 review 08/84] SCTP scope_id handling fix
Message-ID: <20070807204304.GI23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sctp-scope_id-handling-fix.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>

SCTP: Add scope_id validation for link-local binds

SCTP currently permits users to bind to link-local addresses,
but doesn't verify that the scope id specified at bind matches
the interface that the address is configured on.  It was report
that this can hang a system.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/ipv6.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -875,6 +875,10 @@ static int sctp_inet6_send_verify(struct
 			dev = dev_get_by_index(addr->v6.sin6_scope_id);
 			if (!dev)
 				return 0;
+			if (!ipv6_chk_addr(&addr->v6.sin6_addr, dev, 0)) {
+				dev_put(dev);
+				return 0;
+			}
 			dev_put(dev);
 		}
 		af = opt->pf->af;

-- 
