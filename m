Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZKJAPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZKJAPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbZKJAPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:15:31 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45973 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZKJAPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:15:31 -0500
Date: Tue, 10 Nov 2009 00:15:36 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
In-Reply-To: <4AF8A0A0.2080800@zytor.com>
Message-ID: <alpine.LFD.2.00.0911092326200.9725@eddie.linux-mips.org>
References: <20091108155356.GB25940@lenovo> <4AF8A0A0.2080800@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, H. Peter Anvin wrote:

> In theory we could have more than one ioapic packed into a single page,
> and it is also entirely plausible we'll support other page sizes in x86
> at some point.  However, it's probably easier to flag something as
> PAGE_SIZE and have to fix it up later than have magic constants, so I
> think it's probably the right thing to do.

 Hmm, the MPS said in Chapter 3.6.5 "APIC Memory Mapping":

 "Non-default APIC base addresses can be used if the MP configuration 
table is provided. (Refer to Chapter 4.)  However, the local APIC base 
address must be aligned on a 4K boundary, and the I/O APIC base address 
must be aligned on a 1K boundary."

This probably still stands; I suppose it would be safer to define 
IOAPIC_SLOT_SIZE to 1024 and use it by default, expanding all reservations 
as needed where less than PAGE_SIZE / IOAPIC_SLOT_SIZE I/O APICs would be 
mapped in a page.  This is relatively recent a piece of code -- how much 
has it been tested?

 Well, actually not much as a quick search has revealed this message:

http://marc.info/?l=linux-kernel&m=118114792006520

which shows page alignment of I/O APICs clearly does not stand, and 
moreover there are two pairs of I/O APIC in the system reported which 
share a page each.  In this case the ranges requested do not make sense 
and some resource insertions will silently fail.  And also while page 
aliases created in fixmaps here should not harm, they make me feel a 
little bit chilly...

 Overall this piece of code needs an overhaul, fixing resource allocation 
and reusing fixmaps where possible.

  Maciej 
