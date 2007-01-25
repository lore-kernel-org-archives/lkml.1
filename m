Return-Path: <linux-kernel-owner+w=401wt.eu-S965699AbXAYIWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699AbXAYIWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965700AbXAYIWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:22:49 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:60220 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965699AbXAYIWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:22:48 -0500
Message-ID: <45B868D5.9070409@vc.cvut.cz>
Date: Thu, 25 Jan 2007 00:22:45 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-2)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx>
In-Reply-To: <45B7D750.1040501@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Petr Vandrovec wrote:
>> Hello,
>>   create test scenario where first transmit of NCP request is lost by
>> network, and before resend you kill this process.  So it stops
>> resending, but local sequence count is already incremented.  Then when
>> next process tries to access ncpfs, server will ignore its requests as
>> it expects packet with sequence X, while packet with sequence X+1
>> arrived.
> 
> Figured something along those lines, but I couldn't find any docs on the
> protocol so I wasn't sure. You wouldn't happen to have any pointers to
> such docs?

You can download NCP documentation from Novell website.  Or you could, 
couple of months ago.  Unfortunately that documentation just describes 
different NCP calls, not transport - to my knowledge transport layer was 
never documented outside of Novell.

>> And unfortunately it is not possible to simple not increment sequence
>> number unless you get reply - when server receives two packets with
>> same sequence number, it simple resends answer it gave to first
>> request, without looking at request's body at all.  So in this case
>> server would answer, but would gave you bogus answer.
> 
> This sounds promising though. In that case it wouldn't be necessary to
> store the entire request, just the sequence number, right?

Not quite.  If packet signatures are on then server needs to know packet 
you sent so it can correctly compute secret used for next packet (it is 
function of old secret, and data in current packet).  As current 
signatures implementation implement only partial signatures, you need 
just first 64bytes of the packet same - but at that point it may be 
better to just resend packet completely, as write request with correct 
file handle, length, and offset, but with only ~50 bytes of valid data 
is going to do lot of damage on the server.  So I would recommend 
resending original request...
							Petr


