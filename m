Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbZAQENz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbZAQENz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 23:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZAQENr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 23:13:47 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25302 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbZAQENq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 23:13:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=KRInxIz52Mg5ZEaRrkgJzcxG9LjCZQ1rs+eymLn7gEs+eqT3nSdxy5Z8e3V5Hx6vF
	+wPiy2va252cu4Vei+W2A==
Date: Fri, 16 Jan 2009 20:13:30 -0800
From: Mandeep Singh Baines <msb@google.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v2] softlockup: decouple hung tasks check from softlockup detection
Message-ID: <20090117041330.GE14946@google.com>
References: <20090112065213.GA19795@google.com> <c62985530901160858j3a8cd7b9o216cda473bc585e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901160858j3a8cd7b9o216cda473bc585e9@mail.gmail.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.88
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frédéric,

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> > -       read_lock(&tasklist_lock);
> > -       do_each_thread(g, t) {
> > -               if (!--max_count)
> > -                       goto unlock;
> 
> 
> Instead of having this arbitrary limit of tasks, why not just
> lurk the need_resched() and then schedule if it needs too.
> 
> I know that sounds a bit racy, because you will have to release the
> tasklist_lock and
> a lot of things can happen in the task list until you become resched.
> But you can do a get_task_struct() on g and t before your thread is
> going to sleep and then put them
> when it is awaken.
> Perhaps some tasks will disappear or be appended in the list before g
> and t, but that doesn't really matter:
> if they disappear, they didn't lockup, and if they were appended, they
> are not enough cold to be analyzed :-)
> 
> This way you can drop the arbitrary limit of task number given by the user....
> 
> Frederic.
> 

Would be nice to remove the limit. But I don't think get_task_struct()
can be used to prevent a task from being unlinked from the task list. It
only prevents the task_struct from being freed. So hung_task could end up
holding a reference to an unlinked task after it returns from schedule().

That doesn't mean what you are suggesting can't be implemented. Just means
that the case of the held task being unlinked needs to be handled.

Regards,
Mandeep
