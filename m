Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYFCV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYFCV77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYFCV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYFCV7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:59:47 -0400
Message-ID: <4845BDDC.8060807@redhat.com>
Date: Tue, 03 Jun 2008 17:55:40 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: chris@linuxinfotag.de
CC: linux-kernel@vger.kernel.org
Subject: Re: "core dump helper" runs always as root
References: <20080603182040.GB20582@silmor.de>
In-Reply-To: <20080603182040.GB20582@silmor.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Perle wrote:
> Hi *
> 
> I recently played around with the /proc/sys/kernel/core_pattern file
> (2.6.24.7 and 2.6.25) and found out that processes started by the
> "|/path/to/executable" notation always run as root, even if the
> segfaulting process runs as non-root.
> 
> Is there a reason for this behaviour? If not, i would suggest starting the
> process which receives the core dump on stdin as the same UID of the
> segfaulting process.
> 
> With the current behaviour you can do funny things:
> 
> (as root)
> # echo "|/bin/chmod 4755 /bin/ash" > /proc/sys/kernel/core_pattern
> 
> (as user)
> $ sleep 2 & kill -11 $!
> 
> Of course this is *not* a local root exploit because you need to be root
> to write to the proc entry, but IMHO running the "core dump helper" (is
> there a better name for this?) always as root is potentially harmful.
> 
> 
> Greetings,
>   Chris

If we run the usermode helper with the privileges of the dying process, what do 
we do about rlimit enforcement?  They don't have a PAM environment, so either 
they get the default rlimits, or we have to make them inherit their limits from 
the dying process.  This is very problematic if the process died due to 
exceeding an rlimit.

Userspace is the best place to resolve complex policy issues.  If it makes you 
uncomfortable having your coredump helper run as root, you can implement 
privilege separation in it, and any arbitrary code you see fit to resolve the 
rlimit dilemma.

Personally, I would not be opposed to honoring setuid permissions for usermode 
helpers, as this maintains the separation of policy and mechanism, and leaves no 
room for ambiguity about the intent of the system administrator.

-- Chris
