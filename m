Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYGSPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYGSPce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYGSPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:32:26 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:44899 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbYGSPc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:32:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=YN6DqclJxPAcsDWi3PESTomrP9lbS5T+17eSxfzavMikFvHI87SVCaM7fAU/9w+WszxL6w99Jokq7Mga+yQ907JXNm/ZCrdjC4fLd4n6TaLGSuFbMmrOMvlL1LSmZUqN;
Message-ID: <48820904.2090707@simon.arlott.org.uk>
Date: Sat, 19 Jul 2008 16:32:20 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Arjan van de Ven <arjan@infradead.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Re  [patch 2/3] fastboot: turn the USB hostcontroller initcalls
 into async initcalls
References: <Pine.LNX.4.44L0.0807191116370.3491-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807191116370.3491-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/08 16:25, Alan Stern wrote:
> On 18 July, 2008, Arjan van de Ven wrote:
> 
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Subject: [PATCH] fastboot: turn the USB hostcontroller initcalls into 
>> async initcalls
>> 
>> the USB host controller init calls take a long time, mostly due to a
>> "minimally 100 msec" delay *per port* during initialization.
>> These are prime candidates for going in parallel to everything else.
>> 
>> The USB device ordering is not affected by this due to the
>> serialized-within-eachother property of async initcalls.
> 
> Is there some reason this patch wasn't posted to the linux-usb mailing
> list as well as to LKML?
> 
> Where is this "minimally 100 msec" per-port delay you refer to?  
> Offhand I can't recall any such delays in the init routines.
> 

usb/core/hub.c:

/* USB 2.0 spec, 7.1.7.3 / fig 7-29:
 *
 * Between connect detection and reset signaling there must be a delay
 * of 100ms at least for debounce and power-settling.  The corresponding
 * timer shall restart whenever the downstream port detects a disconnect.
 *
 * Apparently there are some bluetooth and irda-dongles and a number of
 * low-speed devices for which this debounce period may last over a second.
 * Not covered by the spec - but easy to deal with.
 *
 * This implementation uses a 1500ms total debounce timeout; if the
 * connection isn't stable by then it returns -ETIMEDOUT.  It checks
 * every 25ms for transient disconnects.  When the port status has been
 * unchanged for 100ms it returns the port status.
 */

Could it do that for all ports on the hub in parallel instead?

-- 
Simon Arlott
