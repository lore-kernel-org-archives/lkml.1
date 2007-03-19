Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXCSVkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXCSVkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXCSVjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:39:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:55491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbXCSVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:33 -0400
Date: Mon, 19 Mar 2007 14:37:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Moore <paul.moore@hp.com>,
       James Morris <jmorris@namei.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/31] NetLabel: Verify sensitivity level has a valid CIPSO mapping
Message-ID: <20070319213744.GG9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=netlabel-cipso_std_bug
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

The current CIPSO engine has a problem where it does not verify that the given
sensitivity level has a valid CIPSO mapping when the "std" CIPSO DOI type is
used.  The end result is that bad packets are sent on the wire which should
have never been sent in the first place.  This patch corrects this problem by
verifying the sensitivity level mapping similar to what is done with the
category mapping.  This patch also changes the returned error code in this case
to -EPERM to better match what the category mapping verification code returns.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/cipso_ipv4.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -732,11 +732,12 @@ static int cipso_v4_map_lvl_hton(const s
 		*net_lvl = host_lvl;
 		return 0;
 	case CIPSO_V4_MAP_STD:
-		if (host_lvl < doi_def->map.std->lvl.local_size) {
+		if (host_lvl < doi_def->map.std->lvl.local_size &&
+		    doi_def->map.std->lvl.local[host_lvl] < CIPSO_V4_INV_LVL) {
 			*net_lvl = doi_def->map.std->lvl.local[host_lvl];
 			return 0;
 		}
-		break;
+		return -EPERM;
 	}
 
 	return -EINVAL;
@@ -771,7 +772,7 @@ static int cipso_v4_map_lvl_ntoh(const s
 			*host_lvl = doi_def->map.std->lvl.cipso[net_lvl];
 			return 0;
 		}
-		break;
+		return -EPERM;
 	}
 
 	return -EINVAL;

-- 
