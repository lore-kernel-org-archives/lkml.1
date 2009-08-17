Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZHQSV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZHQSV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 14:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757948AbZHQSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 14:21:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:54098 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbZHQSVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 14:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P1uEY02bI3basnr3rWc6c+BST0iwZeu1hv+ZzITTnkyd4JvBxaREVUNaKzOlMZPYzk
         h1w/FNDMLMxIgoEL1FNFm7wsFoJ8jBtFVCM/UIAItMGD9t7NtJxseD/dRiqvOEf9BlZA
         7mGTTHG1Uwl8XSHTOTrC8q4sX/AT+V4mKfXEM=
MIME-Version: 1.0
In-Reply-To: <1250529575.7858.31.camel@mulgrave.site>
References: <200908122007.43522.ngupta@vflare.org>
	 <20090816083434.2ce69859@infradead.org>
	 <1250437927.3856.119.camel@mulgrave.site> <4A8834B6.2070104@rtr.ca>
	 <1250446047.3856.273.camel@mulgrave.site> <4A884D9C.3060603@rtr.ca>
	 <1250447052.3856.294.camel@mulgrave.site> <4A898752.9000205@tmr.com>
	 <87f94c370908171008t44ff64ack2153e740128278e@mail.gmail.com>
	 <1250529575.7858.31.camel@mulgrave.site>
Date: Mon, 17 Aug 2009 14:21:21 -0400
Message-ID: <87f94c370908171121u5ee8016p253824b16851b48@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Mark Lord <liml@rtr.ca>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Worley <worleys@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 1:19 PM, James Bottomley<James.Bottomley@suse.de> wrote:
> On Mon, 2009-08-17 at 13:08 -0400, Greg Freemyer wrote:
>> All,
>>
>> Seems like the high-level wrap-up of all this is:
>>
>> There are hopes that highly efficient SSDs will appear on the market
>> that can leverage a passthru non-coalescing discard feature.  And that
>> a whitelist should be created to allow those SSDs to see discards
>> intermixed with the rest of the data i/o.
>
> That's not my conclusion.  Mine was the NCQ drain would still be
> detremental to interleaved trim even if the drive could do it for zero
> cost.

Maybe I misunderstood Jim Owens previous comment that designing for
devices that only meet the spec. was not his / Linus'es preference.

Instead they want to have a whitelist enabled list of drives that
support trim / ncq without having to drain the queue.

I just re-read his post and he did not explicitly say that, so maybe
I'm mis-representing it.

>> For the other known cases:
>>
>> SSDs that meet the ata-8 spec, but don't exceed it
>> Enterprise SCSI
>
> No, SCSI will do WRITE_SAME/UNMAP as currently drafted in SBC3
>
>> mdraid with SSD storage used to build raid5 / raid6 arrays
>>
>> Non-coalescing is believed detrimental,
>
> It is?  Why?

For the only compliant SSD in the wild, Mark has shown it to be true
via testing.

For Enterprise SCSI, I thought you said a coalescing solution is
preferred.  (I took that to mean non-coalescing is detremental.  Not
true?).

For mdraid, if the trims are not coalesced mdraid will have to either
ignore them, or coalesce them themselves. Having them come in bigger
discard ranges is clearly better.  (ie. At least the size of a stripe,
so it can adjust the start / end sector to a stripe boundary.)

>>  but a regular flushing of the
>> unused blocks/sectors via a tool like Mark Lord has written should be
>> acceptable.
>>
>> Mark, I don't believe your tool really addresses the mdraid situation,
>> do you agree.  ie. Since your bypassing most of the block stack,
>> mdraid has no way of snooping on / adjusting the discards you are
>> sending out.
>>
>> Thus the 2 solutions that have been worked on already seem to address
>> the needs of everything but mdraid.
>
> I count three:  Mark Lord script via SG_IO.  hch enhanced script via
> XFS_TRIM and willy current discard inline which he's considering
> coalescing for.

I missed XFS_TRIM somehow.  What benefit does XFS_TRIM provide at a
high level?  Is it part of the realtime delete file process, or an
after the fact scanner?

> James

Greg
