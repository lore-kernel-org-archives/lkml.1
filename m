Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZH0MJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZH0MJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZH0MJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:09:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54634 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZH0MJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:09:03 -0400
Date: Thu, 27 Aug 2009 08:08:41 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Chris Friesen <cfriesen@nortel.com>, linuxppc-dev@ozlabs.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix book E watchdog to take WDIOC_SETTIMEOUT arg in
	seconds
Message-ID: <20090827120841.GA25303@zod.rchland.ibm.com>
References: <4A8303C6.7070705@nortel.com> <20090827111458.GB29382@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827111458.GB29382@infomag.iguana.be>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:14:58PM +0200, Wim Van Sebroeck wrote:
>Hi Chris,
>
>> The WDIOC_SETTIMEOUT argument is supposed to be a "seconds" value.
>> However, the book E wdt currently treats it as a "period" which is
>> interpreted in a board-specific way.
>> 
>> This patch allows the user to pass in a "seconds" value and the driver
>> will set the smallest timeout that is at least as large as specified
>> by the user.  It's been tested on e500 hardware and works as
>> expected.
>> 
>> The patch only modifies the CONFIG_FSL_BOOKE case, the CONFIG_4xx case
>> is left unmodified as I don't have any hardware to test it on.
>> 
>> Signed-off-by: Chris Friesen <cfriesen@nortel.com>
>
>Added with some small changes to keep checkpatch happy. (removed trailing spaces + changed sizeof(struct watchdog_info) to sizeof(ident) and changed some spaces in tabs).
>
>Now we only need someone that can look at the CONFIG_4xx cases still :-)

It seems the FSL watchdog is much more flexible than the one found in 4xx
cores.  On 4xx, you basically have 4 static choices that represent specific
times determined by the clock frequency.  I'm concerned that the lack of
granularity here will result in less than desirable behavior.

For example, with a 400MHz clock you would get choices of roughly:

5.2 ms
83.9 ms
1.34 s
21.47 s

Personally, I consider the first two options basically unusable.  Considering
the second two, if a user were to say "Set the timeout for 2 seconds" they
would then get a timeout of 21 seconds with the framework Chris' patch has
set up.  That doesn't really seem to be ideal to me.

josh
