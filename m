Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbYHLGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbYHLGIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYHLGIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:08:05 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:26655 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751163AbYHLGIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:08:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PZbvwprLBPQxkoQGYxY8IoFfykjbInCGDv0UmqHZmoeU23cCW6RXYLzCfVmVyuLpIvMdAhc3kQE7haj+FtfxaNKqBFku57TrxaW0RbRPOP9hRJ6eCete4XlIuGsZv6wzITnGrGFMdEB6830E/2cnhYP3FicTSlaHmPM4DIS8o1Y=  ;
X-YMail-OSG: 6pWe6iYVM1n8nffRZp4s8_0PTq0csljkFkfGMMhfZqLPmzB28Yx1cOWKK9DuGpuOXyra35W8i7Hlsq_KQtPMYcB7c80dzgNep.cLAiY7jLm7M.d.uoz2RTTtUMVLNEi21rc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for pagesize!=blocksize
Date: Tue, 12 Aug 2008 16:07:55 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       jack@ucw.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org> <200808041719.43293.nickpiggin@yahoo.com.au> <6.0.0.20.2.20080812113004.03c68f48@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20080812113004.03c68f48@172.19.0.2>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121607.55673.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 13:57, Hisashi Hifumi wrote:
> Hi Nick.
>
> >This patch unfortunately appears like it may introduce an
> >uninitialized memory leak due to a data race between one
> >thread initializing a buffer then marking it uptodate, and
> >the other testing buffer uptodate then reading from the
> >buffer (buffer, read as: page memory covered by buffer head).
> >
> >For reference, this is basically the same class of data race
> >that I fixed 0ed361dec36945f3116ee1338638ada9a8920905
>
> I think the same issue that your patch 0ed361dec36945f3116ee
> 1338638ada9a8920905 "fix PageUptodate data race" pointed out
> is there around buffer_head without my patch "vfs: pagecache usage
> optimization for pagesize!=blocksize".
> Because set_buffer_uptodate or buffer_uptodate are used without
> distinct locking facility (lock_buffer, or lock_page) in many places,
> so it would be needed to deal with memory ordering issue.

Right.


> Do you add wmb/rmb to BUFFER_FNS macros?

That would fix it, yes. But now the patch is no longer a single
predictable branch but will make the code measurably larger and
slower. On some architectures these can cost hundreds or thousands
of cycles.

So IMO it requires either more thought for a better fix, or we
now need more justification that we want to do this rather than
a artificial microbenchmark numbers.
