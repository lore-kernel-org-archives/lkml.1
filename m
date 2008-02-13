Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbYBMBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbYBMBqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYBMBpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:45:55 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:50118 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756270AbYBMBpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:45:54 -0500
Message-ID: <47B24BCB.8030003@opengridcomputing.com>
Date: Tue, 12 Feb 2008 19:45:47 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Christoph Lameter <clameter@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Rik van Riel <riel@redhat.com>, steiner@sgi.com,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
References: <20080209015659.GC7051@v2.random> <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com> <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com> <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com> <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com> <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com> <20080213012638.GD31435@obsidianresearch.com>
In-Reply-To: <20080213012638.GD31435@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gunthorpe wrote:
> On Tue, Feb 12, 2008 at 05:01:17PM -0800, Christoph Lameter wrote:
>> On Tue, 12 Feb 2008, Jason Gunthorpe wrote:
>>
>>> Well, certainly today the memfree IB devices store the page tables in
>>> host memory so they are already designed to hang onto packets during
>>> the page lookup over PCIE, adding in faulting makes this time
>>> larger.
>> You really do not need a page table to use it. What needs to be maintained 
>> is knowledge on both side about what pages are currently shared across 
>> RDMA. If the VM decides to reclaim a page then the notification is used to 
>> remove the remote entry. If the remote side then tries to access the page 
>> again then the page fault on the remote side will stall until the local 
>> page has been brought back. RDMA can proceed after both sides again agree 
>> on that page now being sharable.
> 
> The problem is that the existing wire protocols do not have a
> provision for doing an 'are you ready' or 'I am not ready' exchange
> and they are not designed to store page tables on both sides as you
> propose. The remote side can send RDMA WRITE traffic at any time after
> the RDMA region is established. The local side must be able to handle
> it. There is no way to signal that a page is not ready and the remote
> should not send.
> 
> This means the only possible implementation is to stall/discard at the
> local adaptor when a RDMA WRITE is recieved for a page that has been
> reclaimed. This is what leads to deadlock/poor performance..
>

If the events are few and far between then this model is probably ok. 
For iWARP, it means TCP retransmit and slow start and all that, but if 
its an infrequent event, then its ok if it helps the host better manage 
memory.

Maybe... ;-)


Steve.
