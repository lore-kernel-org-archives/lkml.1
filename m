Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZGETrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZGETrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZGETqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:46:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZGETqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:46:54 -0400
Date: Sun, 5 Jul 2009 21:46:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Renninger <trenn@suse.de>
Cc: kernel@stable.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rjw@sisk.pl, hidave.darkstar@gmail.com,
       penberg@cs.helsinki.fi, kernel-testers@vger.kernel.org,
       davej@redhat.com, mathieu.desnoyers@polymtl.ca,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] CPUFREQ: Remove unneeded dbs_mutexes from ondemand
	and conservative governors
Message-ID: <20090705194646.GF17910@elf.ucw.cz>
References: <20090623193215.GA31374@elte.hu> <1245938485-12663-2-git-send-email-trenn@suse.de> <20090630063339.GF1351@ucw.cz> <200907031210.16828.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907031210.16828.trenn@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-03 12:10:15, Thomas Renninger wrote:
> Hi Pavel,
> 
> On Tuesday 30 June 2009 08:33:39 Pavel Machek wrote:
> > On Thu 2009-06-25 16:01:24, Thomas Renninger wrote:
> > > Comment from Venkatesh:
> > > ...
> > > This mutex is just serializing the changes to those variables. I could't
> > > think of any functionality issues of not having the lock as such.
> > > 
> > > -> rip it out.
> > > 
> > > CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > Signed-off-by: Thomas Renninger <trenn@suse.de>
> > 
> > >  static struct dbs_tuners {
> > > @@ -236,10 +222,7 @@ static ssize_t store_sampling_down_factor(struct cpufreq_policy *unused,
> > >  	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
> > >  		return -EINVAL;
> > >  
> > > -	mutex_lock(&dbs_mutex);
> > >  	dbs_tuners_ins.sampling_down_factor = input;
> > > -	mutex_unlock(&dbs_mutex);
> > > -
> > 
> > You'd need to make s_down_factor atomic_t for this to work....
> Can you provide a userspace scenario (or tell which kind of event must
> happen in between), that this would cause problems, please.


Imagine 

dbs_tuners_ins.sampling_down_factor = 0xd0000;
input = 0xabcd;

..then other threads can see 0xdabcd; if they read at "bad"
moment. Not on i386, but this is generic code (right?). Just use
atomic_t.
									Pavel   

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
