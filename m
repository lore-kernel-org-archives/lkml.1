Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYAKSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYAKSRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761683AbYAKSRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:17:31 -0500
Received: from phunq.net ([64.81.85.152]:53758 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761555AbYAKSR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:17:29 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
Date: Fri, 11 Jan 2008 10:17:28 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org
References: <20080109085231.GE6650@kernel.dk>
In-Reply-To: <20080109085231.GE6650@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801111017.28753.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This looks really useful.

On Wednesday 09 January 2008 00:52, Jens Axboe wrote:
> Disadvantages:
>
> - The file block mappings must not change while loop is using the
> file. This means that we have to ensure exclusive access to the file
> and this is the bit that is currently missing in the implementation.
> It would be nice if we could just do this via open(), ideas
> welcome... 

Get_block methods are pretty fast and you have caching in the level 
above you, so you might be able to get away with no cache of physical 
addresses at all, in which case you just need i_mutex and i_alloc_sem 
at get_block time.  This would save a pile of code and still have the 
main benefit of avoiding double caching.

If you use ->get_block instead of bmap, it will fill in file holes for 
you, but of course get_block is not exposed, and Al is likely to bark 
at anyone who exposes it.

Instead of exposing get_block you could expose an aops method 
like ->bio_transfer that would hide the use of *_get_block in a library 
routine, just as __blockdev_direct_IO does.  Chances are, there are 
other users besides loop that would be interested in a generic way of 
performing bio transfers to files.

I presume you would fall back to the existing approach for any 
filesystem without get_block.  You could handle this transparently with 
a default library method that does read/write.

Regards,

Daniel
