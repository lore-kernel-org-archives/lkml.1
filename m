Return-Path: <linux-kernel-owner+w=401wt.eu-S964817AbZLQKgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbZLQKgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZLQKgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:36:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZLQKgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:36:40 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] IPMI: Add parameter to limit CPU usage in kipmid
Date: Thu, 17 Dec 2009 11:36:47 +0100
User-Agent: KMail/1.9.1
Cc: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
References: <20091216212354.GA13097@minyard.local> <20091216134252.868ea5bf.akpm@linux-foundation.org>
In-Reply-To: <20091216134252.868ea5bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912171136.48086.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your comments.

Le mercredi 16 décembre 2009 22:42, Andrew Morton a écrit :
> On Wed, 16 Dec 2009 15:23:54 -0600
> Corey Minyard <minyard@acm.org> wrote:
> 
> > From: Martin Wilck <martin.wilck@ts.fujitsu.com>
> > 
> > In some cases kipmid can use a lot of CPU.
> 
> Why is that?  Without this information it is hard for others to suggest
> alternative implementations.

Quoting Greg KH as he was investigating this issue:

"This looks to be a difference in the way the hardware works from
different ipmi controllers. Some allow for sleeping in an
interruptable state, and others do not, and can not have their delays
interrupted. Because of this, the process is put into uninterruptable
sleep mode, which causes a 'fake' system load increase on those types
of hardware controllers."

> >  This adds a way to tune
> > the CPU used by kipmid to help in those cases.  By setting
> > kipmid_max_busy_us to a value between 100 and 500, it is possible to
> > bring down kipmid CPU load to practically 0 without loosing too much
> > ipmi throughput performance.  Not setting the value, or setting the
> > value to zero, operation is unaffected.
> 
> Requiring the addition of a module parameter is regrettable.  It'd be
> better if the code "just works".

That's right, it'd be better. But my understanding is that there is
no way to figure out automatically when the parameter is needed nor
its optimal value other than by trial and error. I'd love to be
proven wrong though.

> > Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
> > Cc: Jean Delvare <jdelvare@suse.de>
> > Signed-off-by: Corey Minyard <cminyard@mvista.com>
> > 
> > --- linux-2.6.29.4/drivers/char/ipmi/ipmi_si_intf.c	2009-05-19 01:52:34.000000000 +0200
> > +++ linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c	2009-06-04 15:30:34.855398091 +0200
> > @@ -297,6 +297,9 @@
> >  static int force_kipmid[SI_MAX_PARMS];
> >  static int num_force_kipmid;
> >  
> > +static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
> > +static int num_max_busy_us;
> > +
> >  static int unload_when_empty = 1;
> >  
> >  static int try_smi_init(struct smi_info *smi);
> > @@ -927,23 +930,56 @@
> >  	}
> >  }
> >  
> > +#define ipmi_si_set_not_busy(timespec) \
> > +	do { (timespec)->tv_nsec = -1; } while (0)
> > +#define ipmi_si_is_busy(timespec) ((timespec)->tv_nsec != -1)
> 
> These could have been implemented in C.  It's better that way.

+1, inline functions would be more readable.

I'll let Corey and maybe Martin comment on the rest, as the code is
not mine and I am not familiar with it.

-- 
Jean Delvare
Suse L3
