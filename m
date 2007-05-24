Return-Path: <linux-kernel-owner+w=401wt.eu-S1750858AbXEXOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858AbXEXOp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbXEXOo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:44:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:16904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbXEXOo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,574,1170662400"; 
   d="scan'208";a="90119135"
Message-ID: <4655A4CD.8010901@intel.com>
Date: Thu, 24 May 2007 07:44:29 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org> <20070524104713.GA9174@gondor.apana.org.au> <20070524105403.GA9285@gondor.apana.org.au>
In-Reply-To: <20070524105403.GA9285@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2007 14:44:55.0817 (UTC) FILETIME=[1854F790:01C79E12]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, May 24, 2007 at 08:47:13PM +1000, Herbert Xu wrote:
>> On Thu, May 24, 2007 at 11:36:22AM +0100, Jeremy Fitzhardinge wrote:
>>> I got a hang while rmmodding e1000.  sysrq-t shows:
>>>
>>> rmmod         D 003FFAFC  6616 15923  15911 (NOTLB)
>>>        e9341e44 00000092 82318c15 003ffafc e9341e2c 00000000 e9341e14 823187a1 
>>>        003ffafc 00000000 c0123862 d3dbab80 d3dbad1c c2c08a40 77a67d01 000001ca 
>>>        00000292 e9341e24 c03799cd e9341e54 c0540840 e9341e44 00223389 000000ff 
>>> Call Trace:
>>>  [<c03777b1>] schedule_timeout+0x70/0x8e
>>>  [<c03777e4>] schedule_timeout_uninterruptible+0x15/0x17
>>>  [<c0133d04>] msleep+0x10/0x16
>>>  [<c030d5e0>] dev_close+0x39/0x6b
>> Looks like we're spinning on __LINK_STATE_RX_SCHED.  This means that
>> someone called netif_poll_disable() without re-enabling it again.
>> Perhaps e1000_io_error_detected? Auke?

Should not be, e1000_io_error_detected will call e1000_down which does the 
netif_poll_disable, but e1000_io_resume nicely calls e1000_up again which does 
the netif_poll_enable again, unless io_resume somehow failed

> I think the dual meaning of __LINK_STATE_RX_SCHED is seriously broken.
> In dev_close we are waiting for any outstanding poll to terminate but
> the same bit can either mean an outstanding poll or that poll has
> been disabled.

that seems more likely

> It's a surprise that it has taken so many years for someone to report
> a bug on it.  I'll try to get this fixed up, probably by adding a bit.

I get the feeling that a recent change exposed us to this, our lab has been 
seeing similar OOPS's yesterday out of nothing.


Auke
