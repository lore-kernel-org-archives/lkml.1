Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZCCAi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZCCAi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZCCAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:38:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:64314 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZCCAiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nLFbW6Akrc/bT6i1mARFPksTXHNQRoAR/tsuy1/rGMggdR48VSjrXE0rHan9yl4oBX
         cCeSbW25i/96Hrgw+9MsimoatgWYG5RAky2pWu7ujeEFuS41GGMvi5wPdbQvxJH6iRKY
         kS0XPoTJvBD0WhUe8Lk6G3HX0Ja+TgYGkkn6c=
Subject: Re: [PATCH 2/2] unaligned: add load/store_{endian}_noalign API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <alpine.LFD.2.00.0903021616440.3111@localhost.localdomain>
References: <1236038818.5756.12.camel@brick>
	 <alpine.LFD.2.00.0903021616440.3111@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:38:10 -0800
Message-Id: <1236040690.5756.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:18 -0800, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Harvey Harrison wrote:
> >
> > Add a typed API with the usual argument ordering and use load/store,
> > this API is also consistent with the aligned versions.
> 
> This naming is horrible. It doesn't match the normal pattern we have in 
> the kernel. 
> 
> Why not just try to fix the current (well-named) "get_unaligned_le16()" 
> problems, instead of introducing a new (and badly named) version of them.
> 
> So NAK on both of these.

Well, the current API can be made typesafe, and then the sparse fallout
can be fixed...I introduced the new API to make it opt-in and then
phase out the old API over time to avoid that.  As I already had a new
API, 'fixing' the argument order was doable as well.  Comments from AKPM
made me drop the get/put name as well, and load/store seemed the most
natural replacement.

The other reason was currently we have:

Aligned:
le16_to_cpup

Unaligned:
get_unaligned_le16
put_unaligned_le16

And although the le16_to_cpup is at worst the same as le16_to_cpu(*p) it
is more efficient on arches like powerpc and sparc that have a load-swap
instruction...but few people use it because of the goofy name.  Same goes
for the get/put_unaligned, people don't use them and just open-code the
byteswapping whenever there is going to be unaligned access.

So I was hoping to make it easier/more obvious to use as well.

Aligned:
load_le16
store_le16

Unaligned (which degrades to aligned on arches without alignment restrictions)
load_le16_noalign
store_le16_noalign

Cheers,

Harvey

