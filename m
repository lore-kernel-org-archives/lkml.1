Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYG3E4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYG3E4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYG3E4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:56:15 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:39487 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751233AbYG3E4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:56:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aciXOlVXMz/fMBrZSD7xoieH3Smj7lPUKd9DUXArCJzPaK3No+A+HKj0ou2Yh7UBPuefV5GVPe2PFs/ODN4yRiPSW6ydgmZcJ4DElLMO2jBEAtQ+opD0UrNok30/xmWrcAhuv7/2MdjLeXjMuCqSKgTVbs1u1bmkAaOw3YjsAHE=  ;
X-YMail-OSG: fMNzXUkVM1kwuOP2zYz4W9OxZV_pIs3IgehvJiXzg6AqGshz6zBrYu.BEiq.FBkrqB73HR5wMqPcJ0LSZU2hEPT_mWlwiKqT8w29ha6F0Li2RPa3jM2ZZr8IN87HEi2.SqA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2/2] x86: implement multiple queues for smp function call IPIs
Date: Wed, 30 Jul 2008 14:55:57 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <488FA8A9.6000005@goop.org>
In-Reply-To: <488FA8A9.6000005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301455.57507.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 09:32, Jeremy Fitzhardinge wrote:
> This adds 8 queues for smp_call_function(), in order to avoid a
> bottleneck on a single global lock and list for function calls.  When
> initiating a function call, the sender chooses a queue based on its
> own processor id (if there are more than 8 processors, they hash down
> to 8 queues).  It then sends an IPI to the corresponding vector for
> that queue to each target CPU.  The target CPUs use the vector number
> to determine which queue they should scan for work.
>
> This should give smp_call_function the same performance
> characteristics as the original x86-64 cross-cpu tlb flush code, which
> used the same scheme.

Yep, I'm much happier if you go this way to do it. This way hopefully
eventually we can extend the call function infrastructure to also
generalise the UV type payload-IPIs and fold all that in here too.

I don't _think_ there should any longer be any reason why it should
be slower than the special case code (at least nothing fundamental
that I can see).

Actually it should have a chance to be faster because we should be able
to queue up multiple tlb flushes into each global call queue, rather
than executing them strictly one at a time under the tlbstate lock like
we do now.

Anyway it looks like Andi is reviewing the fine details, so I'm happy
with this if he is :) Thanks!
