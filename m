Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZETJUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZETJUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZETJUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:20:47 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43256 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753985AbZETJUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:20:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qfQHGl/fXp0ghhOEtlz260VGVKcdYnxtimh8SF93pYN+MRjd6rPzaBaAyQ2lVPo3Q52XyjaOwp6CSZnJ/2tOqCYtxjXDclFJdTV6OocyNPGy7QjKwNU9lLg4+rTrm7eHktcXhbDg0Yrf5fSd0hSIEcb2LBoe8A8z/0TzHIlsTgE=  ;
X-YMail-OSG: PiwWNfAVM1mSSLHEJL084JDJsVb9bxWiZJ.4Z_VYnRfDOeLPHFeohQ6P5QeA2u5qiKvud1UMPm.coTlLdfSthHnRw2upRYNu9skRTOw5fSR7bksiK4dfVkvePHL2hpyVsx3qrQtn8e3OKvptJQ8sz9Na1chQWtsqRlfcxoaZai0NUmoy.Z4Q.Zb5cXqTAxdHjYNPn1MISSWeUhNDb7FxT7dxyj3QoEvCIvymALHST6X8WLXNo.jUSiXfkch9iv7BZPP9DzFgQJzp460-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Wed, 20 May 2009 02:20:46 -0700
User-Agent: KMail/1.9.10
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905192149.07778.david-b@pacbell.net> <200905201035.23964.wolfgang.mues@auerswald.de>
In-Reply-To: <200905201035.23964.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200905200220.46569.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 May 2009, Wolfgang Mües wrote:
> what about the following proposal which is not so aggressive?

Seems plausible to me, though note one comment at the end...


> The current mapping in mmc_spi.c is:
> 
> R1_SPI_PARAMETER => EINVAL
> R1_SPI_ADDRESS => EINVAL
> R1_SPI_ILLEGAL_COMMAND => EINVAL
> R1_SPI_COM_CRC => EILSEQ
> R1_SPI_ERASE_SEQ => EIO
> R1_SPI_ERASE_RESET => EIO

Yeah, that took a bit of head-scratching to come up with.


> R1_SPI_COM_CRC is a transmission error - no doubt. Mapping to EILSEQ is OK.
> 
> R1_SPI_ERASE_SEQ and R1_SPI_ERASE_RESET are responses to a sector erase 
> command. block.c is not sending such commands, so block.c can safely assume 
> that each such response is a transmission error.

Hmm, would hope that's not a long-term plan.  Remember that the
firmware in the card can leverage "that's erased" knowledge for
things like wear leveling.  SSDs and other storage devices would
likewise benefit from such knowledge.  I'm quite certain there's
been discussion about adding support for that in the block layer.


> R1_SPI_PARAMETER and R1_SPI_ADDRESS are errors from the card controller
> because a parameter or an address is out of range/invalid. It is mapped to 
> EINVAL, and so the caller can not distinguish between errors from the host 
> controller and driver or the card. This has to be changed to some other code,
> maybe EFAULT /* Bad address */.

OK.


> R1_SPI_ILLEGAL_COMMAND is mapped to EINVAL, and I suggest it to replace with
> ENOSYS /* Function not implemented */.
> 
> A quick scan in the mmc directory for EINVAL reveals that there are no callers 
> which need to be changed.
> 
> As block.c does not send a command, parameter or address which is invalid/out 
> of range,

That is, *today* it doesn't.  For the moment I suspect just logging
the actual fault code (a pr_debug) may will suffice; this is the kind
of stuff that shouldn't get buried too deeply.


> these errors must be considered transmission errors in the command  
> (if CRC is off) or in the response.

And the key issue is -- correct me if I'm wrong -- that returning
EINVAL makes trouble, so you need to change those three codes.  The
others don't much matter, right?

