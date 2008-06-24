Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYFXIh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYFXIh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYFXIhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:37:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:60677 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYFXIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WN/tWKqYN1+l/wRbx3ran88xrFCahroh/K6b9D0wYqNu2070yvIw0yG7zeRK3kbQNz
         aaWKB3OTt/gXQ2MQIaywT3j8z7T1t70tE/kRek2SV8Fn7qHYkKJkX61tHgdExEJ3UIIt
         O/1wi1/FoBVpRURCnvQNAR880NAl/Jou5nVBo=
Message-ID: <19f34abd0806240137w31191b67t45e243a208cba933@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:37:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, "Mike Travis" <travis@sgi.com>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       "Gautham R Shenoy" <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>
In-Reply-To: <1214294783.25608.75.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080622125633.GA8166@damson.getinternet.no>
	 <200806231326.11328.rusty@rustcorp.com.au> <485FD644.80208@sgi.com>
	 <200806241136.52430.rusty@rustcorp.com.au>
	 <1214294783.25608.75.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5O8c1fq009369

On Tue, Jun 24, 2008 at 10:06 AM, Zhang, Yanmin<yanmin_zhang@linux.intel.com> wrote:> In function _cpu_up, the panic happens when calling __raw_notifier_call_chain> at the second time. Kernel doesn't panic when calling it at the first time. If> just say because ï»¿of nr_cpu_ids, that's not right.>> By checking source codes, I find function do_boot_cpu is the culprit.> Consider below call chain:>  _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.>> So ï»¿do_boot_cpu is called in the end. In ï»¿do_boot_cpu, if boot_error==true,> cpu_clear(cpu, cpu_possible_map) is executed. So later on, when ï»¿_cpu_up> calls ï»¿__raw_notifier_call_chain at the second time to report CPU_UP_CANCELED,> because this cpu is already cleared from ï»¿cpu_possible_map, get_cpu_sysdev returns> NULL.
Ahhha! Well done!
(Whew, I have a lot to learn :-D)
>> Many resources are related to ï»¿cpu_possible_map, so it's better not to change it.>> Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in ï»¿cpu_possible_map.>> Vegard, would you like to help test it?
Sure, but it can take a while. 1) I have no idea why the processorfailed to initialize in the first place. So far, it only ever happenedthis one time. 2) There seems to be a couple of other failure casesrelated to cpu hotplug (usually the machine freezes hard), so it's notcertain that we hit this (failed to initialize) first. But I will try!
Thanks for solving the mystery.

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
