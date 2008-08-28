Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYH1S5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYH1S5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYH1S5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:57:19 -0400
Received: from smtp21.orange.fr ([80.12.242.48]:47747 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYH1S5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:57:18 -0400
X-ME-UUID: 20080828185716644.9D6591C000AE@mwinf2114.orange.fr
Message-ID: <48B6F4FE.6010308@cosmosbay.com>
Date: Thu, 28 Aug 2008 20:57:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Andi Kleen <andi@firstfloor.org>, Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <20080827.201020.17601834.davem@davemloft.net> <21915755.1327801219904892242.JavaMail.root@ouachita> <20080828072218.GI26610@one.firstfloor.org> <200808281948.52608.denys@visp.net.lb>
In-Reply-To: <200808281948.52608.denys@visp.net.lb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko a écrit :
> My small IMHO regarding SO_TIMESTAMP.
> 
> 1)Right now i have 400-500 Mbps passing router. If i will run 
> 5 "pings" ,simultaneous ,under _USER_ privileges(i know ping is suid), 
> instead of free 20% CPU time, i will have 1-2% free CPU time. Sure i know 
> ping is suid program, but it is has been "like this" since long time. By 
> security psychos it will be caled DoS.
> 

> 

So... if using ping on your machine has direct an noticeable effect on cpu load, problem is elsewhere
(if no ping is running, you dont have skb timestamping, but still getnstimeofday() is the top function in oprofile)

1) Do you have any netfilter rule using xt_time ?
   (This module also calls __net_timestamp(skb))

2) You maybe have a bad program that do something expensive relative to kernel time services.


bad_program()
{
while (1) {
    struct timeval t0,t1;
    gettimeofday(&tv0, NULL); // or whatever function that calls getnstimeofday()
    do_small_work();
    gettimeofday(&tv1, NULL); // or whatever function that calls getnstimeofday()
    add_stat_event(&tv1, &tv0);
}

> 2)Usefullness of this option. What is a difference if on almost idle machine 
> timestamp retrieved on higher level or lower level? 
> And why we need on highly loaded server so high precision timestamp (with 
> expensive timer), if in my case enabling any socket with SO_TIMESTAMP 
> creating delays more than 10ms(up to 100ms)?

Your setup is probably not common.
You want a PersonnalComputer class machine acts as a SuperCiscoDevice(TM),
while most PC machines dont use more than 10% of CPU power in average...

Many existing programs depend on current SO_TIMESTAMP.
We wont break them to solve a particular problem (yet to be demonstrated)

> 
> 3)Who is most users of SO_TIMESTAMP? iputils which is installed on almost 
> _ANY_ linux machine? busybox which is using same option? Many others 
> userspace multiplatform applications? Or banks? I dont take much in account 
> dhcpd, who is maybe abusing this option.
> 
> So there is few good solutions available (IMHO):
> 1)Introduce some SO_REALTIMESTAMP (anyway even SO_TIMESTAMP not defined in any 
> standard) for banks and ntp folks, who need them. And even give them timespec 
> instead timeval, so they will be even more happy with resolution.

kernel already provides nanosecond resolution :)
Check SO_TIMESTAMPNS and SCM_TIMESTAMPNS





