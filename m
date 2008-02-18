Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbYBRU0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbYBRU0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYBRU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:26:14 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9313 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYBRU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:26:13 -0500
Date: Mon, 18 Feb 2008 14:26:07 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
In-reply-to: <20080218113107.GB24147@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47B9E9DF.8010408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LKjQjbOw482S/QFVaQ9fSrM+IFw@ifi.uio.no>
 <fa.wuwhrqFp6CufvpAJxShHqIaOPdI@ifi.uio.no> <47B67A0E.7060605@shaw.ca>
 <20080218113107.GB24147@one.firstfloor.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> With just this patch you will have this problem. You need either the 
>> patch to disable decode during BAR sizing,
> 
> Isn't that one already merged?
> 
> I remember the BAR decoding patch did help with at least one
> of the original failures (there were multiple ones iirc0) 

I believe that one's been dropped as it's not needed if we don't use 
MMCONFIG for non-extended accesses (like we use during BAR sizing). 
(Though, there may still be a case where it's needed, see below.)

> 
> If someone points me to all the patches needed or a tree who 
> has them all applied I can give it a quick spin on the boxes I have here.
> One of the systems where it originally failed I don't have anymore
> though.
> 
>> or the patch to use MMCONFIG 
>> for extended config space only, if you don't have them already.
> 
> That would mean it would boot, but anything that uses extended config
> space would fail. While not as catastrophic as before I'm not sure
> it's that great either. At least there would be still breakage,
> but much more subtle ones.

The only issue on those boards is that since certain device BARs will 
overlap the MMCONFIG area during BAR sizing, if you use MMCONFIG to do 
the accesses used during BAR sizing itself, it'll fail. If you use conf1 
to do the BAR sizing then that problem doesn't happen.

However, I suppose there could be an issue if you hotplugged a device 
(causing BAR sizing) once you'd booted, while extended config space was 
in use on another device. The BAR sizing wouldn't fail, but the guy 
using extended config space would since he's actually reading 
from/writing into the BAR of the device being sized instead of the 
MMCONFIG area. That wouldn't be good. The disable-decode-during-sizing 
patch would avoid that problem.
