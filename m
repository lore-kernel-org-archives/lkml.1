Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZHKWEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZHKWEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 18:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZHKWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 18:04:11 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43075 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbZHKWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 18:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=KDL1tai6A6pd9b1YS0e9xWGtAgsdvPkuvPd43vHQhvvilLzMKprDGrTb3cOkcsqyua
         mfsgRLqivfzS3WjNKtvoGgiYLdiS/FO8+uFH8W0thYTlq6+/a/8UgVV4vKbT6NbHaChw
         YNGklK6S0Rli5dn7sSL456SVrmokuF8Y+mCqs=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Wed, 12 Aug 2009 00:04:09 +0200
Message-ID: <7c86c4470908111504i3a1e83b9k140fdaa717584a30@mail.gmail.com>
Subject: perf_counters issue remapped count
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to use the remapped counter feature
on Intel Core. It does not work as expected.

Well, in fact, it segfaults immediately, but that's because
you have not enabled PCE in cr4. But assume you have
for a moment. Them there are still several problems.

1/ hdr->index does not work with fixed counters

    On Intel, RDPMC supports fixed counters, however, you
    have to add an offset 0x40000000 to the index (see Intel
    Vol 2b RDPMC description).

    From what I can see in:

    static int perf_counter_index(struct perf_counter *counter)
    {
        if (counter->state != PERF_COUNTER_STATE_ACTIVE)
                return 0;

        return counter->hw.idx + 1 - PERF_COUNTER_INDEX_OFFSET;
    }

    It  cannot be made to work for both generic and fixed counters.
    I think this function has to go in arch-specific code or become
    more complicated.


2/ rdpmc() + offset returns bogus counts

    Suppose you are using a generic counter, RDPMC returns the live
    40-bit value of the counter. Then, my understanding is that you are
    supposed to addr hdr->offset to that value to reconstruct the full
    64-bit value.

    It appears this is not quite working. Here is small example counting
    PERF_COUNT_HW_BRANCH_INSTRUCTIONS.

   RDPMC RAW hdr->offset
                34a1 offset=0x0
                3bac offset=0x0
                40e4 offset=0x0
                461c offset=0x0
                4b54 offset=0x0
                508c offset=0x0
                55c4 offset=0x0
                5afc offset=0x0
                6034 offset=0x0
                656c offset=0x0
                6aa4 offset=0x0
                6fdc offset=0x0
                7514 offset=0x0
                7a4c offset=0x0
                7f84 offset=0x0
                84bc offset=0x0
                89f4 offset=0x0
                8f2c offset=0x0
                9464 offset=0x0
                999c offset=0x0
                9ed4 offset=0x0
                ac20 offset=0x0
          ff8000bbe9 offset=0x7fffffff
          ff8000bf15 offset=0x7fffffff
          ff8000c241 offset=0x7fffffff
          ff8000c56d offset=0x7fffffff
          ff8000c899 offset=0x7fffffff
          ff8000cbc5 offset=0x7fffffff
          ff8000cef1 offset=0x7fffffff
          ff8000d21d offset=0x7fffffff
          ff8000d549 offset=0x7fffffff

It appears at some point, the live value of the counter is changed and suddenly
you set bit 31 (bit32-39 are sign extension). Don't think it is because of PMU
interrupt, I suspect something wrong during context switching.

The core of my loop is as follows:

        for(;;) {
                for (i=0; i < num; i++) {
                        uint64_t offset = 0;
                        uint64_t values[3];
                        do {
                                seq = hdr->lock;
                                barrier();
                                if (hdr->index > 0) {
                                        values[0] = rdpmc(hdr->index-1);
                                        offset = hdr->offset;
                                        //values[0] += offset;
                                        values[1] = hdr->time_enabled;
                                        values[2] = hdr->time_running;
                                } else {
                                        ret = read(fd, values, sizeof(values));
                                        break;
                                }
                                barrier();
                        } while (hdr->lock != seq);

                        if (values[2])
                                values[0]=
(uint64_t)((double)values[0] * values[1]/values[2]);

                        printf("%20"PRIx64" offset=0x%"PRIx64"\n",
                                values[0],
                                offset);
                }
                fib(10);
        }
