Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbYFRFMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbYFRFMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 01:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759869AbYFRFMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 01:12:18 -0400
Received: from mga10.intel.com ([192.55.52.92]:47779 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759847AbYFRFMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 01:12:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,663,1204531200"; 
   d="scan'208";a="579116786"
Subject: Re: IPF Montvale machine panic when running a network-relevent
	testing
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080617.203703.254889774.davem@davemloft.net>
References: <1213345160.25608.3.camel@ymzhang>
	 <1213759663.25608.33.camel@ymzhang>
	 <20080617.203703.254889774.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Jun 2008 13:12:02 +0800
Message-Id: <1213765922.25608.36.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-17 at 20:37 -0700, David Miller wrote:
> From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> Date: Wed, 18 Jun 2008 11:27:43 +0800
> 
> > This issue is caused by tcp defer accept. Mostly, process context calls lock_sock
> > to apply a sleeping lock. BH (SoftIRQ) context calls bh_lock_sock(_nested) to just apply
> > for the sk->sk_lock.slock without sleeping, then do appropriate processing based on
> > if sk->sk_lock.owned==0. That works well if both process context and BH context operate
> > the same sk at the same time. But with ﻿tcp defer accept, it doesn't, because
> > process context(for example, in inet_csk_accept) locks the listen sk, while BH
> > context (in tcp_v4_rcv, for example) locks the child sk and calls
> > ﻿tcp_defer_accept_check﻿ => inet_csk_reqsk_queue_add => reqsk_queue_add, so there is a race
> > to access the listen sock.
> > 
> > Below patch against 2.6.26-rc6 fixes the issue.
> > 
> > ﻿﻿Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> We reverted the guilty defer accept changes, please test Linus's
> current tree.
I happened to download git tree on June 16th, which includes the reverting patch.

I confirm it fixes the hang issue.

-yanmin


