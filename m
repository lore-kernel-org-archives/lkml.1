Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYFAAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYFAAjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYFAAjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:39:13 -0400
Received: from gw.goop.org ([64.81.55.164]:52492 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYFAAjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:39:12 -0400
Message-ID: <4841EF8B.3060800@goop.org>
Date: Sun, 01 Jun 2008 01:38:35 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the resume path
References: <c692f3a12da1e99a4a43.1212192095@localhost>	<4840B0C5.4020606@pobox.com>	<48411F70.5020100@goop.org>	<20080531025949.7c8b17bc.akpm@linux-foundation.org>	<4841240A.1000008@goop.org> <20080531164712.2788baf2.akpm@linux-foundation.org>
In-Reply-To: <20080531164712.2788baf2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 31 May 2008 11:10:18 +0100 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> Whether you should also add __GFP_HIGH to cause the page allocation to
>>> bite harder into the page reserves is unclear to me, sorry.
>>>   
>>>       
>> Well, if the allocation fails the machine is dead in the water, because 
>> it probably can't go on without its devices.  I think it's worth eating 
>> to the reserves to avoid that.  (I'll have a close look to only add it 
>> to allocations which are really unrecoverable if they fail.)
>>     
>
> OK.
>
> I don't actually have a clue what you're doing here.  Restoring a
> virtual machine from disk/network or something like that?
>   

More or less.  When you suspend the VM it gets disconnected from all its 
virtual devices.  When you resume - which may be after a migration to 
another machine - it reconnects to all its devices again.  These 
allocations are happening on the reconnection path, and so may happen 
before there's any underlying device to do IO to (in fact, they've been 
triggered by something trying to do IO, and the driver notices it has 
become disconnected and tries to reconnect itself).

> It might be appropriate to do a big memory-reclaim before starting the
> operation, along the lines of suspend-to-disk - go off and allocate
> (and possible pin) sufficient memroy for the entire operation before
> actually starting it?
>   

Not really.  Live migration - which is one instance of when this comes 
into play - is a very lightweight process from the guest VM's 
perspective, and may cause only ~100ms service interruption.  Doing a 
mass of reclaim/IO would be expensive by comparison.

Also, in general the drivers have to be prepared to deal with a 
disconnection from their devices at any moment (ie, they may 
spontaneously disconnect for no apparent reason), so there's no 
opportunity to prepare for it.

Maybe it would be possible to scurry away some preallocated memory for 
use if the main allocation fails, but that seems logically equivalent to 
dipping into the global emergency pool.

    J
