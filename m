Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299Ab0A2TWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0A2TWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263Ab0A2TWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:22:05 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:57114 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0A2TWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:22:04 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 14:22:04 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=hbJtDGqzLu4l8vR4Sba4wU+RdOBuqaBaV5VRGp0gKu3aFsPC7XbtFxlf0QvQzzOm64
         PAEvK0I9cVz/BIxry6jPTuVjHk+y8NVFNSBpTcx895gQiGD81+PnaB0na6uGuU5Kcgdi
         pBE33zXGtakRnHx8gtwIiZ55bqW4mj4rx+vro=
Date: Fri, 29 Jan 2010 17:15:58 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: john smith <whalajam@yahoo.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: perf report for .ko files
Message-ID: <20100129191558.GA9990@ghostprotocols.net>
References: <20100126210552.GA12567@ghostprotocols.net>
 <229562.61603.qm@web55007.mail.re4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <229562.61603.qm@web55007.mail.re4.yahoo.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 29, 2010 at 10:55:13AM -0800, john smith escreveu:
> Problem1: 
> 
> > Well, you could reduce the number of samples collected by
> > asking perf record to
> > include only kernel samples by fiddling with these
> > perf_event_attr fields:
> >  
> >    exclude_user   :  1, /* don't count user      */
> >    exclude_kernel :  1, /* ditto kernel          */
> >    exclude_hv     :  1, /* ditto hypervisor      */
> >    exclude_idle   :  1, /* don't count when idle */
> > 
> > I.e. setting exclude_user, exclude_hv and exclude_idle to
> > 1, but this requires
> > a patch for tools/perf/builtin-record.c as this is not
> > exposed yet.
 
> I did setup attr->exclude_hv, exclude_idle, exclude_user = 1 in
> create_counter() just before "try_again:" label, no difference in
> results, on a 2.6.31 (too old? "perf buildid-list" is not available)
> kernel version:
 
> # perf record -f -e cycles fio fio_script

> (for more than a minute, I increased the sample frequency with
> different -c values, some locked the machine - expectedly)
> and
> # perf report --verbose --dso=/my_module_path/my_module.ko
> (--verbose doesn't provide any more info)

This isn't going to work, you need to do:

perf report --verbose --dso='[my_module]'

I.e. as it appear on /proc/modules + brackets. Arguably we need to get
it to work also with both 'my_module.ko' and the full path.
 
> return the same "# Samples: 0":
> 
> "
> # dso: /my_module_path/my_module.ko
> # Samples: 0
> #...
> "
> 
> > [root@doppio linux-2.6-tip]# perf report --dsos '[e1000e]'
> > # dso: [e1000e]
> > # Samples: 110518812
> 
> 'e1000e' module may be be sampled more often than the scsi modules but ...
> 
> > > not sure why that is, /proc/kallsyms does seem to
> > > include some iwlagn symbols.
 
> /proc/kallsyms includes all syms I need, so is a problem not finding
> the symbols, does this (Samples: 0) make sens?
 
> "perf report --sort comm,dso,symbol" report has my module symbols.

See above on how to specify the module name, its just that it is finding
no samples for the module name as specified, it seems.
 
> Problem2: 

> If I try "perf annotate -l -k /my_module_path/my_module.ko my_symbol"
> has all the percentages "0.00" where I would expect a % breakdown
> (considering the total function counter 100%), even if the function
> represents a small overall counter % compared to the others, any
> ideas?

I actually never tried doing annotation with a module, will try.

- Arnaldo
