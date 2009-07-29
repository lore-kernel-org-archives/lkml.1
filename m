Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZG2QO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZG2QO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZG2QO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:14:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44358 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZG2QO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:14:57 -0400
Date: Wed, 29 Jul 2009 18:14:56 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
       Neil Brown <neilb@suse.de>
Subject: Why does __do_page_cache_readahead submit READ, not READA?
Message-ID: <20090729161456.GB8059@barkeeper1-xen.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I naively assumed, from the "readahead" in the name, that readahead
would be submitting READA bios. It does not.

I recently did some statistics on how many READ and READA requests
we actually see on the block device level.
I was suprised that READA is basically only used for file system
internal meta data (and not even for all file systems),
but _never_ for file data.

A simple
	dd if=bigfile of=/dev/null bs=4k count=1
will absolutely cause readahead of the configured amount, no problem.
But on the block device level, these are READ requests, where I'd
expected them to be READA requests, based on the name.

This is because __do_page_cache_readahead() calls read_pages(),
which in turn is mapping->a_ops->readpages(), or, as fallback,
mapping->a_ops->readpage().

On that level, all variants end up submitting as READ.

This may even be intentional.
But if so, I'd like to understand that.

Please, anyone in the know, enlighten me ;)


	Lars

Annecdotical: I've seen an oracle being killed by OOM, because someone
did a grep -r . while accidentally having a bogusly huge readahead set.
