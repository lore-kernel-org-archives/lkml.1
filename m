Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXF0MUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXF0MUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXF0MTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:19:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46183 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXF0MTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:19:50 -0400
Date: Wed, 27 Jun 2007 13:19:48 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Neil Booth <neil@daikokuya.co.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627121948.GN21478@ftp.linux.org.uk>
References: <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070626233226.GO7590@daikokuya.co.uk> <20070627001803.GJ21478@ftp.linux.org.uk> <20070627115245.GP7590@daikokuya.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627115245.GP7590@daikokuya.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 08:52:45PM +0900, Neil Booth wrote:
> Al Viro wrote:-
> 
> > 
> > sparse simply doesn't check that.  We don't have anything resembling
> > support of VLA.  Note that check for integer constant expression
> > has nothing to do with that;
> > 
> > 	int x[(int)(0.6 + 0.6)];
> > 
> > is valid (if stupid).
> 
> It isn't valid; it fails the test twice.  Both 0.6 are not "immediate
> operands of casts".  Their sum is, but that's irrelevant.
> Therefore the dimension is not an ICE and a diagnostic is required.

Egads...  After rereading that...  What a mess.

int foo(void)
{
	static int a[1][0,2];
}

is, AFAICS, allowed.  Reason:
	int a[0,2]
is a VLA due to 6.7.5.2[4] (0,2 is not an ICE).  However, due to the language
in the same section,
	int a[1][0,2]
is *not* a VLA, since (a) 2 is an ICE and (b) its element type "has a known
constant size" (it does - the value of 0,2 is certainly guaranteed to be 2).
I.e., it's VM type, but not a VLA.  I.e. only the first part of 6.7.5.2[2]
applies and we are actually fine.

	So we can have a static single-element array of int [0,2], but
not a plain static int [0,2].  Lovely, that...
