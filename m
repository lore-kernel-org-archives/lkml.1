Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbZDBCaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbZDBCaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZDBCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:30:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33072 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbZDBCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:30:43 -0400
Date: Thu, 2 Apr 2009 13:30:40 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: david@lang.hm
Cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
Message-ID: <20090402023040.GA20071@brong.net>
References: <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <gqr50k$4aq$1@ger.gmane.org> <alpine.DEB.1.10.0903311813390.28893@asgard.lang.hm> <49D3954A.9010309@tmr.com> <alpine.DEB.1.10.0904011311240.28893@asgard.lang.hm> <49D3DDBF.9060406@ursus.ath.cx> <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904011528100.28893@asgard.lang.hm>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 03:29:29PM -0700, david@lang.hm wrote:
> On Wed, 1 Apr 2009, Andreas T.Auer wrote:
>> On 01.04.2009 22:15 david@lang.hm wrote:
>>> except if another file in the directory gets modified while it's
>>> writing out the first two, that file now would need to get written out
>>> as well, before the metadata for that directory can be written. if you
>>> have a busy system (say a database or log server), where files are
>>> getting modified pretty constantly, it can be a long time before all
>>> the file data is written out and the system is idle enough to write
>>> the metadata.
>> Thank you, David, for this use case, but I think the problem could be
>> solved quite easily:
>>
>> At any write-out time, e.g. after collecting enough data for delayed
>> allocation or at fsync()
>>
>> 1) copy the metadata in memory, i.e. snapshot it
>> 2) write out the data corresponding to the metadata-snapshot
>> 3) write out the snapshot of the metadata
>>
>> In that way subsequent metadata changes should not interfere with the
>> metadata-update on disk.
>
> the problem with this approach is that the dcache has no provision for  
> there being two (or more) copies of the disk block in it's cache, adding  
> this would significantly complicate things (it was mentioned briefly a 
> few days ago in this thread)

It seems that it's obviously the "right way" to solve the problem
though.  How much does the dcache need to know about this "in flight"
block (ok, blocks - I can imagine a pathological case where there
were a stack of them all slightly different in the queue)?

You'd be basically reinventing MVCC-like database logic with
transactional commits at that point - so each fs "barrier" call
would COW all the affected pages and write them down to disk.

Bron.
