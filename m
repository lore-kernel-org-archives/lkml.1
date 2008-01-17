Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYAQTo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYAQTo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYAQToe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:44:34 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41939
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYAQTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:44:33 -0500
X-Greylist: delayed 688 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 14:44:33 EST
Date: Thu, 17 Jan 2008 20:32:52 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Izik Eidus <izike@qumranet.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, clameter@sgi.com,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] mmu notifiers #v2
Message-ID: <20080117193252.GC24131@v2.random>
References: <20080113162418.GE8736@v2.random> <20080116124256.44033d48@bree.surriel.com> <478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478F9C9C.7070500@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 08:21:16PM +0200, Izik Eidus wrote:
> ohh i like it, this is cleaver solution, and i guess the cost of the 
> vmexits wont be too high if it will
> be not too much aggressive....

Yes, and especially during swapping, the system isn't usually CPU
bound. The idea is to pay with some vmexit minor fault when the CPU
tends to be idle, to reduce the amount of swapouts. I say swapouts and
not swapins because it will mostly help avoiding writing out swapcache
to disk for no good reason. Swapins already have a chance not to
generate any read-I/O if the removed spte is really hot.

To make this work we still need notification from the VM about memory
pressure and perhaps the slab shrinker method is enough even if it has
a coarse granularity. Freeing sptes during memory pressure converges
also with the objective of releasing pinned slab memory so that the
spte cache can grow more freely (the 4k PAGE_SIZE for 0-order page
defrag philosophy will also appreciate that to work). There are lots
of details to figure out in an good implementation though but the
basic idea converges on two fairly important fronts.
