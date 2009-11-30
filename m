Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbZK3URM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbZK3URM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZK3URL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:17:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:49961 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZK3URK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kTjeZLO/RwSAQye1HpFVm2B9dfpXlX0ZowgqVJhBiDn1adelSKZTZMFKqOsLpDqc10
         oqxo///lLNwmHLbxD8XrqIhQwPVfBLkruzD3WaCwQPsJYZ0x8Sb7vEVAK5VkuEaf9Td5
         p/BaFBfL8LWUVpYNJzCaIJN994uDOvQIZ3Oz0=
Date: Mon, 30 Nov 2009 23:17:09 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       isdn@linux-pingi.de, mac@melware.de
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
Message-ID: <20091130201709.GA4507@x200.malnet.ru>
References: <20091123015625.GA32088@x200.localdomain>
 <20091124162541.03e7e375.akpm@linux-foundation.org>
 <20091125045914.GA3528@x200.malnet.ru>
 <4B1314F8.10500@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1314F8.10500@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:42:32AM +0100, Tilman Schmidt wrote:
> Am 25.11.2009 05:59 schrieb Alexey Dobriyan:
> > --- a/drivers/isdn/gigaset/capi.c
> > +++ b/drivers/isdn/gigaset/capi.c
> > @@ -2106,35 +2106,22 @@ static char *gigaset_procinfo(struct capi_ctr *ctr)
> >  	return ctr->name;	/* ToDo: more? */
> >  }
> >  
> > -/**
> > - * gigaset_ctr_read_proc() - build controller proc file entry
> > - * @page:	buffer of PAGE_SIZE bytes for receiving the entry.
> > - * @start:	unused.
> > - * @off:	unused.
> > - * @count:	unused.
> > - * @eof:	unused.
> > - * @ctr:	controller descriptor structure.
> > - *
> > - * Return value: length of generated entry
> > - */
> > -static int gigaset_ctr_read_proc(char *page, char **start, off_t off,
> > -			  int count, int *eof, struct capi_ctr *ctr)
> > +static int gigaset_proc_show(struct seq_file *m, void *v)
> 
> I would prefer that, instead of throwing the kerneldoc comment away,
> you adapted it to the new function. Specifically, I would like to
> know what the second argument "void *v" is for.

Sorry, no.
I personally find the corellation between kernel-docness and useleness
to be highly positive.

Comment is removed because after removal of parameters "description",
nothing is left.

> >  {
> > +	struct capi_ctr *ctr = m->private;
> 
> See below.
> 
> > +static int gigaset_proc_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, gigaset_proc_show, PDE(inode)->data);
> 
> I'd like to understand how that works.
> 
> According to Documentation/filesystems/seq_file.txt, the value of
> the last argument will be passed to the proc_show function in the
> private field of the seq_file structure. Your gigaset_proc_show()
> function assumes that this will be the capi_ctr pointer for the
> device.
> 
> So what is PDE(inode)->data and where does it get set to the
> capi_ctr pointer for the device?

When you create proc entry, you set ->data for proc entry,
it's accessible as PDE(inode)->data.
Now you need to pass it doen to actual hook.
It got stashed eventually into struct seq_file::private (see single_open())
