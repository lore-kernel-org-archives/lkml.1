Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837Ab0A0AJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0A0AJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656Ab0A0AJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:09:22 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:8718 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab0A0AJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:09:17 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHETX0urR7H+/2dsb2JhbADDQoleCI1BgkEIgW4E
X-IronPort-AV: E=Sophos;i="4.49,349,1262563200"; 
   d="scan'208";a="292667204"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126220333.GB12035@ldl.fc.hp.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 26 Jan 2010 16:09:13 -0800
In-Reply-To: <20100126220333.GB12035@ldl.fc.hp.com> (Alex Chiang's message of
	"Tue, 26 Jan 2010 15:03:33 -0700")
Message-ID: <adaljfko1cm.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jan 2010 00:09:16.0811 (UTC) FILETIME=[F70E1DB0:01CA9EE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > It looks like we have a hole from [128, 192).
 > 
 > Would it be something as simple as this?

 > -       IB_UVERBS_BASE_MINOR  = 192,
 > -       IB_UVERBS_MAX_DEVICES = 32
 > +       IB_UVERBS_BASE_MINOR  = 128,
 > +       IB_UVERBS_MAX_DEVICES = 64

I don't think this is a good idea for two reasons:

 - It doesn't take into account the fact that the infiniband_mad and
   infiniband_cm drivers will take up more minors if more devices appear
   (in the best case, you would only be able to run opensm on the first
   32 HCAs or something like that).

 - It changes the minor of the first uverbs device, so something like a
   system with hardcoded static /dev would break in a mysterious way.

I think unfortunately we have to extend the device # assignment so the
first 32 HCAs get the same minors they would have and then overflow into
some dynamic region.

 - R.
