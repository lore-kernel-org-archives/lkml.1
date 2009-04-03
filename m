Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbZDCDJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbZDCDJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 23:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZDCDI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 23:08:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:56727 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbZDCDI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 23:08:56 -0400
Date: Thu, 2 Apr 2009 20:08:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090403013603.GA10886@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021954080.30587@asgard.lang.hm>
References: <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <20090402234617.GB9538@srcf.ucam.org>
 <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org> <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm>
 <20090403013603.GA10886@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 06:24:28PM -0700, david@lang.hm wrote:
>> On Fri, 3 Apr 2009, Matthew Garrett wrote:
>>> No it wouldn't. The kernel would be implementing an adminstrator's
>>> choice about whether fsync() is important or not. That's something that
>>> would affect the mail client, but it's hardly a decision based on the
>>> mail client. Sucks to be that user if they do anything involving mysql.
>>
>> in the case of laptops, in 99+% of the cases the user and the
>> administrator are the same person. in the other cases that's something the
>> user should take up with the administrator, because the administrator can
>> do a lot of things to the system that will affect the safety of their data
>> (including loading a kernel that turns fsync into a noop, but more likely
>> involving enabling or disabling write caches on disks)
>
> Well, yes, the administrator could hate the user. They could achieve the
> same affect by just LD_PRELOADING something that stubbed out fsync() and
> inserted random data into every other write(). We generally trust that
> admins won't do that.

then trust the admins to make a reasonable decision for or with the user 
on this as well.

>>> Benchmarks please.
>>
>> if spinning down a drive saves so little power that it wouldn't make a
>> significant difference to battery lift to leave it on, why does anyone
>> bother to spin the drive down?
>
> There's various circumstances in which it's beneficial. The difference
> between an optimal algorithm for typical use and an optimal algorithm
> for typical use where there's an fsync() every 5 minutes isn't actually
> that great.

mixing some sub-threads a bit to combine thoughts

you object to calling something like this 'laptop mode'

Ted's statements about laptop mode indicate that he believes that it 
delays writes for a configurable time rather than accelerating writes.

what would you think of something like the following

at the block device level an option called something like "delay_writes"

delays writes (including fsync) up to the configurable number of seconds.

if an fsync or barrier is issued the block driver figures out what pages 
would be written by that fsync/barrier, puts them in it's queue (but 
doesn't start the write), puts a barrier in it's queue following the pages 
and marks the pages COW.

if the timeout expires (or the drive spins up for other reasons) and the 
pages have not been modified, they get written and released by the block 
driver (which should take them out of COW mode).

if the pages get written to prior to the write taking place, COW kicks in 
and new pages are allocated for the changes. since the device driver 
already has those pages queued the filesystem just ends up with the copied 
pages and continues operation. when the drive finally gets spun up, the 
queued pages get written prior to anything else (preserving order in case 
of a crash)

doing this could cost memory (as there may be multiple copies of something 
queued), so it may be worth having some trigger that if more than X pages 
are queued by the block driver, it should go ahead and spin up the drive 
to write them.

thoughts?

David Lang
