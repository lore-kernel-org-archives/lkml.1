Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYILTN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYILTN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbYILTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:13:50 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:43190 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755485AbYILTNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:13:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CfXV1NZv3jKcvZVYxvHaBGYFGmagsskBQKVADi/vqT3L690ghay6vQ6VnLJuJLe9LhDg3Bp9V392Zno4sum4ZYEHHC/jpEoFCW1j/yC52qKrqTAGfoPMe7XSphtPxyrLpOlLjhYnJFUZfGVf9ztzwA+hLM8RX1GSUtuCy0AvYyQ=  ;
X-YMail-OSG: HlZ8v0kVM1leaZm_dcwBWgrv3Dkoh4MCG8HSXpsRna3E4iuQE.mGX2i8hoOjSnUaGl2FwgQi5n9zthk7waNUcZTpzI_rzuQYF1aIkcbFkQFxKZF_na6VEmw0xMbEpqg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.27 mmotm] rtc-cmos: export second NVRAM bank
Date: Fri, 12 Sep 2008 12:13:45 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
References: <200809120957.55562.david-b@pacbell.net> <20080912115530.79a3c1a3.akpm@linux-foundation.org>
In-Reply-To: <20080912115530.79a3c1a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121213.45877.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008, Andrew Morton wrote:
> > +#define can_bank2	true
> 
> It would be more idiomatic to make this upper-case: CAN_BANK2.

Think of it as:  "static const bool can_bank2 = true;" ...


> : static ssize_t
> : cmos_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
> : 		char *buf, loff_t off, size_t count)
> : {
> : 	int	retval;
> : 
> : 	if (unlikely(off >= attr->size))
> : 		return 0;
> : 	if (unlikely(off < 0))
> : 		return -EINVAL;
> : 	if ((off + count) > attr->size)
> : 		count = attr->size - off;
> : 
> : 	off += NVRAM_OFFSET;
> : 
> 
> The VFS will (hopefully) prevent ->read methods from being called with
> a negative file offset.  What prompted the additional test for that?

I was chasing down a problem related to offsets.  Now fixed;
that bit could probably go away ... except that so long as the
interface allows negative/bogus values, it seems appropriate to
defend against them.  If the interface passed an unsigned type,
my paranoia-meter would not fire in this case.

 
> I did't look at it exhaustively but I suspect that the above code won't
> work right if attr->size has a value of around (2^31 - 42) and `offset'
> is (2^31 - 54) and NVRAM_OFFSET==54.  Or something like that.  It looks
> holey ;)

In this case, size over 256 would be impossible.  A relevant
case study may be:

  http://thedailywtf.com/Articles/Rule-Number-One.aspx

:)
