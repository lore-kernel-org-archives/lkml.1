Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYF2WQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYF2WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYF2WQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 18:16:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYF2WQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 18:16:17 -0400
Message-ID: <486807D6.9060407@zytor.com>
Date: Sun, 29 Jun 2008 15:08:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <avi@qumranet.com>, Agner Fog <agner@agner.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org> <20080628200231.GA21259@one.firstfloor.org> <48677313.8000804@qumranet.com> <48677E39.6000001@firstfloor.org> <486780BA.6010202@qumranet.com> <486788F4.5060202@firstfloor.org> <48678BBF.80707@qumranet.com> <48678CC5.5080504@firstfloor.org>
In-Reply-To: <48678CC5.5080504@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>>   
>> If you use xsave, I don't see how this is different to the user fpu save
>> area.
> 
> For once there's no clear error handling path for allocation failures
> on the (arbitarily sized) xsave state. On user code that can be barely
> tolerated, but for the kernel it would be deadly.
> 

Well, that's relatively easily dealt with... you'd have to allocate that 
state save area explicitly in kernel_fpu_begin(), and it would be up to 
the callers of that function to handle the resulting sleep and/or 
allocation failure -- we could even make kernel_fpu_begin() take a GFP_* 
flag.

Now, there are a few possibilities what to do with said state area.  One 
is to make it associated with the task; if used for something as RAID, 
this would mean pretty soon *all* (or nearly all) tasks have such a 
state area, and we might as well go back to allocating them preemptively 
on thread creation.  The other, of course, is to destroy it in 
kernel_fpu_end().  This may cause quite a bit of allocation/deallocation 
overhead, but perhaps this would be a decent use of a quicklist.

	-hpa


