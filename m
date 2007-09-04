Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbXIDQpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbXIDQpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXIDQp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:45:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:35789 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbXIDQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PUe3EA4VPEeaf91nEKytXB6qD4tIXCdTZrnurhPZMQKOt2QJWTHyIm4im3lgQk1ErjKP3lKOCkPOTHNpI+6ZZoBg7MfXYxIx0RUpAj7vtDc4Xy8idsiMSfyRbprV9YC/cRg8/NSP3wksTFNIveor+rir4jLN9ECvRn+ehLGLfKc=
Message-ID: <379fb4870709040945ve834f9djf4772ec6166bb7ff@mail.gmail.com>
Date: Tue, 4 Sep 2007 18:45:23 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: albert.neu@gmail.com
Subject: Re: Race condition: calling remove_proc_entry in cleanup_module (module_exit) while someone's using procfile
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/07, anon... anon.al <anon.asdf@gmail.com> wrote:
<snip>
> If yes: which mechanism can be used?

I was thinking about using an atomic counter in procfile_write

  proc_f = create_proc_entry(PROC_FILE_NAME, 0644, NULL);
  //...
  proc_f->write_proc = procfile_write;

int procfile_write(struct file *filp, const char *buffer, \
		   unsigned long len, void *data)
{
  //"StackXXX"
  atomic_inc(&cnt_procfile_users);

  printk(KERN_ALERT "Hi there!\n");

  atomic_dec(&cnt_procfile_users);
  wake_up_interruptible(&queue);
  return len;
}

and then in cleanup_module using:

wait_event_interruptible(queue,           \
(                                         \
 spin_lock_irqsave(&lock, flags),	  \
 cnt = atomic_read(&cnt_procfile_users),  \
 ((cnt == 0)                              \
  ? 1					  \
  : (spin_unlock_irqrestore(&lock, flags), 0))\
));
remove_proc_entry(PROC_FILE_NAME, &proc_root);
spin_unlock_irqrestore(&lock, flags);

But:
x1)
Could it happen that code is already in function procfile_write at "StackXXX"
(before atomic_inc(&cnt_procfile_users)) when the scheduler switches
to another task??
((Or is the "entering into a function, up to the function's first
statement" atomic??))

x2)
Could it happen that the scheduler switches, after
atomic_dev(&cnt_procfile_users) but before
return len??

If so, then it could happen that we're in spin_lock_irqsave, while
someone else is still using the procfile; and then this code still
fails miserably.
?

Regards -Albert
