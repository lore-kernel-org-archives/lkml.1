Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbXCZMfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbXCZMfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXCZMfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:35:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37938 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXCZMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:35:39 -0400
Subject: Re: [PATCH 09/20 take 4] UBI: wear-leveling unit
From: Frank Haverkamp <haver@vnet.ibm.com>
Reply-To: haver@vnet.ibm.com
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Alexander Schmidt <alexs@linux.ibm.com>
In-Reply-To: <20070323164342.8958.94778.sendpatchset@localhost.localdomain>
References: <20070323164256.8958.58377.sendpatchset@localhost.localdomain>
	 <20070323164342.8958.94778.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Mon, 26 Mar 2007 14:34:14 +0200
Message-Id: <1174912454.4202.59.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wonder if a generic wear-leveling infrastructure makes sense. Artem is
showing us here his example of how he is attacking the problem for UBI.

The wear-leveling described here is only one approach out of many
possible. A different one, I think, is used where e.g. filesystems do
their own approach, because they have deeper knowledge on how the blocks
are used.
I think this is something special and out of the scope of what I try to
point out here.

Artems approach for UBI, as far as I can see, uses currently the hints:
erase counts per block a sequence number and a full view of all existing
blocks. If a block is requested the user can give following information:
LONGTERM, UNKNOWN, and SHORTTERM. Internally it has trees containing:
free blocks, used blocks, and blocks to scrub.

Let me try to illustrate how I think that a generic aproach might look
like:

struct wlevel_block {
	phys_block_num;
	erase_count;
	sequence_number;
	... /* which other hints are reasonable? 
		maybe other devices -> other hints? */
};

struct wlevel {
	int (* erase_block)(phys_num, priv_data); /* callback */
	/* more callbacks needed? */
	...
	void *priv_data;
};

wlevel_init(struct wlevel *wl);
wlevel_add(struct wlevel *wl, struct block_info *bi); /* add block info
e.g. during scan */
wlevel_put(struct wlevel *wl, block); /* free/erase a block */
wlevel_scrub(struct wlevel *wl, block);

enum characteristics {
	WL_DATA_LONGTERM,
	WL_DATA_UNKNOWN,
	WL_DATA_SHORTTERM,
};

wlevel_get(struct wlevel *wl, enum characteristics ch);
...
wlevel_destroy(struct wlevel *wl);

I do not hope that throwing this topic into the discussion might lead to
more itzi-bitsi-ness, and obsolete interfaces in the code (which were
just removed), but it might be worth a discussion on the side, to
explore if there are other people trying to solve similar problems like
we try here for the FLASH example, and if a common approach for this
problem makes sense or not - and of course if so how it could look like.

Regards,

Frank

