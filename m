Return-Path: <linux-kernel-owner+w=401wt.eu-S1751100AbZL1Pjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbZL1Pjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZL1Pjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:39:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50229 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZL1Pjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:39:41 -0500
Message-ID: <4B38D0CF.9000403@vflare.org>
Date: Mon, 28 Dec 2009 21:07:51 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <87eimf87m5.fsf@basil.nowhere.org>
In-Reply-To: <87eimf87m5.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2009 08:32 PM, Andi Kleen wrote:
> Nitin Gupta <ngupta@vflare.org> writes:
> 
>> Events:
>>  - Swapon
>>  - Swapoff
>>  - When a swap slot is freed
>>
>> This is required for ramzswap module which implements RAM based block
>> devices to be used as swap disks. These devices require a notification
>> on these events to function properly.
> 
> The first question to ask is if compressed swap is worth
> it. Do you have benchmark numbers showing it to be an improvement?
> Are there cases where it is slower than uncompressed swap?
> 

http://code.google.com/p/compcache/wiki/Performance
This contains data for both positive and negative cases.
Also, it is currently being used on (unofficial) Android builds where
it shows noticeable performance gains compared to plain SSD swap.

> 
>> Currently, I'm not sure if any of these event notifiers have any other
>> users. However, adding ramzswap specific hooks instead of this generic
>> approach resulted in a bad/hacky code.
> 
> If there's only a single user I think it's preferable to call
> directly. That makes the code much easier to read and understand.
> In the end notifiers are a form of code obfuscation.
> 

Adding ramzswap code in place of generic swap slot free notification
is bad since ramzswap is just another module and might not be selected
for compilation. So, the code will include some unnecessary #ifdef'ery.

I think SLOT_FREE notifier is the major worry which is surely too
ramzswap specific (who else would want notification so often).

However, SWAPON and SWAPOFF events are fairly generic and (I hope) should
find some more users in future. If its okay to keep just these two notifiers,
I will replace SWAP_NOTIFY notifier with a simple callback function in
swap_info_struct. In future, if this event finds more users, I will revert
back to this generic notifier.

> The main use for notifiers would be if something is a optional
> module, but that's not the case here.


ramzswap is an optional module.

Thanks,
Nitin
