Return-Path: <linux-kernel-owner+w=401wt.eu-S965433AbXHMBlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965433AbXHMBlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 21:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935290AbXHMBlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 21:41:19 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:37484 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762461AbXHMBlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 21:41:17 -0400
Message-ID: <46BFB6BB.80406@steeleye.com>
Date: Sun, 12 Aug 2007 21:41:15 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,	anyways?
 [compare with e.g. NBD + MD raid])
References: <200708121335.17267.a1426z@gawab.com> <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm> <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr> <20070812174549.GA2915@teal.hq.k1024.org>
In-Reply-To: <20070812174549.GA2915@teal.hq.k1024.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Iustin Pop wrote:
> On Sun, Aug 12, 2007 at 07:03:44PM +0200, Jan Engelhardt wrote:
>> On Aug 12 2007 09:39, david@lang.hm wrote:
>>> now, I am not an expert on either option, but three are a couple things that I
>>> would question about the DRDB+MD option
>>>
>>> 1. when the remote machine is down, how does MD deal with it for reads and
>>> writes?
>> I suppose it kicks the drive and you'd have to re-add it by hand unless done by
>> a cronjob.

Yes, and with a bitmap configured on the raid1, you just resync the 
blocks that have been written while the connection was down.


>>From my tests, since NBD doesn't have a timeout option, MD hangs in the
> write to that mirror indefinitely, somewhat like when dealing with a
> broken IDE driver/chipset/disk.

Well, if people would like to see a timeout option, I actually coded up 
a patch a couple of years ago to do just that, but I never got it into 
mainline because you can do almost as well by doing a check at 
user-level (I basically ping the nbd connection periodically and if it 
fails, I kill -9 the nbd-client).


>>> 2. MD over local drive will alternate reads between mirrors (or so I've been
>>> told), doing so over the network is wrong.
>> Certainly. In which case you set "write_mostly" (or even write_only, not sure
>> of its name) on the raid component that is nbd.
>>
>>> 3. when writing, will MD wait for the network I/O to get the data saved on the
>>> backup before returning from the syscall? or can it sync the data out lazily
>> Can't answer this one - ask Neil :)
> 
> MD has the write-mostly/write-behind options - which help in this case
> but only up to a certain amount.

You can configure write_behind (aka, asynchronous writes) to buffer as 
much data as you have RAM to hold. At a certain point, presumably, you'd 
want to just break the mirror and take the hit of doing a resync once 
your network leg falls too far behind.

--
Paul
