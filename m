Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbYAKQAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbYAKQAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbYAKQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:00:21 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54495 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760605AbYAKQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:00:18 -0500
Message-ID: <47879290.3040700@bull.net>
Date: Fri, 11 Jan 2008 17:00:16 +0100
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PROCFS] [NETNS] issue with /proc/net entries
References: <478654E1.5050501@bull.net> <m1ir21v4jv.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir21v4jv.fsf@ebiederm.dsl.xmission.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/01/2008 17:08:32,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/01/2008 17:08:35,
	Serialize complete at 11/01/2008 17:08:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Benjamin Thery <benjamin.thery@bull.net> writes:
> 
>> Hi Eric,
>>
>> While testing the current network namespace stuff merged in net-2.6.25,
>> I bumped into the following problem with the /proc/net/ entries.
>> It doesn't always display the actual data of the current namespace,
>> but sometime displays data from other namespaces.
>>
>> I bisected the problem to the commit:
>> "proc: remove/Fix proc generic d_revalidate"
>> 3790ee4bd86396558eedd86faac1052cb782e4e1
>>
>> The problem: If a process in a particular network namespace changes
>> current directory to /proc/net, then processes in other network
>> namespaces trying to look at /proc/net entries will see data from the
>> first namespace (the one with CWD /proc/net). (See test case below).
>>
>> As you comments in the commit suggest, you seem to be aware of some
>> issues when CONFIG_NET_NS=y. Is it one of these corner cases you
>> identified? Any idea on how we can fix it?
> 
> Yes.  It isn't especially hard.   I have most of it in my queue
> I just need to get the silly patches out of there.
> 
> Essentially we need to fix the caching of proc_generic entries,
> So that we can have a proper d_revalidate implementation.
> 
> To get d_revalidate and the caching correct for /proc/net will take
> just a bit more work.  We need to make /proc/net a symlink
> to something like /proc/self/net so that we don't get excess
> revalidates when switching between different processes.
> 
> Or else we can't properly implement the case you have described.
> Where being in the directory causes the wrong version of /proc/net
> to show up. Changing the contents of the dentry for /proc/net
> should only happen during unshare.  Not when we switch between
> processes or else we get into the d_revalidate leaks mount points
> problem again.
> 
> We also need the check to see if something is mounted on top of
> us before we call drop the dentry.  But if we don't even try until
> we know the dentry is invalid it should not be too bad.

Thanks for all the details.
I'll put this issue on my "netns current limitations" list until
it's solved.

Benjamin


> 
> Eric
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
