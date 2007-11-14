Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXKNJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXKNJXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbXKNJXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:23:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:62750 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbXKNJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:23:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=g+25xEDTXhLuLwl1iCi/XV9+Huhga8WZUyfrTu1RfFLZVIj88luzIZZzTn3qh9sKXt2Vthpd6/hyQbMfuZ+n9mCBP6bifNfZpPX7t2V8qlYFfO2AsFDIYy1mvXjve3Zvgz0DZWgMJ4NAaLwjLu+vRcppO1OuaFG8xUEjm8cmTs4=
Message-ID: <473ABE7D.6060703@googlemail.com>
Date: Wed, 14 Nov 2007 10:23:09 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
CC: Gabriel C <nix.or.die@googlemail.com>, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       bk@suse.de, khali@linux-fr.org, Boaz Harrosh <bharrosh@panasas.com>,
       James <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.24-rc2-mm1
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com> <20071114043923.GK6089@one-eyed-alien.net> <473A88B3.3010303@googlemail.com> <20071114082332.GM6089@one-eyed-alien.net>
In-Reply-To: <20071114082332.GM6089@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> On Wed, Nov 14, 2007 at 06:33:39AM +0100, Gabriel C wrote:
>> Matthew Dharm wrote:
>>> On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
>>>> Matt, are these the errors you were worried about with the patch we were
>>>> just talking about tha tis in my tree?
>>> I can't tell from these logs.
>> There is the dmesg with CONFIG_USB_STORAGE_DEBUG :
>>
>> http://194.231.229.228/dmesg-2.6.24-rc2-mm1
> 
> Good news: This isn't the bug Greg was worried about.
> 
> Bad news: Something is seriously strange here.  Note the following from the
> logs:
> 
> Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
> Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short transfer
> 
> Note the 'R' value of zero -- this is the residue value.  It indicates a
> complete transfer, and that matches the log lines immediately previous
> which indicate a 4K transfer which completed properly.
> 
> If residue is zero, then srb->resid should be zero.  Take a look in
> linux/usb/storage/transport.c in usb_stor_Bulk_transport()
> 
> If srb->resid is zero, then you should NEVER get the "unexpectedly short
> transfer" message.  Look at usb_stor_invoke_transport() in the same file.

That code got replaced recently but I have no idea about it.

( http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=shortlog  see the patches from Boaz Harrosh) 

srb->resid got replaced by scsi_get_resid() it I see that right.

I'm CC'ing the author , he will know I think.

> 
> In fact, every transfer I look at shows this error.  I didn't exhaustivly
> check every single one in the log, but a quick scan suggests that they all
> are bogus; good transfer, CSW residue of 0, and "unexpectedly short"
> message.
> 
> Maybe I'm too tired at this hour, but I just don't see how this is
> possible.  Then again, I'm looking at 2.6.22 codebase (it's what I have
> handy).
> 
> Hrm... does this tree have the "srb accessor" patches in it?  I'm wondering
> if somewhere the init srb->resid to 0 before invoking the transport got
> lost....
> 
> Matt
> 


Gabriel
