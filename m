Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYILClG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYILClG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 22:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYILCkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 22:40:52 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:24424 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYILCkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 22:40:51 -0400
X-IronPort-AV: E=Sophos;i="4.32,385,1217808000"; 
   d="scan'208";a="45366369"
From: Roland Dreier <rdreier@cisco.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
References: <48C9D040.8010107@lwfinger.net>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 11 Sep 2008 19:39:49 -0700
In-Reply-To: <48C9D040.8010107@lwfinger.net> (Larry Finger's message of "Thu,
	11 Sep 2008 21:13:20 -0500")
Message-ID: <ada4p4mm6iy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Sep 2008 02:39:49.0622 (UTC) FILETIME=[D3A93160:01C91480]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > In file drivers/net/wireless/p54/p54common.c, the statement
 > 
 >        priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);

[I don't see this code in Linus's tree]

 > 
 > generates the sparse warning
 > 
 > .../p54common.c:185:29: warning: cast to restricted __le16
 > 
 > where bootrec->data is u32, and priv->rx_mtu is u16.
 > 
 > What should be done to eliminate this warning?

the code in question looks buggy to me.  Since bootrec->data[10] is u32,
casting it to a 16-bit type is going to take a different 2 bytes out of
the 4 bytes depending on the endianness of the system the driver is
built for.  And I assume you are parsing some fixed-layout thing that
the firmware is giving you or something like that.

I would guess you want something like:

	priv->rx_mtu = le16_to_cpu(((__force __le16 *) bootrec->data)[20]);

(__force is what shuts up sparse, and as far as I can see, the size_t
cast is useless, since the result will be promoted anyway)

 - R.
