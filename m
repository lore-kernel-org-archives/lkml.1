Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbYGPVgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbYGPVgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbYGPVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:35:58 -0400
Received: from n2c.bullet.mail.ac4.yahoo.com ([76.13.13.79]:36536 "HELO
	n2c.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755694AbYGPVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:35:57 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 939649.57313.bm@omp102.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=rTDRZzHEjcWOQr1Ng9pXFmDAoLSHGjv6CQeAwwLfqJtguscEAEOhX3Jn9K+n7cPB+HE9gi5aNrgcRbtRRlj3ttjj6wiXdhsfYogqB1LY+mwSYaI/Y/4QTmU2w1tJMBQOftH1WZoTO1XeA50eK88igwcqPy2DYAEnzze2QOfcr4I=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Wed, 16 Jul 2008 14:35:56 -0700 (PDT)
From: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>

> To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Thursday, July 17, 2008 2:21:09 AM
> Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
> 
> On Wed, 2008-07-16 at 13:19 -0700, Soumyadip Das Mahapatra wrote:
> > Hello everybody !!
> >       The patch below is what i think is a better approach to
> > compute int_sqrt().
> > 
> > What about it ?
> 
> Indeed, what about it?
> 
> How is it better;
> - is it cheaper
>    - how so
>    - on what platform
> 
> - it is more accurate
>    - who needs it
> 
> Please provide a little more information about why you suggest this
> change.
> 
> > Thanks !!
> > 
> > ---
> > --- a/lib/int_sqrt.c    2008-04-17 08:19:44.000000000 +0530
> > +++ b/lib/int_sqrt.c    2008-07-02 11:37:01.000000000 +0530
> > @@ -1,4 +1,3 @@
> > -
> >  #include 
> >  #include 
> >  
> > @@ -7,26 +6,21 @@
> >   * @x: integer of which to calculate the sqrt
> >   *
> >   * A very rough approximation to the sqrt() function.
> > + * Improved version from the previous one.
> 
> With the previuos one being gone, this comment adds little but
> confusion..
> 
> >   */
> >  unsigned long int_sqrt(unsigned long x)
> >  {
> > -    unsigned long op, res, one;
> > -
> > -    op = x;
> > -    res = 0;
> > -
> > -    one = 1UL << (BITS_PER_LONG - 2);
> > -    while (one > op)
> > -        one >>= 2;
> > -
> > -    while (one != 0) {
> > -        if (op >= res + one) {
> > -            op = op - (res + one);
> > -            res = res +  2 * one;
> > -        }
> > -        res /= 2;
> > -        one /= 4;
> > -    }
> > -    return res;
> > +    unsigned long ub, lb, m;
> > +    lb = 1;                /* lower bound */
> > +    ub = (x >> 5) + 8;        /* upper bound */
> > +    do {
> > +        m = (ub + lb) >>  1;    /* middle value */
> > +        if((m * m) > x)
> > +            ub = m - 1;
> > +        else
> > +            lb = m + 1;
> > +    } while(ub >= lb);
> > +    
> > +    return lb - 1;
> >  }
> >  EXPORT_SYMBOL(int_sqrt);
> > 

Thanks Peter for noticing :-)
Sorry, I should have it explained before. Really sorry
for that. Here are they...

0 It is better because 
         o it uses only one loop instead of two
         o contains no division operator (older version has two)
            which are surely comparatively slow task in computer

0 Currently find . -name '*.[ch]' | xargs grep int_sqrt gives me this
        ....
        ./fs/nfs/write.c:       nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
        ./drivers/video/fbmon.c:        h_period = int_sqrt(h_period);
        ./mm/page_alloc.c:      min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
        ./mm/oom_kill.c:        s = int_sqrt(cpu_time);
        ./mm/oom_kill.c:        s = int_sqrt(int_sqrt(run_time));
        ....
  So this function works in critical computing sections like frame-buffer, paging.
  Which means betterment of this function should not be ignored.
  Besides, if there is a better way to do things then why should not we do that ?

Anyways thanks :-)


      

