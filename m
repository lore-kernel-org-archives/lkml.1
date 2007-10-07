Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXJGLPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXJGLPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 07:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXJGLPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 07:15:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:50361 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbXJGLPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 07:15:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rRuPn5oNJ+H5RivvVzKqzBn0IOOnExbl4ITrBnWF4OyUCjgg6RJYmSAVAHaoj8PVUn7+HfZ+mwRJsi+YbopT0LkLQeCh+MGg1+DXO/ahon4F6aKr8/PxT0gPnGzAMXRusRkStf2GYDQnpDGYqc++qqshE8qW/2sB6x7+JQ3RtJo=
Subject: Re:Sleeping in RCU list traversal
From: Jun WANG <junwang1234@gmail.com>
To: penguin-kernel@i-love.sakura.ne.jp
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: HITSZ
Date: Mon, 08 Oct 2007 03:11:47 +0800
Message-Id: <1191784307.3618.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
>Something like this?
>
>rcu_read_lock();
>list_for_each_rcu(p, ...) {
>   ptr = list_entry(p, struct ..., list);
>   /* Grab a reference to "ptr". */
>   rcu_read_unlock();
>   my_task_that_may_sleep(ptr);
>   rcu_read_lock();
>   /* Drop a reference to "ptr". */
 >}
 >rcu_read_unlock();

>Regarding my case, memory region pointed by "ptr" never be removed.
>Do I need to grab a reference to "ptr" ?
In Document/RCU/whatisRCU.txt
Note that the value returned by rcu_dereference() is valid
	only within the enclosing RCU read-side critical section.
	For example, the following is -not- legal:

		rcu_read_lock();
		p = rcu_dereference(head.next);
		rcu_read_unlock();
		x = p->address;
		rcu_read_lock();
		y = p->data;
		rcu_read_unlock();

	Holding a reference from one RCU read-side critical section
	to another is just as illegal as holding a reference from
	one lock-based critical section to another!  Similarly,
	using a reference outside of the critical section in which
	it was acquired is just as illegal as doing so with normal
	locking.
                                                            Jun Wang

