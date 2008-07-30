Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYG3Uqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYG3Uqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYG3Uqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:46:39 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39793 "EHLO
	pd2mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754240AbYG3Uqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:46:38 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=q2hyU374kmvBsQSO47wA:9 a=9YSO1XnrHuFxN602oF8CFCb2YykA:4 a=63hpme_HZ7UA:10 a=3AIdeF-xgCkA:10
Message-ID: <4890D329.80106@shaw.ca>
Date: Wed, 30 Jul 2008 14:46:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>, Alan Stern <stern@rowland.harvard.edu>,
       usb-storage@lists.one-eyed-alien.net, Tomas Styblo <tripie@cpan.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] JMicron JM20337 USB-SATA data corruption
 bugfix - device 152d:2338
References: <Pine.LNX.4.44L0.0807232337110.25883-100000@netrider.rowland.org> <4890C72D.7040604@shaw.ca> <20080730200033.GD7578@one-eyed-alien.net>
In-Reply-To: <20080730200033.GD7578@one-eyed-alien.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Wed, Jul 30, 2008 at 01:55:25PM -0600, Robert Hancock wrote:
>> Alan Stern wrote:
>>> On Wed, 23 Jul 2008, Robert Hancock wrote:
>>>
>>>> It remains an issue, though, that if there's no underflow, if the device 
>>>> reports an error in the CSW but doesn't provide sense data, we assume 
>>>> nothing bad happened and don't retry. That definitely does not seem 
>>>> correct. The device is not supposed to do this, but with how crappily 
>>>> some of these devices are designed we should be more defensive.
>>> The problem is, what can you do?  The device has said that something 
>>> was wrong, but it hasn't told you what.  Without knowing what went 
>>> wrong, you can't know how to recover.
> 
> Yes and no.  If ASC/ASCQ is clear, then it's telling you that nothing is
> wrong.  The device is contradicting itself. That doesn't really help us
> here, but it's a point I like to be clear on.
> 
>>> I suppose in such cases we could simply report that the command failed
>>> completely.
>> I think that is what we need to do. The SCSI/block layers should retry 
>> the command or report a failure to userspace. Above all else we can't 
>> just continue on our merry way and assume success, otherwise data will 
>> get silently corrupted.
> 
> The code path to supress the reporting of an error when auto-sense shows no
> ASC/ASCQ was added for a reason.  That reason has likely been lost to time,
> but I worry about devices that are out there that rely on the current
> behavior to function properly....

My original comment was that that code should be removed, but this is 
incorrect. In fact that code path is unrelated to this problem since it 
only executes if no transport error was detected. This code path is 
needed since retrieving sense data is done for multiple reasons other 
than a transport failure. For one, "If we're running the CB transport, 
which is incapable of determining status on its own, we will auto-sense 
unless the operation involved a data-in transfer." In this case, for a 
successful transfer the status must be reset to good after getting the 
sense data.

In the case in question here, the BOT transport reports a failure, and 
we retrieve sense data, but the sense data doesn't indicate an error. 
This results in the failure essentially being ignored. In this case I 
think we should be doing the same thing as we do on detecting an underflow:

srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);


