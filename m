Return-Path: <linux-kernel-owner+w=401wt.eu-S1423032AbXDTKUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423032AbXDTKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423037AbXDTKUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:20:42 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:10679 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423032AbXDTKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:20:41 -0400
Message-ID: <462893F4.1000005@fr.ibm.com>
Date: Fri, 20 Apr 2007 12:20:36 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: devel@openvz.org
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph@smtp2.linux-foundation.org, Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org, Hellwig <hch@infradead.org>,
       containers@lists.osdl.org, Marcel@smtp2.linux-foundation.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [Devel] Re: [PATCH] bluetooth bnep: Convert to kthread API.
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org>
In-Reply-To: <20070419162459.af7a182c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 19 Apr 2007 01:58:51 -0600
> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> 
>> From: Eric W. Biederman <ebiederm@xmission.com>
>>
>> This patch starts kbenpd using kthread_run replacing
>> a combination of kernel_thread and daemonize.  Making
>> the code a little simpler and more maintainable.
>>
>>
> 
> 	while (!atomic_read(&s->killed)) {
> 
> ho hum.


yes. we need something like :

-       while (!atomic_read(&s->killed)) {
+       while (1) {
                try_to_freeze();
 
                set_current_state(TASK_INTERRUPTIBLE);
 
+               if (atomic_read(&s->killed))
+                       break;
+

I have an old patch for this driver. I'll refresh it.

>> +	task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);
> 
> It's unusual to have a kernel thread which has a space in its name.  That
> could trip up infufficient-defensive userspace tools.

but we can't just change it, can we ? i could be used by a user space tool 
to check if the thread is running.

C.
