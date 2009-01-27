Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZA0VaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZA0VaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZA0V3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:29:55 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:48979 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZA0V3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B6CgtuwE8czrrfFBDM6JivfefbO9DXp/NleviAMh1XYQiZG/GgRT6wpnsgz5oJFsEP
         GeiEvDi0F5SPpjv48YfUw1MWHxBn4TR79SgpOEDaNKXt5lmL1hWnYSv5bj69/4ZACiaQ
         aKDdsV2NArc9Ty/gAK1YRCqUPZonasuEbhazE=
Subject: Re: [PATCH] fbmem: copy_from/to_user() with mutex held (v3)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>, hannes@cmpxchg.org,
       davej@redhat.com, rjw@sisk.pl, hannes@saeurebad.de, krzysztof.h1@wp.pl,
       stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org
In-Reply-To: <20090127125255.ea9c0d40.akpm@linux-foundation.org>
References: <1232443676-7037-1-git-send-email-righi.andrea@gmail.com>
	 <20090127125255.ea9c0d40.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 13:29:51 -0800
Message-Id: <1233091791.6717.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 12:52 -0800, Andrew Morton wrote:
> On Tue, 20 Jan 2009 10:27:56 +0100
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > Avoid to call copy_from/to_user() with fb_info->lock mutex held in fbmem
> > ioctl().
> > 
> > fb_mmap() is called under mm->mmap_sem (A) held, that also acquires
> > fb_info->lock (B); fb_ioctl() takes fb_info->lock (B) and does
> > copy_from/to_user() that might acquire mm->mmap_sem (A), causing a
> > deadlock.
> > 
> > NOTE: it doesn't push down the fb_info->lock in each own driver's
> > fb_ioctl(), so there're still potential deadlocks somewhere.
> > 
> 
> Looks good to me.
> 
> > ...
> >
> >  static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > -__acquires(&info->lock)
> > -__releases(&info->lock)
> 
> Should the __acquires/__releases annotation be relocated to
> do_fb_ioctl()?  I've never actually got down and understood those
> things.
> 
> 

There's not really any point as the way lock_fb_info is done, it's essentially
impossible to annotate properly.  You could look at how spin_trylock is done,
but it will require a wrapping macro.  As I suggested the first time this
was posted.

Harvey



