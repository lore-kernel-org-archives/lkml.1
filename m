Return-Path: <linux-kernel-owner+w=401wt.eu-S937095AbYEBXMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095AbYEBXMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbYEBXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:12:38 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:37449 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756683AbYEBXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:12:37 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: Re: HELP:  Is writeq an atomic operation??
Date: Fri, 2 May 2008 16:12:34 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021612.34281.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2008 3:40 pm Moore, Eric wrote:
> Is a 64bit write to MMIO registers an atomic operation when using the
> writeq API?
>
> My concern is when I send 64bit data via writeq, will it be sent out as
> two 32 bit writes?  If so, is it possible that another CPU be sending
> the data at the same time.  Meaning can I write the 1st 32bit data from
> CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
> CPU-A didn't complete the full 64bit in one shot.  If this could occur,
> is there an API that I can use to make sure the entire data sent in one
> atomic operation?
>
>
> Here is a trace from pci express analyzer.   I'm sending
> 0x0800010000000000 to the adress DD1400C0 using writeq.   Notice that in
> the TLP header it sent a 32bit Memory write with data length of two.
>
> Trace follows:
>
> Link Tra(597) Downstream 2.5(x1) TLP(1992) Mem MWr(32)(10:00000) TC(0)
> TD(0)
> _______| EP(0) Attributes(01) Length(2) RequesterID(000:02:0) Tag(8)
> _______| Address(DD1400C0) 1st BE(1111) Last BE(1111) Data(08000100
> 00000000)
> _______| VC ID(0) Explicit ACK(Packet #1195) Metrics # Packets(2)
> _______| Time Stamp(0003 . 120 181 840 s)

I think this is normal; PCIe defines transactions in terms of dwords, to a 64 
bit write would indeed be a transaction packet with a length of two (it can 
go up to 4k).  AFAIK though transactions are processed as a whole, so even a 
4k write (as long as it's generated as a single transaction) won't result in 
the device seeing e.g. 2x2k writes.  I'd have to double check the routing 
rules to be 100% sure though, maybe in some cases the fabric is allowed to 
break up transactions (?).

Jesse
