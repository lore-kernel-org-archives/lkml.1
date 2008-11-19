Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYKSIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYKSIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKSIlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:41:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:22871 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYKSIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:41:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:x-mutt-fcc:user-agent;
        b=fgEzFknabaFwMBVGukGbKefO/N8KpUqklYua+i/ho5P+AcMZCr8fMb7EsEs+6RXOer
         6IePu2aBWilT+PQCbfBuVtIBLJFcFTq6Jnt5duALPURSYBkBsT1mnj12EEXYVDBQ1cVV
         fKu82jPUNuzxZw4+fe03VO03zFGmxF5RbNf04=
Date: Wed, 19 Nov 2008 08:41:06 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Ferenc Wagner <wferi@niif.hu>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] netconsole: Disable softirqs in write_msg()
Message-ID: <20081119084106.GA6699@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y6zwwy5c.fsf@tac.ki.iif.hu>
X-Mutt-Fcc: =outbox
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This report: http://marc.info/?l=linux-netdev&m=122599341430090&w=2
shows local_bh_enable() is used in the wrong context (irqs disabled).
It happens when a usual network path is called by netconsole, which
simply turns off hardirqs around this all.

This patch additionally disables softirqs to avoid possibility of
enabling bh and calling do_softirq() with hardirqs disabled.

Reported-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 drivers/net/netconsole.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index d304d38..f6ecad8 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -702,6 +702,8 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 	if (list_empty(&target_list))
 		return;
 
+	/* Avoid enabling softirqs with hardirqs disabled */
+	local_bh_disable();
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
 		netconsole_target_get(nt);
@@ -723,6 +725,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
+	local_bh_enable();
 }
 
 static struct console netconsole = {
