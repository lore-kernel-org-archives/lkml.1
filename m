Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZKCKXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZKCKXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZKCKXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:23:13 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59489 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZKCKXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:23:12 -0500
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       Cosmin Ratiu <cratiu@ixiacom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: reduce ram usage by 40 %
References: <20091101163130.GA7911@kvack.org>
	<20091103035058.GA19515@kroah.com> <4AEFCA49.4020305@gmail.com>
	<4AEFD544.6040602@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Nov 2009 02:23:08 -0800
In-Reply-To: <4AEFD544.6040602@gmail.com> (Eric Dumazet's message of "Tue\, 03 Nov 2009 08\:01\:24 +0100")
Message-ID: <m1bpjjewkz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> Eric Dumazet a écrit :
>
>> Its curious because in my tests the biggest problems come from
>> kernel/sysctl.c (__register_sysctl_paths) consuming 80% of cpu
>> in following attempt to create 20.000 devices

I bet that is Al's cute glue all the sysctl data structures together
patch.  It improves readdir and lookup at a small cost at registration
time.

>> (disable hotplug before trying this, and ipv6 too !)
>> modprobe dummy numdummies=20000


>> I believe we should address __register_sysctl_paths() scalability
>> problems too.

Agreed.

>> I dont know what is the 'sentinel' we allocate after each struct ctl_table
>> But I suspect we could reduce size requirement of the 'sentinel' to include
>> only needed fields for the sentinel (and move them at start of ctl_table)

The sentinel is just a NULL terminator.

> Here is the patch to reduce ram usage of sysctl :
>
> [PATCH] sysctl: reduce ram usage by 40 %
>
> We currently reserve space for a so called sentinel, a full struct ctl_table
> for each ctl_table. We can cheat a bit since only needed fields of a sentinel
> are ctl_name and procname. Add a new structure (struct ctl_table_sentinel)
> that includes a full ctl_table and only required part of a sentinel.

Before we address sysctl I would like to get out my patchset that
makes sys_sysctl a wrapper around the ascii version of
/proc/sys/net. Once that goes in it becomes much easier to do things
and perform radical surgery on sysctl.  Little things like .ctl_name and
.strategy go away.

Have you happened to look at the other cost of /proc proper?  Hmm.
Except for /proc/net/dev_snmp6 it doesn't look like we keep per
interface directories in proc so without ivp6 you won't see the proc
generic code at all.

The practical consequence is if /proc/net/dev_snmp6 is not painful during
registration right now we can probably convert all of /proc/sys/net to proc
generic after my other changes are in.

Eric
