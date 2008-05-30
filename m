Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYE3QX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYE3QX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYE3QXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:23:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:47259 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYE3QXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MiOisHJuMOPnHCPhNf5RM4QHYW1rLl+3JJ1QY8i9Nvh0uvR0qtb2voRfJhnnT9AU+aN+GPZe69fIPWhMWaJE67xXUiOuPov+7hsXyI5VUW29lemickz9DTihZ3wSukkPmYFEjKbRIAQIyxZ14UMtBDN8w/qSb9Yh+2dwDJdPkzE=
Message-ID: <2c0942db0805300923u10bb591am27c73ab4d48466cf@mail.gmail.com>
Date: Fri, 30 May 2008 09:23:45 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu>
	 <Pine.LNX.4.64.0805261550340.16829@wrl-59.cs.helsinki.fi>
X-Google-Sender-Auth: 222fb289b3091f90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4UGO5Hl001849

On Mon, May 26, 2008 at 6:28 AM, Ilpo JÃ¤rvinen<ilpo.jarvinen@helsinki.fi> wrote:> On Mon, 26 May 2008, Ingo Molnar wrote:>>> in an overnight -tip testruns that is based on recent -git i got two>> stuck TCP connections:>>>> Active Internet connections (w/o servers)>> Proto Recv-Q Send-Q Local Address               Foreign Address             State>> tcp        0 174592 10.0.1.14:58015             10.0.1.14:3632              ESTABLISHED>> tcp    72134      0 10.0.1.14:3632              10.0.1.14:58015             ESTABLISHED>>>> on a previously reliable machine. That connection has been stuck for 9>> hours so it does not time out, etc. - and the distcc run that goes over>> that connection is stuck as well.>>>> kernel config is attached.>>>> in terms of debugging there's not much i can do i'm afraid. It's not>> possible to get a tcpdump of this incident, given the extreme amount of>> load these testboxes handle.>> ...but you can still tcpdump that particular flow once the situation is> discovered to see if TCP still tries to do something, no? One needs to> tcpdump couple of minutes at minimum. Also please get /proc/net/tcp for> that flow around the same time.>>> This problem started sometime around rc3>> and it occured on two boxes (on a laptop and on a desktop), both are SMP>> Core2Duo based systems. I never saw this problem before on thousands of>> similar bootups, so i'm 99.9% sure the bug is either new or became>> easier to trigger.>>>> It's not possible to bisect it as it needs up to 12 hours of heavy>> workload to trigger. The incident happened about 5 times since the first>> incident a couple of days ago - 4 times on one box and once on another>> box. The first failing head i became aware of was 78b58e549a3098. (-tip>> has other changes beyond -git but changes nothing in networking.)
Okay, but in some sense you've already bisected this somewhat. I'massuming that your testing uses the latest tip and is refreshed daily.
If that's the case, then I would (possibly naively) expect the culpritto show up in a:  git log -p v2.6.26-rc1..78b58e549a3098net/{compat.c,core,ipv4,netfilter,packet,sched,socket.c}
There are only a few commits in there that appear to touch network behavior:
  79d44516b4b178ffb6e2159c75584cfcfc097914  a1c1f281b84a751fdb5ff919da3b09df7297619f  62ab22278308a40bcb7f4079e9719ab8b7fe11b5
Reverting just those three and running overnight might provide a clue.OTOH, I'm in no way a net/ expert, so if you are already working adebugging strategy then feel free to ignore this. I'm only piping upas it appears that the troubleshooting has stalled.
> (but there were> some recent fixes to FRTO and retrans_stamp change could have some> significance here)?>> Other than that, nothing since -rc1 seems suspicious to me (though> I hardly understand every part of networking).ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
