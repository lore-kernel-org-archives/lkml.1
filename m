Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYEaO0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYEaO0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 10:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYEaOZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 10:25:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:12249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYEaOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 10:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MJbuYCBAv+9BpFUs51O9Kynald/Rf+7DCFLsXG30aC7LCP9yIjv1hR3k1iq3hq4ML/Wsp0czgjAHHDBajcy4wkacKunGxuPNZC8+Jtqjo09ZyR+9Nk5KzzxEbrco7nsEgEWzrvE06DI91irFnyjoEFDMTsiKW1UzVrIUJ60NyDI=
Message-ID: <a01a16b50805310725x4f1c375ep2d091bb044ac0787@mail.gmail.com>
Date: Sat, 31 May 2008 16:25:47 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
In-Reply-To: <1211966834.12349.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu> <1211966834.12349.62.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4VEQ6Hl024685

2008/5/28 Peter Zijlstra <peterz@infradead.org>:> Just a quick note to say, me too!!>> same scenario: distcc on localhost.
Me too, however with a completely different scenario; my hung connectionsare not related to distcc at all. The output from /proc/net/tcp that Ingoposted a few days ago are somewhat different from mine, however I believethis is the same problem or at least related. Just as Ingo experienced,netstat -p only shows PID/program as '-' for the hung connections whilefor other connections it shows the expected results.
I have recently bought a new PC and have started the process of copyingstuff from my old PC to the new PC. During this I have experienced thishang several times. I started copying by using tar on both ends over a sshpipe but in order to eliminate possible ssh problems I also have tried tarover a ttcp connection which also fails. There is no obvious pattern ofwhen this happens, I have experienced failures after transferring 1.15GB,51.4GB and 23.6GB.
Here is the output from netstat -n -o filtered for port 22 and slightlyedited. All the lines started with Proto == tcp and Recv-Q == 0.
Send-Q Local Addr Foreign Addr  State       Timer     0 old_pc:22  new_pc:52667  ESTABLISHED keepalive (3513.93/0/0)     0 old_pc:22  new_pc:43825  ESTABLISHED keepalive (5467.38/0/0)  2896 old_pc:22  new_pc:58601  ESTABLISHED on (21020884.65/0/0)  4344 old_pc:22  new_pc:54105  ESTABLISHED on (21017016.33/0/0)  2896 old_pc:22  new_pc:34149  ESTABLISHED on (20986889.24/0/0)
The first two connections are ongoing, working, interactive sshconnections. The other three connections died days ago on my new PC.
One thing that caught my eyes was these very high timer values.Checking the netstat source reveals that the value printed is "(double)time_len / HZ" and that time_len is extracted from /proc/net/tcp. Whilemy CONFIG_HZ is 1000, I assume netstat has picked up HZ as 100 from/usr/include/asm/param.h, and then things really seems to imply thatthere is some integer overflow since 2^31 = 2147483648.
Looking into get_tcp4_sock in net/ipv4/tcp_ipv4.c I see that timer_expiresis initialized with icsk->icsk_timeout for the troublesome cases. Buthere my competence to trace this further stops, so I have no idea ofhow icsk->icsk_timeout gets such high values.
My old PC is currently still running with these stalled connectionspresent so let me know if there is something I should try to investigatefurther. I can post output from /proc/net/tcp and my .config if you wantto have a look. My old PC is 32 bit/Celeron single core, kernel 2.6.24,while my new is 64 bit/Q9300 quad core, kernel 2.6.25.3. The ethernetcards are the following:
02:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd.RTL-8139/8139C/8139C+ (rev 10)02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056PCI-E Gigabit Ethernet Controller (rev 12)
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
