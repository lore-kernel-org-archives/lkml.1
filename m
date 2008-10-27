Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJ0NMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJ0NMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbYJ0NML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:12:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbYJ0NMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:12:10 -0400
Date: Mon, 27 Oct 2008 14:11:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Lalancette <clalance@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: Fix Xen domU boot with batched mprotect
Message-ID: <20081027131143.GA25371@elte.hu>
References: <49011979.8060301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49011979.8060301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Chris Lalancette <clalance@redhat.com>
>
> Recent i686 2.6.27 kernels with a certain amount of memory (between 
> 736 and 855MB) have a problem booting under a hypervisor that 
> supports batched mprotect (this includes the RHEL-5 Xen hypervisor 
> as well as any 3.3 or later Xen hypervisor).  The problem ends up 
> being that xen_ptep_modify_prot_commit() is using virt_to_machine to 
> calculate which pfn to update.  However, this only works for pages 
> that are in the p2m list, and the pages coming from 
> change_pte_range() in mm/mprotect.c are kmap_atomic pages.  Because 
> of this, we can run into the situation where the lookup in the p2m 
> table returns an INVALID_MFN, which we then try to pass to the 
> hypervisor, which then (correctly) denies the request to a totally 
> bogus pfn.
>
> The right thing to do is to use arbitrary_virt_to_machine, so that 
> we can be sure we are modifying the right pfn.  This unfortunately 
> introduces a performance penalty because of a full page-table-walk, 
> but we can avoid that penalty for pages in the p2m list by checking 
> if virt_addr_valid is true, and if so, just doing the lookup in the 
> p2m table.
>
> The attached patch implements this, and allows my 2.6.27 i686 based 
> guest with 768MB of memory to boot on a RHEL-5 hypervisor again.  
> Thanks to Jeremy for the suggestions about how to fix this 
> particular issue.
>
> Signed-off-by: Chris Lalancette <clalance@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
> arch/x86/xen/mmu.c |   18 ++++++++++++++----
> 1 file changed, 14 insertions(+), 4 deletions(-)

applied to tip/x86/urgent, thanks!

	Ingo
