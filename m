Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061Ab0ATJcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab0ATJcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902Ab0ATJcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:32:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:39093 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab0ATJcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:32:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="234744868"
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
From: Zhu Yi <yi.zhu@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20100119054715.GA10780@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
	 <1263576588.2751.455.camel@rc-desk>
	 <20100119054715.GA10780@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 17:32:44 +0800
Message-ID: <1263979965.10275.2.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-18 at 22:47 -0700, Norbert Preining wrote:
> Hi Reinette,
> 
> On Fr, 15 Jan 2010, reinette chatre wrote:
> > > I am having repeatable complete hard lockups on my laptop with 2.6.33-rc4.
> > > 2.6.32.3 works fine.
> > > 
> > > I believe that it is related to the network, because sometimes I can
> > > actually log in (gnomes session) and as soon as I do some network
> > > related suddenly hard hang, not even Sysrq working anymore.
> > > 
> > > Interestingly it only happens at a specific AP where the ESSID is
> > > hidden (at work). At home I can work without any problems (ESSID not
> > > hidden).
> > > 
> > > Unfortunately I cannot set up a serial console or similar.
> > 
> > Does that mean no netconsole either? Does anything show up in the logs?
> > Is it easy to reproduce? If so, perhaps you can have increased debug at
> > that time and hopefully something will be captured in the logs when the
> > problem occurs.
> 
> Ok, I can confirm that setting up the network is not the problem, nor
> is it pinging other hosts. But ssh-ing into another server
> made it go boom. From the screenshot I attach it looks like something
> in TCP code (that explains why it does not happen in pings), below
> I see tcp_data_snd_check
> 
> I managed to swithc in time to a console with tail -f syslog before
> it hard locked up. The log files are empty, but I got a screenshot photo
> which has some hopefully useful information. I cannot scroll up or down
> anymore ...

Looks like this this is the BUG_ON in skb_pull. Please try if this patch
help? BTW, are you using swiotlb?

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6f36b6e..2f8978f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1031,6 +1031,11 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		return;
 	}
 
+	if (len < ieee80211_hdrlen(header->frame_control)) {
+		IWL_DEBUG_RX(priv, "Packet size is too small %d\n", len);
+		return;
+	}
+
 	/* This will be used in several places later */
 	rate_n_flags = le32_to_cpu(phy_res->rate_n_flags);
 


