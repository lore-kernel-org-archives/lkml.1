Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbYGJTKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbYGJTKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYGJTKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:10:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:36796 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYGJTKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O5EjDCZ0Zs+uh85uXe41ZLHg/DAfvgB+egJ5AWful1XaPfFsj9a9f02lvzPLTMHK4b
         2a/nHeR0sTMbnNZNGri+vq3vpsURmnZdJMkrD5YmXZO2ZMMAllWLY6dpSxkZEGkIaIq3
         O+ei45zFCppBerobP0sEqwwq55GfpBdqP3iao=
Message-ID: <19f34abd0807101210t4043de1en59cd2e64b13d259a@mail.gmail.com>
Date: Thu, 10 Jul 2008 21:10:41 +0200
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6AJAufq004339

On Tue, Jun 24, 2008 at 10:06 AM, Zhang, Yanmin<yanmin_zhang@linux.intel.com> wrote:> In function _cpu_up, the panic happens when calling __raw_notifier_call_chain> at the second time. Kernel doesn't panic when calling it at the first time. If> just say because ï»¿of nr_cpu_ids, that's not right.>> By checking source codes, I find function do_boot_cpu is the culprit.> Consider below call chain:>  _cpu_up=>__cpu_up=>smp_ops.cpu_up=>native_cpu_up=>do_boot_cpu.>> So ï»¿do_boot_cpu is called in the end. In ï»¿do_boot_cpu, if boot_error==true,> cpu_clear(cpu, cpu_possible_map) is executed. So later on, when ï»¿_cpu_up> calls ï»¿__raw_notifier_call_chain at the second time to report CPU_UP_CANCELED,> because this cpu is already cleared from ï»¿cpu_possible_map, get_cpu_sysdev returns> NULL.>> Many resources are related to ï»¿cpu_possible_map, so it's better not to change it.>> Below patch against 2.6.26-rc7 fixes it by removing the bit clearing in ï»¿cpu_possible_map.>> Vegard, would you like to help test it?
Yay! I just hit this again with your patch applied
Inquiring remote APIC #1...... APIC #1 ID: failed... APIC #1 VERSION: failed... APIC #1 SPIV: failed
and it works correctly, no NULL pointer error this time :-)
I know it's applied to mainline already, actually with this tag too,even though I wasn't able to confirm it before:
    Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Thanks :-)

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
