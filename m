Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbXHXPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbXHXPxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbXHXPxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:53:25 -0400
Received: from mail.fieldses.org ([66.93.2.214]:37852 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbXHXPxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:53:24 -0400
Date: Fri, 24 Aug 2007 11:53:17 -0400
To: Ric Wheeler <ric@emc.com>
Cc: John Stoffel <john@stoffel.org>, Peter Staubach <staubach@redhat.com>,
       Robin Lee Powell <rlpowell@digitalkingdom.org>,
       linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
Message-ID: <20070824155317.GC32175@fieldses.org>
References: <20070820225415.GL3956@digitalkingdom.org> <18123.5699.405125.137517@stoffel.org> <46CB1A78.7040102@redhat.com> <18123.13314.43009.263383@stoffel.org> <20070821192556.GB27995@fieldses.org> <46CEF49A.2050105@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CEF49A.2050105@emc.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:09:14AM -0400, Ric Wheeler wrote:
> J. Bruce Fields wrote:
>> The NFS server alone can't prevent the problems Peter Staubach refers
>> to.  Their frequency also depends on the network and the way you're
>> using the filesystem.  (A sufficiently paranoid application accessing
>> the filesystem could function correctly despite the problems caused by
>> soft mounts, but the degree of paranoia required probably isn't common.)
>>   
> Would it be sufficient to insure that that application always issues an 
> fsync() before closing any recently written/updated file? Is there some 
> other subtle paranoid techniques that should be used?

NFS already syncs on close (and on unlock), so you should just need to
check the return values from any writes, fsyncs, closes, etc. (and
realize that an error there may mean some or all of the previous writes
to this file descriptor failed).  And operations like mkdir have the
same problem--a timeout leaves you not knowing whether the directory was
created, because you don't know whether the operation reached the server
or not.

I assume the problems with executables that Peter Staubach refers to are
due to reads on mmap'd files timing out.

I don't use soft mounts myself and haven't had to debug user problems
with them, so my understanding of it all is purely theoretical--others
will have a better idea when and how these kinds of failures actually
manifest themselves in practice.

--b.
