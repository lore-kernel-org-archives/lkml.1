Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYLKW5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYLKW5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759419AbYLKW4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:56:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:2439 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135AbYLKW4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:56:10 -0500
Message-ID: <ac3eb2510812111448s7c700199ia2e57834f91c02a@mail.gmail.com>
Date: Thu, 11 Dec 2008 23:48:32 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 12201] New: long wait in call_usermodehelper() / queue_work() / wait_for_completion()
Cc: mike@nauticaltech.com, bugme-daemon@bugzilla.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <20081211143758.510b51b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-12201-10286@http.bugzilla.kernel.org/>
	 <20081211143758.510b51b6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 23:37, Andrew Morton <akpm@linux-foundation.org> wrote:
>> As I continued to dig deeper (using lots of printks), I found that these delays
>> were caused by the netlink_create() code calling request_module() to find/load
>> a module for AUDIT support which doesn't exist.
>>
>> Continuing to dig, I found that request_module() uses call_usermodehelper() to
>> run /sbin/modprobe to find/load the module.
>>
>> The farthest I got is that after the process is created, we call
>> wait_for_completion() to get the result of that process.  This waiting process
>> takes 1-2 seconds.
>>
>> The big problem in troubleshooting here is that this only starts to happen
>> after the server has been online for a while (10 days maybe) and serving lots
>> of traffic.  The delay gradually builds up and maxes out at around 2 seconds.
>>
>> If I manually call /sbin/modprobe on the commandline and provide it the same
>> arguments that call_usermodehelper() uses, the command returns instantly 100%
>> of the time (assuming server has been on for a while).
>>
>> If I write a small pilot program that calls socket(PF_NETLINK, SOCK_RAW,
>> NETLINK_AUDIT), it will delay by 1-2 seconds 100% of the time (assuming server
>> has been online for a while).  Certain protocol types given to socket() have
>> zero delay (because no module needs to be loaded).
>>
>> Steps to reproduce:
>> Once server has been online for a while, a simple call to socket(PF_NETLINK,
>> SOCK_RAW, NETLINK_AUDIT) shows the problem.

If you replace /sbin/modprobe in the kernel module loader, does the
delay go away:
  echo /bin/true > /proc/sys/kernel/modprobe
?

Kay
