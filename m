Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0AEAft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0AEAft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404Ab0AEAfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:42 -0500
Received: from kroah.org ([198.145.64.141]:34429 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab0AEAfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 58/97] mac80211: fix race with suspend and dynamic_ps_disable_work
Date: Mon,  4 Jan 2010 16:33:11 -0800
Message-Id: <1262651630-7354-58-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit b98c06b6debfe84c90200143bb1102f312f50a33 upstream.

When mac80211 suspends it calls a driver's suspend callback
as a last step and after that the driver assumes no calls will
be made to it until we resume and its start callback is kicked.
If such calls are made, however, suspend can end up throwing
hardware in an unexpected state and making the device unusable
upon resume.

Fix this by preventing mac80211 to schedule dynamic_ps_disable_work
by checking for when mac80211 starts to suspend and starts
quiescing. Frames should be allowed to go through though as
that is part of the quiescing steps and we do not flush the
mac80211 workqueue since it was already done towards the
beginning of suspend cycle.

The other mac80211 issue will be hanled in the next patch.

For further details see refer to the thread:

http://marc.info/?t=126144866100001&r=1&w=2

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/mac80211/tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eaa4118..d398197 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1401,6 +1401,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    local->hw.conf.dynamic_ps_timeout > 0 &&
+	    !local->quiescing &&
 	    !(local->scanning) && local->ps_sdata) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
-- 
1.6.6

