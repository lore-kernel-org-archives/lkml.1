Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYAKPaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYAKPaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYAKP36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:29:58 -0500
Received: from as3.cineca.com ([130.186.84.211]:56188 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759059AbYAKP35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:29:57 -0500
Message-ID: <47878B68.5070806@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bill Davidsen <davidsen@tmr.com>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net>	 <4786CB57.9060000@tmr.com>  <478744D7.2070802@users.sourceforge.net> <1200061259.29498.64.camel@twins>
In-Reply-To: <1200061259.29498.64.camel@twins>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jan 2008 16:29:44 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>
>> Anyway, I'm wondering if it's possible (and how) to already do this with
>> process containers...
> 
> I think there is an IO controller somewhere based on CFQ.
> 
> I don't like this patch, because it throttles requests/s, and that
> doesn't say much. If a task would generate a very seeky load it could
> still tie up the disk even with a relatively low setting.
> 

Very true. A seeky intensive process wouldn't be limited at all. And I'm
sure there're better ways/models to satisfy my needs.

A suggestion (off-list) has been to try with ionice that seems to be the
right solution to limit the I/O activity of single processes, but it
doens't allow to define policies based on UIDs or GIDs.

BTW I don't have any number to compare the effectiveness of the priority
approach vs the throttling approach. Here is a very quick test made on
my PC (not sure if glxgears is the right benchmark to evaluate
the system responsiveness):

>>>>>> starting: glxgears <<<<<<
3564 frames in 5.0 seconds = 711.722 FPS
3953 frames in 5.0 seconds = 790.598 FPS
3969 frames in 5.0 seconds = 793.794 FPS
>>>>>> starting: md5sum /usr/lib/* <<<<<<
3769 frames in 5.0 seconds = 753.189 FPS
2877 frames in 5.0 seconds = 572.843 FPS
3481 frames in 5.0 seconds = 696.071 FPS
3775 frames in 5.0 seconds = 751.404 FPS
2781 frames in 5.0 seconds = 556.118 FPS
3209 frames in 5.0 seconds = 641.064 FPS
2843 frames in 5.0 seconds = 565.697 FPS
>>>>>> starting: echo 100 > /proc/`pidof md5sum`/io_throttle <<<<<<
3652 frames in 5.0 seconds = 730.253 FPS
3669 frames in 5.0 seconds = 733.734 FPS
3797 frames in 5.0 seconds = 759.234 FPS
3883 frames in 5.0 seconds = 776.488 FPS
3895 frames in 5.0 seconds = 778.868 FPS
3845 frames in 5.0 seconds = 768.968 FPS
3829 frames in 5.0 seconds = 765.793 FPS

>>>>>> flush caches (/proc/sys/vm/drop_caches) <<<<<<

>>>>>> starting: glxgears <<<<<<
3763 frames in 5.0 seconds = 752.539 FPS
3818 frames in 5.0 seconds = 763.483 FPS
>>>>>> starting: ionice -c3 md5sum /usr/lib/* <<<<<<
3443 frames in 5.0 seconds = 688.597 FPS
3202 frames in 5.0 seconds = 640.390 FPS
3807 frames in 5.0 seconds = 761.391 FPS
3053 frames in 5.0 seconds = 610.539 FPS
2759 frames in 5.0 seconds = 551.790 FPS
2975 frames in 5.0 seconds = 594.873 FPS
2993 frames in 5.0 seconds = 596.709 FPS
3250 frames in 5.0 seconds = 649.857 FPS
3494 frames in 5.0 seconds = 698.688 FPS

-Andrea
