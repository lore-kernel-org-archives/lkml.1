Return-Path: <linux-kernel-owner+w=401wt.eu-S1764180AbYBZRzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180AbYBZRzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762437AbYBZRy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:54:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55051 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbYBZRy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:54:57 -0500
Message-ID: <47C45267.4090105@garzik.org>
Date: Tue, 26 Feb 2008 12:54:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <47C441C1.5060305@garzik.org> <20080226170011.GB21203@shareable.org>
In-Reply-To: <20080226170011.GB21203@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Jeff Garzik wrote:
>> Nick Piggin wrote:
>>> Anyway, the idea of making fsync/fdatasync etc. safe by default is
>>> a good idea IMO, and is a bad bug that we don't do that :(
>> Agreed...  it's also disappointing that [unless I'm mistaken] you have 
>> to hack each filesystem to support barriers.
>>
>> It seems far easier to make sync_blkdev() Do The Right Thing, and 
>> magically make all filesystems data-safe.
> 
> Well, you need ordered metadata writes, barriers _and_ flushes with
> some filesystems.
> 
> Merely writing all the data pages than issuing a drive cache flush
> won't Do The Right Thing with those filesystems - someone already
> mentioned Btrfs, where it won't.

Oh certainly.  That's why we have a VFS :)  fsync for NFS will look 
quite different, too.


> But I agree that your suggestion would make a superb default, for
> filesystems which don't provide their own function.

Yep.  That would immediately cover a bunch of filesystems.


> It's not optimal even then.
> 
>   Devices: On a software RAID, you ideally don't want to issue flushes
>   to all drives if your database did a 1 block commit entry.  (But they
>   probably use O_DIRECT anyway, changing the rules again).  But all that
>   can be optimised in generic VFS code eventually.  It doesn't need
>   filesystem assistance in most cases.

My own idea is that we create a FLUSH command for blkdev request queues, 
to exist alongside READ, WRITE, and the current barrier implementation. 
  Then FLUSH could be passed down through MD or DM.

	Jeff


