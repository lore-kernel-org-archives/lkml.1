Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbYLSTSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbYLSTSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbYLSTRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:17:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLSTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:17:50 -0500
Message-ID: <494BF361.1090003@vlnb.net>
Date: Fri, 19 Dec 2008 22:17:53 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: "David M. Lloyd" <dmlloyd@flurg.com>, linux-mm@kvack.org,
       Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC]: Support for zero-copy TCP transmit of user space data
References: <4941590F.3070705@vlnb.net> <1229022734.3266.67.camel@localhost.localdomain> <4942BAB8.4050007@vlnb.net> <1229110673.3262.94.camel@localhost.localdomain> <49469ADB.6010709@vlnb.net> <20081215231801.GA27168@infradead.org> <4947FA1C.2090509@vlnb.net> <494A97DD.7080503@vlnb.net> <494A99EF.6070400@flurg.com> <494BDBC5.7050701@vlnb.net> <20081219190701.GP32491@kernel.dk>
In-Reply-To: <20081219190701.GP32491@kernel.dk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19yzeDHCpw0dFEb1yTzu5lkiG0aaPMusVaBGtq
 aYPn+WLXXclwyt58YcECeZ6lsv/va1HTd/K5l4LxRi9H2Z/+pe
 UsRwuGAHZa3uil6XmNzXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe, on 12/19/2008 10:07 PM wrote:
> On Fri, Dec 19 2008, Vladislav Bolkhovitin wrote:
>> David M. Lloyd, on 12/18/2008 09:43 PM wrote:
>>> On 12/18/2008 12:35 PM, Vladislav Bolkhovitin wrote:
>>>> An iSCSI target driver iSCSI-SCST was a part of the patchset 
>>>> (http://lkml.org/lkml/2008/12/10/293). For it a nice optimization to 
>>>> have TCP zero-copy transmit of user space data was implemented. Patch, 
>>>> implementing this optimization was also sent in the patchset, see 
>>>> http://lkml.org/lkml/2008/12/10/296.
>>> I'm probably ignorant of about 90% of the context here, but isn't this the 
>>> sort of problem that was supposed to have been solved by vmsplice(2)?
>> No, vmsplice can't help here. ISCSI-SCST is a kernel space driver. But, 
>> even if it was a user space driver, vmsplice wouldn't change anything 
>> much. It doesn't have a possibility for a user to know, when 
>> transmission of the data finished. So, it is intended to be used as: 
>> vmsplice() buffer -> munmap() the buffer -> mmap() new buffer -> 
>> vmsplice() it. But on the mmap() stage kernel has to zero all the newly 
>> mapped pages and zeroing memory isn't much faster, than copying it. 
>> Hence, there would be no considerable performance increase.
> 
> vmsplice() isn't the right choice, but splice() very well could be. You
> could easily use splice internally as well. The vmsplice() part sort-of
> applies in the sense that you want to fill pages into a pipe, which is
> essentially what vmsplice() does. You'd need some helper to do that.

Sorry, Jens, but splice() works only if there is a file handle on the 
another side, so user space doesn't see data buffers. But SCST needs to 
serve a wider usage cases, like reading data with decompression from a 
virtual tape, where decompression is done in user space. For those only 
complete zero-copy network send, which I implemented, can give the best 
performance.

> And
> the ack-on-xmit-done bits is something that splice-to-socket needs
> anyway, so I think it'd be quite a suitable choice for this.

So, are you writing that splice() could also benefit from the zero-copy 
transmit feature, like I implemented?

Thanks,
Vlad


