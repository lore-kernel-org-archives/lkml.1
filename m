Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbZCYSQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbZCYSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbZCYSQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:16:35 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:35619 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbZCYSQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dll1kw3MvBK2fcKb2xHIEA1k9d5cW/MtqhwI1qVfV3fyoewmlw5hwIHmo/wGWuEi0s
         zd1GmufkC3EUnqD5SGPblaAxsKOZ0fkeAaAzo7Dsc1iXc710/d4OwV+/xHpqBpooDWeM
         W1TSY2mJxw5bRlC7L8ThAfo5meA391/AVLbos=
MIME-Version: 1.0
In-Reply-To: <49CA6D09.1020401@krogh.cc>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	 <49C87B87.4020108@krogh.cc>
	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	 <49C88C80.5010803@krogh.cc>
	 <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	 <49CA6D09.1020401@krogh.cc>
Date: Wed, 25 Mar 2009 11:16:30 -0700
Message-ID: <72dbd3150903251116ie84b9e9ib998ac0283e6cfbb@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: David Rees <drees76@gmail.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 10:42 AM, Jesper Krogh <jesper@krogh.cc> wrote:
> David Rees wrote:
>> On Tue, Mar 24, 2009 at 12:32 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>>> David Rees wrote:
>>> The 480 secondes is not the "wait time" but the time gone before the
>>> message is printed. It the kernel-default it was earlier 120 seconds but
>>> thats changed by Ingo Molnar back in september. I do get a lot of less
>>> noise but it really doesn't tell anything about the nature of the
>>> problem.
>>>
>>> The systes spec:
>>> 32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in
>>> Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to
>>> decide
>>> if thats fast or slow?
>>
>> The drives should be fast enough to saturate 4Gbit FC in streaming
>> writes.  How fast is the array in practice?
>
> Thats allways a good question.. This is by far not being the only user
> of the array at the time of testing.. (there are 4 FC-channel connected to a
> switch). Creating a fresh slice.. and just dd'ing onto it from /dev/zero
> gives:
> jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=10000
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 78.0557 s, 134 MB/s
> jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 8.11019 s, 129 MB/s
>
> Watching using dstat while dd'ing it peaks at 220M/s

Hmm, not as fast as I expected.

> It has 2GB of battery backed cache. I'm fairly sure that when it was new
> (and I only had connected one host) I could get it up at around 350MB/s.

With 2GB of BBC, I'm surprised you are seeing as much latency as you
are.  It should be able to suck down writes as fast as you can throw
at it.  Is the array configured in writeback mode?

>> On a 32GB system that's 1.6GB of dirty data, but your array should be
>> able to write that out fairly quickly (in a couple seconds) as long as
>> it's not too random.  If it's spread all over the disk, write
>> throughput will drop significantly - how fast is data being written to
>> disk when your system suffers from large write latency?
>
> Thats another thing. I havent been debugging while hitting it (yet) but if I
> go ind and do a sync on the system manually. Then it doesn't get above
> 50MB/s in writeout (measured using dstat). But even that doesn't sum up to 8
> minutes .. 1.6GB at 50MB/s ..=> 32 s.

Have you also tried increasing the IO priority of the kjournald
processes as a workaround as Arjan van de Ven suggests?

You must have a significant amount of activity going to that FC array
from other clients - it certainly doesn't seem to be performing as
well as it could/should be.

-Dave
