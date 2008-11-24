Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYKXLvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYKXLvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYKXLvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:51:39 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:52082 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbYKXLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:51:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMFANchKklMROB9/2dsb2JhbACBbYEwzF2CfA
Date: Mon, 24 Nov 2008 06:51:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: ltt-dev@lists.casi.polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [RFC PATCH] Poll : add poll_wait_set_exclusive
	(fixing thundering herd problem in LTTng)
Message-ID: <20081124115134.GA17972@Krystal>
References: <20081124112429.GA15791@Krystal> <20081124203932.26BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081124203932.26BE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:48:23 up 7 days, 12:28,  3 users,  load average: 0.14, 0.56,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> >  static struct poll_table_entry *poll_get_entry(poll_table *_p)
> >  {
> >  	struct poll_wqueues *p = container_of(_p, struct poll_wqueues, pt);
> > @@ -117,8 +135,10 @@ static struct poll_table_entry *poll_get
> >  }
> >  
> >  /* Add a new entry */
> > -static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
> > -				poll_table *p)
> > +static void __pollwait_common(struct file *filp,
> > +			      wait_queue_head_t *wait_address,
> > +			      poll_table *p,
> > +			      int exclusive)
> >  {
> >  	struct poll_table_entry *entry = poll_get_entry(p);
> >  	if (!entry)
> > @@ -127,7 +147,23 @@ static void __pollwait(struct file *filp
> >  	entry->filp = filp;
> >  	entry->wait_address = wait_address;
> >  	init_waitqueue_entry(&entry->wait, current);
> > -	add_wait_queue(wait_address, &entry->wait);
> > +	if (!exclusive)
> > +		add_wait_queue(wait_address, &entry->wait);
> > +	else
> > +		add_wait_queue_exclusive(wait_address, &entry->wait);
> > +}
> 
> 
> I fully agreed this feature is needed.
> Actually, I've made similar patch at one years ago.
> 
> http://marc.info/?l=linux-kernel&m=120257050719087&w=2
> 
> 
> but, I have one question.
> My version have epoll support, but yours donesn't have.
> Is it intensionally?
> 
> this is just dumb question, it doesn't mean any objection.

Hrm, actually, your patch seems cleaner than mine, but it adds a branch
in the standard hotpath, which mine does not do (but I am not sure it is
such an important optimization...). Is there any reason why your patch
did not get merged ?

The only reason I did not make a epoll version is simply because LTTng
currently does not support it. :)

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
