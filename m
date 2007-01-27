Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358AbXA0TUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbXA0TUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 14:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXA0TUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 14:20:37 -0500
Received: from styx.suse.cz ([82.119.242.94]:58860 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752356AbXA0TUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 14:20:36 -0500
Date: Sat, 27 Jan 2007 20:20:34 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070127192034.GA17652@suse.cz>
References: <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz> <873b61cf1v.fsf@gmx.it> <20070126171536.GB964@elf.ucw.cz> <878xfpoeom.fsf@gmx.it> <20070127174525.GA4787@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127174525.GA4787@ucw.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 05:45:25PM +0000, Pavel Machek wrote:
> Hi!
> 
> >    Well, I do not think your kernel code is mergeable. But bits to enable
> >    similar functionality in userspace probably would be mergeable.
> > 
> > You said it :-)
> > 
> > This patch exports to the user space the inactivity time (in msecs) of a given
> > input device. Example follows:
> 
> Looks okay to me. I guess you should sign it off, and ask Dmitry
> (input maintainer) for a merge?

The /proc/bus/input/devices has an extensible structure. You can just
add an "A:" line (for Activity) instead of adding a new proc file.
Anyway, I believe this should be also available through sysfs, if not
only there.

Also, the activity counters should IMO coincide with the event times
passed through /dev/input/event, and should not be jiffies based.
Ideally, both should be based on clock_gettime(CLOCK_MONOTONIC).

> > <0> $ cat /proc/bus/input/activity
> > 0011 0001 0001 ab41     1
> > 0011 0002 0008 0000     3160799
> > 0011 0002 0008 7321     549991
> > 0019 0000 0005 0000     3160799
> > 0019 0000 0001 0000     3454901
> > 0010 104d 0000 0000     3160799
> > 0010 104d 0000 0000     2162833
> > 
> > The device ordering matches the /proc/bus/input/devices one, anyway I reported
> > also vendor, product, etc. Now the daemon is trivial...
> 
> > @@ -482,6 +484,30 @@
> >  	return seq_open(file, &input_devices_seq_ops);
> >  }
> >  
> > +static int input_activity_seq_show(struct seq_file *seq, void *v)
> > +{
> > +	struct input_dev *dev = container_of(v, struct input_dev, node);
> > +
> > +	seq_printf(seq, "%04x %04x %04x %04x\t%u\n",
> > +		   dev->id.bustype, dev->id.vendor,
> > +		   dev->id.product, dev->id.version,
> > +		   jiffies_to_msecs((long) jiffies - (long) dev->last_activity));
> > +
> > +	return 0;
> > +}
> > +
> > +static struct seq_operations input_activity_seq_ops = {
> > +	.start	= input_devices_seq_start,
> > +	.next	= input_devices_seq_next,
> > +	.stop	= input_devices_seq_stop,
> > +	.show	= input_activity_seq_show,
> > +};
> > +
> > +static int input_proc_activity_open(struct inode *inode, struct file *file)
> > +{
> > +	return seq_open(file, &input_activity_seq_ops);
> > +}
> > +
> >  static struct file_operations input_devices_fileops = {
> >  	.owner		= THIS_MODULE,
> >  	.open		= input_proc_devices_open,
> > @@ -491,6 +517,15 @@
> >  	.release	= seq_release,
> >  };
> >  
> > +static struct file_operations input_activity_fileops = {
> > +	.owner		= THIS_MODULE,
> > +	.open		= input_proc_activity_open,
> > +	.poll		= input_proc_devices_poll,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= seq_release,
> > +};
> > +
> >  static void *input_handlers_seq_start(struct seq_file *seq, loff_t *pos)
> >  {
> >  	/* acquire lock here ... Yes, we do need locking, I knowi, I know... */
> > @@ -558,15 +593,23 @@
> >  	entry->owner = THIS_MODULE;
> >  	entry->proc_fops = &input_devices_fileops;
> >  
> > -	entry = create_proc_entry("handlers", 0, proc_bus_input_dir);
> > +	entry = create_proc_entry("activity", 0, proc_bus_input_dir);
> >  	if (!entry)
> >  		goto fail2;
> >  
> >  	entry->owner = THIS_MODULE;
> > +	entry->proc_fops = &input_activity_fileops;
> > +
> > +	entry = create_proc_entry("handlers", 0, proc_bus_input_dir);
> > +	if (!entry)
> > +		goto fail3;
> > +
> > +	entry->owner = THIS_MODULE;
> >  	entry->proc_fops = &input_handlers_fileops;
> >  
> >  	return 0;
> >  
> > + fail3:	remove_proc_entry("activity", proc_bus_input_dir);
> >   fail2:	remove_proc_entry("devices", proc_bus_input_dir);
> >   fail1: remove_proc_entry("input", proc_bus);
> >  	return -ENOMEM;
> > diff -ur OLD/include/linux/input.h NEW/include/linux/input.h
> > --- OLD/include/linux/input.h	2007-01-26 16:59:38.000000000 +0100
> > +++ NEW/include/linux/input.h	2007-01-26 17:31:29.000000000 +0100
> > @@ -949,6 +949,8 @@
> >  	const char *uniq;
> >  	struct input_id id;
> >  
> > +	unsigned long last_activity;
> > +	
> >  	unsigned long evbit[NBITS(EV_MAX)];
> >  	unsigned long keybit[NBITS(KEY_MAX)];
> >  	unsigned long relbit[NBITS(REL_MAX)];
> 
> > 
> > -- 
> > I don't think anyone should write their autobiography until after they're
> > dead. - Samuel Goldwyn
> 
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

-- 
Vojtech Pavlik
Director SuSE Labs
