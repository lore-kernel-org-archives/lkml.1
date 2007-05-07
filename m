Return-Path: <linux-kernel-owner+w=401wt.eu-S967243AbXEGXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967243AbXEGXoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933652AbXEGXoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:44:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933635AbXEGXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:44:16 -0400
Message-ID: <463FB957.40707@redhat.com>
Date: Mon, 07 May 2007 19:42:15 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <20070502192214.GA1248@infradead.org>
In-Reply-To: <20070502192214.GA1248@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 02, 2007 at 02:15:42PM +0200, Stefan Richter wrote:
>> +/*						-*- c-basic-offset: 8 -*-
> 
> Please don't pollute the code with annotation for some editors.

OK.

>> + * fw-card.c - card level functions
> 
> Please don't put the filename into a comment inside the filename.
> It's not actually useful and it gets out of date very easily.

Yeah, true.

>> +static DECLARE_RWSEM(card_rwsem);
> 
> this one is only ever used with down_read/up_read so a normal
> mutex would probably better suited.

down_write/up_write, but yes, I'll change that to a mutex.  The card_rwsem was 
previously subsystem.rwsem, but that went away.

>> +static LIST_HEAD(card_list);
> 
> 
> 
>> +#define bib_pmc			((1) << 27)
>> +#define bib_bmc			((1) << 28)
>> +#define bib_isc			((1) << 29)
>> +#define bib_cmc			((1) << 30)
>> +#define bib_imc			((1) << 31)
> 
> These are rather odd names for constants.  They should at least
> start with an uppercase letter if not be all uppercase.  Also
> an enum might be right here.

Sure, I'll do that... all those uppercase letters hurt my eyes, though.

>> +static u32 *
>> +generate_config_rom (struct fw_card *card, size_t *config_rom_length)
> 
> Please don't put white spaces after the function identifier.

Ugh, yeah, I don't know why I keep doing that...

>> +	/* Initialize contents of config rom buffer.  On the OHCI
>> +	 * controller, block reads to the config rom accesses the host
>> +	 * memory, but quadlet read access the hardware bus info block
>> +	 * registers.  That's just crack, but it means we should make
>> +	 * sure the contents of bus info block in host memory mathces
>> +	 * the version stored in the OHCI registers. */
> 
> Normal style for block comments is:
> 
> 	/*
> 	 * Initialize contents of config rom buffer.  On the OHCI
> 	 * controller, block reads to the config rom accesses the host
> 	 * memory, but quadlet read access the hardware bus info block
> 	 * registers.  That's just crack, but it means we should make
> 	 * sure the contents of bus info block in host memory mathces
> 	 * the version stored in the OHCI registers.
> 	 */

Oh, ok, I can clean that up.

>> +struct fw_node {
>> +	u16 node_id;
>> +	u8 color;
>> +	u8 port_count;
>> +	unsigned link_on : 1;
>> +	unsigned initiated_reset : 1;
>> +	unsigned b_path : 1;
>> +	u8 phy_speed : 3; /* As in the self ID packet. */
>> +	u8 max_speed : 5; /* Minimum of all phy-speeds and port speeds on
>> +			   * the path from the local node to this node. */
>> +	u8 max_depth : 4; /* Maximum depth to any leaf node */
>> +	u8 max_hops : 4;  /* Max hops in this sub tree */
> 
> I don't think we need to save the few bits here and can just use
> u8 instead of bitfields.

These bitfields aren't used on the wire or anywhere outside the driver... what 
the problem? Perfomance?

>> +		/* Pop the child nodes off the stack and push the new node. */
>> +		__list_del(h->prev, &stack);
> 
> Please don't ever use __list_del directly, it's an interna implementation
> detail.

Do you have an alternative suggestion here?  I need to take a sub-list of the 
list, which is exactly what __list_del does.  I could loop through the 
sublist, but it's pretty pointless since I have both ends of the sublist.

> I also notices that close to none of the export functions have kerneldoc
> comment blocks.  I think we really should have them on something that
> is a driver API.

Yeah... I'll sit down and try to document it better.

thanks
Kristian
