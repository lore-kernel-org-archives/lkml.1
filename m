Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYCQIpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYCQIpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYCQIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:45:08 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:47064 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754582AbYCQIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:44:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cb0KzO7+ttlK8PgrlNhqkRBlMRWbuUK/DUhE612iNjLHibbpCV6Yk0Aoa4ABpGzIEM7FK/2BnP0UBJqXjXrVBu4UEI0wxDnUvO22rOSsChhfLQ136uBMgFzTr0MHFnyBIcoHJZpuSBXs+lrEVwStBb/WSClOGpzrSd4BA5XNEkw=  ;
X-YMail-OSG: WwdJOioVM1lHRZ1XfAptV3Z2.NOzc7UI0gVwVB_b1nM18lhd4N3lMVjiEmDcNfKlNfLJoq7YzQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Too many timer interrupts in NO_HZ
Date: Mon, 17 Mar 2008 00:44:49 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>, suresh.b.siddha@intel.com,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       discuss@lesswatts.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0803162224460.2108-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803162224460.2108-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803170144.50990.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Alan Stern wrote:
> On Sun, 16 Mar 2008, Vaidyanathan Srinivasan wrote:
> 
> The largest entry is for ehci_watchdog.  This timer won't run at all if

... you're not accessing EHCI devices at all.  Is HAL or
something else polling them too often?  Or are you maybe
doing something else that resembles "real work"?


> your EHCI controllers are allowed to autosuspend, which will happen
> automatically if
> 
> 	(1) You enable CONFIG_USB_SUSPEND, and
> 
> 	(2) You have no high-speed USB devices attached, or the
> 	    ones that are attached have all been suspended.
> 
> On the other hand, if you were actively using some high-speed USB 
> device during the test then it's understandable that there should be 
> lots of timer interrupts as a result.

That watchdog is a bit messy, but it's got two basic tasks:

 (a) Take work off the async ring ... bulk and control
     transfers will leave an empty QH there for a few
     milliseconds before taking it off, to avoid wasting
     effort in the common case where another transfer
     quickly follows the first one.  In the extreme case,
     when there's no more work, that ring gets disabled.

 (b) A real I/O watchdog ... in case the hardware forgets
     to issue some kind of I/O completion interrupt.  This
     watchdog rarely needs to fire.

So I'm thinking this is most likely a case where something
is sending work to one or more high speed devices.

- Dave

