Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0BBSmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:42:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756779Ab0BBSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:42:12 -0500
Date: Tue, 2 Feb 2010 10:40:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Olivier Galibert <galibert@pobox.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after
 lseek()
In-Reply-To: <20100202181321.GB75577@dspnet.fr.eu.org>
Message-ID: <alpine.LFD.2.00.1002021037110.3664@localhost.localdomain>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com> <20100202181321.GB75577@dspnet.fr.eu.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Olivier Galibert wrote:
> 
> Wouldn't that trigger on lseeks to end of file to get the size?

Well, you'd only ever do that with a raw block device, no (if even that: 
more "raw block device" tools just use the BLKSIZE64 ioctl etc)? Any sane 
regular file accessor will do 'fstat()' instead.

And do we care about startup speed of ramping up read-ahead from the 
beginning? In fact, the problem case that caused this was literally 
'blkid' on a block device - and the fact that the kernel tried to 
read-ahead TOO MUCh rather than too little.

If somebody is really doing lots of serial reading, the read-ahead code 
will figure it out very quickly. The case this worries about is just the 
_first_ read, where the question is one of "do we think it might be 
seeking around, or does it look like the user is going to just read the 
whole thing"?

IOW, if you start off with a SEEK_END, I think it's reasonable to expect 
it to _not_ read the whole thing.

			Linus
