Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXHBQFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXHBQFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbXHBQFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:05:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:36786 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXHBQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:05:44 -0400
Date: Thu, 2 Aug 2007 12:05:36 -0400
To: Jeff Layton <jlayton@redhat.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Stefan Walter <stefan.walter@inf.ethz.ch>
Subject: Re: [NFS] rpc.mountd crashes when extensively using netgroups
Message-ID: <20070802160536.GF21282@fieldses.org>
References: <46ADDFB2.9070709@inf.ethz.ch> <20070731144824.GA15231@fieldses.org> <20070802113255.d686894c.jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802113255.d686894c.jlayton@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 11:32:55AM -0400, Jeff Layton wrote:
> On Tue, 31 Jul 2007 10:48:24 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > That's an interesting problem.  Thanks for the report!
> > 
> > I don't believe that long comma-delimited string actually has any
> > meaning to the kernel--as far as the kernel is concerned, it's just an
> > opaque object that will be passed back to mountd later (along with a
> > path name) to get export options.
> > 
> > So I suppose that string could be replaced by a hash, or maybe even just
> > by the ip address of the particular host--the disadvantage to the latter
> > being that it would require the kernel to keep a separate export for
> > each client address.
> 
> I started having a look at this today. The original patches that I
> proposed to clean up the rmtab a few months ago also eliminated this
> comma-delimited string. Neil had valid objections to it at the time,
> but if we switched to using the IP address as a cache key like Bruce
> describes then doing that becomes more reasonable.
> 
> The only downside I see is the one Bruce points out -- the size of
> the kernel export cache would increase. I don't have a feel for whether
> this is a show stopper, however.

Yeah, there might be some risk of solving that problem at the expense of
people with tons of clients all matching *.example.com.  The actual
export objects are actually pretty small--68 bytes, last I checked?
You'd also need two upcalls to mountd per client (for ip address and
export, as opposed to just ip address).  I don't know what other costs
there might be.

What about the idea of hashing the comma-delimited list and passing
that?  You'd want hash large enough to be collision-free--might as well
use some cryptographic hash, I guess, though it may be mild overkill.
Is there any reason why that wouldn't work?

Could you remind me what problems you were trying to fix with your rmtab
cleanup?

--b.
