Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYHUHHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYHUHHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYHUHGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:06:55 -0400
Received: from saeurebad.de ([85.214.36.134]:39490 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYHUHGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:06:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Sean MacLennan <smaclennan@pikatech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
References: <20080820135551.74911cb3@lappy.seanm.ca>
	<20080820190436.GA5388@joi> <20080820151531.38fc1071@lappy.seanm.ca>
	<87myj74azn.fsf@skyscraper.fehenstaub.lan>
	<20080821000844.GA10031@joi>
Date: Thu, 21 Aug 2008 09:06:32 +0200
In-Reply-To: <20080821000844.GA10031@joi> (Marcin Slusarz's message of "Thu,
	21 Aug 2008 02:08:48 +0200")
Message-ID: <873aky4zk7.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin Slusarz <marcin.slusarz@gmail.com> writes:

> On Wed, Aug 20, 2008 at 11:45:00PM +0200, Johannes Weiner wrote:
>> Hi,
>> 
>> > On Wed, 20 Aug 2008 21:05:41 +0200
>> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
>> >
>> >> I thought about this warning today and found 2 other solutions:
>> >> 1) Mark contig_page_data as __ref (but it might hide real bugs).
>> >> 2) Remove bdata from struct pglist_data and access it directly through
>> >>    bootmem_node_data. It requires passing node number to all functions
>> >>    which use bdata, but unfortunately arch/ia64/mm/discontig.c handles
>> >>    node numbering its own way. I'm still investigating it.
>> 
>> Yeah, I gave it a shot once too but dropped it again after I looked at
>> ia64 code.
>> 
>> Perhaps we can just remove the static assignment and do it at boot up?
>
> That won't work - modpost will warn at different place about section
> mismatch. But even if it would work, we lose potentially useful
> analysis of all uses of pglist_data->bdata.

Right, but the current way of handling things completely circumvents the
section checking, no?

> But I think I found better solution - replace "struct bootmem_data *bdata"
> in struct pglist_data with "int bootmem_node;" and change all uses of bdata
> to &bootmem_node_data[struct pglist_data *->bootmem_node].

Good idea.  You don't even need a new number here, pgdat->node_id should
be usable out of the box to index into the bdata array.

> What do you think about it? Would it be acceptable?

Yes, that sounds good.

	Hannes
