Return-Path: <linux-kernel-owner+w=401wt.eu-S2993042AbXBQSZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993042AbXBQSZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993041AbXBQSZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:25:00 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:28739 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993028AbXBQSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:24:59 -0500
Message-ID: <45D74852.4070206@monatomic.org>
Date: Sat, 17 Feb 2007 20:24:18 +0200
From: Dan Aloni <da-x@monatomic.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] OOM and USB, latest Linux 2.6
References: <Pine.LNX.4.44L0.0702171156300.4173-100000@netrider.rowland.org> <45D7462D.6080700@monatomic.org>
In-Reply-To: <45D7462D.6080700@monatomic.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Aloni wrote:
> Alan Stern wrote:
[...]
>> Can you be any more specific than that?  usb-storage should use only 
>> GFP_NOIO in its I/O paths.
>>
>>
>>   
> You are right, I looked over this state with kdb, and usb-storage
> waited in usb_stor_bulk_transfer_sg, which does pass GFP_NOIO
> at this scenario.
>
> It looked suspicious though, because OOM handling was invoked
> from many processes, and it didn't print about any process being
> killed and it didn't complain about no processes to kill either.
Hmm, I'm pretty sure I stomped over this (from select_bad_process()):

                /*
                 * This task already has access to memory reserves and is
                 * being killed. Don't allow any other task access to the
                 * memory reserve.
                 *
                 * Note: this may have a chance of deadlock if it gets
                 * blocked waiting for another task which itself is waiting
                 * for memory. Is there a better alternative?
                 */
                if (test_tsk_thread_flag(p, TIF_MEMDIE))
                        return ERR_PTR(-1UL);

Which might explains why the OOM handling was behaving like it did.

It would have been nice if it at least printed "OOM: I'm in a deadlock,
please FIXME...".

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il

