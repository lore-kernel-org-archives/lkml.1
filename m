Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYCSX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYCSX6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936416AbYCSWpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:45:22 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:60527 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936423AbYCSWpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oPEiulCo8yZ+7bUxXicfA4K3D0+kbvqLoIOjWgMOwfGRNQ7pLTChNlKMuh92/EFgHzoM3HZG9HEc2lRLz4CuJzax6sphxGG+QpNB5+EKpXtxkir4i3/veEjsnQQjxQytvw09lfzaCjyot3KcWIS6yHw9QCa6FfIO2CGxIRiaBGc=
Message-ID: <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
Date: Wed, 19 Mar 2008 15:45:16 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080319020440.80379d50.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318209.039112899@firstfloor.org>
	 <20080318003620.d84efb95.akpm@linux-foundation.org>
	 <20080318141828.GD11966@one.firstfloor.org>
	 <20080318095715.27120788.akpm@linux-foundation.org>
	 <20080318172045.GI11966@one.firstfloor.org>
	 <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319083228.GM11966@one.firstfloor.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 2:04 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  The requirement to write to an executable sounds like a bit of a
>  showstopper.

Agreed.  In addition, it makes all kinds of tools misbehave.  I can
see extensions to the ELF format and those would require relinking
binaries, but without this you create chaos.  ELF is so nice because
it describes the entire file and we can handle everything according to
rules.  If you just somehow magically patch some new data structure in
this will break things.

Furthermore, by adding all this data to the end of the file you'll
normally create unnecessary costs.  The parts of the binaries which
are used at runtime start at the front.  At the end there might be a
lot of data which isn't needed at runtime and is therefore normally
not read.


>  if it proves useful, build it all into libc..

I could see that.  But to handle it efficiently kernel support is
needed.  Especially since I don't think the currently proposed
"learning mode" is adequate.  Over many uses of a program all kinds of
pages will be needed.  Far more than in most cases.  The prefetching
should really only cover the commonly used code paths in the program.
If you pull in everything, this will have advantages if you have that
much page cache to spare.  In that case just prefetching the entire
file is even easier.  No, such an improved method has to be more
selective.

But if we're selective in the loading of the pages we'll
(unfortunately) end up with holes.  Possibly many of them.  This would
mean with today's interfaces a large number of madvise() calls.  What
would be needed is kernel support which takes a bitmap, each bit
representing a page.  This bitmap could be allocated as part of the
binary by the linker.  With appropriate ELF data structures supporting
it so that strip et.al won't stumble.  To fill in the bitmaps one can
have separate a separate tool which is explicitly asked to update the
bitmap data. To collect the page fault data one could use systemtap.
It's easy enough to write a script which monitors the minor page
faults for each binary and writes the data into a file.  The binary
update tool and can use the information from that file to generate the
bitmap.
