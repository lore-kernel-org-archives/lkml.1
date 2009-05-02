Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZEBVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZEBVbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 17:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZEBVbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 17:31:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:33265 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZEBVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 17:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kLakIvW++BqIdo54X7aILQTE4iCKINpo2oM80kOSZOzd57z3hYwAuHSiMD5YtCUBND
         yUZk4e8ArJN4aGz0K1dE0q0B0OrYnFAu+qJTJPB4j/uE06pPJ6D/j9OJ7PPscEzitDTN
         qKQKnuOvIhcQ8MC37dZ3Ol7R0aTPKOMisJm54=
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, Marc Pignat <Marc.Pignat@hevs.ch>,
       jkosina@suse.cz, ext-roger.quadros@nokia.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1241298873.4412.19.camel@localhost.localdomain>
References: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
	 <a8e1da0905020708j54cda260tac256469498f6ce3@mail.gmail.com>
	 <1241293366.4412.14.camel@localhost.localdomain>
	 <dd18b0c30905021319u79bc94d0ned9c6333e0408818@mail.gmail.com>
	 <1241295698.4412.15.camel@localhost.localdomain>
	 <1241298438.1864.1.camel@unix>
	 <1241298873.4412.19.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 02 May 2009 14:31:40 -0700
Message-Id: <1241299900.1826.1.camel@unix>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-02 at 14:14 -0700, Marcel Holtmann wrote:
> Hi Justin,
> 
> > > > >> >>> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
> > > > >> >>> >
> > > > >> >>> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
> > > > >> >>> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
> > > > >> >>> > and del_conn against each other.
> > > > >> >>> >
> > > > >> >>> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> > > > >> >>>
> > > > >> >>> Acked-by: Jiri Kosina <jkosina@suse.cz>
> > > > >> >>>
> > > > >> >>> FWIW.
> > > > >> >>
> > > > >> >>nak from my side since I think it is the wrong fix. We really wanna wait
> > > > >> >>for all works to finish here. This includes work from other connection
> > > > >> >>attempts or terminations.
> > > > >> >
> > > > >> > IMHO, there is no need to wait for work currently running, since this is a
> > > > >> > singlethread workqueue.
> > > > >>
> > > > >> Yes, sounds right.
> > > > >>
> > > > >> >
> > > > >> > But it is perhaps simpler to use a lock (mutex or watherver locking primitive).
> > > > >>
> > > > >> I'm here a little bit late. Marcel, I'm quite busy recently, I just
> > > > >> see the commit and then this thread.
> > > > >>
> > > > >> Let me explain why I add two workqueue originally,  because workqueue
> > > > >> will be defered, so   we must guarantee "connection deletion" finished
> > > > >> before "connection adding with same bt addr",  or the "connection
> > > > >> adding" will fail.
> > > > >>
> > > > >> On the other hand flush "adding" workqueue in "connection deletion"
> > > > >> function is not necessary.
> > > > >>
> > > > >> To fix this bug, I think we can just use the two work struct for
> > > > >> add/del, at the same time keeping the original two workqueue.
> > > > >>
> > > > >> Please see following patch for this, (building-test only, I have no
> > > > >> bluetooth device at hand, I can test this the day after tommorrow)
> > > > >
> > > > > so I spent the whole day figuring out what is going on here and we keep
> > > > > making the wrong assumptions over and over again.
> > > > >
> > > > > First of all, we only add the sysfs device when we have a successful
> > > > > connection. And we identify it with the handle. This means that we can
> > > > > NOT have any name clashes anymore since the controller has to make sure
> > > > > a handle is only assigned once. Previously we did this on the BD_ADDR
> > > > > value and that lead to it. That is no longer the case.
> > > > >
> > > > > Second of all the two work queues introduces way too much complexity for
> > > > > a really simple task of adding and removing a sysfs device entry.
> > > > >
> > > > > The real problem we have right now are that we are not initializing the
> > > > > sysfs device when creating the hci_conn. This is just wrong and can lead
> > > > > to all kinds of weird invalid data access. And as a result the adding of
> > > > > the sysfs device should only set the name and add it.
> > > > >
> > > > > We also check device_registered before making sure that device_add has
> > > > > been run. And instead of adding more locking or crazy work queue
> > > > > dependencies, we should use the single thread work queue to ensure the
> > > > > correct order of things.
> > > > >
> > > > > The attached patch introduces a hci_conn_init_sysfs step to make sure we
> > > > > setup the sysfs device correctly. I left the flush_work calls, but I
> > > > > think they are not needed since a del_conn before add_conn is no longer
> > > > > possible now.
> > > > 
> > > > well it seems your not the only one
> > > > with a broken bluetooth(latest git pull
> > > > this morning)
> > > 
> > > can you try the patch that I attached to the previous email. It should
> > > fix exactly this.
> >
> > nice patch.
> > works like a charm
> > bluetooth is alive again.
> 
> thanks for testing.
> 
> Marc, Roger, can you test this and confirm that it works for you and
> doesn't have any other side effects. Then I prepare it work upstream
> inclusion.
> 
> Regards
> 
> Marcel
> 
> 

no worries, 
Thanks for the patch.

regards,

Justin P. Mattock

