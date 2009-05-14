Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbZENO2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbZENO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZENO2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:28:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45693 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZENO2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:28:36 -0400
X-Greylist: delayed 753 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 10:28:36 EDT
Message-Id: <4A0C46B80200007800000ED4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 14 May 2009 15:28:40 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <linux-kernel-owner@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
	 allocator
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
In-Reply-To: <1242305390-21958-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 14.05.09 14:49 >>>
>The remap allocator allocates a PMD page per cpu, returns whatever is
>unnecessary to the page allocator and remaps the PMD page into vmalloc
>area to construct the first percpu chunk.  This is to take advantage
>of large page mapping.  However this creates active aliases for the
>recycled pages.  When some user allocates the recycled pages and tries
>to change pageattr on it, remapped PMD alias might end up having
>different attributes with the regular page mapped addresses which can
>lead to subtle data corruption according to Andi.

In order to reduce the amount of work to do during lookup as well as the
chance of having a collision at all, wouldn't it be reasonable to use as much
of an allocated 2/4M page as possible rather than returning whatever is
left after a single CPU got its per-CPU memory chunk from it? I.e. you'd
return only those (few) pages that either don't fit another CPU's chunk
anymore or that are left after running through all CPUs.

Or is there some hidden requirement that each CPU's per-CPU area must
start on a PMD boundary?

This would additionally address a potential problem on 32-bits - currently,
for a 32-CPU system you consume half of the vmalloc space with PAE (on
non-PAE you'd even exhaust it, but I think it's unreasonable to expect a
system having 32 CPUs to not need PAE).

Jan

