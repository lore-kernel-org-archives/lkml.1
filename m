Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYAOVyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYAOVyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYAOVx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:53:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:16595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbYAOVx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:53:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,290,1196668800"; 
   d="scan'208";a="290782496"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Date: Tue, 15 Jan 2008 13:53:43 -0800
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52042FA541@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080115190458.rxt3yhb2o8o404kc@mail.bigtelecom.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Thread-Index: AchXlC3O1HExPF5YS7OjcVxBeWWRwwALFq+A
References: <200801150625.10823.elendil@planet.nl><20080114.215317.38045859.davem@davemloft.net><200801151504.10047.elendil@planet.nl> <20080115190458.rxt3yhb2o8o404kc@mail.bigtelecom.ru>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: <slavon@bigtelecom.ru>, "Frans Pop" <elendil@planet.nl>
Cc: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Jan 2008 21:53:44.0561 (UTC) FILETIME=[1958BE10:01C857C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slavon@bigtelecom.ru wrote:
> Quoting Frans Pop <elendil@planet.nl>:
>>> (Note this isn't the final correct patch we should apply.  There  is
>>> no reason why this revert back to the older ->poll() logic  here
>>> should have any effect on the TX hang triggering...)
>> 
>> s/no reason/no obvious reason/ ? ;-)

The tx code has an "early exit" that tries to limit the amount of tx
packets handled in a single poll loop and requires napi or interrupt
rescheduling based on the return value from e1000_clean_tx_irq.

see this code in e1000_clean_tx_irq

4005 #ifdef CONFIG_E1000_NAPI
4006 #define E1000_TX_WEIGHT 64
4007 >       >       /* weight of a sort for tx, to avoid endless
transmit cleanup */
4008 >       >       if (count++ == E1000_TX_WEIGHT) break;
4009 #endif

I think that is probably related.  For a test you could apply the
original patch, and remove this "break" just by commenting out line
4008.  This would guarantee all tx work is cleaned at every e1000_clean

Jesse
