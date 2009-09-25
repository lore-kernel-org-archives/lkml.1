Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZIYIzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZIYIzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 04:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZIYIzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 04:55:35 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:40387 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZIYIzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 04:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oq/MwozamE2EGN2con3nBGN7RzNrmJmO6GG4QhWot/f83gqkM99jRCwfS/fpI0XEZO
         nKDdX0pg49XCT7uCFJwtATAugw8h1Lb7oAnGU37zhC49U4nQLFUSCqA2vja7uQCQYzAZ
         43PsNg/+RiBy2qhcIjvpVL6BAd5/0ZrsUBDq4=
MIME-Version: 1.0
In-Reply-To: <511432.48405.qm@web63401.mail.re1.yahoo.com>
References: <40c9f5b20909241932k5e1f1d74kf8065e2e06aa4d09@mail.gmail.com>
	 <511432.48405.qm@web63401.mail.re1.yahoo.com>
Date: Fri, 25 Sep 2009 16:55:36 +0800
Message-ID: <40c9f5b20909250155l49ad5fd2if8efb4fd48ed6066@mail.gmail.com>
Subject: Re: TCP stack bug related to F-RTO?
From: zhigang gong <zhigang.gong@gmail.com>
To: Joe Cao <caoco2002@yahoo.com>
Cc: linux-kernel@vger.kernel.org, jcaoco2002@yahoo.com, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, I see, so I spoke too quickly in last mail. You just ignore some packets
in the trace. I have analysed the traffic flow  and have some findings as below,
hope it's helpful.

>> > 1. The client opens up a big window,
>> > 2. the server sends 19 packets in a row (pkt #14- #32
>> in the trace), but all of them are dropped due to some
>> congestion.
>> > 3. The server hits RTO and retransmits pkt #14 in #33
This retransmission timer expiring indicate the server's tcp/ip
stack to enter slow start mode, as a result we can see the
server's sending window will be reduced to one.

>> > 4. The client immediately acks #33 (=#14), and the
>> server (seems like to enter F-RTO) expends the window and
>> sends *NEW* pkt #35 & #36.=A0 Timeoute is doubled to
>> 2*RTO; The client immediately sends two Dup-ack to #35 and
>> #36.

Server is still in slow start mode, and extend window to 2.

>> > 5. after 2*RTO, pkt #15 is retransmitted in #39.

Here , the second retransmission timer expiring ocur. Server's sending
window reduce to one again and continue in slow start mode.

>> > 6. The client immediately acks #39 (=#15) in #40, and
>> the server continues to expand the window and sends two
>> *NEW* pkt #41 & #42. Now the timeoute is doubled to 4
>> *RTO.
Here you ignore two duplicate acks #37 and #38 sent by the client. As I know
the server must receive three or even more duplcate acks before it enter fast
retransmit mode, otherwise it will still in slow start mode and  it
will wait until next
time retransmission timer expiring before retransmit the lost packets.
And this is
actually what you got.

I'm not an kernel expert, I just analyse from the TCP protocol standard. From my
view, I think there is no problem in the server's network stack. But
there maybe
some problem in the client (or some intermediate network appliance) side, as it
always just sends two duplicate acks at the same time, and never send the third
one no matter how long the interval is. In my opinion, if the client
can send the third
duplicate acks then the server will enter fast retransmit mode and
then fast recovery
then every thing will be ok.

>> > 8. After 4*RTO timeout, #16 is retransmitted.
>> > 9....
>> > 10. The above steps repeats for retransmitting pkt
>> #16-#32 and each time the timeout is doubled.
>> > 11. It takes a long long time to retransmit all the
>> lost packets and before that is done, the client sends a RST
>> because of timeout.

On Fri, Sep 25, 2009 at 2:42 PM, Joe Cao <caoco2002@yahoo.com> wrote:
> Hi,
>
> On the wrong tcp checksum, that's because of hardware checksum offload.
>
> As for the seq/ack number, because the trace is long, I deliberately removed those irrelevant packets between after the three-way handshake and when the problem happens.  That can be seen from the timestamps.
>
> Please also note that I intentionally replaced the IP addresses and mac addresses in the trace to hide proprietary information in the trace.
>
> Anyway, the problem is not related to the checksum, or seq/ack number, otherwise, you won't see the behavior shown in the trace.
>
> Thanks,
> Joe
>
> --- On Thu, 9/24/09, zhigang gong <zhigang.gong@gmail.com> wrote:
>
