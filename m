Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbZEBVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbZEBVr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZEBVrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:47:19 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:41112 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbZEBVrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090501061701.GB19234@kroah.com> 
	<20090430234312.a63fa5cf.akpm@linux-foundation.org> <20090501065527.GA19773@kroah.com> 
	<20090501120359.05bacb48@lxorguk.ukuu.org.uk> <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 
	<20090501141846.4b833700@lxorguk.ukuu.org.uk> <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com> 
	<49FC8EE4.6040408@googlemail.com> <9b2b86520905021255t4a4812dcrcbcc32f36acd6039@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 2 May 2009 23:47:03 +0200
Message-ID: <ac3eb2510905021447m1fad2382h342b4d4279b75d3d@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 21:55, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> On 5/2/09, Michael Riepe <michael.riepe@googlemail.com> wrote:

>> Well, what about this? Let the kernel buffer all events until udev is
>> ready to process them. Once it signals that it's up and running - the
>> best method for that is tbd -, empty the queue, and then discard it,
>> including the additional code. If udev doesn't come up in time after
>> init has started, or the buffer overflows, assume the system is using a
>> static /dev and throw away the queue as well. If udev starts too late,
>> it can still do a coldplug - in that case, boot speed is already so low
>> that the additional delay hardly matters.
>
> Already answered by Kay.
> <http://groups.google.com/group/linux.kernel/msg/9851b3f5e82d65ef>
>
> But the premise of this question is bogus anyway.  You don't gain
> anything by capturing events earlier; replaying them is really quite
> cheap, and extracting device numbers and names from sysfs is even
> cheaper.  The gains are in reducing how much processing you need to do
> on them.  Both in terms of performance, and in making it
> simple/neutral enough to be considered for kernel inclusion, which in
> turn brings a number of small benefits.

Exactly, we would add more code, make stuff more complex as it already
is, and gain basically nothing.

It is not about missing events, it is about the bootstrap step we
would like to avoid. Buffering events, or reading all device
information from sysfs at this stage introduces a hard checkpoint,
where we need to bring a process up process these events and create
nodes for them. Only after that we can start other things in userspace
which depend on a working /dev, and with the kernel populated one, we
can just go ahead.

Even when it wouldn't be the fasted we can do, which it probably is,
it would still be the simplest we can do, and that would win in most
cases.

Thanks,
Kay
