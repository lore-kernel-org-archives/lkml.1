Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbZAZSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbZAZSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZAZSZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:25:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZAZSZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:25:19 -0500
From: "Hunter, Jon" <jon-hunter@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 12:23:37 -0600
Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: Acl22NMmPRfHmhnyTuem0+yaDRLXwwJCC58g
Message-ID: <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
In-Reply-To: <20090114221624.76ee8aa4.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <mailto:akpm@linux-foundation.org> wrote on Thursday, January 15, 2009 12:16 AM:

> Venki, could you please take a look?

Andrew, Venki, if it helps here are some more details.

The function "__next_timer_interrupt()" (in file kernel/timer.c) consists of two main loops. The first loop (shown below) looks for timer events in tv1.

898         /* Look for timer events in tv1. */
899         index = slot = timer_jiffies & TVR_MASK;
900         do {
901                 list_for_each_entry(nte, base->tv1.vec + slot, entry) {
902                         if (tbase_get_deferrable(nte->base))
903                                 continue;
904
905                         found = 1;
906                         expires = nte->expires;
907                         /* Look at the cascade bucket(s)? */
908                         if (!index || slot < index)
909                                 goto cascade;
910                         return expires;
911                 }
912                 slot = (slot + 1) & TVR_MASK;
913         } while (slot != index);


You can see from the above code snippet, that if a timer event is found for tv1, then it performs a test to see if this timer event is deferrable (lines 902 and 903). If no timer events are found for tv1, then the code enters a second loop, a for-loop with a nested do-while loop, that looks for timer events in tv2-tv5.


927         for (array = 0; array < 4; array++) {
928                 struct tvec *varp = varray[array];
929
930                 index = slot = timer_jiffies & TVN_MASK;
931                 do {
932                         list_for_each_entry(nte, varp->vec + slot, entry) {
933                                 found = 1;
934                                 if (time_before(nte->expires, expires))
935                                         expires = nte->expires;
936                         }
937                         /*
938                          * Do we still search for the first timer or are
939                          * we looking up the cascade buckets ?
940                          */
941                         if (found) {
942                                 /* Look at the cascade bucket(s)? */
943                                 if (!index || slot < index)
944                                         break;
945                                 return expires;
946                         }
947                         slot = (slot + 1) & TVN_MASK;
948                 } while (slot != index);
949
950                 if (index)
951                         timer_jiffies += TVN_SIZE - index;
952                 timer_jiffies >>= TVN_BITS;
953         }


In the above code, you will see that if a timer event is found there is no test to see if this timer event is deferrable. The patch that I proposed simply adds two lines of code that performs the same test as seen in the tv1 loop to check if a timer is deferrable for tv2-tv5. In other words, add lines 902 and 903, in between lines 932 and 933 in the function __next_timer_interrupt().

Cheers
Jon
