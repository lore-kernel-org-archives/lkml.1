Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbZKEAdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbZKEAdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZKEAdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:33:36 -0500
Received: from mail.crca.org.au ([67.207.131.56]:35701 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147AbZKEAde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:33:34 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AF21DA2.6060601@crca.org.au>
Date: Thu, 05 Nov 2009 11:34:42 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "TuxOnIce users' list" <tuxonice-users@lists.tuxonice.net>
CC: Richard Purdie <rpurdie@rpsys.net>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [TuxOnIce-users] An assortment of TuxOnIce resume panics on a
 Radeon KMS-running system in 2.6.31.5, lzo-related?
References: <87ocnim1bj.fsf@spindle.srvr.nix> <4AF1F611.6050206@crca.org.au> <874op9n8k7.fsf@spindle.srvr.nix>
In-Reply-To: <874op9n8k7.fsf@spindle.srvr.nix>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Nix wrote:
> On 4 Nov 2009, Nigel Cunningham told this:
> 
>> Hi.
>>
>> Thanks for your bug report.
>>
>> I'd say it's a bug in the TuxOnIce code. How recent a version are you
>> running? (It's been a while since I bumped the version number, so saying
>> 3.0.1 doesn't mean much any more). Is it recent git?
> 
> 4eddd0d169ddd285b9d7afdcbbfc1a85b870f5ea from your tuxonice 2.6.31 tree,
> (merged, as mentioned, with Dave Airlie's drm-next branch).
> 
> I think that's the latest, right?

No, it's not. But it's prior to where I committed the swap priority
support changes that I was thinking were the cause of your issue.

>> Would you also let me know how your storage is configured - file
>> allocator? swap allocator? More than one swap device? priorities? (I've
> 
> Swap allocator, striped equal-priority swap on two physical disks
> (otherwise occupied entirely with an md1 array):

Okay. Would you be able to try with just one swap device enabled
(temporarily) and see if that makes a difference? It should work with
two at the commit you mentioned, but perhaps I'm forgetting something.

>              total       used       free     shared    buffers     cached
> Mem:      12301216    1238928   11062288          0     111228     440956
> -/+ buffers/cache:     686744   11614472
> Swap:     25189904          0   25189904
> mutilate 2 ~% cat /proc/swaps
> Filename                                Type            Size    Used    Priority
> /dev/sda2                               partition       12594952        0       0
> /dev/sdb2                               partition       12594952        0       0
> 
> (yes, I know it was mad to define swap as 2xRAM on this machine, but I
> have disk space coming out of my ears and have no idea what to do with it :) )
> 
> Swap was barely in use when I suspended (and it's even less in use now
> relatively recently post-reboot).
> 
>> been doing work in this area recently, and so suspect that it might be
>> the cause).
> 
> It's odd that it manifested as a decompressor failure. I suppose if
> something corrupts the data en route to or from the disk you might see
> this? (wild speculation: maybe ordinary swapping happened on top of it,
> though this seems rather unlikely).

Well, if I've got an error in the algorithm for deciding which device to
read/write next (this is what I've been modifying), it makes sense.

> I'm impressed with how well ToI works, btw: it must have saved me about
> twenty quid in power costs on this desktop box already and I've only
> been using it for a couple of months. I was even more impressed that
> nothing went wrong when I started using KMS, once I'd boosted the
> reserved pages enough: took a while to figure out the cause of those
> crashes, though. Maybe you should print a very loud message when the
> number of reserved pages that haven't been consumed drops below some
> smallish number, if it's detectable, 'cos right now exceeding it
> generally results in a crash at suspension time and newbies like me
> can't tell the cause easily...

Not having a big enough allowance for drivers' memory allocations
shouldn't cause problems. There's code in place to automatically back
out and retry with a larger allocation and then abort if that doesn't
work, and I've never had a report of it not working before now. (You'll
see messages in dmesg if this happens). If you have userui enabled, it
will also tell you it's restarting and why.

Regards,

Nigel
