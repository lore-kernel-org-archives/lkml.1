Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbYBGVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbYBGVFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933374AbYBGUwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:37 -0500
Received: from ns.suse.de ([195.135.220.2]:45742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933030AbYBGUwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:36 -0500
Date: Thu, 7 Feb 2008 12:47:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 29/45] sky2: restore multicast addresses after recovery
Message-ID: <20080207204747.GD16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-restore-multicast-addresses-after-recovery.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

patch a7bffe722c996679b4fb2103ecaf673ec2b9b4a7 in mainline.

If the sky2 deadman timer forces a recovery, the multicast hash
list is lost. Move the call to sky2_set_multicast to the end
of sky2_up() so all paths that bring device up will restore multicast.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1412,6 +1412,7 @@ static int sky2_up(struct net_device *de
 	imask |= portirq_msk[port];
 	sky2_write32(hw, B0_IMSK, imask);
 
+	sky2_set_multicast(dev);
 	return 0;
 
 err_out:
@@ -3533,8 +3534,6 @@ static int sky2_set_ringparam(struct net
 		err = sky2_up(dev);
 		if (err)
 			dev_close(dev);
-		else
-			sky2_set_multicast(dev);
 	}
 
 	return err;
@@ -4368,8 +4367,6 @@ static int sky2_resume(struct pci_dev *p
 				dev_close(dev);
 				goto out;
 			}
-
-			sky2_set_multicast(dev);
 		}
 	}
 

-- 
