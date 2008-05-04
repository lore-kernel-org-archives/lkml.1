Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYEDRCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYEDRCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYEDRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:01:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60112 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYEDRB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:01:56 -0400
From: Roland Dreier <rdreier@cisco.com>
To: benh@kernel.crashing.org
Cc: "Moore\, Eric" <Eric.Moore@lsi.com>, linux-kernel@vger.kernel.org
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
	<ada63tw494z.fsf@cisco.com> <1209854242.26383.30.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 04 May 2008 10:01:55 -0700
In-Reply-To: <1209854242.26383.30.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Sun, 04 May 2008 08:37:22 +1000")
Message-ID: <adaabj62ebg.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 May 2008 17:01:55.0751 (UTC) FILETIME=[8EB8DB70:01C8AE08]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > I don't have an authoritative answer, but I can say that I coded
 > > drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
 > > atomic in the sense that you say, and no one has reported any problems.
 > > 
 > > But I'm sure no one has stressed the drivers on 64-bit mips or anything
 > > unusual like that.
 > 
 > Surely only on 64 bits archs right ?

Your question is a bit too terse for me to know exactly what you're
asking, but it is true that these IB drivers use writeq() only on 64-bit
architectures (since no 32-bit architectures even define writeq()!).

The hardware I'm dealing with is smart enough to cope with a driver that
does a write to these 64-bit registers in two 32-bit chunks, as long as
no other writes come in the middle.  So on 32-bit architectures I just
have a spinlock around two writel()s.

The assumption I'm making is that no locking or anything is needed on
64-bit architectures to avoid the writeq() being split into two
transactions with a third unrelated transaction in the middle.

It sounds as though Eric's hardware is much harder to deal with in that
it requires the write to a 64-bit register to be done in a single
transaction, and I'm not sure there is a way to do that on all 32-bit
architectures; certainly we have nothing clean and portable that a
driver can use to do that.

 - R.
