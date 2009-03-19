Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZCSBc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZCSBc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZCSBcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:32:19 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33171 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751196AbZCSBcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:32:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WdezK3i4Gz/Asgf4xIWC4VF4QYZJDS6KLCbVpPvbob+C0Yzpq8Yxg/I2hYq+lj2Ir4LitiKCS4KrjrN/4uoS4Xj43LoX8WmHCYaJetmhdJC8qH/N2SFrD55Gz3L57lHv6a27NTBgiwXPbNduCrDAXfjuontgultt9x+X+wTuohs=  ;
X-YMail-OSG: gbEob5gVM1lolIl3w79Goq_M6EPYuKIizeB1yhJyLv_iMV3XFKuecY74v.nDLxpKoK3A_9Az.v_sh88KU8rSFtZ_IpHgjXqzA55n0DxpPxndgk2qM.oshXXVAdIO.QxMD3MpkQyJru_XtirbzJwyg4MUarAE0lVX5MiMImwXDdfBJXIJo8spFlqkJ.NEsQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
Date: Thu, 19 Mar 2009 12:32:04 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
References: <49C148AF.5050601@goop.org>
In-Reply-To: <49C148AF.5050601@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903191232.05459.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

I think you got most of your questions already hashed out, but
I could make a suggestion...

On Thursday 19 March 2009 06:17:03 Jeremy Fitzhardinge wrote:
> Hi Nick,
>
> The comment in arch/x86/mm/gup.c:gup_get_pte() says:
>
> 	[...] What
> 	 * we do have is the guarantee that a pte will only either go from not
> 	 * present to present, or present to not present or both -- it will not
> 	 * switch to a completely different present page without a TLB flush in
> 	 * between; something that we are blocking by holding interrupts off.
>
>
> Disabling the interrupt will prevent the tlb flush IPI from coming in
> and flushing this cpu's tlb, but I don't see how it will prevent some
> other cpu from actually updating the pte in the pagetable, which is what
> we're concerned about here.

Yes, I don't believe it is possible to have a *new* pte installed until
the flush is done.


> Is this the only reason to disable
> interrupts?  Would we need to do it for the !PAE cases?

It has to pin page tables, and pin pages as well.


> Also, assuming that disabling the interrupt is enough to get the
> guarantees we need here, there's a Xen problem because we don't use IPIs
> for cross-cpu tlb flushes (well, it happens within Xen).  I'll have to
> think a bit about how to deal with that, but I'm thinking that we could
> add a per-cpu "tlb flushes blocked" flag, and maintain some kind of
> per-cpu deferred tlb flush count so we can get around to doing the flush
> eventually.
>
> But I want to make sure I understand the exact algorithm here.

FWIW, powerpc actually can flush tlbs without IPIs, and it also has
a gup_fast. powerpc RCU frees its page _tables_ so we can walk them,
and then I use speculative page references in order to be able to
take a reference on the page without having it pinned.

Turning gup_get_pte into a pvop would be a bit nasty because on !PAE
it is just a single load, and even on PAE it is pretty cheap.

