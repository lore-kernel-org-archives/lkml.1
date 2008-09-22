Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbYIVRE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbYIVRE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYIVRES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:04:18 -0400
Received: from quackingmoose.com ([63.73.180.143]:37718 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbYIVRER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:04:17 -0400
Date: Mon, 22 Sep 2008 10:04:14 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       Chuck Lever <chuck.lever@oracle.com>, Neil Brown <neilb@suse.de>,
       Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [NFS] blocks of zeros (NULLs) in NFS files in kernels >= 2.6.20
Message-ID: <20080922170414.GC12483@merfinllc.com>
References: <20080905191939.GG22796@merfinllc.com> <56258A29-95D5-4A8C-A097-014B8FEDFB8F@oracle.com> <20080911184951.GB19054@merfinllc.com> <200809221805.48463.hpj@urpla.net> <1222101322.7615.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222101322.7615.6.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sep 22 12:35 PM, Trond Myklebust wrote:
> Revert _what_ exactly?

Yep.  I narrowed the problem down to an offending hunk in a particular
patch.  Removing that hunk did eliminate the problem.   However,
reverting that hunk is likely wrong and the code has changed _a lot_
since that commit.

> My understanding was that this is a consequence of unordered writes
> causing the file to be extended while some other task is reading.

Yes.  I added some debugging statements to look at the writeout path.  

I think the following happens:

  - page 0 gets partially written to by app
  - VM writes out partial dirty page 0
  - page 0 gets fully written by app
  - page 1 gets partially written by app
  - VM writes out dirty page 1

  At this point there is a hole in the file.  The tail end of page 0 is
still not written to server.

  - VM writes out dirty page 0
  ...

> AFAICS, this sort of behaviour has _always_ been possible. I can't see
> how reverting anything will fix it.

Here is the crux.  It was possible previously but unlikely e.g. our app
never saw this behavior.  The new writeout semantics causes visible
holes in files often.

Anyway, I agree the new writeout semantics are allowed and possibly
saner than the previous writeout path.  The problem is that it is
__annoying__ for this use case (log files).

I'm not sure if there is an easy solution.  We want the VM to writeout
the address space in order.   Maybe we can start the scan for dirty
pages at the last page we wrote out i.e. page 0 in the example above?

					=a=



-- 
===================
Aaron Straus
aaron@merfinllc.com
