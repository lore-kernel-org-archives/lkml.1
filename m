Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYGTVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYGTVXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYGTVXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 17:23:30 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:51531 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYGTVX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 17:23:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=AyusPcFNeJUN/XdkKihyaiim8NuOIOwQSFTtREJeJxJshFyKlL5hMVce5UN5JCIFSdobYNHRNfBUddeo3fRO6EJ6KWYxI6ttAU+CpPeJteUUBQcKDLPrcA1YOiKwm/2H;
Message-ID: <4883ACBB.4080303@simon.arlott.org.uk>
Date: Sun, 20 Jul 2008 22:23:07 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Rene Herman <rene.herman@keyaccess.nl>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
References: <20080720085924.122feb2b@infradead.org>	 <20080720090041.5924f5ff@infradead.org> <1216588499.6971.1.camel@dhcp32.mvista.com>
In-Reply-To: <1216588499.6971.1.camel@dhcp32.mvista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/08 22:14, Daniel Walker wrote:
> On Sun, 2008-07-20 at 09:00 -0700, Arjan van de Ven wrote:
>> @@ -775,6 +776,11 @@ static void __init do_initcalls(void)
>>                 }
>>                 if (phase == 1 && call >= __async_initcall_end)
>>                         phase = 2;
>> +               if (phase == 2 && call >= __device_initcall_end) {
>> +                       phase = 3;
>> +                       /* make sure all async work is done before level 7 */
>> +                       flush_workqueue(async_init_wq);
>> +               }
>>                 if (phase != 1)
>>                         do_one_initcall(*call);
>>         }
> 
> Did this impact the boot time improvements at all?

The USB HCD initcalls take so little time to complete (100ms 
each) that ensuring they have finished makes no difference.

USB devices get detected after those initcalls finish in 
parallel with the rest of the boot process (and there's 
about 1.5s before the first USB device driver initcall 
runs).

-- 
Simon Arlott
