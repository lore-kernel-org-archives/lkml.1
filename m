Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbYLOSAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYLOSAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYLOSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:00:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYLOSAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:00:05 -0500
Message-ID: <49469ADB.6010709@vlnb.net>
Date: Mon, 15 Dec 2008 20:58:51 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net>	 <20081210214500.GA24212@ioremap.net>  <4941590F.3070705@vlnb.net>	 <1229022734.3266.67.camel@localhost.localdomain>	 <4942BAB8.4050007@vlnb.net> <1229110673.3262.94.camel@localhost.localdomain>
In-Reply-To: <1229110673.3262.94.camel@localhost.localdomain>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/aS5HaDEWVxNqbDm3/+NFrmAI6RiSQ8UXBJ4a
 JJIumVQTM94kaXbDkgbfFAS587Xc7AXoNIsIbL238B6q6uObAS
 GOQHlxDrDFDvllYVjQeKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2008-12-12 at 22:25 +0300, Vladislav Bolkhovitin wrote:
>>> One thing that leaps immediately to mind is that you could isolate this
>>> to the net layer by putting it in skb_frag_struct.  However, such a move
>>> would require a proper API for this in net ...
>> To have net_priv analog in skb was the first idea I was tried. But I 
>> quickly gave up, because it would required that all the pages in each 
>> skb_frag_struct be from the same originator, i.e. with the same 
>> net_priv. It is unpractical to change all the operations with skb's to 
>> forbid merging them, if they have different net_priv. There are too many 
>> such places in very not obvious code pieces.
> 
> Actually, I said carry in skb_frag_struct not skb ... that allows for
> merging of skbs with different page sources.  The API changes would have
> to allow setting at this level.

Possibly, you are right, but the amount of changes would be very big, 
while the net_priv patch I did is just 309 lines long including all the 
descriptions and comments. And it's really simple and straightforward.

>>> right now it looks like
>>> you're using the struct page addition to carry this information from
>>> SCSI to net, which is a bit of a layering violation.
>> I don't think there is any layering violation here. Just lower layer 
>> notifies upper layer that transmission of a page has finished. It's done 
>> a bit not straightforward, but still basically the same as, for 
>> instance, on_free_cmd() callbacks which SCST core uses to notify target 
>> drivers and dev handlers that the corresponding command is about to be 
>> freed, so they can free associated with it data as well.
> 
> The way you transmit the information you want notification is done by a
> private tag in struct page, so you're carrying the information on an
> object that belongs to neither layer ... that's the violation.  It's
> essentially an extension of the net API that goes via the mm layer.

I understand your fears, but I think there can be another view on this. 
There are 2 layers: TCP and iSCSI. ISCSI asks TCP to send data and TCP 
performs that. ISCSI communicates with TCP using sendpage() function, it 
asks TCP to send pages. So, the unit of communications is page. When TCP 
finished transmitting a page, it notifies iSCSI that the page was 
transmitted. Now iSCSI needs to find out its own command, associated 
with that page. It does that using page->net_priv, which keeps pointer 
to the associated iSCSI command. I don't think there is any layer 
violation here, because iSCSI and TCP communicate using pages, not any 
other objects. If they communicated using, e.g., skb, no doubts, it 
would be a layers violation.

But, since iSCSI and TCP communicate using pages, the situation is the 
same as between SCST core and a target driver in the on_free_cmd() 
example I used before. When SCST core notifies the target driver using 
on_free_cmd() callback that a command finished and is about to be freed, 
the target driver also needs to find out its own associated with the 
command data and it does that using tgt_priv pointer in struct scst_cmd. 
Similarly, for instance, struct scsi_cmnd has host_scribble pointer for 
low level drivers.

Thanks,
Vlad
