Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYIBU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYIBU3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYIBU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:29:33 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36775 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYIBU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:29:33 -0400
Message-ID: <1100.69.2.248.210.1220385669.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 2 Sep 2008 14:01:09 -0600 (MDT)
Subject: TLB IPI FLushTLB vs Invl Page
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Analysis on this one has been done by others on other OS's.   Results are:


NMI IPI which results in TLB flush

mov eax, cr3
mov cr3,eax

vs.

invlpg [page]


TLB flushing always blows out the TLB and it usually takes 150 clocks
(cumulative over time) for the processor to recover.  invlpage is more
lightweight but takes around 100 clocks for the system to recover.

Easiest way to measure the two is to write a short program loop that does
something like (holding the processor into this loop):


while (1)
{
   FlushTLB();
   counter++;
}


vs.

while (1)
{
   Invlpg(page);
   counter++;
}


and compare which one counts higher on all processors -- this one is less
overhead on the bus overall.

I did the same tests many years ago and compared these two instructions.

results were invlpg saves you on performance but overall was no better
than flushing the entire TLB since you end up ending more IPI's on average.

Jeff




