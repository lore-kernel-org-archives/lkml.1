Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDCCW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDCCW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 22:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZDCCWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 22:22:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZDCCWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 22:22:50 -0400
Message-ID: <49D572E5.4040306@redhat.com>
Date: Thu, 02 Apr 2009 22:22:29 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
References: <200903291224.21380.info@gnebu.es> <200904030535.00335.nickpiggin@yahoo.com.au> <20090402183834.GB4773@srcf.ucam.org> <200904030556.41270.nickpiggin@yahoo.com.au>
In-Reply-To: <200904030556.41270.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Friday 03 April 2009 05:38:34 Matthew Garrett wrote:
>   
>> On Fri, Apr 03, 2009 at 05:34:59AM +1100, Nick Piggin wrote:
>>
>>     
>>> Shouldn't applications have a mode to avoid spinning up the disk if it is
>>> so important?
>>>       
>> They do. It's called "Don't use fsync() unless your data needs to be on 
>> disk". I'm not sure why you'd ever want an application to be in anything 
>> but this mode.
>>
>>     
>
> Well you might decide you are willing to sacrifice timely storage of
> logs, or reducing backups in your editor or something. But obviously
> the kernel can't decide which of those fsyncs is safe to omit (or
> turn into a barrier) while staying within the advertised semantics of
> the app. Application obviously can.
>
>   
One thing that you can do at the application level is to try and batch 
up your fsync() requests -  running one fsync (especially on the most 
recently written file) can take down the earlier files with it.

Clearly, this does require some application level complexity, but you 
get the same strong fsync() semantics that you are used to and can run 
almost at non-fsync speeds if the batch size is large enough. Your 
application should not acknowledge it has safely stored any of the files 
locally until it has done an fsync on that particular file.

This technique would work great for an application like rsync, tar, etc. 
For a mail client, you would see a benefit only when you were pulling 
down batches of messages which clearly is a common case if you are still 
reading this thread :-)

The fs_mark program I wrote plays around with the various ways to do 
this if someone is interested in playing around a bit,

Ric

