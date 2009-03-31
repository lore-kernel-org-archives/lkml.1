Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZCaKHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZCaKHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZCaKHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:07:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:17047 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZCaKHe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QUCUE3kwwY0VEYKiIKDc3MYkDZ3Onnh56NCryQLGk12sg445UWeZ4VgRrl21iQr2Jg
         9qgYZtgXw7VDhMED7ohXy7IL+fgsEnO2vqVV3GIOMmAydjzwjPjJ6Q3HEVwjEHBT8n9C
         eqNFD5jGZnOllr3pyYIhEu/P7TIIOEW4iuUM0=
MIME-Version: 1.0
In-Reply-To: <20090331100150.GF11808@duck.suse.cz>
References: <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com>
	 <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
	 <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
	 <20090325152234.GN23439@duck.suse.cz>
	 <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
	 <20090325161556.GP23439@duck.suse.cz>
	 <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
	 <20090325194316.GQ23439@duck.suse.cz>
	 <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com>
	 <20090331100150.GF11808@duck.suse.cz>
Date: Tue, 31 Mar 2009 14:07:30 +0400
Message-ID: <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
Subject: Re: next-20090310: ext4 hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/31 Jan Kara <jack@suse.cz>:
> On Thu 26-03-09 01:38:32, Alexander Beregalov wrote:
>> 2009/3/25 Jan Kara <jack@suse.cz>:
>> > On Wed 25-03-09 20:07:46, Alexander Beregalov wrote:
>> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> > On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
>> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> >> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
>> >> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> >> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
>> >> >> >> >>   I've looked into this. Obviously, what's happenning is that we delete
>> >> >> >> >> an inode and jbd2_journal_release_jbd_inode() finds inode is just under
>> >> >> >> >> writeout in transaction commit and thus it waits. But it gets never woken
>> >> >> >> >> up and because it has a handle from the transaction, every one eventually
>> >> >> >> >> blocks on waiting for a transaction to finish.
>> >> >> >> >>   But I don't really see how that can happen. The code is really
>> >> >> >> >> straightforward and everything happens under j_list_lock... Strange.
>> >> >> >> >  BTW: Is the system SMP?
>> >> >> >> No, it is UP system.
>> >> >> >  Even stranger. And do you have CONFIG_PREEMPT set?
>> >> >> >
>> >> >> >> The bug exists even in 2.6.29, I posted it with a new topic.
>> >> >> >  OK, I've sort-of expected this.
>> >> >>
>> >> >> CONFIG_PREEMPT_RCU=y
>> >> >> CONFIG_PREEMPT_RCU_TRACE=y
>> >> >> # CONFIG_PREEMPT_NONE is not set
>> >> >> # CONFIG_PREEMPT_VOLUNTARY is not set
>> >> >> CONFIG_PREEMPT=y
>> >> >> CONFIG_DEBUG_PREEMPT=y
>> >> >> # CONFIG_PREEMPT_TRACER is not set
>> >> >>
>> >> >> config is attached.
>> >> >  Thanks for the data. I still don't see how the wakeup can get lost. The
>> >> > process even cannot be preempted when we are in the section protected by
>> >> > j_list_lock... Can you send me a disassembly of functions
>> >> > jbd2_journal_release_jbd_inode() and journal_submit_data_buffers() so that
>> >> > I can see whether the compiler has not reordered something unexpectedly?
>> >  Thanks for the disassembly...
>> >
>> >> By default gcc inlines journal_submit_data_buffers()
>> >> Here is -fno-inline version. Default version is in attach.
>  <snip>
>
>  I'm helpless here. I don't see how we can miss a wakeup (plus you seem to
> be the only one reporting the bug). Could you please compile and test the kernel
> with the attached patch? It will print to kernel log when we go to sleep
> waiting for inode commit and when we send wakeups etc. When you hit the
> deadlock, please send me your kernel log. It should help with debugging why do
> we miss the wakeup. Thanks.

Which patch?
