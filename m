Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbXGDVyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbXGDVyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXGDVxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:53:55 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:12908 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbXGDVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:53:54 -0400
Date: Wed, 4 Jul 2007 14:53:53 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Rik van Riel <riel@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Message-ID: <20070704215353.GW9157@hexapodia.org>
References: <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com> <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com> <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com> <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com> <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com> <20070702190043.GN9157@hexapodia.org> <46894BE6.1040302@redhat.com> <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com> <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com> <4689826C.5050800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4689826C.5050800@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-PGP-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 06:55:40PM -0400, Rik van Riel wrote:
> You could easily replace the cookie with a pointer to a free
> page pool.

It just occurred to me that something like this is *required* to get the
performance benefit from MAP_NOZERO on a busy system.  With Davide's
current proposal, if there are N jobs with different "nozero cookies"
busy allocating and deallocating pages on a single-NUMA-node system,
then there's only a 1/N chance that the page returned by __alloc_pages
will have the correct cookie, so (N-1)/N percent of the time MAP_NOZERO
will have no positive effect -- 90% of the time for the case of N=10.

(Of course on NUMA systems node affinity will probably make the
situation a bit better.)

So I'm afraid that it sounds like additional complexity would be
required so that __alloc_pages could track and preferentially return
pages with the correct "nozero cookie".


In a mostly unrelated complaint, I note that having a function named
"alloc_zeroed_page_vma" which returns a potentially nonzero page is, um,
unintuitive.  It needs a name which does not claim it returns zeroed
pages.  I'm no good at names, but perhaps "alloc_available_page_vma"?

-andy
