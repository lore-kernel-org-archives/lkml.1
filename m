Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYHVDYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYHVDYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 23:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHVDX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 23:23:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:12316 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYHVDX5 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 23:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p1g6zCZGEq9pwEYCXIJ7spp387Vwi+Zmwh32J6gWLG80u2z0E4Cg5eOTphzFAXaKYQ
         2kzL8Z0qHAWRK36zTjEPRRS08PWp3CkVl3kIGN5id93pUWV7tSMeaYBL2w8SihiWOMBU
         W1+6oWC479ZF2yo8crLBsawASWHeZCjMzY3us=
Message-ID: <6934efce0808212023x758babf0w500da6801bd66f45@mail.gmail.com>
Date: Thu, 21 Aug 2008 20:23:55 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Cc: "Arnd Bergmann" <arnd@arndb.de>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AE22F5.3000309@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de>
	 <48AE22F5.3000309@lougher.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Squashfs has much larger block sizes than cramfs (last time I looked it was
> limited to 4K blocks), and it compresses the metadata which helps to get
> better compression.  But tail merging (fragments in Squashfs terminology) is
> obviously a major reason why Squashfs gets good compression.
>
> The AXFS code is rather obscure but it doesn't look to me that it does tail
> merging.  The following code wouldn't work if the block in question was a
> tail contained in a larger block.  It assumes the block extends to the end
> of the compressed block (cblk_size - cnode_offset).

A c_block is the unit that gets compressed.  It can contain multiple
c_nodes.  The c_block can be PAGE_SIZE to 4GB in size, in theory :)
The c_nodes can be 1B to PAGE_SIZE. in any alignment.  I pack many
tails as c_nodes in a c_block.

>>> +               max_len = cblk_size - cnode_offset;
>>> +               len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE :
>>> max_len;
>>> +               src = (void *)((unsigned long)cblk0 + cnode_offset);
>>> +               memcpy(pgdata, src, len);
>
> Perhaps the AXFS authors could clarify this?

The memcpy in question copies a c_node to the page.  The len is either
the max length of a c_node and size of the buffer I'm copying to
(PAGE_CACHE_SIZE) or it is the difference between the beginning of the
c_node in the c_block and the end of the c_block, whichever is
smaller.  The confusion is probably because of the fact that this
copies extra crap to the page for tails.
