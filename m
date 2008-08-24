Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHXQl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHXQl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 12:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHXQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 12:41:20 -0400
Received: from il.qumranet.com ([212.179.150.194]:18137 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbYHXQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 12:41:20 -0400
Message-ID: <48B18F2E.8090108@qumranet.com>
Date: Sun, 24 Aug 2008 19:41:18 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: oops due to smp_call_function_single changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My 2s x 2c Intel server (Xeon 5150) won't boot anymore.  I bisected this to

commit cc7a486cac78f6fc1a24e8cd63036bae8d2ab431
Author: Nick Piggin <nickpiggin@yahoo.com.au>
Date:   Mon Aug 11 13:49:30 2008 +1000

    generic-ipi: fix stack and rcu interaction bug in 
smp_call_function_mask()
   
    * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
   
    > Found a OOPS on a big SMP box during an overnight reboot test with
    > upstream git.
    >
    > Suresh and I looked at the oops and looks like the root cause is in
    > generic_smp_call_function_interrupt() and smp_call_function_mask() 
with
    > wait parameter.
    >
[...]
    Nice debugging work.
   
    I'd suggest something like the attached (boot tested) patch as the 
simple
    fix for now.
   
    I expect the benefits from the less synchronized, 
multiple-in-flight-data
    global queue will still outweigh the costs of dynamic allocations. But
    if worst comes to worst then we just go back to a globally synchronous
    one-at-a-time implementation, but that would be pretty sad!
   
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


Reverting this commit (and cc7a486cac78f6fc1a24e8cd63036bae8d2ab431, 
which is an add-on fix) allows my guest to boot.

My .config can be found in 
http://userweb.kernel.org/~avi/scf-oops/config.  I have an oops 
somewhere inside a mobile phone but have yet to find a way to dig it 
out.  Netconsole doesn't work for me built-in for some reason, and this 
is during boot (I think during the loading of the ahci modules).

-- 
error compiling committee.c: too many arguments to function

