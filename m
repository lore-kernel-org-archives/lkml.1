Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYFCWOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYFCWOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbYFCWOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:14:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42865
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755643AbYFCWOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:14:17 -0400
Date: Tue, 03 Jun 2008 15:14:16 -0700 (PDT)
Message-Id: <20080603.151416.266389541.davem@davemloft.net>
To: y-goto@jp.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080430213831.F808.E1E9C6FF@jp.fujitsu.com>
References: <20080430.002530.189687792.davem@davemloft.net>
	<20080430163355.4b4f23ec.kamezawa.hiroyu@jp.fujitsu.com>
	<20080430213831.F808.E1E9C6FF@jp.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasunori Goto <y-goto@jp.fujitsu.com>
Date: Wed, 30 Apr 2008 21:53:18 +0900

> I'll reconsider around here.

I think I know at least one of the problems in this change.

This code assumes that it can take __pa() on NODE_DATA().

But, if NUMA is disabled, NODE_DATA() is &contig_page_data which is a
kernel image symbol.  __pa() is not supported for such addresses.

It happens to work on x86, but it will not work on just about every
other platform.

There are several things to consider to fix this changeset and
get it back into a state where it can be resubmitted into the
tree:

1) What is the goal here wrt. allocating the usemap when NUMA
   is disabled.

2) What is appropriate if section_nr targetted allocation of
   the usemap fails.

It seems to me that the pgdat and usemap should be allocated
together if putting them into the same section is important.
This allows us to avoid case #2 completely, and therefore we
don't even need to consider how to handle such a failure.
