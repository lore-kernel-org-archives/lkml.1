Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYBJASa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYBJASa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 19:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYBJASU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 19:18:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:53698 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbYBJAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 19:18:19 -0500
Date: Sun, 10 Feb 2008 01:18:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
In-Reply-To: <20080209235433.GS4352@ghostprotocols.net>
Message-ID: <Pine.LNX.4.64.0802100116560.6917@fbirervta.pbzchgretzou.qr>
References: <87zlugsox9.fsf@saeurebad.de> <20080204180753.GB16050@uranus.ravnborg.org>
 <Pine.LNX.4.64.0802092307520.6917@fbirervta.pbzchgretzou.qr>
 <20080209235433.GS4352@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2008 21:54, Arnaldo Carvalho de Melo wrote:
>> To drop strings that are only shown once anyway, such as:
>> 
>> static int __init ebtables_init(void)
>> {
>>         int ret;
>> 
>>         mutex_lock(&ebt_mutex);
>>         list_add(&ebt_standard_target.list, &ebt_targets);
>>         mutex_unlock(&ebt_mutex);
>>         if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
>>                 return ret;
>> 
>> ->      printk(KERN_INFO "Ebtables v2.0 registered\n");
>>         return 0;
>> }
>> 
>> >If you say "saving memory" then please let us know with specific examples
>> >in what area these savings will really pay off.
>
>[...]
>With a tool like this the advantage is that no source code has to be
>changed, strings in __init functions are automagically moved to
>.init.data, the disadvantage is that not all strings can be moved to
>.init.data as there were (are?) subsystems that keep pointers to the
>string passed and another tool would be involved in the build process.

There is one corner case to consider:


	static char abc[] = "foo";

	int __init init_module(void)
	{
		printk(abc);
	}

I am not sure if gcc/ld is smart enough to figure out that abc is
only ever used from within an __init function and that it could hence
be moved to __initdata.
