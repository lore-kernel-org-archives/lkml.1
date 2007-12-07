Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXLGSYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXLGSYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXLGSYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:24:32 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:41031 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbXLGSYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:24:31 -0500
Message-ID: <47598FD5.3060200@oracle.com>
Date: Fri, 07 Dec 2007 10:24:21 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
References: <1196983219534-git-send-email-zach.brown@oracle.com> <11969832193635-git-send-email-zach.brown@oracle.com> <1196983219225-git-send-email-zach.brown@oracle.com> <11969832192868-git-send-email-zach.brown@oracle.com> <1196983219370-git-send-email-zach.brown@oracle.com> <11969832192130-git-send-email-zach.brown@oracle.com> <20071207115505.GA18013@2ka.mipt.ru>
In-Reply-To: <20071207115505.GA18013@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +/*
>> + * syslet_ring doesn't have any kernel-side storage.  Userspace allocates them
>> + * in their address space and initializes their fields and then passes them to
>> + * the kernel.
>> + *
>> + * These hashes provide the kernel-side storage for the wait queues which
>> + * sys_syslet_ring_wait() uses and the mutex which completion uses to serialize
>> + * the (possible blocking) ordered writes of the completion and kernel head
>> + * index into the ring.
>> + *
>> + * We chose the bucket that supports a given ring by hashing a u32 that
>> + * userspace sets in the ring.
>> + */
>> +#define SYSLET_HASH_BITS (CONFIG_BASE_SMALL ? 4 : 8)
>> +#define SYSLET_HASH_NR (1 << SYSLET_HASH_BITS)
>> +#define SYSLET_HASH_MASK (SYSLET_HASH_NR - 1)
>> +static wait_queue_head_t syslet_waitqs[SYSLET_HASH_NR];
>> +static struct mutex syslet_muts[SYSLET_HASH_NR];
> 
> Why do you care about hashed tables scalability and not using trees?

Well, this notion of letting tasks safely complete to any ring they can
address is just a possibility.  We might decide that it's not worth it.
 This implementation was an easy example that borrows from the way
futexes do similar work.

I like it because you could have, say, different processes completing
into a ring in shared memory.

If we do allow this kind of flexible ring specification, it's not at all
clear that trees would be the best way to address the scalability
limits.  There are lots of possibilities, including locking the page
lock of the page which holds the head index.

- z
