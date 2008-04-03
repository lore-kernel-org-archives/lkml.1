Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYDCASv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYDCASv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYDCASk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:18:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:15461 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbYDCASj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EDma+HyLTHawtySDvgZob/bnpmSToaajZTKk+0Zj9LA/+WD1sQSz33wGD8Rq8HLdj0bVa0a4hpgT1UA4FVI4Ho/Ew1trVAyJXnWjAcLolX5Mns6abZAcNnWNFJwSrfw3PVF/Kzt6DMZzEyjzDqyLbP6nIG8rdqJgNRpuJkIgl/k=
Message-ID: <47F42259.8030603@gmail.com>
Date: Thu, 03 Apr 2008 09:18:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>	 <200804021419.06672.rjw@sisk.pl>	 <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>	 <200804021939.46733.rjw@sisk.pl> <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
In-Reply-To: <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Justin Mattock wrote:
>>  > [ 1233.811794] sd 2:0:1:0: [sda] Starting disk
>>  > [ 1234.013599] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>>  > [ 1234.013601] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
>>  > [ 1234.180232] ata1.00: configured for UDMA/66
>>  > [ 1222.732011] ata3.01: NODEV after polling detection
>>  > [ 1222.732016] ata3.01: revalidation failed (errno=-2)

I presume this is ata_piix, right?  What's hanging off of ata3.01?  An 
optical drive?

What happened is that, after resuming, libata reseted the channel and 
issued IDENTIFY[_PACKET] to make sure the device was still there.  The 
device violated the state machine transition in the same way as when 
there's no device attached.  libata paused for a while and retries and 
the device responded correctly at the retry.  Things like this can 
happen.  The problem is that libata resume is currently synchronous and 
retries like this hold the machine back from reaching operational status 
even when there's no reason for resume retrial on optical drive to delay 
the rest of resume process.

Can you please post full kernel log and the result of 'lspci -nn'?

-- 
tejun
