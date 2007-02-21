Return-Path: <linux-kernel-owner+w=401wt.eu-S964841AbXBUBxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbXBUBxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964824AbXBUBwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:52:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822AbXBUBwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:52:04 -0500
Date: Tue, 20 Feb 2007 17:50:34 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mst@mellanox.co.il,
       openib-general@openib.org, Roland Dreier <rolandd@cisco.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/18] IB/mad: Fix race between cancel and receive completion
Message-ID: <20070221015034.GJ3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-mad-fix-race-between-cancel-and-receive-completion.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rdreier@cisco.com>

When ib_cancel_mad() is called, it puts the canceled send on a list
and schedules a "flushed" callback from process context.  However,
this leaves a window where a receive completion could be processed
before the send is fully flushed.

This is fine, except that ib_find_send_mad() will find the MAD and
return it to the receive processing, which results in the sender
getting both a successful receive and a "flushed" send completion for
the same request.  Understandably, this confuses the sender, which is
expecting only one of these two callbacks, and leads to grief such as
a use-after-free in IPoIB.

Fix this by changing ib_find_send_mad() to return a send struct only
if the status is still successful (and not "flushed").  The search of
the send_list already had this check, so this patch just adds the same
check to the search of the wait_list.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/infiniband/core/mad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.18.7.orig/drivers/infiniband/core/mad.c
+++ linux-2.6.18.7/drivers/infiniband/core/mad.c
@@ -1750,7 +1750,7 @@ ib_find_send_mad(struct ib_mad_agent_pri
 		     */
 		    (is_direct(wc->recv_buf.mad->mad_hdr.mgmt_class) ||
 		     rcv_has_same_gid(mad_agent_priv, wr, wc)))
-			return wr;
+			return (wr->status == IB_WC_SUCCESS) ? wr : NULL;
 	}
 
 	/*

--
