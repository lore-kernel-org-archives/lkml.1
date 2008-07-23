Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYGWXUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYGWXUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYGWXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:20:31 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:54627 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754249AbYGWXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:20:30 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=bfuRuFIiRLqIYlRgT-sA:9 a=apjplFVTiPmexPCRahColFxIFscA:4 a=Gr1l-fY1kBQA:10 a=CDgK0yFw8z8A:10
Message-ID: <4887BCB9.2000103@shaw.ca>
Date: Wed, 23 Jul 2008 17:20:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Tomas Styblo <tripie@cpan.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
References: <Pine.LNX.4.44L0.0807222238060.12003-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0807222238060.12003-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> The system doesn't detect the first problem for two reasons: The
> scsi_eh_prep_cmnd routine fails to preserve scmd->underflow, and
> usb-storage fails to check for underflow when the device returns Check
> Condition status.  The Bugzilla report contains fixes for both of
> these, and they solve the problem.
> 
> The second problem is harder.  The device is supposed to send a STALL
> to cut the WRITE short -- and a USB trace under Windows seems to
> indicate that it does -- but under Linux no STALL is received.  I
> don't know why not.  But since Linux does not respond in the way the
> device expects, the device crashes.
> 
>> Anyway, I'll send the patch to this person so he can try it. 
>> I guess it won't fix his problem. This patch is much simpler and doesn't 
>> need any delays - I really think this is a different situation.
> 
> It isn't.  And your patch is an ad-hoc correction that doesn't address
> the true underlying reasons for the errors.

Tomas, you should try the patch listed in that bug report (well, except 
maybe the part that's actually adding the JMicron unusual devices entry) 
and see if that fixes the problem.

It remains an issue, though, that if there's no underflow, if the device 
reports an error in the CSW but doesn't provide sense data, we assume 
nothing bad happened and don't retry. That definitely does not seem 
correct. The device is not supposed to do this, but with how crappily 
some of these devices are designed we should be more defensive.

It's pretty gross to add random delays in without some good evidence or 
input from the manufacturer that it will really fix the problem. (We do 
have one GO_SLOW flag with a delay in there already for some Genesys 
chips, but I believe that was based on some actual input from Genesys.)

> 
> You should also try adding the delay mentioned in the bug report.
> There's an excellent chance it will also prevent your problems.
> 
>> I sometimes experience the problems described by this person, as I
>> noted in the first message with the patch. When these "reset high
>> speed USB device" messages appear, it is usually necessary to
>> disconnect and power off the device.
> 
> Because the device's firmware has crashed.  That's why the reset fails.
> 
> Alan Stern
> 
> 
