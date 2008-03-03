Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYCCR7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYCCR7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbYCCR6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:58:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47271 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYCCR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:58:42 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC3C48.1020306@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 18:58:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>	 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>	 <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>	 <47CC2C95.1050205@s5r6.in-berlin.de> <59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com>
In-Reply-To: <59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> On Mon, Mar 3, 2008 at 11:51 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
> ...
>>  Maybe I should rather use fw-device.c::idr_rwsem instead of device.sem,
>>  to have better control over who takes the mutex when.  Could also be a
>>  new dedicated mutex but we don't want to end up with too many of them...
>>  Do you have an opinion?
> 
> Using the struct device mutex is fine, and it parallelizes better than
> the global idr_mutex (FWIW).  The only concern I have there is that
> the device core structs seem to change now and then, and it's not
> clear what is implementation details and what is exported for drivers
> to use (eg the subsystem sem).

This may be more of a concern to anybody who wanted to change the driver 
core internals and might be unsure what to do with those three dev->sem 
taking sites which I added; not so much a concern from the firewire 
driver maintenance POV.

OTOH, contention for idr_rwsem is low and there can be multiple readers 
of course.  The most time consuming thing that could happen would be 
waiting for GFP_KERNEL allocations of new IDR tree leaves.  And maybe 
having the dev->sem in a cacheline but idr_rwsem not is probably not a 
concern for the stuff that the writer and the two readers of the ROM 
cache do.

Ah, wait, there is a 3rd reader: sbp2_probe's sbp2_scan_unit_dir.  So, 
using dev->sem is actually the nicest way for now.
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
