Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZBWQQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZBWQQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZBWQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:15:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:43391 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZBWQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hl56fp4R2TgS7i0vnU4cygozqnidbfenwE8JD7d34ZJPHP9JokUEvMavByyBQLf1FM
         04Oh9eXTtS12fpM9cLbdRvJg/10GD8af+KtGMpXc58YuXaDsGnCOdN7YNQX5VoHyI0TE
         LXgw0Wp24CTmCeyCfwWRFvvBPsl1iPHrealP0=
MIME-Version: 1.0
In-Reply-To: <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com>
References: <20090222111807.GB5538@silver.sucs.org>
	 <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org>
	 <20090222144742.GA6078@nowhere>
	 <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
	 <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com>
	 <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com>
Date: Mon, 23 Feb 2009 18:15:51 +0200
Message-ID: <40f31dec0902230815x6b43fa50h41edfeead96822a3@mail.gmail.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Nick Kossifidis <mickflemm@gmail.com>:
> 2009/2/23 Bob Copeland <me@bobcopeland.com>:
>> On Mon, 23 Feb 2009 00:20:50 +0100, Jiri Slaby wrote
>>> On 22.2.2009 22:56, Jiri Slaby wrote:
>>> > Well, maybe we should try to reproduce with jumbo packets sent to the
>>> > ath5k receiver, since I think it (1) is not very much test-covered code
>>> > (2) appears to be related.
>>>
>>> According to the spec I have for older chip, there is not `done' flag
>>> set for descriptors which have `more' flag set. We handle this wrongly.
>>> Am I looking correctly, Nick, Luis, Bob?
>>>
>>> I still don't see what could have caused this though.
>>
>> As I understand it, yes, we don't do the right thing when the more flag
>> is set.  We're supposed to keep processing packets until we get one with
>> the done flag, and then all of that is supposed to be merged into a single
>> packet.  Other flags such as the rx rate are only valid on the final
>> packet.
>>
>> However, I did some debugging of this a while ago and concluded that the
>> 'jumbo' frames were largely garbage data.  The dma buffer size is certainly
>> large enough for a standard 802.11 frame and the 'more' flag is only
>> supposed to be set if the dma buffer size is too small for a packet.  In
>> all cases the dma buffer size was 2500+ bytes and the actual contents of
>> the packets looked like random values (I did have encryption turned on,
>> but there were no 802.11 headers I could see.)
>>
>> So I am not sure if the jumbo packets are causing bad things to happen,
>> or if they are an indication that something bad has already happened.
>>
>
> Hmm can someone test ath5k against an Atheros AP using fast frames ?
> Maybe they are jumbo frames but they don't have any header etc so that
> they look like one frame after un-fragmentation, documentation says
> that the current frame is continued in the next descriptor if more is
> set to 1 so i guess next buffer might not have the header. If more = 0
> then it's our last descriptor and only then other fields such as done,
> frame receive ok, rssi etc are valid.
>
> The fact that they are not reported as PHY error packets makes me
> wonder why would we have garbage data on our rx buffer. How about the
> FRAME_RECEIVE_OK or CRC_ERROR flags (also valid for the last
> descriptor) ? Are they set or not ?
>

Typo alert...
rs->rs_more = !!(rx_status->rx_status_0 & AR5K_5212_RX_DESC_STATUS0_MORE);


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
