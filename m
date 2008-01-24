Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYAXT0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYAXT0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYAXT0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:26:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbYAXT0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:26:43 -0500
Message-ID: <4798E664.2040405@redhat.com>
Date: Thu, 24 Jan 2008 14:26:28 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] firewire: fw-core: react on bus resets while the
 config ROM is being fetched
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de>	<200711011453.35268.nickpiggin@yahoo.com.au>	<4729A1BF.8010800@s5r6.in-berlin.de>	<tkrat.288da3bd61ecfb20@s5r6.in-berlin.de>	<tkrat.9c7056f105b7d6a9@s5r6.in-berlin.de> <4798B8BA.9090203@redhat.com>
In-Reply-To: <4798B8BA.9090203@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Stefan Richter wrote:
>> read_rom() obtained a fresh new fw_device.generation for each read
>> transaction.  Hence it was able to continue reading in the middle of the
>> ROM even if a bus reset happened.  However the device may have modified
>> the ROM during the reset.  We would end up with a corrupt fetched ROM
>> image then.
>>
>> Although all of this is quite unlikely, it is not impossible.
>> Therefore we now restart reading the ROM if the bus generation changed.
>>
>> Side note:  The barrier in read_rom(), inserted by patch "firewire:
>> enforce access order between generation and node ID" is not necessary
>> anymore because the sequence of calls
>> 	fw_device_init() ->
>> 		read_bus_info_block() ->
>> 			read_rom()
>> 			read_rom()
>> 			read_rom()
>> 			...
>> will take care that generation is read before node_id, won't it?
>>
>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Based on a quick read through the code path, coupled with empirical evidence,
> yes, it appears safe to remove the barrier in read_rom().

Crap. My earlier 'empirical evidence' seems to have been happy coincidence.
After a fresh boot, I'm consistently hitting 'failed to read config rom'
failures with this patch applied. Simply putting the barrier back in gets
things working again though. Interestingly, subsequent reloading of firewire-*
modules less the barrier also tend to work until the system is rebooted.


-- 
Jarod Wilson
jwilson@redhat.com

