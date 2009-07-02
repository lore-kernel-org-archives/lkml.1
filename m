Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZGBKw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZGBKw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZGBKwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:52:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56751 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGBKwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qsMJyHbyX4iT4HYPP9QFz49CGYG2krvh5IKlRvV9kF3UNZwyVMFpbtmbcxx7SMFvXG
         mmggslie3U776z7+XjAAEgvE2pARVIZbHhbDWWZwlJOZMG4flJ69QdM2B2Fe0vELHOQW
         iRNiZfRTTf/cZ0T+hbcMkedMSknMOdfvfIQfk=
MIME-Version: 1.0
In-Reply-To: <20090702101207.GA7056@ff.dom.local>
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> 
	<4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> 
	<20090702093031.GC4954@ff.dom.local> <20090702101207.GA7056@ff.dom.local>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Thu, 2 Jul 2009 11:51:56 +0100
Message-ID: <a5d9929e0907020351u4e441486nf285ac6cb32c3202@mail.gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly caused 
	by netem)
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting this one too. On any .31-rc1-gitXX, it pops up a few
seconds after i turn traffic shaping on with tc/htb (no netem here).
Its easily reproducible on my end, turn on traffic shaping, get
traffic flowing, box freezes. No error message, nothing on logs,
although -sometimes- i get lockdep error messages on screen, but
scrolls too fast and box is otherwise unresponsive, so i can't get the
error out.

This does not happen on 2.6.30 at all.

Hope this helps.

(i tried both CONFIG_PACKET_MMAP off and the patch, still happens).

Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal


(snip firewall script. TCBIN is just tc, OUTIF is just the outside
interface (gigabit D-Link using r8169 driver))
$TCBIN class add dev $OUTIF parent 1: classid 1:1 htb rate
${UPLINK}kbit ceil ${UPLINK}kbit
$TCBIN class add dev $OUTIF parent 1:1 classid 1:10 htb rate
$[30*$UPLINK/100]kbit ceil $[30*$UPLINK/100]kbit prio 0
$TCBIN class add dev $OUTIF parent 1:1 classid 1:11 htb rate
$[30*$UPLINK/100]kbit ceil ${UPLINK}kbit prio 1
$TCBIN class add dev $OUTIF parent 1:1 classid 1:12 htb rate
$[8*$UPLINK/100]kbit ceil ${UPLINK}kbit prio 2
$TCBIN class add dev $OUTIF parent 1:1 classid 1:13 htb rate
$[8*$UPLINK/100]kbit ceil ${UPLINK}kbit prio 2
$TCBIN class add dev $OUTIF parent 1:1 classid 1:14 htb rate
$[10*$UPLINK/100]kbit ceil ${UPLINK}kbit prio 7 quantum 50000
$TCBIN class add dev $OUTIF parent 1:1 classid 1:15 htb rate
$[13*$UPLINK/100]kbit ceil ${UPLINK}kbit prio 8

$TCBIN qdisc add dev $OUTIF parent 1:12 handle 120: sfq perturb 10
$TCBIN qdisc add dev $OUTIF parent 1:13 handle 130: sfq perturb 10
$TCBIN qdisc add dev $OUTIF parent 1:14 handle 140: sfq perturb 10
$TCBIN qdisc add dev $OUTIF parent 1:15 handle 150: sfq perturb 10

$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 1 handle 1 fw
classid 1:10
$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 2 handle 2 fw
classid 1:11
$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 3 handle 3 fw
classid 1:12
$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 4 handle 4 fw
classid 1:13
$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 5 handle 5 fw
classid 1:14
$TCBIN filter add dev $OUTIF parent 1:0 protocol ip prio 6 handle 6 fw
classid 1:15
(snip firewall script)

On Thu, Jul 2, 2009 at 11:12 AM, Jarek Poplawski<jarkao2@gmail.com> wrote:
> On Thu, Jul 02, 2009 at 09:30:31AM +0000, Jarek Poplawski wrote:
>> On Thu, Jul 02, 2009 at 02:37:24AM +0200, Andres Freund wrote:
>> ...
>> > So I tried - and I did not catch any lockdep output before the crash.
>> > Unfortunately I do not have another machine on the same local network to
>> > catch any messages after the crash... So I could be missing some warning
>> > (I did synchronous logging though).
>> > Will check with netconsole tomorrow.
>>
>> Could you try if this patch changes anything?
>
> ...and maybe CONFIG_PACKET_MMAP turned off.
>
> Jarek P.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
