Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYBTHeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYBTHeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYBTHe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:34:27 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:47565 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462AbYBTHe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:34:26 -0500
Message-ID: <47BBD7FA.9090101@Voltaire.COM>
Date: Wed, 20 Feb 2008 09:34:18 +0200
From: Erez Zilber <erezz@Voltaire.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, vst@vlnb.net, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	 <47A89660.1080804@Voltaire.COM>	 <e2e108260802060416w492db372mc09848edd365d441@mail.gmail.com>	 <47B95343.9060802@Voltaire.COM> <e2e108260802180301o5c376024t72e649a9debd5157@mail.gmail.com>
In-Reply-To: <e2e108260802180301o5c376024t72e649a9debd5157@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2008 07:34:23.0647 (UTC) FILETIME=[0384A2F0:01C87393]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Feb 18, 2008 10:43 AM, Erez Zilber <erezz@voltaire.com> wrote:
>   
>> If you use a high value for FirstBurstLength, all (or most) of your data
>> will be sent as unsolicited data-out PDUs. These PDUs don't use the RDMA
>> engine, so you miss the advantage of IB.
>>     
>
> Hello Erez,
>
> Did you notice the e-mail Roland Dreier wrote on Februari 6, 2008 ?
> This is what Roland wrote:
>   
>> I think the confusion here is caused by a slight misuse of the term
>> "RDMA".  It is true that all data is always transported over an
>> InfiniBand connection when iSER is used, but not all such transfers
>> are one-sided RDMA operations; some data can be transferred using
>> send/receive operations.
>>     
>
>   
Yes, I saw that. I tried to give an explanation with more details.

> Or: data sent during the first burst is not transferred via one-sided
> remote memory reads or writes but via two-sided send/receive
> operations. At least on my setup, these operations are as fast as
> one-sided remote memory reads or writes. As an example, I obtained the
> following numbers on my setup (SDR 4x network);
> ib_write_bw: 933 MB/s.
> ib_read_bw: 905 MB/s.
> ib_send_bw: 931 MB/s.
>
>   
According to these numbers one can think that you don't need RDMA at
all, just send iSCSI PDUs over IB. The benchmarks that you use are
synthetic IB benchmarks that are not equivalent to iSCSI over iSER. They
just send IB packets. I'm not surprised that you got more or less the
same performance because, AFAIK, ib_send_bw doesn't copy data (unlike
iSCSI that has to copy data that is sent/received without RDMA).

When you use RDMA with iSCSI (i.e. iSER), you don't need to create iSCSI
PDUs and process them. The CPU is not busy as it is with iSCSI over TCP
because no data copies are required. Another advantage is that you don't
need header/data digest because the IB HW does that.

Erez
