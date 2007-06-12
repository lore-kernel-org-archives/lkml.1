Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbXFLMnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbXFLMnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXFLMnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:43:08 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:49236 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755311AbXFLMnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:43:07 -0400
Message-Id: <466EB12B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 14:43:55 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: fix improper .init-type section references
References: <466E6BDF.76E4.0078.0@novell.com>
 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
In-Reply-To: <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> The cacheinfo_cpu_notifier itself is called out from _cpu_down() which
>> is ... yep, *not* __cpuinit (and obviously *cannot* be so). _cpu_down()
>> is called from cpu_down() which is (thankfully!) protected inside
>> #ifdef CONFIG_HOTPLUG_CPU, so we've /just about/ escaped trouble
>> so far, but another of it's callers is disable_nonboot_cpus() which does
>> *not* depend on HOTPLUG_CPU, but is #ifdef'ed inside SUSPEND_SMP
>> (gargh!) instead, and ... is _not_ __cpuinit either (obviously, again).
>
>Wait, SUSPEND_SMP again depends on HOTPLUG_CPU, so there
>are no issues here in marking cache_remove_dev() __cpuexit
>(which effectively simply becomes #ifdef HOTPLUG_CPU) as all
>callsites that call out the notifier with CPU_DEAD/FROZEN are also
>going to be disabled. [ Ok, looks like using __cpuexit as this kind of
>pseudo-#ifdef HOTPLUG_CPU is a standard practice? ]
>
>But modpost will still complain (bogus warning) about calling __exit
>from __init (when HOTPLUG_CPU=n) for cacheinfo_cpu_callback()
>calling cache_remove_dev(), no?

No, it doesn't, at least not for me. And from a purely theoretical
perspective I don't think such references should be considered bad -
.exit.* should be discarded together with .init.* if unloading is
impossible (built-in or configured off), not before module/kernel
initialization. This is specifically because init code may want to utilize
exit code in case of initialization failure.

Jan

