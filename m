Return-Path: <linux-kernel-owner+w=401wt.eu-S1751861AbYJFFEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbYJFFEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYJFFEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:04:12 -0400
Received: from mga07.intel.com ([143.182.124.22]:11147 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbYJFFEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,366,1220252400"; 
   d="scan'208";a="55524984"
Subject: aim7 47% regression with 2.6.27-rc8
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 12:58:55 +0800
Message-Id: <1223269135.1685.11.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.27-rc8, aim7 result has about 47% regression with 2.6.27-rc8 on
my 16-core tigerton and 8 core+HyperThreading x86_64 machine.

I bisected it down to patch:

302745699c1b675b5d2a1af87271de10e4d96b6a is first bad commit
commit 302745699c1b675b5d2a1af87271de10e4d96b6a
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Sep 22 19:02:25 2008 +0200

    clockevents: check broadcast device not tick device
    
    Impact: Possible hang on CPU online observed on AMD C1E machines.
    
    The broadcast setup code looks at the mode of the tick device to
    determine whether it needs to be shut down or setup. This is wrong
    when the broadcast mode is set to one shot already. This can happen
    when a CPU is brought online as it goes through the periodic setup
    first.
    
    The problem went unnoticed as sane systems do not call into that code
    before the switch to one shot for the clock event device happens.
    The AMD C1E idle routine switches over immediately and thereby shuts
    down the just setup device before the first interrupt happens.


After I reverted the patch against 2.6.27-rc8, the regression disappears.
It's interesting that the regression doesn't exist on 8-core stoakley.

-yanmin


