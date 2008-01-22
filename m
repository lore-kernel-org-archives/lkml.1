Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYAVTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYAVTfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYAVTfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:35:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:42031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYAVTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=V2mZ7+0Z0FSfxv4q/6x2J0bBYV/KmfG8W/MqS24NT+J/F+FpH4+qNgFoDSUu5c4sapf/t++BZmQU/mC4W//K52AEZgajWQ3j2jtodiAB0y45d47VxkVmEm42LB+IlB9eg79HLuvKtD0wbMO8Mvfi/SGhHONAOfzEKh5r4GmVEsA=
Message-ID: <47964572.2060002@gmail.com>
Date: Tue, 22 Jan 2008 21:35:14 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange interaction between latencytop and the scheduler
References: <47962DD1.9050800@gmail.com> <47963E2E.9020501@linux.intel.com>
In-Reply-To: <47963E2E.9020501@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Török Edwin wrote:
>> Is this normal? (is overhead really 40msec?)
>
> I'm seeing similar, I would not rule out that this is actual scheduler
> behavior ;(
> at least it seems consistent.

Ok, it is good that we are seeing same behaviour.

> I also made a patch (to lkml yesterday) that counts the total and
> count of scheduler latencies
> to also show the cumulative effect of these latencies
Found it: http://lkml.org/lkml/2008/1/21/223.
I'll try it the next days. Do you want me to report results? [and
especially, should I Cc: Ingo Molnar on the report?]
>
>> I was also seeing an unusually high number of context switches (as shown
>> by vmstat), I usually have 400-800 with non-patched kernels (while
>> running mplayer too), but I was getting steadily over 1100 with the
>> patch (on idle system).
>
> that's weird; there's nothing blocking in the entire patch at all.
> (the only lock is a spinlock)

Maybe the overhead of latencytop is triggerring other behaviour in the
scheduler? Just a guess.
Are there any tests I can run to see why there are more context switches?

>
> The performance aspect... collecting the data isn't cheap (which is
> why it's made a sysctl),
> I still plan to look at optimizing it but it won't ever be free.

Yes, I understand that. Is there a way latencytop could track its own
overhead? I suppose it would lead to more accurate results
(not that there would be anything wrong with the current ones).
>
>> * I compile without CONFIG_SCHED_DEBUG, I no longer get *any* latency
>> from the scheduler, even if I run multi-threaded programs, etc. Is this
>> to be expected? (i.e. is this feature available only when enabling
>> CONFIG_SCHED_DEBUG?)
>
> afaik yes.

Ok.

>> * percentages: new feature (nice!), but the values seem all wrong
>> (global perc. are always wrong, per app perc. are usually ok, but see
>> second example below)
> Some minor latencytop userspace issues:
>
> note that the percentages are percentage this entry had compared the
> total sum of latencies.
> The maximum entry is only loosely related to that; say you have 1
> latency in "foo" for 100ms
> but 900 of 1ms in "bar", "foo" will show 10% and "bar" will show 90%

Thanks, that explains it. Looks like a good substitute for the average
column.
This is the functionality I was missing, when that column went away.
Still, I wouldn't mind to see the average column too (maybe activated
via a hotkey, or shown only if enough screenspace is available?).

>
>> * I miss the Average latency column. If it is too costly to keep account
>> of an overall average, can we have last N second average?
>
> it's not costly to calculate, it's the screen space versus the value
> of the information :(

If I stretch my terminal window there's room for 2 or 3 more columns :)

>
>> * unknown reasons show a backtrace, but backtrace doesn't have enough
>> room on screen
>
> still working on that; you can pass the --unknown option to dump these
> so that I can add them
> to the translation table.

I gathered these while writing this reply:

Unknown: put_device elv_insert blk_plug_device default_wake_function
blk_execute_rq blk_rq_bio_prep blk_rq_append_bio blk_rq_map_user sg_io
scsi_cmd_ioctl ip_queue_xmit tcp_transmit_skb
Unknown: md_thread autoremove_wake_function md_thread md_thread kthread
child_rip kthread child_rip
Unknown: kswapd autoremove_wake_function kswapd kswapd kthread child_rip
kthread child_rip


Best regards,
--Edwin
