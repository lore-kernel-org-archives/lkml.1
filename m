Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYG2A3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYG2A3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYG2A3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:29:06 -0400
Received: from gw.goop.org ([64.81.55.164]:49752 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYG2A3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:29:05 -0400
Message-ID: <488E644B.10801@goop.org>
Date: Mon, 28 Jul 2008 17:28:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Comments on UV tlb flushing
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just reworking the x86 tlb code to use smp_call_function_mask, and I 
see how the UV tlb flushing hooks in.  A few things occur to me:

   1. There should be a CONFIG_X86_UV to select this code.  tlb_uv.o is
      around 6k, which is not trivial overhead to subject every x86_64
      kernel to.
   2. CONFIG_X86_UV should either depend on or select CONFIG_PARAVIRT.
   3. You should hook into paravirt_ops to enable your tlb-flush code. 
      That is, in - say - uv_bau_init() you do
      "pv_mmu_ops.flush_tlb_others = uv_flush_tlb_others".  This removes
      a test/branch in the generic code.  Using paravirt_ops may open
      other opportunities to put UV-optimised functions in place without
      having to modify generic code.

My understanding is that the UV hardware has some kind of 
payload-carrying IPI mechanism, which is a capability could be useful to 
express in a higher-level way in the kernel.  Certainly I could imagine 
using it in a virtual environment as a way to do inter-VCPU messaging 
with less context switch overhead.

Thanks,
    J
