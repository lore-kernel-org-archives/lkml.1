Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbXCPBZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbXCPBZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 21:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbXCPBZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 21:25:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38713 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753523AbXCPBZb (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 21:25:31 -0400
Date: Fri, 16 Mar 2007 12:25:20 +1100
From: David Chinner <dgc@sgi.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Message-ID: <20070316012520.GN5743@melbourne.sgi.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 12:34:29PM +0100, Marco Berizzi wrote:
> Hello everybody.
> Since 2.6.19.2 + commit 7fbbb01dca7704d52ace6f45a805c98a5b0362f9

What commit is that? gitweb search tells me it's an nmi watchdog
change. Doesn't seem likely to change XFS behaviour - can
you post a url to the commit?

> I'm experimenting these errors.
> 2.6.19.1 has been worked good for more
> than 30 days.

With the above commit?

> I have reverted back to 2.6.19.1 to see if
> this problem happens again.

without the above commit?

> find_or_create_page+0x37/0x8e
> _xfs_buf_lookup_pages+0x132/0x2ea
> _xfs_buf_initialize+0xc8/0xf6
> xfs_buf_get_flags+0xf8/0x11d
> xfs_buf_read_flags+0x1c/0x7f
> xfs_trans_read_buf+0x16a/0x34f
> xfs_itobp+0x7c/0x242
> xfs_iread+0x68/0x1d3
> xfs_iget_core+0xe7/0x687
> xfs_iget+0xd8/0x150
> xfs_dir_lookup_int+0x98/0x10e
> xfs_lookup+0x5a/0x90
> xfs_vn_lookup+0x52/0x93

Curious - never seen this before - possibly a corrupted inode
number in the directory has led to this.

> ba 4e 8b cd
> Mar 12 14:35:21 Pleiadi kernel: Filesystem "sda8": XFS internal error
> xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
> 0xc01b00bd
> Mar 12 14:35:21 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
> Mar 12 14:35:21 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
> Mar 12 14:35:21 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35

Hmm - these could simply be follow-on errors from the first
problem - the buffer would now probably be bad or corrupted,
and the directory buffer read code here is saying the buffer
is bad. All the errors appear to have thesame data in the buffer
(which is lacking the correct magic numbers) so i'd say they
are related to the above error.

Can you run xfs_repair on that filesystem and see if reports
(and fixes) any problems?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
