Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbXKTWzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbXKTWzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXKTWzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:55:45 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59193 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbXKTWzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:55:44 -0500
From: ebiederm@xmission.com (Er ic W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Futexes and network filesystems.
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	<4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
	<472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
	<20071102010419.23f3db5c.akpm@linux-foundation.org>
	<1194024622.6271.108.camel@localhost>
	<alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
	<20071103201251.GB26366@elte.hu>
Date: Tue, 20 Nov 2007 15:53:52 -0700
In-Reply-To: <20071103201251.GB26366@elte.hu> (Ingo Molnar's message of "Sat,
	3 Nov 2007 21:12:51 +0100")
Message-ID: <m1ir3wr0jj.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Fri, 2 Nov 2007, Dave Hansen wrote:
>> > 
>> > There are certainly more of these, but here is one In the futex 
>> > userspace address, we install the current pid's vnr into a userspace 
>> > address.
>> 
>> Now, realistically, why not just say "you can't use these things 
>> across namespaces"? Does anybody really care? After all, somebody who 
>> screws this up only screws himself, not anybody else.
>
> i see two main categories of problems:
>
> - one problem is that this condition is 'invisible'.
>
> - so via this we isolate an important category of syscalls from
>   cross-namespace use perhaps forever.

I had a chance to think about this a bit more, and realized that
the problem is that futexes don't appear to work on network
filesystems, even if the network filesystems provide coherent shared
memory.

It seems to me that we need to have a call that gets a unique token
for a process for each filesystem per filesystem for use in futexes
(especially robust futexes).  Say get_fs_task_id(const char *path);

On local filesystems this could just be the pid as we use today, but
for filesystems that can be accessed from contexts with potentially
overlapping pid values this could be something else.  It is an extra
syscall in the preparation path, but it should be hardly more
expensive the current getpid().

Once we have fixed the futex infrastructure to be able to handle
futexes on network filesystems, the pid namespace case will be trivial
to implement.

Eric




