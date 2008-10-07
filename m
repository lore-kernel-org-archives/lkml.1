Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbYJGBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbYJGBBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757948AbYJGAp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbYJGApz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:55 -0400
Date: Mon, 6 Oct 2008 17:40:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 57/71] sctp: do not enable peer features if we cant do them.
Message-ID: <20081007004000.GF3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0007-sctp-do-not-enable-peer-features-if-we-can-t-do-the.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Vlad Yasevich <vladislav.yasevich@hp.com>

[ Upstream commit 0ef46e285c062cbe35d60c0adbff96f530d31c86 ]

Do not enable peer features like addip and auth, if they
are administratively disabled localy.  If the peer resports
that he supports something that we don't, neither end can
use it so enabling it is pointless.  This solves a problem
when talking to a peer that has auth and addip enabled while
we do not.  Found by Andrei Pelinescu-Onciul <andrei@iptel.org>.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/sm_make_chunk.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1886,11 +1886,13 @@ static void sctp_process_ext_param(struc
 			    /* if the peer reports AUTH, assume that he
 			     * supports AUTH.
 			     */
-			    asoc->peer.auth_capable = 1;
+			    if (sctp_auth_enable)
+				    asoc->peer.auth_capable = 1;
 			    break;
 		    case SCTP_CID_ASCONF:
 		    case SCTP_CID_ASCONF_ACK:
-			    asoc->peer.asconf_capable = 1;
+			    if (sctp_addip_enable)
+				    asoc->peer.asconf_capable = 1;
 			    break;
 		    default:
 			    break;
@@ -2455,6 +2457,9 @@ static int sctp_process_param(struct sct
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
+		if (!sctp_addip_enable)
+			goto fall_through;
+
 		addr_param = param.v + sizeof(sctp_addip_param_t);
 
 		af = sctp_get_af_specific(param_type2af(param.p->type));

-- 
