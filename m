Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbYFPWbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbYFPWbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYFPWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:30:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:15732 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbYFPWa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,654,1204531200"; 
   d="scan'208";a="342218721"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [E1000-devel] [regression?] e1000e breaks IPMI
Date: Mon, 16 Jun 2008 15:30:24 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52056AC3B7@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080616211636.GA5179@develbox.linuxbox.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [E1000-devel] [regression?] e1000e breaks IPMI
Thread-Index: AcjP9lCas2/xU+FsQQO+vcRGDTBpHwABUupg
References: <20080616211636.GA5179@develbox.linuxbox.cz>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Nikola Ciprich" <extmaillist@linuxbox.cz>, <linux-kernel@vger.kernel.org>
Cc: <nikola.ciprich@linuxbox.cz>, <e1000-devel@lists.sourceforge.net>,
       <netdev@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-OriginalArrivalTime: 16 Jun 2008 22:30:26.0018 (UTC) FILETIME=[92B82C20:01C8D000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikola Ciprich wrote:
> Hi,
> it seems that e1000e breaks IPMI support on at least some
> motherboards (ie SuperMicro PDSMi-LN4 with AOC-IPMI20-E+ module, and
> also others).  
> When e1000e module is loaded, IPMI module stops to respond. The
> problem is, that it was working before, so I tried examining further
> and bisect showed that following commit caused it to stop working:  

thank you for bisecting.
also, I added netdev so the network developers are aware of this thread.
 
> commit 5918bd88effd0233a048983570ec5803f5f753dc
> Author: Auke Kok <auke-jan.h.kok@intel.com>
> Date:   Tue Feb 12 15:20:24 2008 -0800
> 
>     e1000e: Fix CRC stripping in hardware context bug
> 
>     CRC stripping was only correctly enabled for packet split recieves
>     which is used when receiving jumbo frames. Correctly enable SECRC
>     also for normal buffer packet receives.

At one point I fixed a similar bug in e1000 on 82546 hardware that was
connected to a BMC.  In that case the packets were being discarded by a
BMC that is apparently unable to understand that the hardware is
stripping the CRC at reception (and then the BMC looks for the CRC and
drops the packet because there isn't one)

Basically this works fine for Intel BMC's that know about the (AFAIK -
I'm not a BMC expert) special fields in the SMBUS header that indicate
whether the packet was CRCd correctly.  Does the BMC have an option to
turn off CRC checking?  The BMC is the real problem here, probably.
 
> I can confirm that reverting the patch makes IPMI work again. So it
> either is a regression, or maybe just trigger for some other bug
> (seems more likely to me). Pity I haven't noticed it sooner, we've
> been using older e1000[e] drivers up to now.   
> 
> Any suggestions on where the problem could be?

I'm pretty sure that if you disable hardware stripping then it will
start working.  The short term solution is change the code to disable
setting the SECRC bit, like you did when you reverted the patch.

There is a possible complex patch that completely implements software
stripping of CRCs, because there are a lot of issues with doing
pskb_trim, etc in receive.  It would be modeled on the same kind of
thing we did for e1000.  

I hate working around this broken BMC (again) when others are known to
work just fine, and CRC stripping in hardware really simplifies our
receive path.

Netdev, any advice?

