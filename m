Return-Path: <linux-kernel-owner+w=401wt.eu-S2993136AbXEBTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993136AbXEBTWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993147AbXEBTWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:22:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993136AbXEBTWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:22:16 -0400
Date: Wed, 2 May 2007 20:22:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] firewire: handling of cards, buses, nodes
Message-ID: <20070502192214.GA1248@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux1394-devel <linux1394-devel@lists.sourceforge.net>
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.350cb4dfe522266e@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 02:15:42PM +0200, Stefan Richter wrote:
> +/*						-*- c-basic-offset: 8 -*-

Please don't pollute the code with annotation for some editors.

> + * fw-card.c - card level functions

Please don't put the filename into a comment inside the filename.
It's not actually useful and it gets out of date very easily.

> +static DECLARE_RWSEM(card_rwsem);

this one is only ever used with down_read/up_read so a normal
mutex would probably better suited.

> +static LIST_HEAD(card_list);



> +#define bib_pmc			((1) << 27)
> +#define bib_bmc			((1) << 28)
> +#define bib_isc			((1) << 29)
> +#define bib_cmc			((1) << 30)
> +#define bib_imc			((1) << 31)

These are rather odd names for constants.  They should at least
start with an uppercase letter if not be all uppercase.  Also
an enum might be right here.

> +static u32 *
> +generate_config_rom (struct fw_card *card, size_t *config_rom_length)

Please don't put white spaces after the function identifier.

> +	/* Initialize contents of config rom buffer.  On the OHCI
> +	 * controller, block reads to the config rom accesses the host
> +	 * memory, but quadlet read access the hardware bus info block
> +	 * registers.  That's just crack, but it means we should make
> +	 * sure the contents of bus info block in host memory mathces
> +	 * the version stored in the OHCI registers. */

Normal style for block comments is:

	/*
	 * Initialize contents of config rom buffer.  On the OHCI
	 * controller, block reads to the config rom accesses the host
	 * memory, but quadlet read access the hardware bus info block
	 * registers.  That's just crack, but it means we should make
	 * sure the contents of bus info block in host memory mathces
	 * the version stored in the OHCI registers.
	 */

> +struct fw_node {
> +	u16 node_id;
> +	u8 color;
> +	u8 port_count;
> +	unsigned link_on : 1;
> +	unsigned initiated_reset : 1;
> +	unsigned b_path : 1;
> +	u8 phy_speed : 3; /* As in the self ID packet. */
> +	u8 max_speed : 5; /* Minimum of all phy-speeds and port speeds on
> +			   * the path from the local node to this node. */
> +	u8 max_depth : 4; /* Maximum depth to any leaf node */
> +	u8 max_hops : 4;  /* Max hops in this sub tree */

I don't think we need to save the few bits here and can just use
u8 instead of bitfields.

> +		/* Pop the child nodes off the stack and push the new node. */
> +		__list_del(h->prev, &stack);

Please don't ever use __list_del directly, it's an interna implementation
detail.



I also notices that close to none of the export functions have kerneldoc
comment blocks.  I think we really should have them on something that
is a driver API.
