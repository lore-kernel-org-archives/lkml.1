Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYESAou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYESAou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbYESAoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:44:39 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61233 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbYESAoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:44:37 -0400
Date: Sun, 18 May 2008 20:43:25 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080519004325.GC8335@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, Eric Sandeen <sandeen@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516220315.GB15334@shareable.org> <482E08E6.4030507@redhat.com> <8763tbcrbo.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763tbcrbo.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 10:03:55PM +0200, Andi Kleen wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> >
> > Right, that was the plan.  I wasn't really going to stand there and pull
> > the plug.  :)  I'd like to get to "out of $NUMBER power-loss events
> > under this usage, I saw $THIS corruption $THISMANY times ..."
> 
> I'm not sure how good such exact numbers would do. Surely power down
> behaviour that would depend on the exact disk/controller/system
> combination? Some might be better at getting data out at 
> power less, some might be worse.

Given how rarely people have reported problems, I think it's a really
good idea to understand what exactly our exposure is for
$COMMON_HARDWARE.  And I suspect the biggest question isn't the
hardware, but the workload.  Here are the questions that I think are
worth asking:

* How often can we get corruption on a common desktop workload?  Given
  that we're mostly kernel developers, and kernbench is probably worst
  case for desktops, that's useful.

* What is the performance hit on a common desktop workload (let's use
  kernbench for consistency).

* How often can we get corruption on a hard-core enterprise
  application with lots of fsync()'s?   (i.e., postmark, et. al)

* What is the performance hit on a an fsync()-heavy workload?

I have a feeling that the likelihood of corruption when running
kernbench is minimal, but the performance hit is probably minimal as
well.  And that the corruption for potential is higher for an
fsync-heavy workload, but that's also where we are seeing the
(reported) 30% hit.

The other thing which we should consider is that I suspect we can do
much better for ext4 given that we have journal checksums.  As Chris
pointed out, right now, with barriers turned on, we are doing this:

write log blocks
flush #1
write commit block
flush #2
write metadata blocks

If we don't mind mixing bh and bio functions, we could change it to
this for ext4 (when journal checksumming is enabled)

write log blocks
write commit block
flush (via submitting an empty barrier block I/O request)
write metadata blocks

This should hopefully reduce the performance hit by half, since we're
eliminating one of the flushes.  Even more interesting would be moving
the flush until right before we attempt to write the metadata blocks,
and allowing data writes which don't require metadata updates through.
That should be safe, even in data=ordered mode.  The point is we
should think about ways that we can optimize barrier mode for ext4.
If we do this, then it may be that people will find it interesting to
mount ext3 filesystems using ext4, even without making any additional
changes, because of the better choices of speed/safety tradeoffs.

							- Ted
