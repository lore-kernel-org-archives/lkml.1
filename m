Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYBZJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYBZJR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbYBZJQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:16:52 -0500
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:46528 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760986AbYBZJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:16:32 -0500
X-Yahoo-Newman-Id: 100115.67097.bm@omp401.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oynkkLVsD1xX1Ch37nJxXjgXaB90Q+JL5e7di+oSqV7FZu8zcwWzVqGwxzcoyGpEa+q+Hp1P1Dlzt3tfGJsGALq3a+xvaGBeb8/+x4S5ro/wIgcNjo9I4UF6fXBLmr13iIYXURMVJxD52IRW81vAHCSthAmd08YfZtOY8R+NlFk=  ;
X-YMail-OSG: b7cn0m4VM1nFxGdKJx8H55VdJwSbZ9w20820YSyfNS4feRFaAGoQvJYUnlgF_WMKr4_If5D3fg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Date: Tue, 26 Feb 2008 20:16:11 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org>
In-Reply-To: <20080226075921.GG30238@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802262016.11297.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 18:59, Jamie Lokier wrote:
> Andrew Morton wrote:
> > On Tue, 26 Feb 2008 07:26:50 +0000 Jamie Lokier <jamie@shareable.org> 
wrote:
> > > (It would be nicer if sync_file_range()
> > > took a vector of ranges for better elevator scheduling, but let's
> > > ignore that :-)
> >
> > Two passes:
> >
> > Pass 1: shove each of the segments into the queue with
> >         SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE
> >
> > Pass 2: wait for them all to complete and return accumulated result
> >         with SYNC_FILE_RANGE_WAIT_AFTER
>
> Thanks.
>
> Seems ok, though being able to cork the I/O until the last one would
> be a bonus (like TCP_MORE...  SYNC_FILE_RANGE_MORE?)
>
> I'm imagining I'd omit the SYNC_FILE_RANGE_WAIT_BEFORE.  Is there a
> reason why you have it there?  The man page isn't very enlightening.


Yeah, sync_file_range has slightly unusual semantics and introduce
the new concept, "writeout", to userspace (does "writeout" include
"in drive cache"? the kernel doesn't think so, but the only way to
make sync_file_range "safe" is if you do consider it writeout).

If it makes it any easier to understand, we can add in
SYNC_FILE_ASYNC, SYNC_FILE_SYNC parts that just deal with
safe/unsafe and sync/async semantics that is part of the normal
POSIX api.

Anyway, the idea of making fsync/fdatasync etc. safe by default is
a good idea IMO, and is a bad bug that we don't do that :(

