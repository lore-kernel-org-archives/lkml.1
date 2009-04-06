Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZDFUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZDFUNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZDFUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:13:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbZDFUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:13:38 -0400
Date: Mon, 6 Apr 2009 13:10:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904061300310.6058@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu>
 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Linus Torvalds wrote:
> 
> Yes. I want to go back and see how much this all helps for the 
> data=ordered case (if at all), but I think we should at least consider 
> trying 'data=writeback' as a default.

Hmm.

So I'm back to "data=ordered", and quite frankly, so far it's a horrible 
experience. 

The difference is rather startlingly huge, which it was _not_ before. 

Sure, data=writeback was better before too, but in the end, the difference 
between the occasional 5+ second pause and the occasional 10+ second pause 
wasn't really all that interesting. They were both unusuable, and both 
made me kill the background writer almost immediately.

This time I really forced myself to keep it around, just to get the whole 
horridness of the experience.

Here's wahat I just got from data=writeback and all the latest patches 
(which includes one extra experimental one from Jens to further improve on 
things):

        fsync(6)                                = 0 <0.839397>
        fsync(6)                                = 0 <0.879706>
        fsync(6)                                = 0 <0.240856>
        fsync(6)                                = 0 <0.006497>
        fsync(6)                                = 0 <0.207197>
        fsync(4)                                = 0 <0.318396>
        fsync(4)                                = 0 <0.044499>
        fsync(4)                                = 0 <0.088381>
        fsync(6)                                = 0 <0.001057>
        fsync(9)                                = 0 <0.245389>
        fsync(7)                                = 0 <0.042728>
        fsync(7)                                = 0 <1.148262>
        fsync(6)                                = 0 <0.200707>
        fsync(6)                                = 0 <0.045259>
        fsync(6)                                = 0 <0.111846>

that's all quite usable. Stuttering, yes, but never anything feeling rally 
bad, or like something died.

This is with data=ordered on the same kernel:

	fsync(5)                                = 0 <0.000949>
	fsync(8)                                = 0 <19.674681>
	fsync(8)                                = 0 <1.169357>
	fsync(8)                                = 0 <17.994631>
	fsync(8)                                = 0 <5.711143>
	fsync(8)                                = 0 <4.759515>
	fsync(4)                                = 0 <17.283171>
	fsync(4)                                = 0 <4.371930>
	fsync(4)                                = 0 <0.008327>
	fsync(8)                                = 0 <0.000636>
	fsync(11)                               = 0 <9.802027>
	fsync(9)                                = 0 <14.109262>
	fsync(9)                                = 0 <4.081919>
	fsync(8)                                = 0 <0.000490>
	fsync(8)                                = 0 <0.001588>
	fsync(11)                               = 0 <18.822826>
	fsync(9)                                = 0 <3.917717>
	fsync(9)                                = 0 <0.001035>
	fsync(8)                                = 0 <0.000138>
	fsync(9)                                = 0 <17.466156>

where basically each 'sync' on the big file triggers that 15-20s total 
failure. I do wonder if it's actually gotten _worse_ for the data=ordered 
case, but at the same time it does make a pretty compelling argument for 
switching the defaults around.

			Linus
