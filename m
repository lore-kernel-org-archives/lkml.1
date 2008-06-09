Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYFIRVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYFIRVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYFIRVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:21:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38065 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbYFIRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:21:07 -0400
Subject: Re: [PATCH 03/15] x86: remove early_gdt_descr reference
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
In-Reply-To: <484D5119.5020206@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
	 <1213024983.3508.28.camel@localhost.localdomain>
	 <484D5119.5020206@redhat.com>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:20:41 -0500
Message-Id: <1213032042.3508.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 12:49 -0300, Glauber Costa wrote:
> James Bottomley wrote:
> > On Mon, 2008-06-09 at 11:16 -0300, Glauber Costa wrote:
> >> since we use switch_to_new_gdt, there is no point
> >> in assigning early_gdt_descr except for the first
> >> assignment, which is done manually.
> > 
> > What makes you think you can do this?  If you don't update the early
> > boot gdt, they all end up using the Boot CPU one.  The problem with this
> > is that there's a time from start_secondary to switch_to_new_gdt where
> > the per cpu selector (%fs) and the pda selector (%gs) are those of the
> > boot CPU.   The former isn't a problem but the CPU number is in the
> > latter, and it's used in that path before we get to the initialisation.
> 
> You are right, I missed it.
> 
> However, it only seem to be used in cpu_init, and very early. Sure there 
> are some users _before_ we load the new gdt, but nothing prevents them 
> to be moved after it. (Of course, this patch is wrong anyway).
> 
> And if we do that, we can even take the %fs loading out of head_32.S
> Of course, it's only valid if those are indeed the only early users of it.
> 
> Is there any other use I'm missing?

Well, %fs loading there is done for the boot CPU. To eliminate that you
have to not only verify that start_secondary doesn't use anything in
per_cpu areas, but also verify that nothing in start_kernel() up until
boot_cpu_init() does ... That's a lot of smp_processor_id() references
to convert.

James


