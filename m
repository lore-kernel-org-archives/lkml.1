Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXJDBvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXJDBvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbXJDBvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:51:00 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45564 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752693AbXJDBu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:50:59 -0400
Message-ID: <391462657.01946@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 4 Oct 2007 09:50:53 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: richard kennedy <richard@rsk.demon.co.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
	on a light-load bdi
Message-ID: <20071004015053.GA5789@mail.ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com> <20071002020040.GA5275@mail.ustc.edu.cn> <1191415612.3123.21.camel@castor.rsk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191415612.3123.21.camel@castor.rsk.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 01:46:52PM +0100, richard kennedy wrote:
> On Tue, 2007-10-02 at 10:00 +0800, Fengguang Wu wrote:
> > ---
> >  mm/page-writeback.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- linux-2.6.22.orig/mm/page-writeback.c
> > +++ linux-2.6.22/mm/page-writeback.c
> > @@ -250,6 +250,11 @@ static void balance_dirty_pages(struct a
> >  			pages_written += write_chunk - wbc.nr_to_write;
> >  			if (pages_written >= write_chunk)
> >  				break;		/* We've done our duty */
> > +			if (list_empty(&mapping->host->i_sb->s_dirty) &&
> > +			    list_empty(&mapping->host->i_sb->s_io) &&
> > +			    nr_reclaimable + global_page_state(NR_WRITEBACK) <=
> > +				    dirty_thresh + (1 << (20-PAGE_CACHE_SHIFT)))
> > +				break;
> >  		}
> >  		congestion_wait(WRITE, HZ/10);
> >  	}
> 
> I've been testing 2.6.23-rc9 + this patch all morning but have just seen
> a lockup. As usual it happened  just after a large file copy finished
> and while nr_dirty is still large. I'm sorry to say I didn't have a
> serial console running so I don't have an other info. I will try again
> and see if I can capture some more data.
> 
> I did notice that at the beginning of my tests the dirty blocks are
> written back more quickly than usual
> 
> nr_dirty count after the copy finished and then 60 seconds later :-
> after copy	+60 seconds
> 73520		0
> 73533		0
> 68554		1
>  
> but after several iterations of my testcase & just before the lockup
> 68560		57165
> 71974		62896
>  
> which is about the same as a unpatched kernel.

Hi Richard,

Thank you for the testing.

However, my patch is kind of duplicate efforts. I was taking the
'do it if simple' attitude.  I can continue to improve it if you 
really want it. Otherwise I'd recommend you to test the coming
2.6.24-rc1 or backport the -mm writeback patches back to 2.6.23 and
test it there. Peter has did a good job on it.

Fengguang

