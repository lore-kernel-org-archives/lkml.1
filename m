Return-Path: <linux-kernel-owner+w=401wt.eu-S933863AbZHHJaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863AbZHHJaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933819AbZHHJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:30:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:49978 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbZHHJ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:29:59 -0400
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <m1tz0idc5b.fsf@fess.ebiederm.org>
References: <1249676830.27640.16.camel@wall-e>
	 <20090807135806.ffd068e9.akpm@linux-foundation.org>
	 <1249681387.17422.10.camel@wall-e>
	 <20090807151657.d577dd2d.akpm@linux-foundation.org>
	 <m1tz0idc5b.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 11:29:52 +0200
Message-Id: <1249723792.31457.14.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.08.2009, 23:59 -0700 schrieb Eric W. Biederman:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Fri, 07 Aug 2009 23:43:07 +0200
> > Stefani Seibold <stefani@seibold.net> wrote:
> >
> 
> >> So what is your suggestion? Should we drop this patch or should we
> >> analyze the users and fix it?
> >
> > Well.
> >
> > We could review all implementations of ->write_proc.  There only seem
> > to be twenty or so.
> >
> > If any of them will have their behaviour altered by this patch then
> > let's look at those on a case-by-case basis and decide whether making
> > this change will have an acceptable risk.
> >
> > If we _do_ find one for which we simply cannot make this behavioural
> > change then..  ugh.  We could perhaps add a new `bool
> > proc_dir_entry.implement_old_broken_behaviour' and set that flag for
> > the offending driver(s) and test it within proc_write_file().
> >
> > Or we could do
> >
> > 	if (pde->write_proc_new) {
> > 		rv = pde->write_proc_new(file, buffer, count, pde->data);
> > 		*ppos += rv;
> > 	} else {
> > 		rv = pde->write_proc(file, buffer, count, pde->data);
> > 	}
> >
> > which is really the same thing and isn't obviously better ;)
> >
> >> My opinion is to fix it, because it is wrong and it limits the usage of
> >> the proc_write operation. Many embedded developers like me count on proc
> >> support, because it is much simpler to use than the seqfile thing.
> 
> The simple and portable answer is to implement your own file_operations.
> 

This is what i still doing since a long time:

<CodeSnip>
 proc_entry = create_proc_entry(procname, S_IRUGO|S_IWUGO, NULL);

 proc_entry->read_proc = proc_read_foo;

 bar->proc_file_operations.llseek = proc_entry->proc_fops->llseek;
 bar->proc_file_operations.read = proc_entry->proc_fops->read;
 bar->proc_file_operations.write = proc_write_foo;

 proc_entry->proc_fops = &bar->proc_file_operations;
</CodeSnip>

This works very well for me, but it requires some additional step
because of the buggy interface.

But the question is: can we fix this bug? 

I will have a look on the current users of proc->write and if there are
no driver which is depending on the old behavior we can fix it. 
   
> It is unlikely that implementing a new totally unstructured proc file is
> a good idea.
> 

That is your opinion. I still use it f.e. to access a eeprom.
 
> I'm not quite up to speed on write_proc but I believe we have been spraying
> read_proc and write_proc because of problems with the interface.
> 

First: I never noticed a problem with the current proc interface. The
only issue i figured out is the proc_write ppos problem.

Second: If speed matters or not is a question of the use case. Sometimes
a simple solution is required.  

Stefani


