Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYD3HJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYD3HJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYD3HJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:09:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:24259 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYD3HJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:09:09 -0400
Message-ID: <481819E3.4070301@nokia.com>
Date: Wed, 30 Apr 2008 10:04:03 +0300
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Artem.Bityutskiy@nokia.com,
       Artem Bityutskiy <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com> <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com> <47F1F7A6.5020105@yandex.ru> <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com> <47F1FF98.9020809@nokia.com> <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com> <47F20DEE.7090105@nokia.com> <84144f020804010433xafc6f28o5a5375ce82903a7a@mail.gmail.com> <20080426093732.GB17730@infradead.org> <4815784F.2070601@nokia.com> <20080428090346.GB14100@infradead.org>
In-Reply-To: <20080428090346.GB14100@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Apr 2008 07:08:50.0362 (UTC) FILETIME=[0A8669A0:01C8AA91]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 28, 2008 at 10:10:07AM +0300, Adrian Hunter wrote:
>>>> So instead of arguing about this you really ought to look at what
>>>> SLUB, for example, does. It's perfectly okay to have _debugging
>>>> checks_ compiled out (stuff like verify_inode and such) but at the
>>>> assertion level it makes no sense whatsoever!
>>> Yes, having this in filesystems is not very nice.
>> A technical reason would be more compelling than "not very nice".
> 
> These checks are if properly maintained not harmful for the code,
> but they make the code less readable and there's of course the chance
> that they get out of sync.  That's why the term "not very nice" is
> entirely apropinquate here.

What would make them more readable?  We (ok mostly me) are not enthusiastic
about BUG_ON for the following reasons:
	1. When testing and debugging you lose the opportunity to get more
	information and have to reboot the test platform
	2. When the system is in the hands of consumers we don't want it
	to oops under any circumstances.  This is particularly the case
	when looking at things like BUG_ON(!PageLocked(page)).  In an
	embedded system, single CPU, preemption disabled, even in the
	unlikely event this happens, the system would probably get away
	with it.
	3. We don't have many people using UBIFS so hoping they catch
	BUGs is less realistic.  It is also bad for us as we try to
	persuade people of the merits of UBIFS.  Consequently our focus
	is on our own testing (which brings us back to point 1).
	4. We have had a couple of situations with JFFS2 where BUG_ON was
	used incorrectly to handle errors that didn't look like they
	could happen but it turned out they could.  I.e. an error code
	should have been returned and the system allowed to continue.
	In short BUG_ON can be bad all by itself.

Perhaps if we called it dbg_check() instead of ubifs_assert() ?

As for things getting out of sync, anyone making changes to UBIFS, either
without testing or testing without the debug checks turned on, is taking
a much much bigger risk than just letting the checks get out of sync.

I am not sure it is really reasonable to compare the debugging needs of
SLUB with those of UBIFS because UBIFS has a much lower visibility and
usage.  There are far fewer eyes looking at the code and far fewer people
using it.  Since the burden of testing really falls on just a few of us,
we are keen to have lots of checks.

> 
>>> If someone feels
>>> very strong about interface assertation we should add them at the
>>> method level boundary so that the interface is verified for all
>>> filesystems.
>>>
>> The checks are not valid for all file systems.
>>
>> The point of the checks as preconditions is lost if they moved elsewhere.
>>
>> VFS code paths are not simple, so the suggestion is impractical anyway.
> 
> Most of these checks are indeed generic.  Those that arise from special
> filesystem invariants like not having unmapped buffers due to
> implementing ->page_mkwrite should for now be checked in the filesystem,
> although I'd like to make sure this is true for all filesystems
> long-term.

We use both PagePrivate and PageChecked differently to EXT3 etc.

>From the original example, that just leaves PageLocked, but lots of kernel
functions seem to check that, so why not UBIFS too?



