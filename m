Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbYBTNjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbYBTNjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYBTNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:39:24 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:25089 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbYBTNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:39:23 -0500
Message-ID: <47BC2D4B.6070000@emc.com>
Date: Wed, 20 Feb 2008 08:38:19 -0500
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeremy Higdon <jeremy@sgi.com>
CC: David Chinner <dgc@sgi.com>, Michael Tokarev <mjt@tls.msk.ru>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219071948.GA244758@sgi.com>
In-Reply-To: <20080219071948.GA244758@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.51425
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
X-Tablus-Inspected: yes
X-Tablus-Classifications: public
X-Tablus-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Higdon wrote:
> On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
>> On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
>>> First, I still don't understand why in God's sake barriers are "working"
>>> while regular cache flushes are not.  Almost no consumer-grade hard drive
>>> supports write barriers, but they all support regular cache flushes, and
>>> the latter should be enough (while not the most speed-optimal) to ensure
>>> data safety.  Why to require write cache disable (like in XFS FAQ) instead
>>> of going the flush-cache-when-appropriate (as opposed to write-barrier-
>>> when-appropriate) way?
>> Devil's advocate:
>>
>> Why should we need to support multiple different block layer APIs
>> to do the same thing? Surely any hardware that doesn't support barrier
>> operations can emulate them with cache flushes when they receive a
>> barrier I/O from the filesystem....
>>
>> Also, given that disabling the write cache still allows CTQ/NCQ to
>> operate effectively and that in most cases WCD+CTQ is as fast as
>> WCE+barriers, the simplest thing to do is turn off volatile write
>> caches and not require any extra software kludges for safe
>> operation.
> 
> 
> I'll put it even more strongly.  My experience is that disabling write
> cache plus disabling barriers is often much faster than enabling both
> barriers and write cache enabled, when doing metadata intensive
> operations, as long as you have a drive that is good at CTQ/NCQ.
> 
> The only time write cache + barriers is significantly faster is when
> doing single threaded data writes, such as direct I/O, or if CTQ/NCQ
> is not enabled, or the drive does a poor job at it.
> 
> jeremy
> 

It would be interesting to compare numbers.

In the large, single threaded write case, what I have measured is 
roughly 2x faster writes with barriers/write cache enabled on S-ATA/ATA 
class drives. I think that this case alone is a fairly common one.

For very small file sizes, I have seen write cache off beat barriers + 
write cache enabled as well but barriers start out performing write 
cache disabled when you get up to moderate sizes (need to rerun tests to 
  get precise numbers/cross over data).

The type of workload is also important. In the test cases that I ran, 
the application needs to fsync() each file so we beat up on the barrier 
code pretty heavily.

ric

