Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbZFBGwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbZFBGwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZFBGwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:52:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33070 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbZFBGwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:52:04 -0400
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-4-git-send-email-ebiederm@xmission.com>
	<84144f020906012216n715a04d0ha492abc12175816@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Jun 2009 23:51:56 -0700
In-Reply-To: <84144f020906012216n715a04d0ha492abc12175816@mail.gmail.com> (Pekka Enberg's message of "Tue\, 2 Jun 2009 08\:16\:44 +0300")
Message-ID: <m1ws7vyvoz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: penberg@cs.helsinki.fi, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, npiggin@suse.de, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@cs.helsinki.fi> writes:

> Hi Eric,
>
> On Tue, Jun 2, 2009 at 12:50 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> +#ifdef CONFIG_FILE_HOTPLUG
>> +
>> +static bool file_in_use(struct file *file)
>> +{
>> +       struct task_struct *leader, *task;
>> +       bool in_use = false;
>> +       int i;
>> +
>> +       rcu_read_lock();
>> +       do_each_thread(leader, task) {
>> +               for (i = 0; i < MAX_FILE_HOTPLUG_LOCK_DEPTH; i++) {
>> +                       if (task->file_hotplug_lock[i] == file) {
>> +                               in_use = true;
>> +                               goto found;
>> +                       }
>> +               }
>> +       } while_each_thread(leader, task);
>> +found:
>> +       rcu_read_unlock();
>> +       return in_use;
>> +}
>
> This seems rather heavy-weight. If we're going to use this
> infrastructure for forced unmount, I think this will be a problem.

> Can't we two this in two stages: (1) mark a bit that forces
> file_hotplug_read_trylock to always fail and (2) block until the last
> remaining in-kernel file_hotplug_read_unlock() has executed?

Yes there is room for more optimization in the slow path.
I haven't noticed being a problem yet so I figured I would start
with stupid and simple.

I can easily see two passes.  The first setting the flag an calling
f_op->dead.  The second some kind of consolidate walk through the task
list, allowing checking on multiple files at once.

I'm not ready to consider anything that will add cost to the fast
path in the file descriptors though.

Eric
