Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZDPFys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZDPFys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZDPFyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:54:36 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:54220
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391AbZDPFyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:54:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgBAJxk5kl8qNY8/2dsb2JhbAAI0BuDfQY
X-IronPort-AV: E=Sophos;i="4.40,197,1238947200"; 
   d="scan'208";a="483233268"
Subject: [PATCH 0/9] Fix unsafe disable_irq usage
From: Ben Nizette <bn@niasdigital.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: dan.j.williams@intel.com, Eric Miao <eric.miao@marvell.com>,
       linux@arm.linux.org.uk, dmitry.torokhov@gmail.com,
       p_gortmaker@yahoo.com, David Brownell <david-b@pacbell.net>,
       sameo@linux.intel.com, linux-omap@vger.kernel.org, pierre@ossman.eu,
       linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:54:05 +1000
Message-Id: <1239861245.29831.113.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After being bitten by unsafe usage of disable_irq from within that irq's
handler [1], I went through and used Coccinelle to audit the rest of
drivers/ too.  This turned up 9 more unsafe usages.

As Haavard pointed out in that thread, disable_irq waits for running
handlers of an irq to complete before returning.  When a handler
disable_irq's its own irq then we see a deadlock.

Note that this wasn't actually observed in the wild until the recent
merge of

commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Mar 23 18:28:15 2009 +0100

    genirq: add threaded interrupt handler support

    Add support for threaded interrupt handlers



Regards,
	--Ben.


[1] http://lkml.org/lkml/2009/4/15/498

