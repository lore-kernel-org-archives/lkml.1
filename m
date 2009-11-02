Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZKBP5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZKBP5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZKBP5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:57:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36970 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZKBP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:57:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AEF0144.3080505@s5r6.in-berlin.de>
Date: Mon, 02 Nov 2009 16:56:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Zubin Dittia <zubin@tintri.com>, linux-kernel@vger.kernel.org
Subject: Re: SSD read latency negatively impacted by large writes (independent
 of  choice of I/O scheduler)
References: <47c554d90910301621y1f19a96bx454f539adec1ae35@mail.gmail.com> <x49eiohqa06.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49eiohqa06.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Zubin Dittia <zubin@tintri.com> writes:
[...]
>> about 30 seconds after the write (which is when the write is
>> actually written back to the device from buffer cache), I see a very
>> large spike in read latency: from 200 microseconds to 25 milliseconds.
>>  This seems to imply that the writes issued by the scheduler are not
>> being broken up into sufficiently small chunks with interspersed
>> reads; instead, the whole sequential write seems to be getting issued
>> while starving reads during that period.
[...]
>> Playing around with different I/O
>> schedulers and parameters doesn't seem to help at all.
[...]
> I haven't verified your findings, but if what you state is true, then
> you could try tuning max_sectors_kb for your device.  Making that
> smaller will decrease the total amount of I/O that can be queued in the
> device at any given time.  There's always a trade-off between bandwidth
> and latency, of course.

Maximum transfer size per request is indeed one factor; another one is
queue_depth.  With a deep queue, a read request between many write
requests will still be held up by many write requests queued up before
the read request.  (Once the scheduler issued the requests to the queue,
it can't reorder the requests any more --- only the disk's firmware
could reorder the requests if it is sophisticated enough and there are
no barriers in the mix.)

When transfer size and queue depth are set different from the default,
the various I/O schedulers should be tested again because then their
behaviors may vary more than before.
-- 
Stefan Richter
-=====-==--= =-== ---=-
http://arcgraph.de/sr/
