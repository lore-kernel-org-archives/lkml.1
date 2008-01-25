Return-Path: <linux-kernel-owner+w=401wt.eu-S1760747AbYAYXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbYAYXi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbYAYXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:38:50 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:55728 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYAYXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:38:49 -0500
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 25 Jan 2008 23:38:02 +0000
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
Thread-Index: Achfq1MzkZSEOcueEdyNUQAWy6hiGQ==
In-Reply-To: <479A68B8.4050705@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/1/08 22:54, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> The only possibly relevant comment I can find in vol3a is:
> 
>     Older IA-32 processors that implement the PAE mechanism use uncached
>     accesses when loading page-directory-pointer table entries. This
>     behavior is
>     model specific and not architectural. More recent IA-32 processors may
>     cache page-directory-pointer table entries.

Go read the Intel application note "TLBs, Paging-Structure Caches, and Their
Invalidation" at http://www.intel.com/design/processor/applnots/317080.pdf

Section 8.1 explains about the PDPTR cache in 32-bit PAE mode, which can
only be refreshed by appropriate tickling of CR0, CR3 or CR4.

It is also important to note that *any* valid page directory entry at *any*
level in the page-table hierarchy can become cached at *any* time. Basically
TLB lookup is performed as a longest-prefix match on the linear address to
skip as many levels in a page-table walk as possible (where a walk is
needed, because there is no full-length match on the linear address). So, if
you modify a directory entry from present to not-present, or change the page
directory that a valid pde points to, you probably need to flush the pde
caching structure. One piece of good news is that all pde caches are flushed
by any arbitrary INVLPG.

 -- Keir


