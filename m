Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXEAQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXEAQgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXEAQgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:36:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64786 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbXEAQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:36:16 -0400
Date: Tue, 1 May 2007 09:31:40 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, linux-kernel@vger.kernel.org,
       bunk@stusta.de, akpm@osdl.org, gcoady@gmail.com, zlynx@acm.org,
       dgc@sgi.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       hch@infradead.org, jengelh@linux01.gwdg.de, zwane@infradead.org,
       neilb@suse.de, jens.axboe@oracle.com, eric@provenscaling.com,
       wli@holomorphy.com
Subject: Re: [3/3] use vmalloc() to arrange guard pages for stacks
Message-ID: <20070501163140.GM26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
	bunk@stusta.de, akpm@osdl.org, gcoady@gmail.com, zlynx@acm.org,
	dgc@sgi.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	hch@infradead.org, jengelh@linux01.gwdg.de, zwane@infradead.org,
	neilb@suse.de, jens.axboe@oracle.com, eric@provenscaling.com
References: <20070430232351.GG26598@holomorphy.com> <20070430233309.GH26598@holomorphy.com> <20070430233712.GI26598@holomorphy.com> <20070430234030.GJ26598@holomorphy.com> <463757A3.7010808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463757A3.7010808@redhat.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
>> This patch introduces CONFIG_DEBUG_STACK, which vmalloc()'s task and IRQ
>> stacks in order to establish guard pages. In such a manner any stack
>> overflow that references pages immediately adjacent to the stack is
>> immediately trapped with a fault, which precludes silent memory corruption
>> or difficult-to-decipher failure modes resulting from stack corruption.

On Tue, May 01, 2007 at 11:07:15AM -0400, Chuck Ebbert wrote:
> Is there a guard page below and above the stack? (I've seen stack underflow
> before, as well as overflow.)

vmallocspace allocations are always separated by at least a page, so
this establishes guard pages both above and below the stack by virtue
of such.

It's also notable that the option establishes guard pages for IRQ stacks
in like fashion.

It's a shame that the resource scalability implications of vmallocspace
allocations prevent this from being useful in production. One could, in
principle, establish guard pages within ZONE_NORMAL, but for 4KB stacks
it's somewhat awkward to dredge up 3 contigous pages, and 4 defeats the
purpose. Alignment with 8KB stacks wants 2 contiguous order 1 pages that
span an order 2 page boundary. I guess I could rewrite the page allocator
(again), but people seem to feel safest with the buddy allocator affairs.

BTW, did the original patches for this prove to be of any use to you?


-- wli
