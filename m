Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbYBMQbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbYBMQbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbYBMQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:30:54 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:38310 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbYBMQax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:30:53 -0500
Date: Wed, 13 Feb 2008 10:20:53 -0600
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/8] IPMI: Hold ATTN until upper layer ready
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Patrick Schoeller <Patrick.Schoeller@hp.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080213162053.GA9830@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

Hold handling of ATTN until the upper layer has reported that it is
ready.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
---

Index: linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.24.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.24/drivers/char/ipmi/ipmi_si_intf.c
@@ -723,8 +723,11 @@ static enum si_sm_result smi_event_handl
 		si_sm_result = smi_info->handlers->event(smi_info->si_sm, 0);
 	}
 
-	/* We prefer handling attn over new messages. */
-	if (si_sm_result == SI_SM_ATTN)
+	/*
+	 * We prefer handling attn over new messages.  But don't do
+	 * this if there is not yet an upper layer to handle anything.
+	 */
+	if (likely(smi_info->intf) && si_sm_result == SI_SM_ATTN)
 	{
 		unsigned char msg[2];
 
