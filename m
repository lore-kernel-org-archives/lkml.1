Return-Path: <linux-kernel-owner+w=401wt.eu-S1755791AbZGGIIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbZGGIIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZGGIIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:08:00 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41326 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZGGIH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PQrqdYQ42N5oJtEux8WpTS7sPZkoy6g/P90ceY9QOWCIZXfJwZQSMlr4F4TULQSSZ0
         q45AdEBuhxqVfV5Z1a3Ep7CD9ZNKx2Y9wQGjWyUAtS24F4uqPyneB9eZqoWXImqVDKNj
         RIILpcrGyJrlk7+NbmGxxi9PaAlK8RzjFSl6I=
Date: Tue, 7 Jul 2009 10:07:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] trace_workqueue: add refcnt to struct
	cpu_workqueue_stats
Message-ID: <20090707080755.GC6173@nowhere>
References: <4A51B16F.6010608@cn.fujitsu.com> <4A52E627.10507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52E627.10507@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:07:35PM +0800, Li Zefan wrote:
> > The stat entries can be freed when the stat file is being read.
> > The worse is, the ptr can be freed immediately after it's returned
> > from workqueue_stat_start/next().
> > 
> > Add a refcnt to struct cpu_workqueue_stats to avoid use-after-free.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> ...
> > @@ -175,11 +184,14 @@ static void *workqueue_stat_next(void *prev, int idx)
> >  				return NULL;
> >  		} while (!(ret = workqueue_stat_start_cpu(cpu)));
> >  		return ret;
> > +	} else {
> > +		ret = list_entry(prev_cws->list.next,
> > +				 struct cpu_workqueue_stats, list);
> 
> I just realized accessing prev_cws->list.next can be invalid!
> 
> We can fix it by using list_del_init() to delete cws->list in
> probe_workqueue_destruction(), but then if the race happened,
> the next time stat_next() is called, NULL will be returned.
> I guess this is Ok, since the race is rare.


If you ensure the kref_get/put are under the
workqueue_cpu_stat(cpu)->lock, it should be fine, right?

 
> (I never like the design of trace_stat..Fortunately we'll
> probably switch to perfcounter for this kind of statistics
> reporting)


I don't like its design either. I wrote it specifically for
the branch tracer and didn't think about free-able events :-/


> 
> > +		kref_get(&ret->kref);
> >  	}
> >  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> >  
> > -	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
> > -			  list);
> > +	return ret;
> >  }
> 

