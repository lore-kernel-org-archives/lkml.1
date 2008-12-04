Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYLDN3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYLDN3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYLDN3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:29:30 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50004 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYLDN3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:29:30 -0500
Message-ID: <4937DB1E.7060500@cosmosbay.com>
Date: Thu, 04 Dec 2008 14:29:02 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Alexander Shishkin <alexander.shishckin@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: A question about sparse: how to use __acquires() and __releases()
 correctly ?
References: <e2e108260812021159r31eb86a1v95d2cbdf7cfdae2d@mail.gmail.com> <e2e108260812040412j1f3f353bv2834750dbe914c48@mail.gmail.com>
In-Reply-To: <e2e108260812040412j1f3f353bv2834750dbe914c48@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 04 Dec 2008 14:29:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche a écrit :
> [ping]
> 
> Is there anyone who can help me with the question below ?
> 
> Thanks,
> 
> Bart.
> 
> On Tue, Dec 2, 2008 at 8:59 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
>> Hello,
>>
>> I'm helping to prepare the SCST source code for inclusion in the Linux
>> kernel by a.o. cleaning up sparse warnings. Although most of the SCST
>> source code has been annotated by this time it's still not clear to me
>> how to use __acquires() and __releases() correctly.
>>
>> I will illustrate my questions via the following code from
>> net/core/dev.c, Linux kernel version 2.6.27.7:
>>
>> void dev_seq_stop(struct seq_file *seq, void *v)
>>        __releases(dev_base_lock)
>> {
>>        read_unlock(&dev_base_lock);
>> }
>>
>> The command "make C=2 M=net/core" produces the following output for
>> the above function (using a sparse binary built from the sparse git
>> repository, last updated on August 26, 2008):
>>
>> net/core/dev.c:2579:2: warning: context problem in 'dev_seq_stop':
>> '_read_unlock' expected different context
>> net/core/dev.c:2579:2:    context 'lock': wanted >= 1, got 0
>>
>> My questions are as follows:
>> * Which argument type should be passed to __releases() -- a pointer to
>> a lock structure or the lock strucure itself ? In the header file
>> include/linux/spinlock_api_smp.h a pointer is passed to __acquires()
>> and __releases(), while other code (like the above) passes the lock
>> structure itself to the __acquires() and __releases() annotations.
>> * If the __releases() annotation is used correctly in net/core/dev.c,
>> why does sparse complain about a context problem ?
>>
>> Please keep me in CC -- I'm not subscribed to the LKML.
>>
>> Bart.
>>

I added __releases() annotation in dev_seq_stop() in January 1st

^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2617) }
^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2618)
^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2619) void dev_seq_stop(struct seq_file *seq, void *v)
9a429c49 (Eric Dumazet                   2008-01-01 21:58:02 -0800 2620)        __releases(dev_base_lock)
^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2621) {
^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2622)        read_unlock(&dev_base_lock);
^1da177e (Linus Torvalds                 2005-04-16 15:20:36 -0700 2623) }


The sparse version I have here doesnt complain on dev_seq_stop() in net/core/dev.c

  CHECK   net/core/dev.c
net/core/dev.c:2060:29: warning: symbol 'br_fdb_get_hook' was not declared. Should it be static?
net/core/dev.c:2062:6: warning: symbol 'br_fdb_put_hook' was not declared. Should it be static?
net/core/dev.c:1889:4: warning: context imbalance in 'dev_queue_xmit' - different lock contexts for basic block
net/core/dev.c:2022:3: warning: context imbalance in 'net_tx_action' - different lock contexts for basic block
include/linux/netpoll.h:94:2: warning: context imbalance in 'net_rx_action' - different lock contexts for basic block
  CC      net/core/dev.o

# sparse --version
# sparse -V
# type sparse
sparse is hashed (/root/bin/sparse)
# ls -l /root/bin/sparse
-rwxr-xr-x  1 root root 947324 déc 17  2007 /root/bin/sparse
# cd /usr/src/sparse
# git log | head
commit a02aeb329d5a8f9047c0b75b7e7f64ee2db3ffcf
Author: Josh Triplett <josh@freedesktop.org>
Date:   Tue Nov 13 04:15:13 2007 -0800

    Makefile: VERSION=0.4.1

    Signed-off-by: Josh Triplett <josh@freedesktop.org>




