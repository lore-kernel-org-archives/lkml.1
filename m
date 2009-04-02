Return-Path: <linux-kernel-owner+w=401wt.eu-S1765648AbZDBT6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765648AbZDBT6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZDBT6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:58:38 -0400
Received: from gw.goop.org ([64.81.55.164]:47623 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbZDBT6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:58:38 -0400
Message-ID: <49D518E9.1090001@goop.org>
Date: Thu, 02 Apr 2009 12:58:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, frankeh@watson.ibm.com,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       hugh@veritas.com, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [patch 0/6] Guest page hinting version 7.
References: <20090327150905.819861420@de.ibm.com>	<200903281705.29798.rusty@rustcorp.com.au>	<20090329162336.7c0700e9@skybase>	<200904022232.02185.nickpiggin@yahoo.com.au>	<20090402175249.3c4a6d59@skybase> <49D50CB7.2050705@redhat.com>
In-Reply-To: <49D50CB7.2050705@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Page hinting has a complex, but well understood, mechanism
> and simple policy.
>   

For the guest perhaps, and yes, it does push the problem out to the 
host.  But that doesn't make solving a performance problem any easier if 
you end up in a mess.

> Ballooning has a simpler mechanism, but relies on an
> as-of-yet undiscovered policy.
>   
(I'm talking about Xen ballooning here; I know KVM ballooning works 
differently.)

Yes and no.  If you want to be able to shrink the guest very 
aggressively, then you need to be very careful about not shrinking too 
much for its current and near-future needs.  But you'll get into an 
equivalently bad state with page hinting if the host decides to swap out 
and discard lots of persistent guest pages.

When the host demands memory from the guest, the simple caseballooning 
is analogous to page hinting:

    * give up free pages == mark pages unused
    * give up clean pages == mark pages volatile
    * cause pressure to release some memory == host swapping

The flipside is how guests can ask for memory if their needs increase 
again.  Page-hinting is fault-driven, so the guest may stall while the 
host sorts out some memory to back the guests pages.  Ballooning 
requires the guest to explicitly ask for memory, and that could be done 
in advance if it notices the pool of easily-freed pages is shrinking 
rapidly (though I guess it could be done on demand as well, but we don't 
have hooks for that).

But of course, there are other approaches people are playing with, like 
Dan Magenheimer's transcendental memory, which is a pool of 
hypervisor-owned and managed pages which guests can use via a copy 
interface, as a second-chance page discard cache, fast swap, etc.  Such 
mechanisms may be easier on both the guest complexity and policy fronts.

The more complex host policy decisions of how to balance overall memory 
use system-wide are much in the same for both mechanisms.

    J
