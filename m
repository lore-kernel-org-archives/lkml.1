Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbZAQOHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbZAQOHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZAQOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:07:38 -0500
Received: from mail-bw0-f18.google.com ([209.85.218.18]:63185 "EHLO
	mail-bw0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZAQOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tIu/qw8vf4Xczk8ss64ExDc5KWy0j+DrauYLzxj98PUCN/ncHJvWZnI4/gcA7C71dY
         H8iXgtM4QwqqBevAzqQ+WtP7c/ZmOhYhOuBSVOSaxdfaEQd226CIWdr3Kx3TkYBcKVAl
         0xiVBebBrdTwVziBX8V+/77xWVfpKLrFMhehs=
Date: Sat, 17 Jan 2009 15:07:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v2] softlockup: decouple hung tasks check from
	softlockup detection
Message-ID: <20090117140731.GC8413@nowhere>
References: <20090112065213.GA19795@google.com> <c62985530901160858j3a8cd7b9o216cda473bc585e9@mail.gmail.com> <20090117041330.GE14946@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090117041330.GE14946@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 08:13:30PM -0800, Mandeep Singh Baines wrote:
> Hi Frédéric,
> 
> Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> > > -       read_lock(&tasklist_lock);
> > > -       do_each_thread(g, t) {
> > > -               if (!--max_count)
> > > -                       goto unlock;
> > 
> > 
> > Instead of having this arbitrary limit of tasks, why not just
> > lurk the need_resched() and then schedule if it needs too.
> > 
> > I know that sounds a bit racy, because you will have to release the
> > tasklist_lock and
> > a lot of things can happen in the task list until you become resched.
> > But you can do a get_task_struct() on g and t before your thread is
> > going to sleep and then put them
> > when it is awaken.
> > Perhaps some tasks will disappear or be appended in the list before g
> > and t, but that doesn't really matter:
> > if they disappear, they didn't lockup, and if they were appended, they
> > are not enough cold to be analyzed :-)
> > 
> > This way you can drop the arbitrary limit of task number given by the user....
> > 
> > Frederic.
> > 
> 
> Would be nice to remove the limit. But I don't think get_task_struct()
> can be used to prevent a task from being unlinked from the task list. It
> only prevents the task_struct from being freed. So hung_task could end up
> holding a reference to an unlinked task after it returns from schedule().
> 
> That doesn't mean what you are suggesting can't be implemented. Just means
> that the case of the held task being unlinked needs to be handled.
> 
> Regards,
> Mandeep

Hmm, you're right.
Why not testing 1024 tasks, then check need_resched and if you sleep
and the task becomes unlinked (there are few chances) so... that's not
a big deal actually, you will have better chances on the next check :-)

I think that's a bit important since you are more likely to see a
soft-lockup if you have a lot of tasks.

