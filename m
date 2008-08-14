Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbYHNJrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbYHNJrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHNJq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:46:59 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:58138 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYHNJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:46:58 -0400
In-Reply-To: <1218653864.3540.109.camel@localhost.localdomain>
To: Eric Paris <eparis@redhat.com>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Thu, 14 Aug 2008 10:46:55 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:46:55,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 14/08/2008 10:46:55,
	Serialize complete at 14/08/2008 10:46:55,
	S/MIME Sign failed at 14/08/2008 10:46:55: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 14/08/2008 10:46:56,
	Serialize complete at 14/08/2008 10:46:56
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080814094701.A65372FE89E@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote on 13/08/2008 19:57:44:

> > It's clear from the protection model that you described that on 'read'
> > you want to wait until the scan is done before you give the data to 
the
> > process asking for it... and that's totally reasonable: "Do not give
> > out bad data" is a very clear line in terms of security.
> > 
> > for the "dirty" case it gets muddy. You clearly want to scan "some
> > time" after the write, from the principle of getting rid of malware
> > that's on the disk, but it's unclear if this HAS to be synchronous.
> > (obviously, synchronous behavior hurts performance bigtime so lets do
> > as little as we can of that without hurting the protection).
> > One advantage of doing the dirty case async (and a little time 
delayed)
> > is that repeated writes will get lumped up into one scan in practice,
> > saving a ton of performance.
> > (scan-on-close is just another way of implementing "delay the dirty
> > scan").
> > Based on Alans comments, to me this sounds like we should have an
> > efficient mechanism to notify userspace of "dirty events"; this is not
> > virus scan specific in any way or form. And this mechanism likely will
> > need to allow multiple subscribers.
> 
> I'm certainly willing to go down the inotify'ish path for async
> notification of 'dirty' inodes instead of implement my own async
> mechanism if I can find a way to do it.

Do I understand correctly that everyone agrees scanning whenever an inode 
gets dirty would be a terrible thing for performance? 

Another thing we have here is that malware could not be neccessariliy 
identified until the very last write (one example where it will always be 
the case are PDF files (I think)).

So the whole question is at which point should be performing an async 
scan. Close seems like a natural point which should be ideal for majority 
of applications, I don't see how any time-based lumping/delaying scheme 
can be better than close?

> > for the open() case, I would argue that you don't need synchronous
> > behavior as long as the read() case is synchronous. I can imagine that
> > open() kicks off an async scan, and if it's done by the time the first
> > read() happens, no blocking at all happens.
> 
> An interesting addition.  Trying to keep these queues of events gets
> much more complex, but if people really think the open to read race is
> that important I've always said it wasn't impossible to close.

This really sounds pretty interesting. Not necessariliy so much as a 
performance optimisation, because I am not sure there are so many programs 
where first read comes long after the first open, but as closing the 
open-read race. 

Could the implementation be not so complicated after all? If we generated 
the same (roughly) event on reads and pass it for scanning if cache has 
been invalidated in the mean time? The only thing is this could be a big 
performance hit so some benchmarking might be in order depending on which 
the read hook could be made run-time optional.
 
--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

