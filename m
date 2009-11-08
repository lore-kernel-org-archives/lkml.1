Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZKHLK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZKHLK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZKHLKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:10:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57736 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZKHLKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:10:54 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Sun, 8 Nov 2009 16:40:07 +0530
Subject: RE: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Thread-Topic: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Thread-Index: AcpgTVaASJDYUgXzQRWGBdLZe30rpgAFqLGA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE31FD10@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
 <20091107165421.GA1630@ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FCF1@dbde02.ent.ti.com>
 <20091108082727.GC16482@elf.ucw.cz>
In-Reply-To: <20091108082727.GC16482@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with 80 column restriction) 

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz] 
> Sent: Sunday, November 08, 2009 1:57 PM
> To: Dasgupta, Romit
> Cc: Rafael J. Wysocki; linux-omap@vger.kernel.org; 
> linux-kernel@vger.kernel.org; linux-pm@lists.linux-foundation.org
> Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be 
> exited kernel threads
> 
> On Sun 2009-11-08 09:52:52, Dasgupta, Romit wrote:
> > > Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be 
> exited kernel
> > > threads
> > > 
> > > Hi!
> > > 
> > > > Kicks out a frozen thread from the refrigerator when an 
> active thread has
> > > > invoked kthread_stop on the frozen thread.
> ...
> > > > @@ -49,7 +50,7 @@ void refrigerator(void)
> > > >
> > > >  	for (;;) {
> > > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > > > -		if (!frozen(current))
> > > > +		if (!frozen(current) || (!current->mm 
> && kthread_should_stop()))
> > > >  			break;
> > > >  		schedule();
> > > 
> > > Well, what if the thread does some processing before 
> stopping? That
> > > would break refrigerator assumptions...
> > 
> > The suspend thread will block until the 'to be stopped' 
> thread clears up. That is what any call to kthread_stop would 
> boil down to. The target thread would anyway be out of the 
> refrigerator so I am not sure what assumption you mean here. 
> Eventually, the target thread would clear up and wake up the 
> suspend thread and then things would go on as usual.
> 
> (Please format to 80 columns).
> 
> No, I do not get it.
> 
> Lets say we have
> 
> evil_data_writer thread that needs to be stopped becuase it writes to
> filesystem
> 
> nofreeze random_stopper thread
> 
> now we create the suspend image, and start writing it out. But that's
> okay, evil_data_writer is stopped so it can't do no harm. But now
> random_stopper decides to thread_stop() the evil_data_writer, and this
> new code allows it to exit the refrigerator, *do some writing*, and
> then stop.
> 
> That's bad, right?
evil_data_writer will enter refrigerator after invoking 'try_to_freeze'. This 
should be followed by a call to kthread_should_stop. There it decides if it 
needs to exit the thread (after cleanups if necessary) or not. I have seen that
the bdi_writeback_task function is like that. It does not care if there is 
pending data to be written if it detects that someone have invoked a 
'kthread_stop' on it. It simply exits. I have seen some other kernel threads 
that do not follow this and I think that probably is not right. 
