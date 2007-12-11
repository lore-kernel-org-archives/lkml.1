Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXLKPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXLKPCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbXLKPC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:02:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45622 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXLKPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:02:27 -0500
Date: Tue, 11 Dec 2007 16:02:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: dor.laor@qumranet.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211150225.GC16750@one.firstfloor.org>
References: <475E8C8B.7070308@qumranet.com> <p73lk81nw71.fsf@bingen.suse.de> <475EA54C.4090306@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EA54C.4090306@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 04:57:16PM +0200, Dor Laor wrote:
> Andi Kleen wrote:
> >[headers rewritten because of gmane crosspost breakage]
> >
> >  
> >>In the latest kernel (2.6.24-rc3) I noticed a drastic performance 
> >>decrease for KVM networking.
> >>    
> >
> >That should not have changed for quite some time.
> >
> >Also it depends on the CPU of course.
> >  
> I didn't find the exact place of the change but using fedora 2.6.23-8 
> there is no problem.
> 3aefbe0746580a710d4392a884ac1e4aac7c728f turn X86_FEATURE_SYNC_RDTSC  
> off for most
> intel cpus, but it was committed in May.

Ah there was a change to enable it on Core2. On AMD it was 
always there except on CPUs with RDTSCP

Anyways the very likely right way (I'm still waiting for final
confirmation from Intel) to solve this is to use LFENCE which
happens to stop RDTSC and is relatively light weight and won't
cause vmexits. Unfortunately that doesn't work on AMD, but 
there MFENCE happens to work. But there are more problems
in this code which I have a (.24) patchkit to fix.

> According to Intel spec it is a serializing instruction along with cpuid 
> and others.

You're right. The real roblem is that it is ring 0 only and that can
be executed in ring 3. That is why Ingo's patch was wrong too.

-Andi
