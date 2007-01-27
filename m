Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXA0THO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXA0THO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXA0THO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:07:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:33771 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXA0THN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,246,1167638400"; 
   d="scan'208"; a="173728303:sNHT19994814"
Message-ID: <45BBA2DD.50609@intel.com>
Date: Sat, 27 Jan 2007 11:07:09 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Possible regression: MSI vector leakage since 2.6.18-rc5ish (Unable
 to repeatedly allocate/free MSI interrupt)
References: <45BA82DA.6050201@intel.com> <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqkku8bp.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Auke Kok <auke-jan.h.kok@intel.com> writes:
> 
>> Hi,
>>
>> I've established a regression in the MSI vector/irq allocation routine for both
>> i386 and x86_64. Our test labs repeatedly modprobe/rmmod the e1000 driver for
>> serveral minutes which allocates msi vectors and frees them. These tests have
>> been running fine until 2.6.19.
>>
>> git-bisecting I've established that in between commit
>> 04b9267b15206fc902a18de1f78de6c82ca47716 "Eric W. Biederman -- genirq: x86_64
>> irq: Remove the msi assumption that irq == vector" and commit
>> f29bd1ba68c8c6a0f50bd678bbd5a26674018f7c "Ingo Molnar -- genirq: convert the
>> x86_64 architecture to irq-chips" the behaviour broke.
>>
>> The revisions in between seem to be dependent and give all sorts of other
>> issues, so it's rather hard for me to bisect that and give trustworthy results.
>>
>> the e1000 driver hits the 256-mark cycle (I think - it consistently refuses to
>> do 500 msi irq/vector allocations which is my test case) and throws:
>>
>> e1000: eth4: e1000_request_irq: Unable to allocate MSI interrupt Error: -16
>>
>> which is caused by a `if ((err = pci_enable_msi(adapter->pdev))) {` call from
>> the e1000 driver. It's rather easy to hit this mark with the new 4-port e1000
>> adapters :).
>>
>> as for the e1000 code, I can say that even our oldest msi-enabled e1000 driver
>> works fine with 2.6.18 and under. All kernels from 2.6.19 fail consistently.
>>
>> I mostly suspect commit 7bd007e480672c99d8656c7b7b12ef0549432c37 at the
>> moment. Perhaps Eric Biederman can help?
> 
> Does this patch fix it for you?  It looks like i386 vector allocate
> did not have logic to look through the set of vectors more than once.
> 
> The code in this patch is a simplified version of what we have
> on x86_64.

I highly doubt it - I've seen the problem even on this weeks git on x86_64. 
Moreover, I'm at home for the weekend and testing resources are limited :). I'll 
see what I can do

Auke
