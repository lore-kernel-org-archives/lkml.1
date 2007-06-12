Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXFLMco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXFLMco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXFLMch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:32:37 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:44530 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXFLMcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:32:36 -0400
Date: Tue, 12 Jun 2007 05:32:19 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Stephane Eranian <eranian@hpl.hp.com>, levon@movementarian.org
Subject: problem with NMI MSR reserve routines
Message-ID: <20070612123219.GE32163@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070601101648.GD24898@frankl.hpl.hp.com> <20070601105753.GE7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601105753.GE7217@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I am running into several issues related to the newly restructured
NMI MSR allocator in perfctr-watchdog.c. There are issues with Oprofile
and also with perfmon.

Let me describe the Oprofile issue first (because perfmon is similar).
The fill_in_addresses() callback for Oprofile systematically invokes the
reserve_perfctr_nmi()/reserve_evntsel_nmi() routines regardless
of whether NMI watchdog is active or not. It uses those routines as
a generic PMU register allocator which it is not in its current form.

The issue is that the reserve_*() have a side effect when wd_ops is not
yet defined. The nmi_*_msr_to_bit() routines return 0 which means you've
collapsed all MSR to a single bit. The first reserve() will return success
the others will return failure, thus the caller will assume only one PMU
register is present. This what you can see in the following trace for
Oprofile on Opteron with nmi_watchdog=0:

tired kernel: res_ctr @0xc0010004 returns 1 (success)
tired kernel: res_ctr @0xc0010005 returns 0 (failure)
tired kernel: res_ctr @0xc0010006 returns 0
tired kernel: res_ctr @0xc0010007 returns 0

tired kernel: res_sel @0xc0010000 returns 1 (success)
tired kernel: res_sel @0xc0010001 returns 0 (failure)
tired kernel: res_sel @0xc0010002 returns 0
tired kernel: res_sel @0xc0010003 returns 0

I think we either need to fix up fill_in_addresses X86 routines to check
for nmi_watchdog() or (better) change the allocator to work differently,be
independent of NMI watchdog.

-- 
-Stephane
