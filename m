Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab0CJGUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:20:23 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39026 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0CJGUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:20:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NOJjGkPZ+7Y1pd7iIT81TpQGYip0CENE5W75ZMxaC6Jq2k5aQUcuKkqXEpRo3c3+Bx
         oFCR+7QYdESRMHyYgM9EHRpNSNn4r7Zav9fC4cDyyIY1Jb1FnwBDc6ZUi1g/uorKJFu3
         MKfytsoScAk10l5lF5Hs3tuP8PfWMnD4eFxv4=
Date: Tue, 9 Mar 2010 22:20:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Kacur <jkacur@gmail.com>
Subject: Re: [PATCH 2/3] input: use input_mutex instead of BKL when opening
 input device
Message-ID: <20100310062015.GA2445@core.coreip.homeip.net>
References: <1268162386-2745-1-git-send-email-cascardo@holoscopio.com>
 <1268162386-2745-2-git-send-email-cascardo@holoscopio.com>
 <201003092112.14071.arnd@arndb.de>
 <20100309205947.GB1498@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309205947.GB1498@holoscopio.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 05:59:48PM -0300, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Mar 09, 2010 at 09:12:13PM +0100, Arnd Bergmann wrote:
> > On Tuesday 09 March 2010, Thadeu Lima de Souza Cascardo wrote:
> > >  MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
> > > @@ -1881,7 +1880,7 @@ static int input_open_file(struct inode *inode, struct file *file)
> > >         const struct file_operations *old_fops, *new_fops = NULL;
> > >         int err;
> > >  
> > > -       lock_kernel();
> > > +       mutex_lock(&input_mutex);
> > >         /* No load-on-demand here? */
> > >         handler = input_table[iminor(inode) >> 5];
> > >         if (!handler || !(new_fops = fops_get(handler->fops))) {
> > > @@ -1909,7 +1908,7 @@ static int input_open_file(struct inode *inode, struct file *file)
> > >         }
> > >         fops_put(old_fops);
> > >  out:
> > > -       unlock_kernel();
> > > +       mutex_unlock(&input_mutex);
> > >         return err;
> > >  }
> > >  
> > > -- 
> > 
> > Well, actually please have a look at
> > http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=commitdiff;h=c06fd0234357618a5741ce958d58901ae4cb7ac1
> > 
> > * use mutex_lock_interruptible() where possible
> > * you probably don't want to hold input_mutex when calling into the lower
> >   device's open function
> > 
> > 	Arnd
> 
> Yeah. I was just looking at your appointed branch. And I've noticed your
> change was better.
> 
> I was willing to let the open call go unprotected. But ended up checking
> that the three callees were fine (they do not call any of the other
> functions that take the mutex).
> 
> Since the fops_put/fops_get do protect that section from the handler
> removal and I can't think of any other race right now, I think your
> version is really better.
> 
> Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> 

OK, applied 2 Thadeu's patches and one Arnd's.

Thanks.

-- 
Dmitry
