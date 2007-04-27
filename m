Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXD1A0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXD1A0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbXD1A0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 20:26:43 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:56641 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757961AbXD1A0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 20:26:41 -0400
Date: Fri, 27 Apr 2007 16:50:46 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177718250.4737.222.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <200704280041.17617.rjw@sisk.pl>  <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
  <200704280145.26253.rjw@sisk.pl> <1177718250.4737.222.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Nigel Cunningham wrote:

> Hi.
>
> On Sat, 2007-04-28 at 01:45 +0200, Rafael J. Wysocki wrote:
>> On Saturday, 28 April 2007 01:17, Linus Torvalds wrote:
>>>
>>> On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
>>>>
>>>>> And can you name a _single_ advantage of doing so?
>>>>
>>>> Yes.  We have a lot less interdependencies to worry about during the whole
>>>> operation.
>>>
>>> That's not an advantage. That's why it has *sucked*.
>>
>> Actually, the less things happen while we're creating and saving the image,
>> the less sources of potential problems there are and by freezing the kernel
>> threads (not all of them), we cause less things to happen at that time.
>>
>> To make you happy, we could stop doing that, but what actual _advantage_
>> that would bring?
>
> A couple of other advantages to freezing other processes:
>
> 1) It makes predicting how much memory is available for making and
> saving snapshot a tractable problem. It therefore makes hibernation
> _much_ more reliable.
> 2) Racing against other processes would also make hibernation slower,
> increasing the chances of your battery running out before the save is
> complete.
> 3) It makes finding potential memory leaks in the code possible. It was
> ages ago now, but at one stage I could display a table saying exactly
> how many pages had been allocated and freed by different sections of the
> process and compare the number of free pages at the start and end of the
> cycle to ensure there were no memory leaks at all.

nobody is suggesting that you leave peocesses running while you do the snapshot, 
what is being proposed is

1. pause userspace (prevent scheduling)
2. make snapshot image of memory
3. make mounted filesystems read-only (possibly with snapshot/checkpoint)
4. unpause
5. save image (with full userspace available, including network)
6. shutdown system (throw away all userspace memory, no need to do graceful
    shutdown or nice kill signals, revert filesystem to snapshot/checkpoint if
    needed)

>>> NONE of these are valid explanations at all. You're listing totally
>>> theoretical problems, and ignoring all the _real_ problems that trying to
>>> freeze kernel threads has _caused_.
>>
>> Example, please?
>
> I agree with Rafael. Freezing processes greatly helps in ensuring we
> have a consistent image. He's right, too, in asserting that it's even
> more important for Suspend2. Freezing processes is essential to being
> able to know that those LRU pages won't change and therefore being able
> to save them separately and then reuse them for the atomic copy.

all that's needed for the snapshot is to prevent userspace from scheduling, and 
prevent media from being written to in a permanent way (writing to a LVM volume 
after invoking a snapshot doesn't count, just revert to the snapshot)

David Lang
